import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trade_agent_v2/constant/constant.dart';
import 'package:trade_agent_v2/entity/entity.dart';
import 'package:trade_agent_v2/generated/l10n.dart';

class TradeConfigPage extends StatefulWidget {
  const TradeConfigPage({Key? key}) : super(key: key);

  @override
  State<TradeConfigPage> createState() => _TradeConfigPageState();
}

class _TradeConfigPageState extends State<TradeConfigPage> {
  late Future<Config> futureConfig;

  @override
  void initState() {
    super.initState();
    futureConfig = fetchConfig();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          title: Text(S.of(context).trade_configuration),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: FutureBuilder<Config>(
            future: futureConfig,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                if (data.http == null) {
                  return Text(
                    S.of(context).no_data,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  );
                }
                return ListView(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.computer, color: Colors.black),
                      title: const Text(
                        'HTTP',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: ListTile(
                            title: const Text('Port'),
                            trailing: Text(data.http!.port!),
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.document_scanner, color: Colors.black),
                      title: const Text(
                        'Postgres',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: ListTile(
                            title: const Text('Pool Max'),
                            trailing: Text(data.postgres!.poolMax!.toString()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: ListTile(
                            title: const Text('DB Name'),
                            trailing: Text(data.postgres!.dbName!),
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.radio, color: Colors.black),
                      title: const Text(
                        'Sinopac',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: ListTile(
                            title: const Text('Pool Max'),
                            trailing: Text(data.sinopac!.poolMax!.toString()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: ListTile(
                            title: const Text('URL'),
                            trailing: Text(data.sinopac!.url!),
                          ),
                        ),
                      ],
                    ),
                    // ExpansionTile(
                    //   leading: const Icon(Icons.money, color: Colors.black),
                    //   title: const Text(
                    //     'Trade Switch',
                    //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    //   ),
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 10, right: 10),
                    //       child: ListTile(
                    //         title: const Text('Simulation'),
                    //         trailing: Text(data.tradeSwitch!.simulation!.toString()),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 10, right: 10),
                    //       child: ListTile(
                    //         title: const Text('Buy'),
                    //         trailing: Text(data.tradeSwitch!.buy!.toString()),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 10, right: 10),
                    //       child: ListTile(
                    //         title: const Text('Sell'),
                    //         trailing: Text(data.tradeSwitch!.sell!.toString()),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 10, right: 10),
                    //       child: ListTile(
                    //         title: const Text('Sell First'),
                    //         trailing: Text(data.tradeSwitch!.sellFirst!.toString()),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 10, right: 10),
                    //       child: ListTile(
                    //         title: const Text('Buy Later'),
                    //         trailing: Text(data.tradeSwitch!.buyLater!.toString()),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 10, right: 10),
                    //       child: ListTile(
                    //         title: const Text('Mean Time Forward'),
                    //         trailing: Text(data.tradeSwitch!.meanTimeForward!.toString()),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 10, right: 10),
                    //       child: ListTile(
                    //         title: const Text('Mean Time Reverse'),
                    //         trailing: Text(data.tradeSwitch!.meanTimeReverse!.toString()),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 10, right: 10),
                    //       child: ListTile(
                    //         title: const Text('Forward MAX'),
                    //         trailing: Text(data.tradeSwitch!.forwardMax!.toString()),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 10, right: 10),
                    //       child: ListTile(
                    //         title: const Text('Reverse MAX'),
                    //         trailing: Text(data.tradeSwitch!.reverseMax!.toString()),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 10, right: 10),
                    //       child: ListTile(
                    //         title: const Text('Hold Time From Open'),
                    //         trailing: Text(data.tradeSwitch!.holdTimeFromOpen!.toString()),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 10, right: 10),
                    //       child: ListTile(
                    //         title: const Text('Total Open Time'),
                    //         trailing: Text(data.tradeSwitch!.totalOpenTime!.toString()),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 10, right: 10),
                    //       child: ListTile(
                    //         title: const Text('Trade IN Wait Time'),
                    //         trailing: Text(data.tradeSwitch!.tradeInWaitTime!.toString()),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 10, right: 10),
                    //       child: ListTile(
                    //         title: const Text('Trade OUT Wait Time'),
                    //         trailing: Text(data.tradeSwitch!.tradeOutWaitTime!.toString()),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 10, right: 10),
                    //       child: ListTile(
                    //         title: const Text('Trade IN End Time'),
                    //         trailing: Text(data.tradeSwitch!.tradeInEndTime!.toString()),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 10, right: 10),
                    //       child: ListTile(
                    //         title: const Text('Trade OUT Wait Time'),
                    //         trailing: Text(data.tradeSwitch!.tradeOutEndTime!.toString()),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    ExpansionTile(
                      leading: const Icon(Icons.currency_exchange, color: Colors.black),
                      title: const Text(
                        'History',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: ListTile(
                            title: const Text('History Close Period'),
                            trailing: Text(data.history!.historyClosePeriod!.toString()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: ListTile(
                            title: const Text('History Tick Period'),
                            trailing: Text(data.history!.historyTickPeriod!.toString()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: ListTile(
                            title: const Text('History Kbar Period'),
                            trailing: Text(data.history!.historyKbarPeriod!.toString()),
                          ),
                        ),
                      ],
                    ),
                    // ExpansionTile(
                    //   leading: const Icon(Icons.account_balance_wallet, color: Colors.black),
                    //   title: const Text(
                    //     'Quota',
                    //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    //   ),
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 10, right: 10),
                    //       child: ListTile(
                    //         title: const Text('Trade Quota'),
                    //         trailing: Text(data.quota!.tradeQuota!.toString()),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 10, right: 10),
                    //       child: ListTile(
                    //         title: const Text('Trade Tax Ratio'),
                    //         trailing: Text(data.quota!.tradeTaxRatio!.toString()),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 10, right: 10),
                    //       child: ListTile(
                    //         title: const Text('Trade Fee Ratio'),
                    //         trailing: Text(data.quota!.tradeFeeRatio!.toString()),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 10, right: 10),
                    //       child: ListTile(
                    //         title: const Text('Fee Discount'),
                    //         trailing: Text(data.quota!.feeDiscount!.toString()),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            },
          ),
        ),
      );
}

Future<Config> fetchConfig() async {
  try {
    final response = await http.get(Uri.parse('$tradeAgentURLPrefix/basic/config'));
    if (response.statusCode == 200) {
      return Config.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return Config();
    }
  } on Exception {
    return Config();
  }
}
