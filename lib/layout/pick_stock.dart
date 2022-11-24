import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trade_agent_v2/basic/base.dart';
import 'package:trade_agent_v2/database.dart';
import 'package:trade_agent_v2/generated/l10n.dart';
import 'package:trade_agent_v2/layout/kbar.dart';
import 'package:trade_agent_v2/models/model.dart';
import 'package:trade_agent_v2/utils/app_bar.dart';
import 'package:web_socket_channel/io.dart';

class PickStockPage extends StatefulWidget {
  const PickStockPage({Key? key, required this.db}) : super(key: key);
  final AppDatabase db;

  @override
  State<PickStockPage> createState() => _PickStockPageState();
}

class _PickStockPageState extends State<PickStockPage> {
  var _channel = IOWebSocketChannel.connect(Uri.parse(tradeAgentWSURLPrefix));

  TextEditingController textFieldController = TextEditingController();

  List<PickStock> stockList = [];
  late Future<List<PickStock>> stockArray;

  @override
  void initState() {
    super.initState();
    stockArray = widget.db.pickStockDao.getAllPickStock();
    initialWS();
    checkConnection();
  }

  @override
  void dispose() {
    textFieldController.dispose();
    _channel.sink.close();
    super.dispose();
  }

  void initialWS() {
    _channel.stream.listen(
      (message) {
        if (message == 'pong') {
          return;
        }

        for (final Map<String, dynamic> i in jsonDecode(message)) {
          for (final j in stockList) {
            if (i['stock_num'] == j.stockNum) {
              if (i['price_change'] is int) {
                var tmp = i['price_change'] as int;
                i['price_change'] = tmp.toDouble();
              }
              if (i['price_change_rate'] is int) {
                var tmp = i['price_change_rate'] as int;
                i['price_change_rate'] = tmp.toDouble();
              }
              if (i['price'] is int) {
                var tmp = i['price'] as int;
                i['price'] = tmp.toDouble();
              }
              var tmp = PickStock(
                i['stock_num'],
                i['stock_name'],
                0,
                i['price_change'],
                i['price_change_rate'],
                i['price'],
                id: j.id,
                createTime: j.createTime,
                updateTime: j.updateTime,
              );
              if (i['wrong']) {
                widget.db.pickStockDao.deletePickStock(tmp);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(S.of(context).warning),
                    content: Text('${tmp.stockNum} ${S.of(context).stock_dose_not_exist}'),
                    actions: [
                      ElevatedButton(
                        child: Text(
                          S.of(context).ok,
                          style: const TextStyle(color: Colors.black),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              } else {
                widget.db.pickStockDao.updatePickStock(tmp);
              }
              break;
            }
          }
        }
        setState(() {
          stockArray = widget.db.pickStockDao.getAllPickStock();
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
    var actions = [
      IconButton(
        icon: const Icon(Icons.delete_forever),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(S.of(context).delete_all_pick_stock),
              content: Text(S.of(context).delete_all_pick_stock_confirm),
              actions: [
                ElevatedButton(
                  child: Text(
                    S.of(context).cancel,
                    style: const TextStyle(color: Colors.black),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: Text(
                    S.of(context).delete,
                    style: const TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    widget.db.pickStockDao.deleteAllPickStock();
                    stockList = [];
                    _channel.sink.add(jsonEncode({
                      'topic': 'pick_stock',
                      'pick_stock_list': [],
                    }));
                    setState(() {
                      stockArray = widget.db.pickStockDao.getAllPickStock();
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(S.of(context).type_stock_number),
                  content: TextField(
                    // onChanged: (value) {},
                    controller: textFieldController,
                    decoration: InputDecoration(
                      hintText: '${S.of(context).stock_number}(0050, 00878...)',
                    ),
                    keyboardType: TextInputType.number,
                    autofocus: true,
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text(
                        S.of(context).cancel,
                        style: const TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        textFieldController.clear();
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (textFieldController.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(S.of(context).warning),
                              content: Text(S.of(context).input_must_not_empty),
                              actions: [
                                ElevatedButton(
                                  child: Text(
                                    S.of(context).ok,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          );
                          return;
                        }
                        var t = PickStock(
                          textFieldController.text,
                          textFieldController.text,
                          1,
                          0,
                          0,
                          0,
                        );
                        var exist =
                            stockList.firstWhere((element) => element.stockNum == textFieldController.text, orElse: () => PickStock('', '', 0, 0, 0, 0));
                        if (exist.stockNum == '') {
                          widget.db.pickStockDao.insertPickStock(t);
                          setState(() {
                            stockArray = widget.db.pickStockDao.getAllPickStock();
                          });
                        }
                        textFieldController.clear();
                        Navigator.pop(context);
                      },
                      child: Text(
                        S.of(context).add,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      )
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: trAppbar(
        context,
        S.of(context).pick_stock,
        widget.db,
        actions: actions,
      ),
      body: FutureBuilder<List<PickStock>>(
        future: stockArray,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              _channel.sink.add(jsonEncode({
                'topic': 'pick_stock',
                'pick_stock_list': [],
              }));
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.of(context).no_pick_stock,
                      style: const TextStyle(fontSize: 30),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        S.of(context).click_plus_to_add_stock,
                        style: const TextStyle(fontSize: 22, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              var numList = <String>[];
              stockList = [];
              for (final s in snapshot.data!) {
                stockList.add(s);
                numList.add(s.stockNum);
              }
              _channel.sink.add(jsonEncode({
                'topic': 'pick_stock',
                'pick_stock_list': numList,
              }));
            }
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                height: 0,
                color: Colors.grey,
              ),
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var textColor = Colors.black;
                if (snapshot.data![index].priceChangeRate < 0) {
                  textColor = Colors.green;
                } else if (snapshot.data![index].priceChangeRate > 0) {
                  textColor = Colors.red;
                }
                var sign = '';
                if (snapshot.data![index].priceChangeRate > 0) {
                  sign = '+';
                }
                return ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          snapshot.data![index].stockName,
                          style: TextStyle(fontSize: 23, color: textColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          snapshot.data![index].price.toString(),
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 23, color: textColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: Text(
                          snapshot.data![index].stockNum,
                          // style: TextStyle(
                          //   color: textColor,
                          // ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '$sign${snapshot.data![index].priceChange}($sign${snapshot.data![index].priceChangeRate}%)',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Kbar(
                          stockNum: snapshot.data![index].stockNum,
                          stockName: snapshot.data![index].stockName,
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(S.of(context).delete),
                          content: Text(S.of(context).delete_pick_stock_confirm),
                          actions: <Widget>[
                            ElevatedButton(
                              child: Text(
                                S.of(context).cancel,
                                style: const TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            ElevatedButton(
                              child: Text(
                                S.of(context).ok,
                                style: const TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.db.pickStockDao.deletePickStock(snapshot.data![index]);
                                  stockArray = widget.db.pickStockDao.getAllPickStock();
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
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
    );
  }
}
