import 'dart:async';
import 'dart:convert';

import 'package:date_format/date_format.dart' as df;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:trade_agent_v2/basic/base.dart';
import 'package:trade_agent_v2/database.dart';
import 'package:trade_agent_v2/generated/l10n.dart';
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

  List<RealTimeFutureTick> tickArr = [];
  int qty = 1;
  String mxfCode = '';

  bool automationTrade = false;
  bool automationByTimer = false;
  bool automationByBalance = false;

  bool allowBuy = true;
  bool allowSell = true;

  Future<RealTimeFutureTick?> realTimeFutureTick = Future.value();
  Future<PeriodOutInVolume?> periodVolume = Future.value();
  Future<FuturePosition?> futurePosition = Future.value();
  Future<TradeIndex?> tradeIndex = Future.value();
  Future<List<RealTimeFutureTick>> realTimeFutureTickArr = Future.value([]);

  YahooPrice previousNasdaq = YahooPrice('');
  YahooPrice previousNF = YahooPrice('');
  Snapshot previousTSE = Snapshot('');
  Snapshot previousOTC = Snapshot('');

  int nsadaqBreakCount = 0;
  int nfBreakCount = 0;
  int tseBreakCount = 0;
  int otcBreakCount = 0;

  @override
  void initState() {
    super.initState();
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
          return;
        }

        if (msg.containsKey('first_period')) {
          setState(() {
            periodVolume = updateTradeRate(msg);
          });
          return;
        }

        if (msg.containsKey('base_order')) {
          if (mounted) {
            _showDialog(context, FutureOrder.fromJson(msg).generateStatusMessage());
          }
          return;
        }

        if (msg.containsKey('tse')) {
          setState(() {
            tradeIndex = updateTradeIndex(msg);
          });
          return;
        }

        if (msg.containsKey('position')) {
          if (mxfCode.isNotEmpty) {
            futurePosition = updateFuturePosition(msg, mxfCode);
          }
          return;
        }

        if (msg.containsKey('err_msg')) {
          if (mounted) {
            _showDialog(context, msg['err_msg']);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: trAppbar(
        context,
        S.of(context).future_trade,
        widget.db,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                automationByBalance = !automationByBalance;
              });
            },
            icon: Icon(Icons.monetization_on, color: automationByBalance ? Colors.blueAccent : Colors.grey),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                automationByTimer = !automationByTimer;
              });
            },
            icon: Icon(Icons.timer, color: automationByTimer ? Colors.blueAccent : Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                setState(() {
                  automationTrade = !automationTrade;
                  if (automationTrade) {
                    allowBuy = false;
                    allowSell = false;
                  } else {
                    allowBuy = true;
                    allowSell = true;
                  }
                });
              },
              icon: Icon(Icons.power_settings_new_rounded, color: automationTrade ? Colors.greenAccent : Colors.grey),
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
                    var priceChg = snapshot.data!.priceChg!;
                    var type = (priceChg > 0) ? '↗️' : '↘️';

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
                                                      'Buy: ${snapshot.data!.quantity}\nAvg: ${snapshot.data!.price}',
                                                      style:
                                                          GoogleFonts.getFont('Source Code Pro', fontStyle: FontStyle.normal, fontSize: 15, color: Colors.grey),
                                                    );
                                                  }
                                                  if (snapshot.data!.direction == 'Sell') {
                                                    return Text(
                                                      'Sell: ${snapshot.data!.quantity}\nAvg: ${snapshot.data!.price}',
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
                                                                    color: nasdaqChg < 0 ? Colors.green : Colors.red),
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
                                                                  color: nsadaqBreakCount < 0 ? Colors.green : Colors.red,
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
                                                                  color: nfChg < 0 ? Colors.green : Colors.red,
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
                                                                    color: nfBreakCount < 0 ? Colors.green : Colors.red),
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
                                                                    color: snapshot.data!.tse!.priceChg! < 0 ? Colors.green : Colors.red),
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
                                                                    color: tseBreakCount < 0 ? Colors.green : Colors.red),
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
                                                                    color: snapshot.data!.otc!.priceChg! < 0 ? Colors.green : Colors.red),
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
                                                                    color: otcBreakCount < 0 ? Colors.green : Colors.red),
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
                                style: TextStyle(
                                  fontSize: 50,
                                  color: priceChg > 0 ? Colors.red : Colors.green,
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
                              if (snapshot.hasData) {
                                var percent1 = 100 *
                                    snapshot.data!.firstPeriod!.outVolume! /
                                    (snapshot.data!.firstPeriod!.outVolume! + snapshot.data!.firstPeriod!.inVolume!);
                                var percent2 = 100 *
                                    snapshot.data!.secondPeriod!.outVolume! /
                                    (snapshot.data!.secondPeriod!.outVolume! + snapshot.data!.secondPeriod!.inVolume!);
                                var percent3 = 100 *
                                    snapshot.data!.thirdPeriod!.outVolume! /
                                    (snapshot.data!.thirdPeriod!.outVolume! + snapshot.data!.thirdPeriod!.inVolume!);
                                var percent4 = 100 *
                                    snapshot.data!.fourthPeriod!.outVolume! /
                                    (snapshot.data!.fourthPeriod!.outVolume! + snapshot.data!.fourthPeriod!.inVolume!);

                                var rate = (snapshot.data!.fourthPeriod!.outVolume! + snapshot.data!.fourthPeriod!.inVolume!) / 40;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildVolumeRatioCircle(percent1),
                                    _buildVolumeRatioCircle(percent2),
                                    Text(
                                      '${rate.toStringAsFixed(2)}/s',
                                      style: GoogleFonts.getFont(
                                        'Source Code Pro',
                                        fontStyle: FontStyle.normal,
                                        fontSize: 25,
                                      ),
                                    ),
                                    _buildVolumeRatioCircle(percent3),
                                    _buildVolumeRatioCircle(percent4),
                                  ],
                                );
                              }
                              return Container();
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
                                  elevation: MaterialStateProperty.all(16),
                                  backgroundColor: allowBuy ? MaterialStateProperty.all(Colors.red) : MaterialStateProperty.all(Colors.grey),
                                ),
                                onPressed: () {
                                  if (allowBuy) {
                                    _channel.sink.add(jsonEncode({
                                      'topic': 'future_trade',
                                      'future_order': {
                                        'code': snapshot.data!.code,
                                        'action': 1,
                                        'price': snapshot.data!.close,
                                        'qty': qty,
                                      },
                                    }));
                                  }
                                },
                                child: SizedBox(
                                  width: 130,
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
                              ElevatedButton(
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(16),
                                  backgroundColor: allowSell ? MaterialStateProperty.all(Colors.green) : MaterialStateProperty.all(Colors.grey),
                                ),
                                onPressed: () {
                                  if (allowSell) {
                                    _channel.sink.add(jsonEncode({
                                      'topic': 'future_trade',
                                      'future_order': {
                                        'code': snapshot.data!.code,
                                        'action': 2,
                                        'price': snapshot.data!.close,
                                        'qty': qty,
                                      },
                                    }));
                                  }
                                },
                                child: SizedBox(
                                  width: 130,
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
                              '${value[index].close}',
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
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                  ));
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ListTile(
                  leading: const Icon(
                    Icons.numbers_outlined,
                    color: Colors.teal,
                  ),
                  title: Text(S.of(context).quantity),
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

Widget _buildVolumeRatioCircle(double percent) {
  return CircularPercentIndicator(
    animateFromLastPercent: true,
    animation: true,
    radius: 25,
    lineWidth: 8,
    percent: percent / 100,
    center: Text('${percent.toStringAsFixed(0)}%'),
    progressColor: generateOutInRatioColor(percent),
  );
}

void _showDialog(BuildContext context, String message) {
  if (message.isNotEmpty) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        iconColor: Colors.teal,
        icon: const Icon(
          Icons.warning,
          size: 40,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(S.of(context).notification),
        content: Text(
          message,
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

Future<RealTimeFutureTick> getData(Map<String, dynamic> json) async {
  return RealTimeFutureTick.fromJson(json);
}

Future<PeriodOutInVolume> updateTradeRate(Map<String, dynamic> json) async {
  return PeriodOutInVolume.fromJson(json);
}

Future<TradeIndex> updateTradeIndex(Map<String, dynamic> json) async {
  return TradeIndex.fromJson(json);
}

Future<FuturePosition> updateFuturePosition(Map<String, dynamic> json, String code) async {
  if (json['position'] != null) {
    for (final element in json['position'] as List) {
      if (element['code'] == code) {
        return FuturePosition.fromJson(element);
      }
    }
  }

  return FuturePosition();
}

Future<List<RealTimeFutureTick>> fillArr(Map<String, dynamic> json, List<RealTimeFutureTick> originalArr) async {
  var tmp = RealTimeFutureTick.fromJson(json);
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

class OutInVolume {
  OutInVolume(this.outVolume, this.inVolume);

  OutInVolume.fromJson(Map<String, dynamic> json) {
    outVolume = json['out_volume'];
    inVolume = json['in_volume'];
  }

  num? outVolume;
  num? inVolume;
}

class PeriodOutInVolume {
  PeriodOutInVolume(this.firstPeriod, this.secondPeriod, this.thirdPeriod, this.fourthPeriod);

  PeriodOutInVolume.fromJson(Map<String, dynamic> json) {
    firstPeriod = json['first_period'] != null ? OutInVolume.fromJson(json['first_period']) : null;
    secondPeriod = json['second_period'] != null ? OutInVolume.fromJson(json['second_period']) : null;
    thirdPeriod = json['third_period'] != null ? OutInVolume.fromJson(json['third_period']) : null;
    fourthPeriod = json['fourth_period'] != null ? OutInVolume.fromJson(json['fourth_period']) : null;
  }

  OutInVolume? firstPeriod;
  OutInVolume? secondPeriod;
  OutInVolume? thirdPeriod;
  OutInVolume? fourthPeriod;
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
  YahooPrice(this.updateAt);

  YahooPrice.fromJson(Map<String, dynamic> json) {
    last = json['last'];
    price = json['price'];
    updateAt = json['updated_at'];
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

class Snapshot {
  Snapshot(this.snapTime);

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

  int _processBreakCount(Snapshot previous, num breakCount) {
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
        return '$actionStr ${baseOrder!.price}\nPendingSubmit';
      case 2:
        return '$actionStr ${baseOrder!.price}\nPreSubmitted';
      case 3:
        return '$actionStr ${baseOrder!.price}\nSubmitted';
      case 4:
        return '$actionStr ${baseOrder!.price}\nFailed';
      case 5:
        return '$actionStr ${baseOrder!.price}\nCancelled';
      case 6:
        return '$actionStr ${baseOrder!.price}\nFilled';
      case 7:
        return '$actionStr ${baseOrder!.price}\nPartFilled';
      default:
        return '';
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

Color generateOutInRatioColor(double percent) {
  if (percent >= 55) {
    return Colors.red;
  } else if (percent <= 45) {
    return Colors.green;
  }
  return Colors.yellow;
}
