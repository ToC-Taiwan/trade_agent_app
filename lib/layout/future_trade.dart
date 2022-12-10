import 'dart:async';
import 'dart:convert';

import 'package:date_format/date_format.dart' as df;
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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
  late IOWebSocketChannel? _channel;

  int qty = 1;
  String code = '';
  String delieveryDate = '';

  bool allowTrade = true;
  bool isAssiting = false;

  int automationType = 0;
  bool automationByTimer = false;
  bool automationByBalance = false;

  late num? automationByBalanceHigh;
  late num? automationByBalanceLow;
  late num? automationByTimePeriod;

  num placeOrderTime = DateTime.now().millisecondsSinceEpoch;

  double lastRate = 0;
  TradeRate tradeRate = TradeRate(0, 0, 0, 0, 0);
  List<RealTimeFutureTick> totalTickArr = [];

  List<RealTimeFutureTick> tickArr = [];
  RealTimeFutureTick? lastTick;
  RealTimeFutureTick? beforeLastTick;

  Future<RealTimeFutureTick?> realTimeFutureTick = Future.value();
  Future<FuturePosition?> futurePosition = Future.value();
  Future<TradeIndex?> tradeIndex = Future.value();
  Future<List<RealTimeFutureTick>> realTimeFutureTickArr = Future.value([]);
  Future<List<KbarData>> kbarArr = Future.value([]);

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
    initialWS();
    Wakelock.enable();
  }

  @override
  void dispose() {
    _channel!.sink.close();
    Wakelock.disable();
    super.dispose();
  }

  void initialWS() {
    _channel = IOWebSocketChannel.connect(Uri.parse(tradeAgentFutureWSURLPrefix));
    _channel!.stream.listen(
      (message) {
        if (message == 'pong') {
          return;
        }

        var msg = pb.WSMessage.fromBuffer(message);
        switch (msg.type) {
          case pb.WSType.TYPE_FUTURE_TICK:
            if (mounted) {
              updateTradeRate(msg.futureTick, totalTickArr);
              setState(() {
                realTimeFutureTick = getData(msg.futureTick);
                realTimeFutureTickArr = fillArr(msg.futureTick, tickArr);
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
            if (code.isNotEmpty) {
              futurePosition = updateFuturePosition(msg.futurePosition, code);
            }
            return;

          case pb.WSType.TYPE_ASSIST_STATUS:
            if (mounted) {
              setState(() {
                isAssiting = AssistStatus.fromProto(msg.assitStatus).running!;
              });
            }
            return;

          case pb.WSType.TYPE_KBAR_ARR:
            setState(() {
              kbarArr = getKbarArr(msg.historyKbar);
            });
            return;

          case pb.WSType.TYPE_ERR_MESSAGE:
            if (mounted) {
              _showErrorDialog(ErrMessage.fromProto(msg.errMessage));
            }
            return;

          case pb.WSType.TYPE_FUTURE_DETAIL:
            code = msg.futureDetail.code;
            setState(() {
              delieveryDate = msg.futureDetail.deliveryDate;
            });
            return;
        }
      },
      onDone: () {
        if (mounted) {
          initialWS();
        }
      },
    );
    checkConnection(_channel!);
  }

  void checkConnection(IOWebSocketChannel channel) {
    var period = const Duration(seconds: 1);
    Timer.periodic(period, (timer) {
      try {
        channel.sink.add('ping');
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
          description: Text('$actionStr ${order.baseOrder!.price!.toStringAsFixed(0)} x ${order.baseOrder!.quantity}'),
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
          description: Text('$actionStr ${order.baseOrder!.price!.toStringAsFixed(0)} x ${order.baseOrder!.quantity}'),
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
          description: Text('$actionStr ${order.baseOrder!.price!.toStringAsFixed(0)} x ${order.baseOrder!.quantity}'),
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
          description: Text('$actionStr ${order.baseOrder!.price!.toStringAsFixed(0)}'),
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
          description: Text('$actionStr ${order.baseOrder!.price!.toStringAsFixed(0)}'),
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
          description: Text('$actionStr ${order.baseOrder!.price!.toStringAsFixed(0)} x ${order.baseOrder!.quantity}'),
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
          description: Text('$actionStr ${order.baseOrder!.price!.toStringAsFixed(0)} x ${order.baseOrder!.quantity}'),
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
                    value: automationByBalanceHigh!.toInt(),
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
                    value: automationByBalanceLow!.toInt(),
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
              value: automationByTimePeriod!.toInt(),
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
    _channel!.sink.add(jsonEncode(
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

  void updateTradeRate(pb.WSFutureTick ws, List<RealTimeFutureTick> totalArr) {
    totalTickArr.add(RealTimeFutureTick.fromProto(ws));

    var baseDuration = const Duration(seconds: 10);
    var firstPeriod = RealTimeFutureTickArr();
    var secondPeriod = RealTimeFutureTickArr();
    var thirdPeriod = RealTimeFutureTickArr();
    var fourthPeriod = RealTimeFutureTickArr();

    for (var i = 0; i < totalTickArr.length; i++) {
      if (totalTickArr[i].tickTime!.isBefore(DateTime.now().subtract(baseDuration * 4))) {
        totalTickArr.removeAt(i);
        continue;
      }

      if (totalTickArr[i].tickTime!.isBefore(DateTime.now().subtract(baseDuration * 3))) {
        fourthPeriod.arr.add(totalTickArr[i]);
        continue;
      }

      if (totalTickArr[i].tickTime!.isBefore(DateTime.now().subtract(baseDuration * 2))) {
        thirdPeriod.arr.add(totalTickArr[i]);
        fourthPeriod.arr.add(totalTickArr[i]);
        continue;
      }

      if (totalTickArr[i].tickTime!.isBefore(DateTime.now().subtract(baseDuration * 1))) {
        secondPeriod.arr.add(totalTickArr[i]);
        thirdPeriod.arr.add(totalTickArr[i]);
        fourthPeriod.arr.add(totalTickArr[i]);
        continue;
      }

      firstPeriod.arr.add(totalTickArr[i]);
      secondPeriod.arr.add(totalTickArr[i]);
      thirdPeriod.arr.add(totalTickArr[i]);
      fourthPeriod.arr.add(totalTickArr[i]);
    }

    setState(() {
      if (mounted) {
        tradeRate = TradeRate(
          firstPeriod.getOutInVolume()._getOutInRatio(),
          secondPeriod.getOutInVolume()._getOutInRatio(),
          thirdPeriod.getOutInVolume()._getOutInRatio(),
          fourthPeriod.getOutInVolume()._getOutInRatio(),
          firstPeriod.getOutInVolume()._getRate(),
        );
      }
    });

    if (!isAssiting && !allowTrade && (automationByBalance || automationByTimer) && DateTime.now().millisecondsSinceEpoch - placeOrderTime > 30000) {
      if (tradeRate.rate > 25 && lastRate < 10) {
        if (tradeRate.percent1 > 85) {
          _buyFuture(code, lastTick!.close!);
          placeOrderTime = DateTime.now().millisecondsSinceEpoch;
        } else if (tradeRate.percent1 < 15) {
          _sellFuture(code, lastTick!.close!);
          placeOrderTime = DateTime.now().millisecondsSinceEpoch;
        }
      }
    }
    lastRate = tradeRate.rate;
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
    _channel!.sink.add(jsonEncode(
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
                      child: Icon(!allowTrade ? Icons.pause_circle_outline_outlined : Icons.play_circle_outline,
                          color: allowTrade ? Colors.teal : Colors.red[300]),
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
                    if (snapshot.data!.close == 0) {
                      return Center(
                        child: Text(
                          S.of(context).loading,
                          style: const TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      );
                    }
                    beforeLastTick = lastTick;
                    lastTick = snapshot.data;
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
                                                  delieveryDate,
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
                                style: GoogleFonts.getFont('Source Code Pro',
                                    fontStyle: FontStyle.normal, fontSize: 50, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '$type ${snapshot.data!.priceChg!.toStringAsFixed(0)}',
                                style: GoogleFonts.getFont('Source Code Pro',
                                    fontStyle: FontStyle.normal,
                                    fontSize: 50,
                                    color: priceChg == 0
                                        ? Colors.blueGrey
                                        : priceChg > 0
                                            ? Colors.red
                                            : Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildVolumeRatioCircle(tradeRate.percent1, tradeRate.rate),
                              _buildVolumeRatioCircle(tradeRate.percent2, tradeRate.rate),
                              Text(
                                '${tradeRate.rate.toStringAsFixed(2)}/s',
                                style: GoogleFonts.getFont(
                                  'Source Code Pro',
                                  fontStyle: FontStyle.normal,
                                  fontSize: 25,
                                  color: tradeRate.rate >= 10 ? Colors.red : Colors.grey,
                                ),
                              ),
                              _buildVolumeRatioCircle(tradeRate.percent3, tradeRate.rate),
                              _buildVolumeRatioCircle(tradeRate.percent4, tradeRate.rate),
                            ],
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
                                        fontSize: 26,
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
                                        fontSize: 26,
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
              flex: 3,
              child: FutureBuilder<List<RealTimeFutureTick>>(
                future: realTimeFutureTickArr,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Container();
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
                            trailing: Text(df.formatDate(value[index].tickTime!, [df.HH, ':', df.nn, ':', df.ss])),
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
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: FutureBuilder<List<KbarData>>(
                  future: kbarArr,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SfCartesianChart(
                        plotAreaBorderWidth: 2,
                        primaryYAxis: NumericAxis(
                          isVisible: false,
                        ),
                        primaryXAxis: DateTimeAxis(),
                        series: <ChartSeries>[
                          CandleSeries(
                            showIndicationForSameValues: true,
                            enableSolidCandles: true,
                            bearColor: Colors.green,
                            bullColor: Colors.red,
                            dataSource: snapshot.data!,
                            xValueMapper: (datum, index) => datum.kbarTime,
                            lowValueMapper: (datum, index) => datum.low,
                            highValueMapper: (datum, index) => datum.high,
                            openValueMapper: (datum, index) => datum.open,
                            closeValueMapper: (datum, index) => datum.close,
                          )
                        ],
                      );
                    }
                    return Text(
                      'Kbar close is loading',
                      style: GoogleFonts.getFont('Source Code Pro', fontStyle: FontStyle.normal, fontSize: 15, color: Colors.grey),
                    );
                  },
                ),
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

Future<TradeIndex> updateTradeIndex(pb.WSTradeIndex ws) async {
  return TradeIndex.fromProto(ws);
}

Future<FuturePosition> updateFuturePosition(pb.WSFuturePosition ws, String code) async {
  return FuturePosition.fromProto(ws, code);
}

Future<List<KbarData>> getKbarArr(pb.WSHistoryKbarMessage ws) async {
  var tmp = <KbarData>[];
  for (final element in ws.arr) {
    tmp.add(
      KbarData(
        kbarTime: DateTime.parse(element.kbarTime),
        high: element.high,
        low: element.low,
        open: element.open,
        close: element.close,
        volume: element.volume.toInt(),
      ),
    );
  }
  return tmp;
}

Future<List<RealTimeFutureTick>> fillArr(pb.WSFutureTick wsTick, List<RealTimeFutureTick> originalArr) async {
  var tmp = RealTimeFutureTick.fromProto(wsTick);
  if (originalArr.isNotEmpty && originalArr.last.close == tmp.close && originalArr.last.tickType == tmp.tickType) {
    originalArr.last.volume = originalArr.last.volume! + tmp.volume!;
    originalArr.last.tickTime = tmp.tickTime;
    originalArr.last.combo = true;
  } else {
    originalArr.add(tmp);
    if (originalArr.length > 2) {
      originalArr.removeAt(0);
    }
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
    tickTime = DateTime.parse(tick.tickTime);
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
  DateTime? tickTime;
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

class RealTimeFutureTickArr {
  OutInVolume getOutInVolume() {
    var outVolume = 0;
    var inVolume = 0;
    for (var i = 0; i < arr.length; i++) {
      switch (arr[i].tickType) {
        case 1:
          outVolume += arr[i].volume!.toInt();
          continue;
        case 2:
          inVolume += arr[i].volume!.toInt();
          continue;
      }
    }
    return OutInVolume(outVolume, inVolume);
  }

  List<RealTimeFutureTick> arr = [];
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

  double _getOutInRatio() {
    if (outVolume == 0 && inVolume == 0) {
      return 0;
    }
    return 100 * (outVolume! / (outVolume! + inVolume!));
  }

  double _getRate() {
    return (outVolume! + inVolume!) / 10;
  }

  num? outVolume;
  num? inVolume;
}

class TradeRate {
  TradeRate(
    this.percent1,
    this.percent2,
    this.percent3,
    this.percent4,
    this.rate,
  );

  double percent1;
  double percent2;
  double percent3;
  double percent4;
  double rate;
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

class KbarData {
  KbarData({this.kbarTime, this.close, this.open, this.high, this.low, this.volume});

  DateTime? kbarTime;
  num? close;
  num? open;
  num? high;
  num? low;
  int? volume;
}
