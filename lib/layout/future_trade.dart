import 'dart:async';
import 'dart:convert';

import 'package:date_format/date_format.dart' as df;
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:trade_agent_v2/basic/base.dart';
import 'package:trade_agent_v2/database.dart';
import 'package:trade_agent_v2/generated/l10n.dart';
import 'package:trade_agent_v2/models/model.dart';
import 'package:trade_agent_v2/pb/app.pb.dart' as pb;
import 'package:trade_agent_v2/utils/app_bar.dart';
import 'package:wakelock/wakelock.dart';
import 'package:web_socket_channel/io.dart';

class FutureTradePage extends StatefulWidget {
  const FutureTradePage({Key? key, required this.db}) : super(key: key);
  final AppDatabase db;

  @override
  State<FutureTradePage> createState() => _FutureTradePageState();
}

class _FutureTradePageState extends State<FutureTradePage> {
  IOWebSocketChannel _channel = IOWebSocketChannel.connect(Uri.parse(tradeAgentFutureWSURLPrefix));
  List<RealTimeFutureTick> tickArr = [];

  int qty = 1;
  String mxfCode = '';
  double tradeRate = 0;
  num close = 0;

  bool allowTrade = true;
  bool isAssiting = false;

  bool automationByTimer = false;
  bool automationByBalance = false;

  int automationType = 0;
  num automationByBalanceHigh = 0;
  num automationByBalanceLow = 0;
  num automationByTimePeriod = 0;

  num placeOrderTime = DateTime.now().millisecondsSinceEpoch;

  Future<RealTimeFutureTick?> realTimeFutureTick = Future.value();
  Future<PeriodOutInVolume?> periodVolume = Future.value();
  Future<FuturePosition?> futurePosition = Future.value();
  Future<TradeIndex?> tradeIndex = Future.value();
  Future<List<RealTimeFutureTick>> realTimeFutureTickArr = Future.value([]);

  YahooPrice previousNasdaq = YahooPrice('');
  YahooPrice previousNF = YahooPrice('');
  StockSnapshot previousTSE = StockSnapshot('');
  StockSnapshot previousOTC = StockSnapshot('');

  int nsadaqBreakCount = 0;
  int nfBreakCount = 0;
  int tseBreakCount = 0;
  int otcBreakCount = 0;

  @override
  void initState() {
    super.initState();
    widget.db.basicDao.getBasicByKey('balance_high').then((value) {
      automationByBalanceHigh = int.parse(value!.value);
    });
    widget.db.basicDao.getBasicByKey('balance_low').then((value) {
      automationByBalanceLow = int.parse(value!.value);
    });
    widget.db.basicDao.getBasicByKey('time_period').then((value) {
      automationByTimePeriod = int.parse(value!.value);
    });
    Wakelock.enable();
    initialWS();
    checkConnection();
  }

  @override
  void dispose() {
    _channel.sink.close();
    Wakelock.disable();
    super.dispose();
  }

  void initialWS() {
    _channel.stream.listen(
      (message) {
        if (message == 'pong') {
          return;
        }

        var msg = pb.WSMessage.fromBuffer(message);
        switch (msg.type) {
          case pb.WSType.TYPE_FUTURE_TICK:
            if (mounted) {
              setState(() {
                realTimeFutureTick = getData(msg.futureTick);
                realTimeFutureTickArr = fillArr(msg.futureTick, tickArr);
              });
            }
            return;

          case pb.WSType.TYPE_PERIOD_TRADE_VOLUME:
            if (mounted) {
              setState(() {
                periodVolume = updateTradeRate(msg.periodTradeVolume);
              });
            }
            return;

          case pb.WSType.TYPE_FUTURE_ORDER:
            if (mounted) {
              _showOrderResult(FutureOrder.fromProto(msg.futureOrder));
            }
            return;

          case pb.WSType.TYPE_TRADE_INDEX:
            if (mounted) {
              setState(() {
                tradeIndex = updateTradeIndex(msg.tradeIndex);
              });
            }
            return;

          case pb.WSType.TYPE_FUTURE_POSITION:
            if (mxfCode.isNotEmpty) {
              futurePosition = updateFuturePosition(msg.futurePosition, mxfCode);
            }
            return;

          case pb.WSType.TYPE_ASSIST_STATUS:
            if (mounted) {
              setState(() {
                isAssiting = AssistStatus.fromProto(msg.assitStatus).running!;
              });
            }
            return;

          case pb.WSType.TYPE_ERR_MESSAGE:
            if (mounted) {
              _showErrorDialog(ErrMessage.fromProto(msg.errMessage));
            }
            return;
        }
      },
      onDone: () {
        if (mounted) {
          _channel.sink.close();
          _channel = IOWebSocketChannel.connect(Uri.parse(tradeAgentFutureWSURLPrefix));
          initialWS();
        }
      },
    );
  }

