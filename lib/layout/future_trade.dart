import 'dart:async';
import 'dart:convert';

import 'package:date_format/date_format.dart' as df;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:trade_agent_v2/basic/basic.dart';
import 'package:trade_agent_v2/database.dart';
import 'package:trade_agent_v2/generated/l10n.dart';
import 'package:trade_agent_v2/models/model.dart';
import 'package:trade_agent_v2/utils/app_bar.dart';
import 'package:web_socket_channel/io.dart';

class FutureTradePage extends StatefulWidget {
  const FutureTradePage({Key? key, required this.db}) : super(key: key);
  final AppDatabase db;

  @override
  State<FutureTradePage> createState() => _FutureTradePageState();
}

class _FutureTradePageState extends State<FutureTradePage> {
  var _channel = IOWebSocketChannel.connect(Uri.parse(tradeAgentFutureWSURLPrefix));
  late Future<Basic?> futureQty;
  bool automationTrade = false;

  Future<RealTimeFutureTick?> realTimeFutureTick = Future.value();
  Future<TradeRate?> tradeRate = Future.value();
  Future<FuturePosition?> futurePosition = Future.value();
  Future<TradeIndex?> tradeIndex = Future.value();
  Future<List<RealTimeFutureTick>> realTimeFutureTickArr = Future.value([]);

  List<RealTimeFutureTick> tickArr = [];

  int qty = 1;
  String mxfCode = '';

  int nsadaqBreakCount = 0;
  num previousNasdaq = 0;
  int nfBreakCount = 0;
  num previousNF = 0;
  int tseBreakCount = 0;
  num previousTSE = 0;
  int otcBreakCount = 0;
  num previousOTC = 0;

