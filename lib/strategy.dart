import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trade_agent_app/url.dart';

class StrategyPage extends StatefulWidget {
  const StrategyPage({Key? key}) : super(key: key);

  @override
  State<StrategyPage> createState() => _StrategyPage();
}

class _StrategyPage extends State<StrategyPage> {
  late Future<List<Strategy>> futureStrategy;

  @override
  void initState() {
    super.initState();
    futureStrategy = fetchStrategy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Strategy'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.add),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {
                      addTargets('1', context);
                    },
                    child: const Text(
                      'Add 0 - 10',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {
                      addTargets('2', context);
                    },
                    child: const Text(
                      'Add 10 - 50',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {
                      addTargets('3', context);
                    },
                    child: const Text(
                      'Add 50 - 100',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {
                      addTargets('4', context);
                    },
                    child: const Text(
                      'Add 100 - 500',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ];
            },
          )
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Strategy>>(
          future: futureStrategy,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                );
              }
              var data = snapshot.data;
              return Center(
                child: ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Card(
                        child: ListTile(
                          title: Text(data[index].date!),
                          subtitle: Text(
                            data[index].stocks!.length.toString(),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(data[index].date!),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: generateStockRow(data[index].stocks!, context),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

List<Widget> generateStockRow(List<Stocks> arr, BuildContext context) {
  var tmp = <Widget>[];
  for (final i in arr) {
    tmp.add(SizedBox(
      // height: 15,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        children: [
          Expanded(
            child: Text(
              i.number!,
            ),
          ),
          Expanded(
            child: Text(
              i.name!,
            ),
          ),
        ],
      ),
    ));
  }
  return tmp;
}

String commaNumber(String n) {
  return n.replaceAllMapped(reg, mathFunc);
}

RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
String mathFunc(Match match) {
  return '${match[1]},';
}

Widget generateRow(String columnName, String value) {
  return SizedBox(
    height: 50,
    child: Padding(
      padding: const EdgeInsets.only(left: 20, top: 20),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$columnName: ',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    ),
  );
}

void addTargets(String opt, BuildContext context) async {
  final response = await http.post(
    Uri.parse('$tradeAgentURLPrefix/targets'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'price_range': opt,
    },
  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    num count;
    count = jsonDecode(response.body)['total_add'];
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Result'),
          content: Text('Success $count added'),
        );
      },
    );
  } else {
    await showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Fail'),
        );
      },
    );
  }
}

Future<List<Strategy>> fetchStrategy() async {
  var straregyArr = <Strategy>[];
  final response = await http.get(Uri.parse('$tradeAgentURLPrefix/targets/quater'));
  if (response.statusCode == 200) {
    for (final Map<String, dynamic> i in jsonDecode(response.body)) {
      straregyArr.add(Strategy.fromJson(i));
    }
    return straregyArr;
  } else {
    return straregyArr;
  }
}

class Strategy {
  Strategy({this.date, this.stocks});

  Strategy.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['stocks'] != null) {
      stocks = <Stocks>[];
      json['stocks'].forEach((v) {
        stocks!.add(Stocks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['date'] = date;
    if (stocks != null) {
      data['stocks'] = stocks!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String? date;
  List<Stocks>? stocks;
}

class Stocks {
  Stocks({this.number, this.name, this.exchange, this.category, this.dayTrade, this.lastClose});

  Stocks.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    name = json['name'];
    exchange = json['exchange'];
    category = json['category'];
    dayTrade = json['day_trade'];
    lastClose = json['last_close'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['number'] = number;
    data['name'] = name;
    data['exchange'] = exchange;
    data['category'] = category;
    data['day_trade'] = dayTrade;
    data['last_close'] = lastClose;
    return data;
  }

  String? number;
  String? name;
  String? exchange;
  String? category;
  bool? dayTrade;
  num? lastClose;
}
