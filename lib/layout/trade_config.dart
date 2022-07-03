import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trade_agent_v2/basic/basic.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
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
              var data = snapshot.data!;
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
                  ExpansionTile(
                    leading: const Icon(Icons.money, color: Colors.black),
                    title: const Text(
                      'Trade Switch',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          title: const Text('Simulation'),
                          trailing: Text(data.tradeSwitch!.simulation!.toString()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          title: const Text('Buy'),
                          trailing: Text(data.tradeSwitch!.buy!.toString()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          title: const Text('Sell'),
                          trailing: Text(data.tradeSwitch!.sell!.toString()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          title: const Text('Sell First'),
                          trailing: Text(data.tradeSwitch!.sellFirst!.toString()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          title: const Text('Buy Later'),
                          trailing: Text(data.tradeSwitch!.buyLater!.toString()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          title: const Text('Mean Time Forward'),
                          trailing: Text(data.tradeSwitch!.meanTimeForward!.toString()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          title: const Text('Mean Time Reverse'),
                          trailing: Text(data.tradeSwitch!.meanTimeReverse!.toString()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          title: const Text('Forward MAX'),
                          trailing: Text(data.tradeSwitch!.forwardMax!.toString()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          title: const Text('Reverse MAX'),
                          trailing: Text(data.tradeSwitch!.reverseMax!.toString()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          title: const Text('Hold Time From Open'),
                          trailing: Text(data.tradeSwitch!.holdTimeFromOpen!.toString()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          title: const Text('Total Open Time'),
                          trailing: Text(data.tradeSwitch!.totalOpenTime!.toString()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          title: const Text('Trade IN Wait Time'),
                          trailing: Text(data.tradeSwitch!.tradeInWaitTime!.toString()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          title: const Text('Trade OUT Wait Time'),
                          trailing: Text(data.tradeSwitch!.tradeOutWaitTime!.toString()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          title: const Text('Trade IN End Time'),
                          trailing: Text(data.tradeSwitch!.tradeInEndTime!.toString()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          title: const Text('Trade OUT Wait Time'),
                          trailing: Text(data.tradeSwitch!.tradeOutEndTime!.toString()),
                        ),
                      ),
                    ],
                  ),
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
                  ExpansionTile(
                    leading: const Icon(Icons.account_balance_wallet, color: Colors.black),
                    title: const Text(
                      'Quota',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          title: const Text('Trade Quota'),
                          trailing: Text(data.quota!.tradeQuota!.toString()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          title: const Text('Trade Tax Ratio'),
                          trailing: Text(data.quota!.tradeTaxRatio!.toString()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          title: const Text('Trade Fee Ratio'),
                          trailing: Text(data.quota!.tradeFeeRatio!.toString()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          title: const Text('Fee Discount'),
                          trailing: Text(data.quota!.feeDiscount!.toString()),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            ));
          },
        ),
      ),
    );
  }
}

Future<Config> fetchConfig() async {
  try {
    final response = await http.get(Uri.parse('$tradeAgentURLPrefix/basic/config'));
    if (response.statusCode == 200) {
      return Config.fromJson(jsonDecode(response.body));
    } else {
      return Config();
    }
  } catch (e) {
    return Config();
  }
}

class Config {
  Config({
    this.http,
    this.postgres,
    this.sinopac,
    this.rabbitmq,
    this.tradeSwitch,
    this.history,
    this.quota,
    this.targetCond,
    this.analyze,
    this.deployment,
  });

  Config.fromJson(Map<String, dynamic> json) {
    http = json['http'] != null ? Http.fromJson(json['http']) : null;
    postgres = json['postgres'] != null ? Postgres.fromJson(json['postgres']) : null;
    sinopac = json['sinopac'] != null ? Sinopac.fromJson(json['sinopac']) : null;
    rabbitmq = json['rabbitmq'] != null ? Rabbitmq.fromJson(json['rabbitmq']) : null;
    tradeSwitch = json['trade_switch'] != null ? TradeSwitch.fromJson(json['trade_switch']) : null;
    history = json['history'] != null ? History.fromJson(json['history']) : null;
    quota = json['quota'] != null ? Quota.fromJson(json['quota']) : null;
    if (json['target_cond'] != null) {
      targetCond = <TargetCond>[];
      json['target_cond'].forEach((v) {
        targetCond!.add(TargetCond.fromJson(v));
      });
    }
    analyze = json['analyze'] != null ? Analyze.fromJson(json['analyze']) : null;
    deployment = json['deployment'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (http != null) {
      data['http'] = http!.toJson();
    }
    if (postgres != null) {
      data['postgres'] = postgres!.toJson();
    }
    if (sinopac != null) {
      data['sinopac'] = sinopac!.toJson();
    }
    if (rabbitmq != null) {
      data['rabbitmq'] = rabbitmq!.toJson();
    }
    if (tradeSwitch != null) {
      data['trade_switch'] = tradeSwitch!.toJson();
    }
    if (history != null) {
      data['history'] = history!.toJson();
    }
    if (quota != null) {
      data['quota'] = quota!.toJson();
    }
    if (targetCond != null) {
      data['target_cond'] = targetCond!.map((v) => v.toJson()).toList();
    }
    if (analyze != null) {
      data['analyze'] = analyze!.toJson();
    }
    data['deployment'] = deployment;
    return data;
  }

  Http? http;
  Postgres? postgres;
  Sinopac? sinopac;
  Rabbitmq? rabbitmq;
  TradeSwitch? tradeSwitch;
  History? history;
  Quota? quota;
  List<TargetCond>? targetCond;
  Analyze? analyze;
  String? deployment;
}

class Http {
  Http({this.port});

  Http.fromJson(Map<String, dynamic> json) {
    port = json['port'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['port'] = port;
    return data;
  }

  String? port;
}

class Postgres {
  Postgres({this.poolMax, this.url, this.dbName});

  Postgres.fromJson(Map<String, dynamic> json) {
    poolMax = json['pool_max'];
    url = json['url'];
    dbName = json['db_name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pool_max'] = poolMax;
    data['url'] = url;
    data['db_name'] = dbName;
    return data;
  }

  int? poolMax;
  String? url;
  String? dbName;
}

class Sinopac {
  Sinopac({this.poolMax, this.url});

  Sinopac.fromJson(Map<String, dynamic> json) {
    poolMax = json['pool_max'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pool_max'] = poolMax;
    data['url'] = url;
    return data;
  }

  int? poolMax;
  String? url;
}

class Rabbitmq {
  Rabbitmq({this.url, this.exchange, this.waitTime, this.attempts});

  Rabbitmq.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    exchange = json['exchange'];
    waitTime = json['wait_time'];
    attempts = json['attempts'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['url'] = url;
    data['exchange'] = exchange;
    data['wait_time'] = waitTime;
    data['attempts'] = attempts;
    return data;
  }

  String? url;
  String? exchange;
  int? waitTime;
  int? attempts;
}

class TradeSwitch {
  TradeSwitch(
      {this.simulation,
      this.buy,
      this.sell,
      this.sellFirst,
      this.buyLater,
      this.holdTimeFromOpen,
      this.totalOpenTime,
      this.tradeInWaitTime,
      this.tradeOutWaitTime,
      this.tradeInEndTime,
      this.tradeOutEndTime,
      this.meanTimeForward,
      this.meanTimeReverse,
      this.forwardMax,
      this.reverseMax});

  TradeSwitch.fromJson(Map<String, dynamic> json) {
    simulation = json['simulation'];
    buy = json['buy'];
    sell = json['sell'];
    sellFirst = json['sell_first'];
    buyLater = json['buy_later'];
    holdTimeFromOpen = json['hold_time_from_open'];
    totalOpenTime = json['total_open_time'];
    tradeInWaitTime = json['trade_in_wait_time'];
    tradeOutWaitTime = json['trade_out_wait_time'];
    tradeInEndTime = json['trade_in_end_time'];
    tradeOutEndTime = json['trade_out_end_time'];
    meanTimeForward = json['mean_time_forward'];
    meanTimeReverse = json['mean_time_reverse'];
    forwardMax = json['forward_max'];
    reverseMax = json['reverse_max'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['simulation'] = simulation;
    data['buy'] = buy;
    data['sell'] = sell;
    data['sell_first'] = sellFirst;
    data['buy_later'] = buyLater;
    data['hold_time_from_open'] = holdTimeFromOpen;
    data['total_open_time'] = totalOpenTime;
    data['trade_in_wait_time'] = tradeInWaitTime;
    data['trade_out_wait_time'] = tradeOutWaitTime;
    data['trade_in_end_time'] = tradeInEndTime;
    data['trade_out_end_time'] = tradeOutEndTime;
    data['mean_time_forward'] = meanTimeForward;
    data['mean_time_reverse'] = meanTimeReverse;
    data['forward_max'] = forwardMax;
    data['reverse_max'] = reverseMax;
    return data;
  }

  bool? simulation;
  bool? buy;
  bool? sell;
  bool? sellFirst;
  bool? buyLater;
  int? holdTimeFromOpen;
  int? totalOpenTime;
  int? tradeInWaitTime;
  int? tradeOutWaitTime;
  int? tradeInEndTime;
  int? tradeOutEndTime;
  int? meanTimeForward;
  int? meanTimeReverse;
  int? forwardMax;
  int? reverseMax;
}

class History {
  History({this.historyClosePeriod, this.historyTickPeriod, this.historyKbarPeriod});

  History.fromJson(Map<String, dynamic> json) {
    historyClosePeriod = json['history_close_period'];
    historyTickPeriod = json['history_tick_period'];
    historyKbarPeriod = json['history_kbar_period'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['history_close_period'] = historyClosePeriod;
    data['history_tick_period'] = historyTickPeriod;
    data['history_kbar_period'] = historyKbarPeriod;
    return data;
  }

  int? historyClosePeriod;
  int? historyTickPeriod;
  int? historyKbarPeriod;
}

class Quota {
  Quota({this.tradeQuota, this.tradeTaxRatio, this.tradeFeeRatio, this.feeDiscount});

  Quota.fromJson(Map<String, dynamic> json) {
    tradeQuota = json['trade_quota'];
    tradeTaxRatio = json['trade_tax_ratio'];
    tradeFeeRatio = json['trade_fee_ratio'];
    feeDiscount = json['fee_discount'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['trade_quota'] = tradeQuota;
    data['trade_tax_ratio'] = tradeTaxRatio;
    data['trade_fee_ratio'] = tradeFeeRatio;
    data['fee_discount'] = feeDiscount;
    return data;
  }

  int? tradeQuota;
  double? tradeTaxRatio;
  double? tradeFeeRatio;
  double? feeDiscount;
}

class TargetCond {
  TargetCond({this.limitPriceLow, this.limitPriceHigh, this.limitVolume, this.subscribe});

  TargetCond.fromJson(Map<String, dynamic> json) {
    limitPriceLow = json['limit_price_low'];
    limitPriceHigh = json['limit_price_high'];
    limitVolume = json['limit_volume'];
    subscribe = json['subscribe'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['limit_price_low'] = limitPriceLow;
    data['limit_price_high'] = limitPriceHigh;
    data['limit_volume'] = limitVolume;
    data['subscribe'] = subscribe;
    return data;
  }

  int? limitPriceLow;
  int? limitPriceHigh;
  int? limitVolume;
  bool? subscribe;
}

class Analyze {
  Analyze(
      {this.closeChangeRatioLow,
      this.closeChangeRatioHigh,
      this.openCloseChangeRatioLow,
      this.openCloseChangeRatioHigh,
      this.outInRatio,
      this.inOutRatio,
      this.volumePrLow,
      this.volumePrHigh,
      this.tickAnalyzeMinPeriod,
      this.tickAnalyzeMaxPeriod,
      this.rsiMinCount,
      this.rsiHigh,
      this.rsiLow,
      this.maxLoss,
      this.maPeriod});

  Analyze.fromJson(Map<String, dynamic> json) {
    closeChangeRatioLow = json['close_change_ratio_low'];
    closeChangeRatioHigh = json['close_change_ratio_high'];
    openCloseChangeRatioLow = json['open_close_change_ratio_low'];
    openCloseChangeRatioHigh = json['open_close_change_ratio_high'];
    outInRatio = json['out_in_ratio'];
    inOutRatio = json['in_out_ratio'];
    volumePrLow = json['volume_pr_low'];
    volumePrHigh = json['volume_pr_high'];
    tickAnalyzeMinPeriod = json['tick_analyze_min_period'];
    tickAnalyzeMaxPeriod = json['tick_analyze_max_period'];
    rsiMinCount = json['rsi_min_count'];
    rsiHigh = json['rsi_high'];
    rsiLow = json['rsi_low'];
    maxLoss = json['max_loss'];
    maPeriod = json['ma_period'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['close_change_ratio_low'] = closeChangeRatioLow;
    data['close_change_ratio_high'] = closeChangeRatioHigh;
    data['open_close_change_ratio_low'] = openCloseChangeRatioLow;
    data['open_close_change_ratio_high'] = openCloseChangeRatioHigh;
    data['out_in_ratio'] = outInRatio;
    data['in_out_ratio'] = inOutRatio;
    data['volume_pr_low'] = volumePrLow;
    data['volume_pr_high'] = volumePrHigh;
    data['tick_analyze_min_period'] = tickAnalyzeMinPeriod;
    data['tick_analyze_max_period'] = tickAnalyzeMaxPeriod;
    data['rsi_min_count'] = rsiMinCount;
    data['rsi_high'] = rsiHigh;
    data['rsi_low'] = rsiLow;
    data['max_loss'] = maxLoss;
    data['ma_period'] = maPeriod;
    return data;
  }

  int? closeChangeRatioLow;
  int? closeChangeRatioHigh;
  int? openCloseChangeRatioLow;
  int? openCloseChangeRatioHigh;
  int? outInRatio;
  int? inOutRatio;
  int? volumePrLow;
  int? volumePrHigh;
  int? tickAnalyzeMinPeriod;
  int? tickAnalyzeMaxPeriod;
  int? rsiMinCount;
  double? rsiHigh;
  double? rsiLow;
  int? maxLoss;
  int? maPeriod;
}
