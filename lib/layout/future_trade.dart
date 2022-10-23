import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trade_agent_v2/basic/basic.dart';
import 'package:trade_agent_v2/database.dart';
import 'package:trade_agent_v2/generated/l10n.dart';
import 'package:trade_agent_v2/models/future_tick.dart';
import 'package:trade_agent_v2/utils/app_bar.dart';
import 'package:web_socket_channel/io.dart';

class FutureTradePage extends StatefulWidget {
  const FutureTradePage({Key? key, required this.db}) : super(key: key);
  final AppDatabase db;

  @override
  State<FutureTradePage> createState() => _FutureTradePageState();
}

class _FutureTradePageState extends State<FutureTradePage> {
  TextEditingController textFieldController = TextEditingController();

  late Future<RealTimeFutureTick?> realTimeFutureTick;
  late Future<List<RealTimeFutureTick>> realTimeFutureTickArr;

  final _channel = IOWebSocketChannel.connect(Uri.parse(tradeAgentFutureWSURLPrefix));

  List<RealTimeFutureTick> tickArr = [];

  @override
  void initState() {
    realTimeFutureTick = widget.db.futureTickDao.getLastFutureTick();
    realTimeFutureTickArr = widget.db.futureTickDao.getAllFutureTick();
    realTimeFutureTickArr.then((value) => {tickArr = value});

    super.initState();
    _channel.stream.listen((message) {
      setState(() {
        realTimeFutureTick = getData(message);
        realTimeFutureTickArr = fillArr(message, tickArr);
      });
    });
  }

  @override
  void dispose() {
    textFieldController.dispose();
    _channel.sink.close();
    widget.db.futureTickDao.deleteAllFutureTick();
    widget.db.futureTickDao.insertFutureTick(tickArr);
    super.dispose();
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
                    Color tmp;
                    String type;
                    if (snapshot.data!.priceChg! < 0) {
                      tmp = Colors.green;
                      type = '↘️';
                    } else {
                      tmp = Colors.red;
                      type = '↗️';
                    }

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  snapshot.data!.high.toString(),
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  snapshot.data!.low.toString(),
                                  // snapshot.data!.priceChg.toString(),
                                  style: const TextStyle(
                                    fontSize: 30,
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
