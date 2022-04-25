import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trade_agent_v2/basic/basic.dart';
import 'package:trade_agent_v2/database.dart';
import 'package:trade_agent_v2/generated/l10n.dart';
import 'package:trade_agent_v2/utils/app_bar.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({Key? key, required this.db}) : super(key: key);
  final AppDatabase db;

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: trAppbar(
        context,
        S.of(context).balance,
        widget.db,
      ),
      body: FutureBuilder<List<Balance>>(
        future: futureBalance,
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
            var dataArr = <Balance>[];
            var rows = <Widget>[];
            dataArr = snapshot.data!;
            num total = 0;
            num lastTotal = 0;
            var latestColor = Colors.black;
            var totalColor = Colors.black;
            dataArr.asMap().forEach((i, value) {
              rows.add(generateBalanceRow(value));
              total += value.total!;
              if (i == dataArr.length - 1) {
                lastTotal = value.total!;
                if (lastTotal < 0) {
                  latestColor = Colors.green;
                } else {
                  latestColor = Colors.red;
                }
              }
            });
            if (total < 0) {
              totalColor = Colors.green;
            } else {
              totalColor = Colors.red;
            }
            var reverse = dataArr.reversed.toList();
            return Column(children: [
              Expanded(
                flex: 14,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    height: 0,
                    color: Colors.grey,
                  ),
                  itemCount: reverse.length,
                  itemBuilder: (context, index) {
                    Color balance;
                    if (reverse[index].total! < 0) {
                      balance = Colors.green;
                    } else {
                      balance = Colors.red;
                    }
                    return ListTile(
                      // onTap: () {},
                      leading: Icon(Icons.account_balance_wallet, color: balance),
                      title: Text(reverse[index].tradeDay!.substring(0, 10)),
                      subtitle: Text('${S.of(context).trade_count}: ${reverse[index].tradeCount}'),
                      trailing: Text(
                        commaNumber(reverse[index].total.toString()),
                        style: TextStyle(
                          fontSize: 18,
                          color: balance,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: ListTile(
                        title: Text(
                          S.of(context).latest,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: SizedBox(
                          child: Text(
                            commaNumber(lastTotal.toString()),
                            style: TextStyle(fontSize: 22, color: latestColor),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: ListTile(
                        title: Text(
                          S.of(context).total,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: SizedBox(
                          child: Text(
                            commaNumber(total.toString()),
                            style: TextStyle(fontSize: 22, color: totalColor),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 26),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {
                              futureBalance = fetchBalance();
                            });
                          },
                          icon: const Icon(
                            Icons.refresh,
                            size: 28,
                          ),
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]);
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

String commaNumber(String n) {
  return n.replaceAllMapped(reg, mathFunc);
}

RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
String mathFunc(Match match) {
  return '${match[1]},';
}

Future<List<Balance>> fetchBalance() async {
  var balanceArr = <Balance>[];
  try {
    final response = await http.get(Uri.parse('$tradeAgentURLPrefix/balance'));
    if (response.statusCode == 200) {
      for (final Map<String, dynamic> i in jsonDecode(response.body)) {
        balanceArr.add(Balance.fromJson(i));
      }
      return balanceArr;
    } else {
      return balanceArr;
    }
  } catch (e) {
    return balanceArr;
  }
}

Widget generateBalanceRow(Balance balance) {
  Color tmp;
  if (balance.total! > 0) {
    tmp = Colors.red;
  } else {
    tmp = Colors.green;
  }
  return Padding(
    padding: const EdgeInsets.only(top: 18, left: 20),
    child: Row(
      children: [
        Expanded(
            flex: 4,
            child: Text(
              balance.tradeDay!.substring(0, 10),
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
        Expanded(
            flex: 2,
            child: Text(
              balance.tradeCount!.toString(),
            )),
        Expanded(
          flex: 3,
          child: Text(
            balance.originalBalance!.toString(),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            balance.discount!.toString(),
          ),
        ),
        Expanded(
            flex: 3,
            child: Text(
              balance.total!.toString(),
              style: TextStyle(color: tmp),
            )),
      ],
    ),
  );
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