  void checkConnection() {
    var period = const Duration(seconds: 1);
    Timer.periodic(period, (timer) {
      try {
        _channel.sink.add('ping');
      } catch (e) {
        timer.cancel();
      }
    });
  }

  void _showOrderResult(FutureOrder order) {
    var actionStr = order.baseOrder!.action == 1 ? S.of(context).buy : S.of(context).sell;
    switch (order.baseOrder!.status) {
      case 1:
        ElegantNotification(
          width: MediaQuery.of(context).size.width,
          notificationPosition: NotificationPosition.topCenter,
          animation: AnimationType.fromTop,
          toastDuration: const Duration(milliseconds: 2000),
          title: Text(S.of(context).pending_submit),
          description: Text('$actionStr ${order.baseOrder!.price} x ${order.baseOrder!.quantity}'),
          icon: const Icon(
            Icons.book,
            color: Colors.orange,
          ),
          progressIndicatorColor: Colors.orange,
          onDismiss: () {},
        ).show(context);
        return;
      case 2:
        ElegantNotification(
          width: MediaQuery.of(context).size.width,
          notificationPosition: NotificationPosition.topCenter,
          animation: AnimationType.fromTop,
          toastDuration: const Duration(milliseconds: 2000),
          title: Text(S.of(context).pre_submitted),
          description: Text('$actionStr ${order.baseOrder!.price} x ${order.baseOrder!.quantity}'),
          icon: const Icon(
            Icons.book,
            color: Colors.orange,
          ),
          progressIndicatorColor: Colors.orange,
          onDismiss: () {},
        ).show(context);
        return;
      case 3:
        ElegantNotification.info(
          width: MediaQuery.of(context).size.width,
          notificationPosition: NotificationPosition.topCenter,
          animation: AnimationType.fromTop,
          toastDuration: const Duration(milliseconds: 2000),
          title: Text(S.of(context).submitted),
          description: Text('$actionStr ${order.baseOrder!.price} x ${order.baseOrder!.quantity}'),
          onDismiss: () {},
        ).show(context);
        return;
      case 4:
        ElegantNotification.error(
          width: MediaQuery.of(context).size.width,
          notificationPosition: NotificationPosition.topCenter,
          animation: AnimationType.fromTop,
          toastDuration: const Duration(milliseconds: 2000),
          title: Text(S.of(context).failed),
          description: Text('$actionStr ${order.baseOrder!.price}'),
          onDismiss: () {},
        ).show(context);
        return;
      case 5:
        ElegantNotification(
          width: MediaQuery.of(context).size.width,
          notificationPosition: NotificationPosition.topCenter,
          animation: AnimationType.fromTop,
          toastDuration: const Duration(milliseconds: 2000),
          title: Text(S.of(context).cancelled),
          description: Text('$actionStr ${order.baseOrder!.price}'),
          icon: const Icon(
            Icons.cached_outlined,
            color: Colors.orange,
          ),
          progressIndicatorColor: Colors.orange,
          onDismiss: () {},
        ).show(context);
        return;
      case 6:
        ElegantNotification.success(
          width: MediaQuery.of(context).size.width,
          notificationPosition: NotificationPosition.topCenter,
          animation: AnimationType.fromTop,
          toastDuration: const Duration(milliseconds: 2000),
          title: Text(S.of(context).filled),
          description: Text('$actionStr ${order.baseOrder!.price} x ${order.baseOrder!.quantity}'),
          onDismiss: () {},
        ).show(context);
        return;
      case 7:
        ElegantNotification(
          width: MediaQuery.of(context).size.width,
          notificationPosition: NotificationPosition.topCenter,
          animation: AnimationType.fromTop,
          toastDuration: const Duration(milliseconds: 2000),
          title: Text(S.of(context).part_filled),
          description: Text('$actionStr ${order.baseOrder!.price} x ${order.baseOrder!.quantity}'),
          icon: const Icon(
            Icons.access_alarm,
            color: Colors.orange,
          ),
          progressIndicatorColor: Colors.orange,
          onDismiss: () {},
        ).show(context);
        return;
    }
  }

  String msgFromErrCode(num code) {
    switch (code) {
      case -1:
        return S.of(context).err_not_trade_time;
      case -2:
        return S.of(context).err_not_filled;
      case -3:
        return S.of(context).err_assist_not_support;
      case -4:
        return S.of(context).err_unmarshal;
      case -5:
        return S.of(context).err_get_snapshot;
      case -6:
        return S.of(context).err_get_position;
      case -7:
        return S.of(context).err_place_order;
      case -8:
        return S.of(context).err_cancel_order_failed;
      case -9:
        return S.of(context).err_assiting_is_full;
    }
    return 'unknown error';
  }