  @override
  void initState() {
    super.initState();
    futureQty = widget.db.basicDao.getBasicByKey('future_qty');
    initialWS();
    checkConnection();
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  void initialWS() {
    _channel.stream.listen(
      (message) {
        if (message == 'pong') {
          return;
        }

        Map<String, dynamic> msg = jsonDecode(message);
        if (msg.containsKey('underlying_price')) {
          setState(() {
            realTimeFutureTick = getData(msg);
            realTimeFutureTickArr = fillArr(msg, tickArr);
          });
        }

        if (msg.containsKey('out_rate')) {
          setState(() {
            tradeRate = updateTradeRate(msg);
          });
        }

        if (msg.containsKey('tse')) {
          setState(() {
            tradeIndex = updateTradeIndex(msg);
          });
        }

        if (msg.containsKey('position')) {
          if (mxfCode.isEmpty) {
            return;
          }
          futurePosition = updateFuturePosition(msg, mxfCode);
        }

        if (msg.containsKey('base_order')) {
          var order = FutureOrder.fromJson(msg);
          if (mounted) {
            _showDialog(context, order.generateStatusMessage());
          }
        }

        if (msg.containsKey('err_msg')) {
          if (mounted) {
            _showDialog(context, msg['err_msg']);
          }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: trAppbar(
        context,
        S.of(context).future_trade,
        widget.db,
      ),
      body: SizedBox(
        child: Column(
          children: [
            Expanded(
              flex: 5,
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
                    var tmp = Colors.black;
                    var type = '';
                    var priceChg = snapshot.data!.priceChg!;
                    if (priceChg < 0) {
                      tmp = Colors.green;
                      type = '↘️';
                    } else if (priceChg > 0) {
                      tmp = Colors.red;
                      type = '↗️';
                    }

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
                                            style: GoogleFonts.getFont('Source Code Pro', fontStyle: FontStyle.normal, fontSize: 40, color: Colors.blueGrey),
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
                                                      'Buy: ${snapshot.data!.quantity}',
                                                      style:
                                                          GoogleFonts.getFont('Source Code Pro', fontStyle: FontStyle.normal, fontSize: 15, color: Colors.grey),
                                                    );
                                                  }
                                                  if (snapshot.data!.direction == 'Sell') {
                                                    return Text(
                                                      'Sell: ${snapshot.data!.quantity}',
                                                      style:
                                                          GoogleFonts.getFont('Source Code Pro', fontStyle: FontStyle.normal, fontSize: 15, color: Colors.grey),
                                                    );
                                                  }
                                                  return Text(
                                                    'Position: 0',
                                                    style:
                                                        GoogleFonts.getFont('Source Code Pro', fontStyle: FontStyle.normal, fontSize: 15, color: Colors.grey),
                                                  );
                                                }
                                                return Container();
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
                                        nsadaqBreakCount = _processBreakCount(snapshot.data!.nasdaq!.price!, previousNasdaq, nsadaqBreakCount);
                                        var nsadaqBreakCountShow = nsadaqBreakCount.abs();
                                        previousNasdaq = snapshot.data!.nasdaq!.price!;

                                        nfBreakCount = _processBreakCount(snapshot.data!.nf!.price!, previousNF, nfBreakCount);
                                        var nfBreakCountShow = nfBreakCount.abs();
                                        previousNF = snapshot.data!.nf!.price!;

                                        tseBreakCount = _processBreakCount(snapshot.data!.tse!.close!, previousTSE, tseBreakCount);
                                        var tseBreakCountShow = tseBreakCount.abs();
                                        previousTSE = snapshot.data!.tse!.close!;

                                        otcBreakCount = _processBreakCount(snapshot.data!.otc!.close!, previousOTC, otcBreakCount);
                                        var otcBreakCountShow = otcBreakCount.abs();
                                        previousOTC = snapshot.data!.otc!.close!;

                                        var nasdaqChange = snapshot.data!.nasdaq!.price! - snapshot.data!.nasdaq!.last!;
                                        var nfChange = snapshot.data!.nf!.price! - snapshot.data!.nf!.last!;
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
                                                                nasdaqChange.toStringAsFixed(2),
                                                                style: GoogleFonts.getFont('Source Code Pro',
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 15,
                                                                    color: _generateColorByPriceChange(nasdaqChange)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment.centerRight,
                                                              child: Text(
                                                                '!$nsadaqBreakCountShow',
                                                                style: GoogleFonts.getFont(
                                                                  'Source Code Pro',
                                                                  fontStyle: FontStyle.normal,
                                                                  fontSize: 15,
                                                                  color: _generateColorByPriceChange(nsadaqBreakCount),
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
                                                                nfChange.toStringAsFixed(2),
                                                                style: GoogleFonts.getFont(
                                                                  'Source Code Pro',
                                                                  fontStyle: FontStyle.normal,
                                                                  fontSize: 15,
                                                                  color: _generateColorByPriceChange(nfChange),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment.centerRight,
                                                              child: Text(
                                                                '!$nfBreakCountShow',
                                                                style: GoogleFonts.getFont('Source Code Pro',
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 15,
                                                                    color: _generateColorByPriceChange(nfBreakCount)),
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
                                                                    color: _generateColorByPriceChange(snapshot.data!.tse!.priceChg!)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment.centerRight,
                                                              child: Text(
                                                                '!$tseBreakCountShow',
                                                                style: GoogleFonts.getFont('Source Code Pro',
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 15,
                                                                    color: _generateColorByPriceChange(tseBreakCount)),
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
                                                                    color: _generateColorByPriceChange(snapshot.data!.otc!.priceChg!)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment.centerRight,
                                                              child: Text(
                                                                '!$otcBreakCountShow',
                                                                style: GoogleFonts.getFont('Source Code Pro',
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 15,
                                                                    color: _generateColorByPriceChange(otcBreakCount)),
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
                                      return const Center(
                                        child: Text(
                                          'Loading...',
                                          style: TextStyle(fontSize: 20),
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
                                snapshot.data!.close.toString(),
                                style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$type ${snapshot.data!.priceChg.toString()}',
                                // snapshot.data!.priceChg.toString(),
                                style: TextStyle(
                                  fontSize: 50,
                                  color: tmp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: FutureBuilder<TradeRate?>(
                            future: tradeRate,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var percent = snapshot.data!.outRate! / (snapshot.data!.outRate! + snapshot.data!.inRate!);
                                return LinearPercentIndicator(
                                  leading: Text(snapshot.data!.outRate!.toString()),
                                  trailing: Text(snapshot.data!.inRate!.toString()),
                                  barRadius: const Radius.circular(5),
                                  lineHeight: 20,
                                  center: Text(
                                    '${(percent * 100).toStringAsFixed(2)}%',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  percent: percent,
                                  backgroundColor: Colors.greenAccent,
                                  progressColor: Colors.redAccent,
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(10),
                                  backgroundColor: MaterialStateProperty.all(Colors.red),
                                ),
                                onPressed: () {
                                  _channel.sink.add(jsonEncode({
                                    'topic': 'future_trade',
                                    'future_order': {
                                      'code': snapshot.data!.code,
                                      'action': 1,
                                      'price': snapshot.data!.close,
                                      'qty': qty,
                                    },
                                  }));
                                },
                                child: SizedBox(
                                  width: 150,
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      S.of(context).buy,
                                      style: const TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(10),
                                  backgroundColor: MaterialStateProperty.all(Colors.green),
                                ),
                                onPressed: () {
                                  _channel.sink.add(jsonEncode({
                                    'topic': 'future_trade',
                                    'future_order': {
                                      'code': snapshot.data!.code,
                                      'action': 2,
                                      'price': snapshot.data!.close,
                                      'qty': qty,
                                    },
                                  }));
                                },
                                child: SizedBox(
                                  width: 150,
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      S.of(context).sell,
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
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                  ));
                },
              ),
            ),
            Expanded(
              flex: 5,
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
                            horizontal: 20,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _generateColorByTickType(tickType!),
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
                                color: _generateColorByTickType(tickType),
                              ),
                            ),
                            title: Text(
                              '${value[index].close}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: volumeFontSize.toDouble(),
                                color: _generateColorByTickType(tickType),
                              ),
                            ),
                            trailing:
                                Text(df.formatDate(DateTime.parse(value[index].tickTime!).add(const Duration(hours: 8)), [df.HH, ':', df.nn, ':', df.ss])),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                  ));
                },
              ),
            ),
            Expanded(
              child: ListTile(
                leading: const Icon(
                  Icons.query_stats_sharp,
                  color: Colors.black,
                ),
                title: Text(S.of(context).future_quantity),
                trailing: SizedBox(
                  width: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: const Text(
                          '-',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () async {
                          await widget.db.basicDao.getBasicByKey('future_qty').then((value) async {
                            if (value != null) {
                              value.value = (int.parse(value.value) - 1).toString();
                              if (value.value == '0') {
                                value.value = '1';
                              }
                              await widget.db.basicDao.updateBasic(value);
                            }
                          });
                          setState(() {
                            futureQty = widget.db.basicDao.getBasicByKey('future_qty');
                          });
                        },
                      ),
                      FutureBuilder<Basic?>(
                        future: futureQty,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            qty = int.parse(snapshot.data!.value);
                            return Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                snapshot.data!.value,
                                style: const TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            );
                          }
                          return const Text('-');
                        },
                      ),
                      ElevatedButton(
                        child: const Text(
                          '+',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () async {
                          await widget.db.basicDao.getBasicByKey('future_qty').then((value) async {
                            if (value != null) {
                              value.value = (int.parse(value.value) + 1).toString();
                              await widget.db.basicDao.updateBasic(value);
                            }
                          });
                          setState(() {
                            futureQty = widget.db.basicDao.getBasicByKey('future_qty');
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                leading: const Icon(
                  Icons.rice_bowl_outlined,
                  color: Colors.black,
                ),
                title: const Text('Half-Auto'),
                trailing: Checkbox(
                    checkColor: Colors.black,
                    value: automationTrade,
                    onChanged: (value) {
                      setState(() {
                        automationTrade = value!;
                      });
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(
        Icons.warning,
        color: Colors.teal,
      ),
      title: Text(S.of(context).notification),
      content: Text(message),
      actions: [
        ElevatedButton(
          child: Text(
            S.of(context).ok,
            style: const TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Color _generateColorByTickType(num tickType) {
  if (tickType == 2) {
    return Colors.green;
  } else {
    return Colors.red;
  }
}

Color _generateColorByPriceChange(num change) {
  if (change < 0) {
    return Colors.green;
  } else if (change > 0) {
    return Colors.red;
  }
  return Colors.black;
}

Future<RealTimeFutureTick> getData(Map<String, dynamic> json) async {
  return RealTimeFutureTick.fromJson(json);
}

Future<TradeRate> updateTradeRate(Map<String, dynamic> json) async {
  return TradeRate.fromJson(json);
}

Future<TradeIndex> updateTradeIndex(Map<String, dynamic> json) async {
  return TradeIndex.fromJson(json);
}

Future<FuturePosition> updateFuturePosition(Map<String, dynamic> json, String code) async {
  if (json['position'] == null) {
    return FuturePosition();
  }

  for (final element in json['position'] as List) {
    if (element['code'] == code) {
      return FuturePosition.fromJson(element);
    }
  }

  return FuturePosition();
}

int _processBreakCount(num current, num previous, num breakCount) {
  if (previous == 0) {
    return 0;
  }

  var tmpBreakCount = breakCount.toInt();
  if (current > previous) {
    if (breakCount > 0) {
      tmpBreakCount++;
    } else {
      tmpBreakCount = 1;
    }
  } else if (current < previous) {
    if (breakCount < 0) {
      tmpBreakCount--;
    } else {
      tmpBreakCount = -1;
    }
  }
  return tmpBreakCount;
}

Future<List<RealTimeFutureTick>> fillArr(Map<String, dynamic> json, List<RealTimeFutureTick> originalArr) async {
  var tmp = RealTimeFutureTick.fromJson(json);
  if (originalArr.isNotEmpty && originalArr.last.close == tmp.close && originalArr.last.tickType == tmp.tickType) {
    originalArr.last.volume = originalArr.last.volume! + tmp.volume!;
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

  RealTimeFutureTick.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    tickTime = json['tick_time'];
    open = json['open'];
    underlyingPrice = json['underlying_price'];
    bidSideTotalVol = json['bid_side_total_vol'];
    askSideTotalVol = json['ask_side_total_vol'];
    avgPrice = json['avg_price'];
    close = json['close'];
    high = json['high'];
    low = json['low'];
    amount = json['amount'];
    totalAmount = json['total_amount'];
    volume = json['volume'];
    totalVolume = json['total_volume'];
    tickType = json['tick_type'];
    chgType = json['chg_type'];
    priceChg = json['price_chg'];
    pctChg = json['pct_chg'];
    simtrade = json['simtrade'];
  }

  String? code = '';
  String? tickTime = '';
  num? open = 0;
  num? underlyingPrice = 0;
  num? bidSideTotalVol = 0;
  num? askSideTotalVol = 0;
  num? avgPrice = 0;
  num? close = 0;
  num? high = 0;
  num? low = 0;
  num? amount = 0;
  num? totalAmount = 0;
  num? volume = 0;
  num? totalVolume = 0;
  num? tickType = 0;
  num? chgType = 0;
  num? priceChg = 0;
  num? pctChg = 0;
  num? simtrade = 0;
  bool? combo = false;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['tick_time'] = tickTime;
    data['open'] = open;
    data['underlying_price'] = underlyingPrice;
    data['bid_side_total_vol'] = bidSideTotalVol;
    data['ask_side_total_vol'] = askSideTotalVol;
    data['avg_price'] = avgPrice;
    data['close'] = close;
    data['high'] = high;
    data['low'] = low;
    data['amount'] = amount;
    data['total_amount'] = totalAmount;
    data['volume'] = volume;
    data['total_volume'] = totalVolume;
    data['tick_type'] = tickType;
    data['chg_type'] = chgType;
    data['price_chg'] = priceChg;
    data['pct_chg'] = pctChg;
    data['simtrade'] = simtrade;
    return data;
  }
}

class TradeRate {
  TradeRate(this.outRate, this.inRate);

  TradeRate.fromJson(Map<String, dynamic> json) {
    outRate = json['out_rate'];
    inRate = json['in_rate'];
  }

  num? outRate;
  num? inRate;
}

class TradeIndex {
  TradeIndex(this.tse, this.otc, this.nasdaq, this.nf);

  TradeIndex.fromJson(Map<String, dynamic> json) {
    tse = json['tse'] != null ? Snapshot.fromJson(json['tse']) : null;
    otc = json['otc'] != null ? Snapshot.fromJson(json['otc']) : null;
    nasdaq = json['nasdaq'] != null ? YahooPrice.fromJson(json['nasdaq']) : null;
    nf = json['nf'] != null ? YahooPrice.fromJson(json['nf']) : null;
  }

  Snapshot? tse;
  Snapshot? otc;
  YahooPrice? nasdaq;
  YahooPrice? nf;
}

class YahooPrice {
  YahooPrice(this.last, this.price);

  YahooPrice.fromJson(Map<String, dynamic> json) {
    last = json['last'];
    price = json['price'];
  }

  num? last;
  num? price;
}

class Snapshot {
  Snapshot(
      {this.snapTime,
      this.open,
      this.high,
      this.low,
      this.close,
      this.tickType,
      this.priceChg,
      this.pctChg,
      this.chgType,
      this.volume,
      this.volumeSum,
      this.amount,
      this.amountSum,
      this.yesterdayVolume,
      this.volumeRatio});

  Snapshot.fromJson(Map<String, dynamic> json) {
    snapTime = json['snap_time'];
    open = json['open'];
    high = json['high'];
    low = json['low'];
    close = json['close'];
    tickType = json['tick_type'];
    priceChg = json['price_chg'];
    pctChg = json['pct_chg'];
    chgType = json['chg_type'];
    volume = json['volume'];
    volumeSum = json['volume_sum'];
    amount = json['amount'];
    amountSum = json['amount_sum'];
    yesterdayVolume = json['yesterday_volume'];
    volumeRatio = json['volume_ratio'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['snap_time'] = snapTime;
    data['open'] = open;
    data['high'] = high;
    data['low'] = low;
    data['close'] = close;
    data['tick_type'] = tickType;
    data['price_chg'] = priceChg;
    data['pct_chg'] = pctChg;
    data['chg_type'] = chgType;
    data['volume'] = volume;
    data['volume_sum'] = volumeSum;
    data['amount'] = amount;
    data['amount_sum'] = amountSum;
    data['yesterday_volume'] = yesterdayVolume;
    data['volume_ratio'] = volumeRatio;
    return data;
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

  FuturePosition.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    direction = json['direction'];
    quantity = json['quantity'];
    price = json['price'];
    lastPrice = json['last_price'];
    pnl = json['pnl'];
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

  FutureOrder.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    baseOrder = json['base_order'] != null ? BaseOrder.fromJson(json['base_order']) : null;
  }

  String generateStatusMessage() {
    if (baseOrder == null) {
      return '';
    }

    var actionStr = baseOrder!.action == 1 ? 'Buy' : 'Sell';
    switch (baseOrder!.status) {
      case 1:
        return '$actionStr ${baseOrder!.price} PendingSubmit';
      case 2:
        return '$actionStr ${baseOrder!.price} PreSubmitted';
      case 3:
        return '$actionStr ${baseOrder!.price} Submitted';
      case 4:
        return '$actionStr ${baseOrder!.price} Failed';
      case 5:
        return '$actionStr ${baseOrder!.price} Cancelled';
      case 6:
        return '$actionStr ${baseOrder!.price} Filled';
      case 7:
        return '$actionStr ${baseOrder!.price} Filling';
      default:
        return 'Unknown';
    }
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

  BaseOrder.fromJson(Map<String, dynamic> json) {
    orderID = json['order_id'];
    status = json['status'];
    orderTime = json['order_time'];
    action = json['action'];
    price = json['price'];
    quantity = json['quantity'];
    tradeTime = json['trade_time'];
    tickTime = json['tick_time'];
    groupID = json['group_id'];
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
