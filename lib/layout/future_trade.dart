import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trade_agent_v2/basic/basic.dart';
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

  int orderQty = 2;
  List<RealTimeFutureTick> tickArr = [];

  Future<RealTimeFutureTick?> realTimeFutureTick = Future.value();
  Future<List<RealTimeFutureTick>> realTimeFutureTickArr = Future.value([]);

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

        setState(() {
          realTimeFutureTick = getData(message);
          realTimeFutureTickArr = fillArr(message, tickArr);
        });
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
    var baseFlex = 16;
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
              flex: baseFlex,
              child: FutureBuilder<RealTimeFutureTick?>(
                future: realTimeFutureTick,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
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

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Text(
                                  snapshot.data!.code!,
                                  style: const TextStyle(fontSize: 50, color: Colors.grey),
                                ),
                              ],
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
                                        'qty': orderQty,
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
                                        'qty': orderQty,
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
                      ),
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
              flex: baseFlex - 1,
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
                        Color tmp;
                        if (value[index].tickType == 2) {
                          tmp = Colors.green;
                        } else {
                          tmp = Colors.red;
                        }
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: tmp,
                              width: 1.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            // onTap: () async {},
                            title: Text('${value[index].close}'),
                            trailing: Text(
                              '${value[index].volume!}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
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
          ],
        ),
      ),
    );
  }
}

Future<RealTimeFutureTick> getData(String message) async {
  return RealTimeFutureTick.fromJson(jsonDecode(message));
}

Future<List<RealTimeFutureTick>> fillArr(String message, List<RealTimeFutureTick> originalArr) async {
  if (originalArr.length > 4) {
    originalArr.removeAt(0);
  }
  originalArr.add(RealTimeFutureTick.fromJson(jsonDecode(message)));
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