  void _showErrorDialog(ErrMessage message) {
    if (message.errCode! != 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          iconColor: Colors.red,
          icon: const Icon(
            Icons.error,
            size: 40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(S.of(context).error),
          content: Text(
            msgFromErrCode(message.errCode!),
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: ElevatedButton(
                child: Text(
                  S.of(context).ok,
                  style: const TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  void _showByBalanceSetting() async {
    Basic? balanceHigh;
    Basic? balanceLow;
    await widget.db.basicDao.getBasicByKey('balance_high').then((value) {
      balanceHigh = value;
      automationByBalanceHigh = int.parse(value!.value);
    });
    await widget.db.basicDao.getBasicByKey('balance_low').then((value) {
      balanceLow = value;
      automationByBalanceLow = int.parse(value!.value);
    });

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        iconColor: Colors.teal,
        icon: const Icon(
          Icons.settings,
          size: 40,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text('${S.of(context).balance} ${S.of(context).settings}'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(S.of(context).earn),
                  NumberPicker(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    selectedTextStyle: const TextStyle(color: Colors.teal, fontSize: 40),
                    value: automationByBalanceHigh.toInt(),
                    minValue: 1,
                    maxValue: 50,
                    itemWidth: 75,
                    axis: Axis.horizontal,
                    haptics: true,
                    onChanged: (value) {
                      setState(() {
                        automationByBalanceHigh = value;
                        balanceHigh!.value = value.toString();
                      });
                    },
                  ),
                  Text(S.of(context).loss),
                  NumberPicker(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    selectedTextStyle: const TextStyle(color: Colors.teal, fontSize: 40),
                    value: automationByBalanceLow.toInt(),
                    minValue: -50,
                    maxValue: -1,
                    itemWidth: 75,
                    axis: Axis.horizontal,
                    haptics: true,
                    onChanged: (value) {
                      setState(() {
                        automationByBalanceLow = value;
                        balanceLow!.value = value.toString();
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          Center(
            child: ElevatedButton(
              child: Text(
                S.of(context).ok,
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () {
                widget.db.basicDao.updateBasic(balanceHigh!);
                widget.db.basicDao.updateBasic(balanceLow!);
                setState(() {
                  automationByBalance = true;
                });
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showByTimePeriodSetting() async {
    Basic? timePeriod;
    await widget.db.basicDao.getBasicByKey('time_period').then((value) {
      timePeriod = value;
      automationByTimePeriod = int.parse(value!.value);
    });

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        iconColor: Colors.teal,
        icon: const Icon(
          Icons.settings,
          size: 40,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text('${S.of(context).time_period} ${S.of(context).settings}'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return NumberPicker(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal),
                borderRadius: BorderRadius.circular(10),
              ),
              selectedTextStyle: const TextStyle(color: Colors.teal, fontSize: 40),
              value: automationByTimePeriod.toInt(),
              minValue: 5,
              maxValue: 500,
              step: 5,
              itemWidth: 75,
              axis: Axis.horizontal,
              haptics: true,
              onChanged: (value) {
                setState(() {
                  automationByTimePeriod = value;
                  timePeriod!.value = value.toString();
                });
              },
            );
          },
        ),
        actions: [
          Center(
            child: ElevatedButton(
              child: Text(
                S.of(context).ok,
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () {
                widget.db.basicDao.updateBasic(timePeriod!);
                setState(() {
                  automationByTimer = true;
                });
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _buyFuture(String code, num close) {
    if (close == 0) {
      return;
    }

    num automationType = 0;
    if (automationByBalance && automationByTimer) {
      automationType = 3;
    } else if (automationByBalance) {
      automationType = 1;
    } else if (automationByTimer) {
      automationType = 2;
    }
    _channel.sink.add(jsonEncode(
      {
        'code': code,
        'action': 1,
        'price': close,
        'qty': qty,
        'option': {
          'automation_type': automationType,
          'by_balance_high': automationByBalanceHigh,
          'by_balance_low': automationByBalanceLow,
          'by_time_period': automationByTimePeriod,
        },
      },
    ));
  }

  void _sellFuture(String code, num close) {
    if (close == 0) {
      return;
    }

    num automationType = 0;
    if (automationByBalance && automationByTimer) {
      automationType = 3;
    } else if (automationByBalance) {
      automationType = 1;
    } else if (automationByTimer) {
      automationType = 2;
    }
    _channel.sink.add(jsonEncode(
      {
        'code': code,
        'action': 2,
        'price': close,
        'qty': qty,
        'option': {
          'automation_type': automationType,
          'by_balance_high': automationByBalanceHigh,
          'by_balance_low': automationByBalanceLow,
          'by_time_period': automationByTimePeriod,
        },
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: trAppbar(
        context,
        S.of(context).future_trade,
        widget.db,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: SizedBox(
              width: 130,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onLongPress: () {
                      _showByBalanceSetting();
                    },
                    onTap: () {
                      setState(() {
                        automationByBalance = !automationByBalance;
                      });
                    },
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.monetization_on, color: automationByBalance ? Colors.blueAccent : Colors.grey),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onLongPress: () {
                      _showByTimePeriodSetting();
                    },
                    onTap: () {
                      setState(() {
                        automationByTimer = !automationByTimer;
                      });
                    },
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.timer, color: automationByTimer ? Colors.blueAccent : Colors.grey),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: !isAssiting
                        ? () {
                            setState(() {
                              allowTrade = !allowTrade;
                            });
                          }
                        : null,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.power_settings_new_sharp, color: allowTrade ? Colors.lightGreen : Colors.red[300]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: FutureBuilder<RealTimeFutureTick?>(
                future: realTimeFutureTick,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    mxfCode = snapshot.data!.code!;
                    if (snapshot.data!.close == 0) {
                      return Center(
                        child: Text(
                          S.of(context).no_data,
                          style: const TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      );
                    }
                    close = snapshot.data!.close!;
                    var priceChg = snapshot.data!.priceChg!;
                    var type = (priceChg == 0)
                        ? ''
                        : (priceChg > 0)
                            ? '↗️'
                            : '↘️';

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            snapshot.data!.code!,
                                            style: GoogleFonts.getFont('Source Code Pro',
                                                fontStyle: FontStyle.normal, fontSize: 40, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 30),
                                            child: FutureBuilder<FuturePosition?>(
                                              future: futurePosition,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  if (snapshot.data!.direction == 'Buy') {
                                                    return Text(
                                                      '${S.of(context).buy}: ${snapshot.data!.quantity}\n${S.of(context).avg}: ${snapshot.data!.price}',
                                                      style:
                                                          GoogleFonts.getFont('Source Code Pro', fontStyle: FontStyle.normal, fontSize: 15, color: Colors.grey),
                                                    );
                                                  }
                                                  if (snapshot.data!.direction == 'Sell') {
                                                    return Text(
                                                      '${S.of(context).sell}: ${snapshot.data!.quantity}\n${S.of(context).avg}: ${snapshot.data!.price}',
                                                      style:
                                                          GoogleFonts.getFont('Source Code Pro', fontStyle: FontStyle.normal, fontSize: 15, color: Colors.grey),
                                                    );
                                                  }
                                                }
                                                return Text(
                                                  '${S.of(context).position}: 0',
                                                  style: GoogleFonts.getFont('Source Code Pro', fontStyle: FontStyle.normal, fontSize: 15, color: Colors.grey),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: FutureBuilder<TradeIndex?>(
                                    future: tradeIndex,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        nsadaqBreakCount = snapshot.data!.nasdaq!._processBreakCount(previousNasdaq, nsadaqBreakCount);
                                        var nasdaqChg = snapshot.data!.nasdaq!._getChangeCompareToPrevious();
                                        previousNasdaq = snapshot.data!.nasdaq!;

                                        nfBreakCount = snapshot.data!.nf!._processBreakCount(previousNF, nfBreakCount);
                                        var nfChg = snapshot.data!.nf!._getChangeCompareToPrevious();
                                        previousNF = snapshot.data!.nf!;

                                        tseBreakCount = snapshot.data!.tse!._processBreakCount(previousTSE, tseBreakCount);
                                        previousTSE = snapshot.data!.tse!;

                                        otcBreakCount = snapshot.data!.otc!._processBreakCount(previousOTC, otcBreakCount);
                                        previousOTC = snapshot.data!.otc!;
                                        return SizedBox(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                        'Nasdaq:',
                                                        style: GoogleFonts.getFont(
                                                          'Source Code Pro',
                                                          fontStyle: FontStyle.normal,
                                                          fontSize: 15,
                                                          color: Colors.blueGrey,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                        'NF:',
                                                        style: GoogleFonts.getFont(
                                                          'Source Code Pro',
                                                          fontStyle: FontStyle.normal,
                                                          fontSize: 15,
                                                          color: Colors.blueGrey,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                        'TSE:',
                                                        style: GoogleFonts.getFont(
                                                          'Source Code Pro',
                                                          fontStyle: FontStyle.normal,
                                                          fontSize: 15,
                                                          color: Colors.blueGrey,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                        'OTC:',
                                                        style: GoogleFonts.getFont(
                                                          'Source Code Pro',
                                                          fontStyle: FontStyle.normal,
                                                          fontSize: 15,
                                                          color: Colors.blueGrey,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: Align(
                                                              alignment: Alignment.centerRight,
                                                              child: Text(
                                                                nasdaqChg.toStringAsFixed(2),
                                                                style: GoogleFonts.getFont('Source Code Pro',
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 15,
                                                                    color: nasdaqChg == 0
                                                                        ? Colors.blueGrey
                                                                        : nasdaqChg > 0
                                                                            ? Colors.red
                                                                            : Colors.green),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment.centerRight,
                                                              child: Text(
                                                                '!${nsadaqBreakCount.abs()}',
                                                                style: GoogleFonts.getFont(
                                                                  'Source Code Pro',
                                                                  fontStyle: FontStyle.normal,
                                                                  fontSize: 15,
                                                                  color: nsadaqBreakCount == 0
                                                                      ? Colors.blueGrey
                                                                      : nsadaqBreakCount > 0
                                                                          ? Colors.red
                                                                          : Colors.green,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: Align(
                                                              alignment: Alignment.centerRight,
                                                              child: Text(
                                                                nfChg.toStringAsFixed(2),
                                                                style: GoogleFonts.getFont(
                                                                  'Source Code Pro',
                                                                  fontStyle: FontStyle.normal,
                                                                  fontSize: 15,
                                                                  color: nfChg == 0
                                                                      ? Colors.blueGrey
                                                                      : nfChg > 0
                                                                          ? Colors.red
                                                                          : Colors.green,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment.centerRight,
                                                              child: Text(
                                                                '!${nfBreakCount.abs()}',
                                                                style: GoogleFonts.getFont('Source Code Pro',
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 15,
                                                                    color: nfBreakCount == 0
                                                                        ? Colors.blueGrey
                                                                        : nfBreakCount > 0
                                                                            ? Colors.red
                                                                            : Colors.green),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: Align(
                                                              alignment: Alignment.centerRight,
                                                              child: Text(
                                                                snapshot.data!.tse!.priceChg!.toStringAsFixed(2),
                                                                style: GoogleFonts.getFont('Source Code Pro',
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 15,
                                                                    color: snapshot.data!.tse!.priceChg! == 0
                                                                        ? Colors.blueGrey
                                                                        : snapshot.data!.tse!.priceChg! > 0
                                                                            ? Colors.red
                                                                            : Colors.green),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment.centerRight,
                                                              child: Text(
                                                                '!${tseBreakCount.abs()}',
                                                                style: GoogleFonts.getFont('Source Code Pro',
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 15,
                                                                    color: tseBreakCount == 0
                                                                        ? Colors.blueGrey
                                                                        : tseBreakCount > 0
                                                                            ? Colors.red
                                                                            : Colors.green),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: Align(
                                                              alignment: Alignment.centerRight,
                                                              child: Text(
                                                                snapshot.data!.otc!.priceChg!.toStringAsFixed(2),
                                                                style: GoogleFonts.getFont('Source Code Pro',
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 15,
                                                                    color: snapshot.data!.otc!.priceChg! == 0
                                                                        ? Colors.blueGrey
                                                                        : snapshot.data!.otc!.priceChg! > 0
                                                                            ? Colors.red
                                                                            : Colors.green),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment.centerRight,
                                                              child: Text(
                                                                '!${otcBreakCount.abs()}',
                                                                style: GoogleFonts.getFont('Source Code Pro',
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 15,
                                                                    color: otcBreakCount == 0
                                                                        ? Colors.blueGrey
                                                                        : otcBreakCount > 0
                                                                            ? Colors.red
                                                                            : Colors.green),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return Center(
                                        child: Text(
                                          '${S.of(context).loading}...',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                snapshot.data!.close!.toStringAsFixed(0),
                                style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$type ${snapshot.data!.priceChg!.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 50,
                                  color: priceChg == 0
                                      ? Colors.blueGrey
                                      : priceChg > 0
                                          ? Colors.red
                                          : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: FutureBuilder<PeriodOutInVolume?>(
                            future: periodVolume,
                            builder: (context, snapshot) {
                              var percent1 = 0.0;
                              var percent2 = 0.0;
                              var percent3 = 0.0;
                              var percent4 = 0.0;
                              var rate = 0.0;
                              var rateDifference = 0.0;
                              if (snapshot.hasData) {
                                percent1 = 100 *
                                    snapshot.data!.firstPeriod!.outVolume! /
                                    (snapshot.data!.firstPeriod!.outVolume! + snapshot.data!.firstPeriod!.inVolume!);
                                percent2 = 100 *
                                    snapshot.data!.secondPeriod!.outVolume! /
                                    (snapshot.data!.secondPeriod!.outVolume! + snapshot.data!.secondPeriod!.inVolume!);
                                percent3 = 100 *
                                    snapshot.data!.thirdPeriod!.outVolume! /
                                    (snapshot.data!.thirdPeriod!.outVolume! + snapshot.data!.thirdPeriod!.inVolume!);
                                percent4 = 100 *
                                    snapshot.data!.fourthPeriod!.outVolume! /
                                    (snapshot.data!.fourthPeriod!.outVolume! + snapshot.data!.fourthPeriod!.inVolume!);

                                rate = ((snapshot.data!.firstPeriod!.outVolume! + snapshot.data!.firstPeriod!.inVolume!) / 10 +
                                        (snapshot.data!.thirdPeriod!.outVolume! + snapshot.data!.thirdPeriod!.inVolume!) / 30) /
                                    2;

                                rateDifference = 100 * (rate - tradeRate) / tradeRate;
                                var lastRate = tradeRate;
                                tradeRate = rate;

                                if (!isAssiting &&
                                    !allowTrade &&
                                    (automationByBalance || automationByTimer) &&
                                    DateTime.now().millisecondsSinceEpoch - placeOrderTime > 15000) {
                                  if (rate > 10 && lastRate < 5) {
                                    if (percent1 > 85) {
                                      _buyFuture(mxfCode, close);
                                      placeOrderTime = DateTime.now().millisecondsSinceEpoch;
                                    } else if (percent1 < 15) {
                                      _sellFuture(mxfCode, close);
                                      placeOrderTime = DateTime.now().millisecondsSinceEpoch;
                                    }
                                  }
                                }
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildVolumeRatioCircle(percent1, rate),
                                  _buildVolumeRatioCircle(percent2, rate),
                                  Text(
                                    '${rate.toStringAsFixed(2)}/s',
                                    style: GoogleFonts.getFont(
                                      'Source Code Pro',
                                      fontStyle: FontStyle.normal,
                                      fontSize: 25,
                                      color: rate > 7
                                          ? Colors.red
                                          : rateDifference > 25
                                              ? Colors.red
                                              : Colors.grey,
                                    ),
                                  ),
                                  _buildVolumeRatioCircle(percent3, rate),
                                  _buildVolumeRatioCircle(percent4, rate),
                                ],
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  elevation: (allowTrade && !isAssiting) ? MaterialStateProperty.all(10) : MaterialStateProperty.all(0),
                                  backgroundColor: isAssiting
                                      ? MaterialStateProperty.all(Colors.orange[100])
                                      : allowTrade
                                          ? MaterialStateProperty.all(Colors.red)
                                          : MaterialStateProperty.all(Colors.grey[300]),
                                ),
                                onPressed: (allowTrade && !isAssiting) ? () => _buyFuture(snapshot.data!.code!, snapshot.data!.close!) : null,
                                child: SizedBox(
                                  width: 130,
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      !isAssiting ? S.of(context).buy : S.of(context).assisting,
                                      style: const TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  elevation: (allowTrade && !isAssiting) ? MaterialStateProperty.all(10) : MaterialStateProperty.all(0),
                                  backgroundColor: isAssiting
                                      ? MaterialStateProperty.all(Colors.orange[100])
                                      : allowTrade
                                          ? MaterialStateProperty.all(Colors.green)
                                          : MaterialStateProperty.all(Colors.grey[300]),
                                ),
                                onPressed: (allowTrade && !isAssiting) ? () => _sellFuture(snapshot.data!.code!, snapshot.data!.close!) : null,
                                child: SizedBox(
                                  width: 130,
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      !isAssiting ? S.of(context).sell : S.of(context).assisting,
                                      style: const TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return Center(
                    child: Container(),
                  );
                },
              ),
            ),
            Expanded(
              flex: 7,
              child: FutureBuilder<List<RealTimeFutureTick>>(
                future: realTimeFutureTickArr,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          S.of(context).no_data,
                          style: const TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      );
                    }
                    var value = snapshot.data!;
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        var tickType = value[index].tickType;
                        var volumeFontSize = 14;
                        if (value[index].combo!) {
                          volumeFontSize = 20;
                        }
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: tickType! == 1 ? Colors.red : Colors.green,
                              width: 1.1,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: ListTile(
                            dense: true,
                            leading: Text(
                              '${value[index].volume!}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: volumeFontSize.toDouble(),
                                color: tickType == 1 ? Colors.red : Colors.green,
                              ),
                            ),
                            title: Text(
                              value[index].close!.toStringAsFixed(0),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: volumeFontSize.toDouble(),
                                color: tickType == 1 ? Colors.red : Colors.green,
                              ),
                            ),
                            trailing:
                                Text(df.formatDate(DateTime.parse(value[index].tickTime!).add(const Duration(hours: 8)), [df.HH, ':', df.nn, ':', df.ss])),
                          ),
                        );
                      },
                    );
                  }
                  return Center(
                    child: Container(),
                  );
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ListTile(
                  leading: const Icon(
                    Icons.control_point_duplicate_outlined,
                    color: Colors.teal,
                  ),
                  title: Text(
                    S.of(context).quantity,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Colors.yellow[50],
                          ),
                          child: const Text(
                            '-',
                            style: TextStyle(color: Colors.black, fontSize: 22),
                          ),
                          onPressed: () {
                            setState(() {
                              qty--;
                              if (qty == 0) {
                                qty = 1;
                              }
                            });
                          },
                        ),
                        Text(
                          qty.toString(),
                          style: GoogleFonts.getFont('Source Code Pro',
                              fontStyle: FontStyle.normal, fontSize: 23, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Colors.yellow[50],
                          ),
                          child: const Text(
                            '+',
                            style: TextStyle(color: Colors.black, fontSize: 22),
                          ),
                          onPressed: () async {
                            setState(() {
                              qty++;
                              if (qty == 10) {
                                qty = 9;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildVolumeRatioCircle(double percent, double rate) {
  return CircularPercentIndicator(
    animateFromLastPercent: true,
    animation: true,
    radius: 25,
    lineWidth: 8,
    percent: percent / 100,
    center: Text('${percent.toStringAsFixed(0)}%'),
    progressColor: percent >= 55
        ? Colors.red
        : percent <= 45
            ? Colors.green
            : Colors.yellow,
  );
}

Future<RealTimeFutureTick> getData(pb.WSFutureTick ws) async {
  return RealTimeFutureTick.fromProto(ws);
}

Future<PeriodOutInVolume> updateTradeRate(pb.WSPeriodTradeVolume ws) async {
  return PeriodOutInVolume.fromProto(ws);
}

Future<TradeIndex> updateTradeIndex(pb.WSTradeIndex ws) async {
  return TradeIndex.fromProto(ws);
}

Future<FuturePosition> updateFuturePosition(pb.WSFuturePosition ws, String code) async {
  return FuturePosition.fromProto(ws, code);
}

Future<List<RealTimeFutureTick>> fillArr(pb.WSFutureTick wsTick, List<RealTimeFutureTick> originalArr) async {
  var tmp = RealTimeFutureTick.fromProto(wsTick);
  if (originalArr.isNotEmpty && originalArr.last.close == tmp.close && originalArr.last.tickType == tmp.tickType) {
    originalArr.last.volume = originalArr.last.volume! + tmp.volume!;
    originalArr.last.tickTime = tmp.tickTime;
    originalArr.last.combo = true;
  } else {
    if (originalArr.length > 4) {
      originalArr.removeAt(0);
    }
    originalArr.add(tmp);
  }
  return originalArr.reversed.toList();
}

class RealTimeFutureTick {
  RealTimeFutureTick(
      this.code,
      this.tickTime,
      this.open,
      this.underlyingPrice,
      this.bidSideTotalVol,
      this.askSideTotalVol,
      this.avgPrice,
      this.close,
      this.high,
      this.low,
      this.amount,
      this.totalAmount,
      this.volume,
      this.totalVolume,
      this.tickType,
      this.chgType,
      this.priceChg,
      this.pctChg,
      this.simtrade);

  RealTimeFutureTick.fromProto(pb.WSFutureTick tick) {
    code = tick.code;
    tickTime = tick.tickTime;
    open = tick.open;
    underlyingPrice = tick.underlyingPrice;
    bidSideTotalVol = tick.bidSideTotalVol.toInt();
    askSideTotalVol = tick.askSideTotalVol.toInt();
    avgPrice = tick.avgPrice;
    close = tick.close;
    high = tick.high;
    low = tick.low;
    amount = tick.amount;
    totalAmount = tick.totalAmount;
    volume = tick.volume.toInt();
    totalVolume = tick.totalVolume.toInt();
    tickType = tick.tickType.toInt();
    chgType = tick.chgType.toInt();
    priceChg = tick.priceChg;
    pctChg = tick.pctChg;
  }

  String? code;
  String? tickTime;
  num? open;
  num? underlyingPrice;
  num? bidSideTotalVol;
  num? askSideTotalVol;
  num? avgPrice;
  num? close;
  num? high;
  num? low;
  num? amount;
  num? totalAmount;
  num? volume;
  num? totalVolume;
  num? tickType;
  num? chgType;
  num? priceChg;
  num? pctChg;
  num? simtrade;
  bool? combo = false;
}

class AssistStatus {
  AssistStatus.fromProto(pb.WSAssitStatus status) {
    running = status.running;
  }

  bool? running;
}

class ErrMessage {
  ErrMessage(this.errCode, this.response);

  ErrMessage.fromProto(pb.WSErrMessage err) {
    errCode = err.errCode.toInt();
    response = err.response;
  }

  num? errCode;
  String? response;
}

class OutInVolume {
  OutInVolume(this.outVolume, this.inVolume);

  num? outVolume;
  num? inVolume;
}

class PeriodOutInVolume {
  PeriodOutInVolume(this.firstPeriod, this.secondPeriod, this.thirdPeriod, this.fourthPeriod);

  PeriodOutInVolume.fromProto(pb.WSPeriodTradeVolume volume) {
    firstPeriod = OutInVolume(volume.firstPeriod.outVolume.toInt(), volume.firstPeriod.inVolume.toInt());
    secondPeriod = OutInVolume(volume.secondPeriod.outVolume.toInt(), volume.secondPeriod.inVolume.toInt());
    thirdPeriod = OutInVolume(volume.thirdPeriod.outVolume.toInt(), volume.thirdPeriod.inVolume.toInt());
    fourthPeriod = OutInVolume(volume.fourthPeriod.outVolume.toInt(), volume.fourthPeriod.inVolume.toInt());
  }

  OutInVolume? firstPeriod;
  OutInVolume? secondPeriod;
  OutInVolume? thirdPeriod;
  OutInVolume? fourthPeriod;
}

class TradeIndex {
  TradeIndex(this.tse, this.otc, this.nasdaq, this.nf);

  TradeIndex.fromProto(pb.WSTradeIndex index) {
    tse = StockSnapshot.fromProto(index.tse);
    otc = StockSnapshot.fromProto(index.otc);
    nasdaq = YahooPrice.fromProto(index.nasdaq);
    nf = YahooPrice.fromProto(index.nf);
  }

  StockSnapshot? tse;
  StockSnapshot? otc;
  YahooPrice? nasdaq;
  YahooPrice? nf;
}

class YahooPrice {
  YahooPrice(this.updateAt);

  YahooPrice.fromProto(pb.WSYahooPrice ws) {
    last = ws.last;
    price = ws.price;
    updateAt = ws.updatedAt;
  }

  int _processBreakCount(YahooPrice previous, num breakCount) {
    if (previous.updateAt!.isEmpty) {
      return 0;
    }

    if (DateTime.parse(previous.updateAt!).isAtSameMomentAs(DateTime.parse(updateAt!))) {
      return breakCount.toInt();
    }

    var tmpBreakCount = breakCount.toInt();
    if (price! > previous.price! + 0.3) {
      if (breakCount >= 0) {
        tmpBreakCount++;
      } else {
        tmpBreakCount = 1;
      }
    } else if (price! < previous.price! - 0.3) {
      if (breakCount <= 0) {
        tmpBreakCount--;
      } else {
        tmpBreakCount = -1;
      }
    }
    return tmpBreakCount;
  }

  num _getChangeCompareToPrevious() {
    if (price == 0 || last == 0) {
      return 0;
    }

    return price! - last!;
  }

  num? last;
  num? price;
  String? updateAt;
}

class StockSnapshot {
  StockSnapshot(this.snapTime);

  StockSnapshot.fromProto(pb.WSStockSnapShot ws) {
    snapTime = ws.snapTime;
    open = ws.open;
    high = ws.high;
    low = ws.low;
    close = ws.close;
    tickType = ws.tickType;
    priceChg = ws.priceChg;
    pctChg = ws.pctChg;
    chgType = ws.chgType;
    volume = ws.volume.toInt();
    volumeSum = ws.volumeSum.toInt();
    amount = ws.amount.toInt();
    amountSum = ws.amountSum.toInt();
    yesterdayVolume = ws.yesterdayVolume;
    volumeRatio = ws.volumeRatio;
  }

  int _processBreakCount(StockSnapshot previous, num breakCount) {
    if (previous.snapTime!.isEmpty) {
      return 0;
    }

    if (DateTime.parse(previous.snapTime!).isAtSameMomentAs(DateTime.parse(snapTime!))) {
      return breakCount.toInt();
    }

    var tmpBreakCount = breakCount.toInt();
    if (close! > previous.close! + 0.3) {
      if (breakCount >= 0) {
        tmpBreakCount++;
      } else {
        tmpBreakCount = 1;
      }
    } else if (close! < previous.close! - 0.3) {
      if (breakCount <= 0) {
        tmpBreakCount--;
      } else {
        tmpBreakCount = -1;
      }
    }
    return tmpBreakCount;
  }

  String? snapTime;
  num? open;
  num? high;
  num? low;
  num? close;
  String? tickType;
  num? priceChg;
  num? pctChg;
  String? chgType;
  num? volume;
  num? volumeSum;
  num? amount;
  num? amountSum;
  num? yesterdayVolume;
  num? volumeRatio;
}

class FuturePosition {
  FuturePosition();

  FuturePosition.fromProto(pb.WSFuturePosition ws, String code) {
    for (final element in ws.position) {
      if (element.code == code) {
        code = element.code;
        direction = element.direction;
        quantity = element.quantity.toInt();
        price = element.price;
        lastPrice = element.lastPrice;
        pnl = element.pnl;
        break;
      }
    }
  }

  String? code;
  String? direction;
  num? quantity;
  num? price;
  num? lastPrice;
  num? pnl;
}

class FutureOrder {
  FutureOrder(
    this.code,
    this.baseOrder,
  );

  FutureOrder.fromProto(pb.WSFutureOrder ws) {
    code = ws.code;
    baseOrder = BaseOrder.fromProto(ws.baseOrder);
  }

  String? code;
  BaseOrder? baseOrder;
}

class BaseOrder {
  BaseOrder(
    this.orderID,
    this.status,
    this.orderTime,
    this.action,
    this.price,
    this.quantity,
    this.tradeTime,
    this.tickTime,
    this.groupID,
  );

  BaseOrder.fromProto(pb.WSOrder ws) {
    orderID = ws.orderId;
    status = ws.status.toInt();
    orderTime = ws.orderTime;
    action = ws.action.toInt();
    price = ws.price;
    quantity = ws.quantity.toInt();
    tradeTime = ws.tradeTime;
    tickTime = ws.tickTime;
    groupID = ws.groupId;
  }

  String? orderID;
  num? status;
  String? orderTime;
  num? action;
  num? price;
  num? quantity;
  String? tradeTime;
  String? tickTime;
  String? groupID;
}
