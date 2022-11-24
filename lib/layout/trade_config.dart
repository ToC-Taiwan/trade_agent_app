import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trade_agent_v2/basic/base.dart';
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
  Config(
      {this.http,
      this.postgres,
      this.sinopac,
      this.rabbitmq,
      this.simulation,
      this.stockTradeSwitch,
      this.futureTradeSwitch,
      this.history,
      this.quota,
      this.targetCond,
      this.stockAnalyze,
      this.futureAnalyze});

  Config.fromJson(Map<String, dynamic> json) {
    http = json['http'] != null ? Http.fromJson(json['http']) : null;
    postgres = json['postgres'] != null ? Postgres.fromJson(json['postgres']) : null;
    sinopac = json['sinopac'] != null ? Sinopac.fromJson(json['sinopac']) : null;
    rabbitmq = json['rabbitmq'] != null ? Rabbitmq.fromJson(json['rabbitmq']) : null;
    simulation = json['simulation'];
    stockTradeSwitch = json['stock_trade_switch'] != null ? StockTradeSwitch.fromJson(json['stock_trade_switch']) : null;
    futureTradeSwitch = json['future_trade_switch'] != null ? FutureTradeSwitch.fromJson(json['future_trade_switch']) : null;
    history = json['history'] != null ? History.fromJson(json['history']) : null;
    quota = json['quota'] != null ? Quota.fromJson(json['quota']) : null;
    targetCond = json['target_cond'] != null ? TargetCond.fromJson(json['target_cond']) : null;
    stockAnalyze = json['stock_analyze'] != null ? StockAnalyze.fromJson(json['stock_analyze']) : null;
    futureAnalyze = json['future_analyze'] != null ? FutureAnalyze.fromJson(json['future_analyze']) : null;
  }

  Http? http;
  Postgres? postgres;
  Sinopac? sinopac;
  Rabbitmq? rabbitmq;
  bool? simulation;
  StockTradeSwitch? stockTradeSwitch;
  FutureTradeSwitch? futureTradeSwitch;
  History? history;
  Quota? quota;
  TargetCond? targetCond;
  StockAnalyze? stockAnalyze;
  FutureAnalyze? futureAnalyze;

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
    data['simulation'] = simulation;
    if (stockTradeSwitch != null) {
      data['stock_trade_switch'] = stockTradeSwitch!.toJson();
    }
    if (futureTradeSwitch != null) {
      data['future_trade_switch'] = futureTradeSwitch!.toJson();
    }
    if (history != null) {
      data['history'] = history!.toJson();
    }
    if (quota != null) {
      data['quota'] = quota!.toJson();
    }
    if (targetCond != null) {
      data['target_cond'] = targetCond!.toJson();
    }
    if (stockAnalyze != null) {
      data['stock_analyze'] = stockAnalyze!.toJson();
    }
    if (futureAnalyze != null) {
      data['future_analyze'] = futureAnalyze!.toJson();
    }
    return data;
  }
}

class Http {
  Http({this.port});
  Http.fromJson(Map<String, dynamic> json) {
    port = json['port'];
  }
  String? port;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['port'] = port;
    return data;
  }
}

class Postgres {
  Postgres({this.poolMax, this.url, this.dbName});
  Postgres.fromJson(Map<String, dynamic> json) {
    poolMax = json['pool_max'];
    url = json['url'];
    dbName = json['db_name'];
  }
  int? poolMax;
  String? url;
  String? dbName;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pool_max'] = poolMax;
    data['url'] = url;
    data['db_name'] = dbName;
    return data;
  }
}

class Sinopac {
  Sinopac({this.poolMax, this.url});
  Sinopac.fromJson(Map<String, dynamic> json) {
    poolMax = json['pool_max'];
    url = json['url'];
  }
  int? poolMax;
  String? url;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pool_max'] = poolMax;
    data['url'] = url;
    return data;
  }
}

class Rabbitmq {
  Rabbitmq({this.url, this.exchange, this.waitTime, this.attempts});
  Rabbitmq.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    exchange = json['exchange'];
    waitTime = json['wait_time'];
    attempts = json['attempts'];
  }
  String? url;
  String? exchange;
  int? waitTime;
  int? attempts;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['url'] = url;
    data['exchange'] = exchange;
    data['wait_time'] = waitTime;
    data['attempts'] = attempts;
    return data;
  }
}

