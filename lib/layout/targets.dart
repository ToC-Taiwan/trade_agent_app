import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:trade_agent_v2/basic/url.dart';
import 'package:trade_agent_v2/generated/l10n.dart';
import 'package:trade_agent_v2/utils/app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class Targetspage extends StatefulWidget {
  const Targetspage({Key? key}) : super(key: key);

  @override
  _TargetspageState createState() => _TargetspageState();
}

class _TargetspageState extends State<Targetspage> {
  List<Target> current = [];
  late Future<List<Target>> futureTargets;

  @override
  void initState() {
    super.initState();
    futureTargets = fetchTargets(current, -1);
  }

  void _onItemClick(num opt) {
    setState(() {
      futureTargets = fetchTargets(current, opt);
    });
  }

  void _launchInWebViewOrVC(String url) async {
    await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: trAppbar(
        context,
        S.of(context).targets,
      ),
      body: SizedBox(
        child: FutureBuilder<List<Target>>(
          future: futureTargets,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var tmp = <Widget>[];
              current = snapshot.data!;
              for (final i in snapshot.data!) {
                if (i.rank == -1) {
                  continue;
                }
                tmp.add(
                  buildTile(
                    1,
                    1,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            i.stock!.number!,
                            style: const TextStyle(fontSize: 22, color: Colors.black),
                          ),
                        ),
                        Expanded(
                          child: AutoSizeText(
                            i.stock!.name!,
                            style: const TextStyle(fontSize: 22, color: Color.fromARGB(255, 0, 46, 184), fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText(
                                  commaNumber('${i.volume! ~/ 1000}k'),
                                  style: const TextStyle(fontSize: 14, color: Colors.red),
                                ),
                                AutoSizeText(
                                  i.stock!.lastClose!.toString(),
                                  style: const TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Text(i.rank.toString()),
                      ],
                    ),
                    onTap: () {
                      var number = i.stock!.number!;
                      setState(() {
                        _launchInWebViewOrVC('https://tw.stock.yahoo.com/quote/$number.TW');
                      });
                    },
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      // controller: emailController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.search),
                        border: const UnderlineInputBorder(),
                        labelText: S.of(context).search,
                        hintText: S.of(context).stock_number,
                      ),
                      textInputAction: TextInputAction.search,
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                          _onItemClick(int.parse(val));
                        } else {
                          _onItemClick(-1);
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: StaggeredGrid.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        children: tmp,
                      ),
                    ),
                  ],
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

RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

String commaNumber(String n) {
  return n.replaceAllMapped(reg, mathFunc);
}

String mathFunc(Match match) {
  return '${match[1]},';
}

Widget buildTile(int cross, int main, Widget child, {Function()? onTap}) {
  return StaggeredGridTile.count(
    crossAxisCellCount: cross,
    mainAxisCellCount: main,
    child: Material(
      color: Colors.grey[100],
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      shadowColor: Colors.pink.shade50,
      child: InkWell(
        onTap: onTap != null ? () => onTap() : () {},
        child: child,
      ),
    ),
  );
}

Future<List<Target>> fetchTargets(List<Target> current, num opt) async {
  var targetArr = <Target>[];
  if (opt == -1) {
    final response = await http.get(Uri.parse('$tradeAgentURLPrefix/targets'));
    if (response.statusCode == 200) {
      for (final Map<String, dynamic> i in jsonDecode(response.body)) {
        targetArr.add(Target.fromJson(i));
      }
      return targetArr;
    } else {
      return targetArr;
    }
  } else {
    for (final i in current) {
      if (i.stock!.number!.substring(0, opt.toString().length) == opt.toString()) {
        targetArr.add(i);
      }
    }
  }
  return targetArr;
}

class Target {
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

  Stock? stock;
  num? stockId;
  String? tradeDay;
  num? rank;
  num? volume;
}

class Stock {
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

  String? number;
  String? name;
  String? exchange;
  String? category;
  bool? dayTrade;
  num? lastClose;
}
