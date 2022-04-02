import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trade_agent_v2/url.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({Key? key}) : super(key: key);

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  late Future<List<Balance>> futureBalance;

  @override
  void initState() {
    super.initState();
    futureBalance = fetchBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Balance>>(
        future: futureBalance,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var dataArr = <Balance>[];
            dataArr = snapshot.data!;
            num total = 0;
            num lastTotal = 0;
            dataArr.asMap().forEach((i, value) {
              total += value.total!;
              if (i == dataArr.length - 1) {
                lastTotal = value.total!;
              }
            });
            return ListView(
              children: [
                const SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child: Text(
                        'Today',
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Center(
                      child: Text(
                        commaNumber(lastTotal.toString()),
                        style: const TextStyle(fontSize: 60),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child: Text(
                        'Total',
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Center(
                      child: Text(
                        commaNumber(total.toString()),
                        style: const TextStyle(fontSize: 60),
                      ),
                    ),
                  ),
                )
              ],
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

String commaNumber(String n) {
  return n.replaceAllMapped(reg, mathFunc);
}

RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
String mathFunc(Match match) {
  return '${match[1]},';
}

Future<List<Balance>> fetchBalance() async {
  var balanceArr = <Balance>[];
  final response = await http.get(Uri.parse('$tradeAgentURLPrefix/balance'));
  if (response.statusCode == 200) {
    for (final Map<String, dynamic> i in jsonDecode(response.body)) {
      balanceArr.add(Balance.fromJson(i));
    }
    return balanceArr;
  } else {
    return balanceArr;
  }
}

class Balance {
  Balance({this.tradeDay, this.tradeCount, this.forward, this.originalBalance, this.discount, this.total});

  Balance.fromJson(Map<String, dynamic> json) {
    tradeDay = json['trade_day'];
    tradeCount = json['trade_count'];
    forward = json['forward'];
    originalBalance = json['original_balance'];
    discount = json['discount'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['trade_day'] = tradeDay;
    data['trade_count'] = tradeCount;
    data['forward'] = forward;
    data['original_balance'] = originalBalance;
    data['discount'] = discount;
    data['total'] = total;
    return data;
  }

  String? tradeDay;
  num? tradeCount;
  num? forward;
  num? originalBalance;
  num? discount;
  num? total;
}