class StockTradeSwitch {
  StockTradeSwitch(
      {this.allowTrade, this.holdTimeFromOpen, this.totalOpenTime, this.tradeInEndTime, this.tradeInWaitTime, this.tradeOutWaitTime, this.cancelWaitTime});
  StockTradeSwitch.fromJson(Map<String, dynamic> json) {
    allowTrade = json['allow_trade'];
    holdTimeFromOpen = json['hold_time_from_open'];
    totalOpenTime = json['total_open_time'];
    tradeInEndTime = json['trade_in_end_time'];
    tradeInWaitTime = json['trade_in_wait_time'];
    tradeOutWaitTime = json['trade_out_wait_time'];
    cancelWaitTime = json['cancel_wait_time'];
  }
  bool? allowTrade;
  int? holdTimeFromOpen;
  int? totalOpenTime;
  int? tradeInEndTime;
  int? tradeInWaitTime;
  int? tradeOutWaitTime;
  int? cancelWaitTime;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['allow_trade'] = allowTrade;
    data['hold_time_from_open'] = holdTimeFromOpen;
    data['total_open_time'] = totalOpenTime;
    data['trade_in_end_time'] = tradeInEndTime;
    data['trade_in_wait_time'] = tradeInWaitTime;
    data['trade_out_wait_time'] = tradeOutWaitTime;
    data['cancel_wait_time'] = cancelWaitTime;
    return data;
  }
}

class FutureTradeSwitch {
  FutureTradeSwitch({this.allowTrade, this.quantity, this.tradeInWaitTime, this.tradeOutWaitTime, this.cancelWaitTime, this.tradeTimeRange});
  FutureTradeSwitch.fromJson(Map<String, dynamic> json) {
    allowTrade = json['allow_trade'];
    quantity = json['quantity'];
    tradeInWaitTime = json['trade_in_wait_time'];
    tradeOutWaitTime = json['trade_out_wait_time'];
    cancelWaitTime = json['cancel_wait_time'];
    tradeTimeRange = json['trade_time_range'] != null ? TradeTimeRange.fromJson(json['trade_time_range']) : null;
  }
  bool? allowTrade;
  int? quantity;
  int? tradeInWaitTime;
  int? tradeOutWaitTime;
  int? cancelWaitTime;
  TradeTimeRange? tradeTimeRange;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['allow_trade'] = allowTrade;
    data['quantity'] = quantity;
    data['trade_in_wait_time'] = tradeInWaitTime;
    data['trade_out_wait_time'] = tradeOutWaitTime;
    data['cancel_wait_time'] = cancelWaitTime;
    if (tradeTimeRange != null) {
      data['trade_time_range'] = tradeTimeRange!.toJson();
    }
    return data;
  }
}

class TradeTimeRange {
  TradeTimeRange({this.firstPartDuration, this.secondPartDuration});
  TradeTimeRange.fromJson(Map<String, dynamic> json) {
    firstPartDuration = json['first_part_duration'];
    secondPartDuration = json['second_part_duration'];
  }
  int? firstPartDuration;
  int? secondPartDuration;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['first_part_duration'] = firstPartDuration;
    data['second_part_duration'] = secondPartDuration;
    return data;
  }
}

class History {
  History({this.historyClosePeriod, this.historyTickPeriod, this.historyKbarPeriod});
  History.fromJson(Map<String, dynamic> json) {
    historyClosePeriod = json['history_close_period'];
    historyTickPeriod = json['history_tick_period'];
    historyKbarPeriod = json['history_kbar_period'];
  }
  int? historyClosePeriod;
  int? historyTickPeriod;
  int? historyKbarPeriod;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['history_close_period'] = historyClosePeriod;
    data['history_tick_period'] = historyTickPeriod;
    data['history_kbar_period'] = historyKbarPeriod;
    return data;
  }
}

