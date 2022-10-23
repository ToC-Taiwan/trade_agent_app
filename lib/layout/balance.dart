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
  late Future<Balance> futureBalance;

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
      body: FutureBuilder<Balance>(
        future: futureBalance,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.future == null && snapshot.data!.stock == null) {
              return Center(
                child: Text(
                  S.of(context).no_data,
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                ),
              );
            }
            var data = snapshot.data!;
            num total = 0;
            num lastTotal = 0;
            var latestColor = Colors.black;
            var totalColor = Colors.black;

            var reverseStock = <BalanceDetail>[];
            var reverseFuture = <BalanceDetail>[];

            if (data.stock != null) {
              data.stock!.asMap().forEach((i, value) {
                total += value.total!;
                if (i == data.stock!.length - 1) {
                  lastTotal = value.total!;
                }
              });
              reverseStock = data.stock!.reversed.toList();
            }

            if (data.future != null) {
              data.future!.asMap().forEach((i, value) {
                total += value.total!;
                if (i == data.future!.length - 1) {
                  lastTotal += value.total!;
                }
              });
              reverseFuture = data.future!.reversed.toList();
            }

            if (lastTotal < 0) {
              latestColor = Colors.green;
            } else {
              latestColor = Colors.red;
            }

            if (total < 0) {
              totalColor = Colors.green;
            } else {
              totalColor = Colors.red;
            }

            return Column(children: [
              Expanded(
                flex: 8,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    height: 0,
                    color: Colors.grey,
                  ),
                  itemCount: reverseFuture.length,
                  itemBuilder: (context, index) {
                    Color balance;
                    if (reverseFuture[index].total! < 0) {
                      balance = Colors.green;
                    } else {
                      balance = Colors.red;
                    }
                    return ListTile(
                      // onTap: () {},
                      leading: Icon(Icons.account_balance_wallet, color: balance),
                      title: Text(reverseFuture[index].tradeDay!.substring(0, 10)),
                      subtitle: Text('${S.of(context).trade_count}: ${reverseFuture[index].tradeCount}'),
                      trailing: Text(
                        commaNumber(reverseFuture[index].total.toString()),
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
                flex: 8,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    height: 0,
                    color: Colors.grey,
                  ),
                  itemCount: reverseStock.length,
                  itemBuilder: (context, index) {
                    Color balance;
                    if (reverseStock[index].total! < 0) {
                      balance = Colors.green;
                    } else {
                      balance = Colors.red;
                    }
                    return ListTile(
                      // onTap: () {},
                      leading: Icon(Icons.account_balance_wallet, color: balance),
                      title: Text(reverseStock[index].tradeDay!.substring(0, 10)),
                      subtitle: Text('${S.of(context).trade_count}: ${reverseStock[index].tradeCount}'),
                      trailing: Text(
                        commaNumber(reverseStock[index].total.toString()),
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

Future<Balance> fetchBalance() async {
  // var balance = Balance;
  try {
    final response = await http.get(Uri.parse('$tradeAgentURLPrefix/order/balance'));
    if (response.statusCode == 200) {
      return Balance.fromJson(jsonDecode(response.body));
    } else {
      return Balance();
    }
  } catch (e) {
    return Balance();
  }
}

Widget generateBalanceRow(BalanceDetail balance) {
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

// class Balance {
//   Balance({this.tradeDay, this.tradeCount, this.forward, this.originalBalance, this.discount, this.total});

//   Balance.fromJson(Map<String, dynamic> json) {
//     tradeDay = json['trade_day'];
//     tradeCount = json['trade_count'];
//     forward = json['forward'];
//     originalBalance = json['original_balance'];
//     discount = json['discount'];
//     total = json['total'];
//   }

//   Map<String, dynamic> toJson() {
//     var data = <String, dynamic>{};
//     data['trade_day'] = tradeDay;
//     data['trade_count'] = tradeCount;
//     data['forward'] = forward;
//     data['original_balance'] = originalBalance;
//     data['discount'] = discount;
//     data['total'] = total;
//     return data;
//   }

//   String? tradeDay;
//   num? tradeCount;
//   num? forward;
//   num? originalBalance;
//   num? discount;
//   num? total;
// }

class Balance {
  Balance({this.stock, this.future});
  Balance.fromJson(Map<String, dynamic> json) {
    if (json['stock'] != null) {
      stock = <BalanceDetail>[];
      json['stock'].forEach((v) {
        stock!.add(BalanceDetail.fromJson(v));
      });
    }
    if (json['future'] != null) {
      future = <BalanceDetail>[];
      json['future'].forEach((v) {
        future!.add(BalanceDetail.fromJson(v));
      });
    }
  }

  List<BalanceDetail>? stock;
  List<BalanceDetail>? future;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (stock != null) {
      data['stock'] = stock!.map((v) => v.toJson()).toList();
    }
    if (future != null) {
      data['future'] = future!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BalanceDetail {
  BalanceDetail({this.id, this.tradeCount, this.forward, this.reverse, this.originalBalance, this.discount, this.total, this.tradeDay});
  BalanceDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tradeCount = json['trade_count'];
    forward = json['forward'];
    reverse = json['reverse'];
    originalBalance = json['original_balance'];
    discount = json['discount'];
    total = json['total'];
    tradeDay = json['trade_day'];
  }
  num? id;
  num? tradeCount;
  num? forward;
  num? reverse;
  num? originalBalance;
  num? discount;
  num? total;
  String? tradeDay;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['trade_count'] = tradeCount;
    data['forward'] = forward;
    data['reverse'] = reverse;
    data['original_balance'] = originalBalance;
    data['discount'] = discount;
    data['total'] = total;
    data['trade_day'] = tradeDay;
    return data;
  }
}
