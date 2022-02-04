import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:trade_agent_app/url.dart';

class Targetspage extends StatefulWidget {
  const Targetspage({Key? key}) : super(key: key);

  @override
  _TargetspageState createState() => _TargetspageState();
}

class _TargetspageState extends State<Targetspage> {
  late Future<List<Target>> futureTargets;

  @override
  void initState() {
    super.initState();
    futureTargets = fetchTargets();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Target>>(
        future: futureTargets,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Widget> tmp = [];
            tmp.add(const SizedBox(
              height: 15,
            ));
            for (Target i in snapshot.data!) {
              tmp.add(
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          i.rank.toString(),
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          i.stock!.number!,
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          i.stock!.name!,
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          i.stock!.lastClose!.toString(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.amber[50],
                        child: Text(
                          i.volume.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              );
              tmp.add(const SizedBox(
                height: 30,
              ));
            }
            return ListView(
              children: tmp,
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

Future<List<Target>> fetchTargets() async {
  List<Target> targetArr = [];
  final response = await http.get(Uri.parse(tradeAgentURLPrefix + '/targets'));
  if (response.statusCode == 200) {
    for (Map<String, dynamic> i in jsonDecode(response.body)) {
      targetArr.add(Target.fromJson(i));
    }
    return targetArr;
  } else {
    throw Exception('Failed to load');
  }
}

class Target {
  Stock? stock;
  num? stockId;
  String? tradeDay;
  num? rank;
  num? volume;

  Target({this.stock, this.stockId, this.tradeDay, this.rank, this.volume});

  Target.fromJson(Map<String, dynamic> json) {
    stock = json['stock'] != null ? Stock.fromJson(json['stock']) : null;
    stockId = json['stock_id'];
    tradeDay = json['trade_day'];
    rank = json['rank'];
    volume = json['volume'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (stock != null) {
      data['stock'] = stock!.toJson();
    }
    data['stock_id'] = stockId;
    data['trade_day'] = tradeDay;
    data['rank'] = rank;
    data['volume'] = volume;
    return data;
  }
}

class Stock {
  String? number;
  String? name;
  String? exchange;
  String? category;
  bool? dayTrade;
  num? lastClose;

  Stock({this.number, this.name, this.exchange, this.category, this.dayTrade, this.lastClose});

  Stock.fromJson(Map<dynamic, dynamic> json) {
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
}