class Quota {
  Quota({this.stockTradeQuota, this.stockFeeDiscount, this.futureTradeFee});
  Quota.fromJson(Map<String, dynamic> json) {
    stockTradeQuota = json['stock_trade_quota'];
    stockFeeDiscount = json['stock_fee_discount'];
    futureTradeFee = json['future_trade_fee'];
  }
  int? stockTradeQuota;
  double? stockFeeDiscount;
  int? futureTradeFee;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['stock_trade_quota'] = stockTradeQuota;
    data['stock_fee_discount'] = stockFeeDiscount;
    data['future_trade_fee'] = futureTradeFee;
    return data;
  }
}

class TargetCond {
  TargetCond({this.blackStock, this.blackCategory, this.realTimeRank, this.limitVolume, this.priceLimit});
  TargetCond.fromJson(Map<String, dynamic> json) {
    blackStock = json['black_stock'].cast<String>();
    blackCategory = json['black_category'].cast<String>();
    realTimeRank = json['real_time_rank'];
    limitVolume = json['limit_volume'];
    if (json['price_limit'] != null) {
      priceLimit = <PriceLimit>[];
      json['price_limit'].forEach((v) {
        priceLimit!.add(PriceLimit.fromJson(v));
      });
    }
  }
  List<String>? blackStock;
  List<String>? blackCategory;
  int? realTimeRank;
  int? limitVolume;
  List<PriceLimit>? priceLimit;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['black_stock'] = blackStock;
    data['black_category'] = blackCategory;
    data['real_time_rank'] = realTimeRank;
    data['limit_volume'] = limitVolume;
    if (priceLimit != null) {
      data['price_limit'] = priceLimit!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PriceLimit {
  PriceLimit({this.low, this.high});
  PriceLimit.fromJson(Map<String, dynamic> json) {
    low = json['low'];
    high = json['high'];
  }
  int? low;
  int? high;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['low'] = low;
    data['high'] = high;
    return data;
  }
}

class StockAnalyze {
  StockAnalyze(
      {this.maxHoldTime,
      this.closeChangeRatioLow,
      this.closeChangeRatioHigh,
      this.allOutInRatio,
      this.allInOutRatio,
      this.volumePrLimit,
      this.tickAnalyzePeriod,
      this.rsiMinCount,
      this.maPeriod});
  StockAnalyze.fromJson(Map<String, dynamic> json) {
    maxHoldTime = json['max_hold_time'];
    closeChangeRatioLow = json['close_change_ratio_low'];
    closeChangeRatioHigh = json['close_change_ratio_high'];
    allOutInRatio = json['all_out_in_ratio'];
    allInOutRatio = json['all_in_out_ratio'];
    volumePrLimit = json['volume_pr_limit'];
    tickAnalyzePeriod = json['tick_analyze_period'];
    rsiMinCount = json['rsi_min_count'];
    maPeriod = json['ma_period'];
  }
  int? maxHoldTime;
  int? closeChangeRatioLow;
  int? closeChangeRatioHigh;
  int? allOutInRatio;
  int? allInOutRatio;
  int? volumePrLimit;
  int? tickAnalyzePeriod;
  int? rsiMinCount;
  int? maPeriod;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['max_hold_time'] = maxHoldTime;
    data['close_change_ratio_low'] = closeChangeRatioLow;
    data['close_change_ratio_high'] = closeChangeRatioHigh;
    data['all_out_in_ratio'] = allOutInRatio;
    data['all_in_out_ratio'] = allInOutRatio;
    data['volume_pr_limit'] = volumePrLimit;
    data['tick_analyze_period'] = tickAnalyzePeriod;
    data['rsi_min_count'] = rsiMinCount;
    data['ma_period'] = maPeriod;
    return data;
  }
}

class FutureAnalyze {
  FutureAnalyze({this.maxHoldTime, this.tickArrAnalyzeCount, this.tickArrAnalyzeUnit});
  FutureAnalyze.fromJson(Map<String, dynamic> json) {
    maxHoldTime = json['max_hold_time'];
    tickArrAnalyzeCount = json['tick_arr_analyze_count'];
    tickArrAnalyzeUnit = json['tick_arr_analyze_unit'];
  }
  int? maxHoldTime;
  int? tickArrAnalyzeCount;
  int? tickArrAnalyzeUnit;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['max_hold_time'] = maxHoldTime;
    data['tick_arr_analyze_count'] = tickArrAnalyzeCount;
    data['tick_arr_analyze_unit'] = tickArrAnalyzeUnit;
    return data;
  }
}
