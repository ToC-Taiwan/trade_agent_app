import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trade_agent_app/url.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Future<Config> futureConfig;

  @override
  void initState() {
    super.initState();
    futureConfig = fetchConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Config>(
        future: futureConfig,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!;
            return ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                ExpansionTile(
                  title: const Text(
                    'Server',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('Run Mode'),
                        trailing: Text(data.server!.runMode!),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('HTTP Port'),
                        trailing: Text(data.server!.httpPort!),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('Sinopac MQ SRV Host'),
                        trailing: Text(data.server!.sinopacSrvHost!),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('Sinopac MQ SRV Port'),
                        trailing: Text(data.server!.sinopacSrvPort!),
                      ),
                    )
                  ],
                ),
                ExpansionTile(
                  title: const Text(
                    'Database',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('Host'),
                        trailing: Text(data.database!.host!),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('Port'),
                        trailing: Text(data.database!.port!),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('User'),
                        trailing: Text(data.database!.user!),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('Database'),
                        trailing: Text(data.database!.database!),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('Time Zone'),
                        trailing: Text(data.database!.timeZone!),
                      ),
                    )
                  ],
                ),
                ExpansionTile(
                  title: const Text(
                    'MQTT',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('Host'),
                        trailing: Text(data.mqtt!.host!),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('Port'),
                        trailing: Text(data.mqtt!.port!),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('User'),
                        trailing: Text(data.mqtt!.user!),
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: const Text(
                    'Trade Switch',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                  ],
                ),
                ExpansionTile(
                  title: const Text(
                    'Trade',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('History Close Period'),
                        trailing: Text(data.trade!.historyClosePeriod!.toString()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('History Tick Period'),
                        trailing: Text(data.trade!.historyTickPeriod!.toString()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('History Kbar Period'),
                        trailing: Text(data.trade!.historyKbarPeriod!.toString()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('Hold Time From Open'),
                        trailing: Text(data.trade!.holdTimeFromOpen!.toString()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('Total Open Time'),
                        trailing: Text(data.trade!.totalOpenTime!.toString()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('Trade IN Wait Time'),
                        trailing: Text(data.trade!.tradeInWaitTime!.toString()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('Trade OUT Wait Time'),
                        trailing: Text(data.trade!.tradeOutWaitTime!.toString()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('Trade IN End Time'),
                        trailing: Text(data.trade!.tradeInEndTime!.toString()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ListTile(
                        title: const Text('Trade OUT Wait Time'),
                        trailing: Text(data.trade!.tradeOutEndTime!.toString()),
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: const Text(
                    'Quota',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

Future<Config> fetchConfig() async {
  final response = await http.get(Uri.parse('$tradeAgentURLPrefix/config'));
  if (response.statusCode == 200) {
    return Config.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load');
  }
}

class Config {
  Config({this.server, this.database, this.mqtt, this.tradeSwitch, this.trade, this.quota, this.targetCond, this.analyze, this.schedule});

  Config.fromJson(Map<String, dynamic> json) {
    server = json['server'] != null ? Server.fromJson(json['server']) : null;
    database = json['database'] != null ? Database.fromJson(json['database']) : null;
    mqtt = json['mqtt'] != null ? Mqtt.fromJson(json['mqtt']) : null;
    tradeSwitch = json['trade_switch'] != null ? TradeSwitch.fromJson(json['trade_switch']) : null;
    trade = json['trade'] != null ? Trade.fromJson(json['trade']) : null;
    quota = json['quota'] != null ? Quota.fromJson(json['quota']) : null;
    targetCond = json['target_cond'] != null ? TargetCond.fromJson(json['target_cond']) : null;
    analyze = json['analyze'] != null ? Analyze.fromJson(json['analyze']) : null;
    schedule = json['schedule'] != null ? Schedule.fromJson(json['schedule']) : null;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (server != null) {
      data['server'] = server!.toJson();
    }
    if (database != null) {
      data['database'] = database!.toJson();
    }
    if (mqtt != null) {
      data['mqtt'] = mqtt!.toJson();
    }
    if (tradeSwitch != null) {
      data['trade_switch'] = tradeSwitch!.toJson();
    }
    if (trade != null) {
      data['trade'] = trade!.toJson();
    }
    if (quota != null) {
      data['quota'] = quota!.toJson();
    }
    if (targetCond != null) {
      data['target_cond'] = targetCond!.toJson();
    }
    if (analyze != null) {
      data['analyze'] = analyze!.toJson();
    }
    if (schedule != null) {
      data['schedule'] = schedule!.toJson();
    }
    return data;
  }

  Server? server;
  Database? database;
  Mqtt? mqtt;
  TradeSwitch? tradeSwitch;
  Trade? trade;
  Quota? quota;
  TargetCond? targetCond;
  Analyze? analyze;
  Schedule? schedule;
}

class Server {
  Server({this.runMode, this.httpPort, this.sinopacSrvHost, this.sinopacSrvPort});

  Server.fromJson(Map<String, dynamic> json) {
    runMode = json['run_mode'];
    httpPort = json['http_port'];
    sinopacSrvHost = json['sinopac_srv_host'];
    sinopacSrvPort = json['sinopac_srv_port'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['run_mode'] = runMode;
    data['http_port'] = httpPort;
    data['sinopac_srv_host'] = sinopacSrvHost;
    data['sinopac_srv_port'] = sinopacSrvPort;
    return data;
  }

  String? runMode;
  String? httpPort;
  String? sinopacSrvHost;
  String? sinopacSrvPort;
}

class Database {
  Database({this.host, this.port, this.user, this.passwd, this.database, this.timeZone});

  Database.fromJson(Map<String, dynamic> json) {
    host = json['host'];
    port = json['port'];
    user = json['user'];
    passwd = json['passwd'];
    database = json['database'];
    timeZone = json['time_zone'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['host'] = host;
    data['port'] = port;
    data['user'] = user;
    data['passwd'] = passwd;
    data['database'] = database;
    data['time_zone'] = timeZone;
    return data;
  }

  String? host;
  String? port;
  String? user;
  String? passwd;
  String? database;
  String? timeZone;
}

class Mqtt {
  Mqtt({this.host, this.port, this.user, this.passwd, this.clientId, this.caPath, this.certPath, this.keyPath});

  Mqtt.fromJson(Map<String, dynamic> json) {
    host = json['host'];
    port = json['port'];
    user = json['user'];
    passwd = json['passwd'];
    clientId = json['client_id'];
    caPath = json['ca_path'];
    certPath = json['cert_path'];
    keyPath = json['key_path'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['host'] = host;
    data['port'] = port;
    data['user'] = user;
    data['passwd'] = passwd;
    data['client_id'] = clientId;
    data['ca_path'] = caPath;
    data['cert_path'] = certPath;
    data['key_path'] = keyPath;
    return data;
  }

  String? host;
  String? port;
  String? user;
  String? passwd;
  String? clientId;
  String? caPath;
  String? certPath;
  String? keyPath;
}

class TradeSwitch {
  TradeSwitch(
      {this.simulation, this.buy, this.sell, this.sellFirst, this.buyLater, this.meanTimeForward, this.meanTimeReverse, this.forwardMax, this.reverseMax});

  TradeSwitch.fromJson(Map<String, dynamic> json) {
    simulation = json['simulation'];
    buy = json['buy'];
    sell = json['sell'];
    sellFirst = json['sell_first'];
    buyLater = json['buy_later'];
    meanTimeForward = json['mean_time_forward'];
    meanTimeReverse = json['mean_time_reverse'];
    forwardMax = json['forward_max'];
    reverseMax = json['reverse_max'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['simulation'] = simulation;
    data['buy'] = buy;
    data['sell'] = sell;
    data['sell_first'] = sellFirst;
    data['buy_later'] = buyLater;
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
  num? meanTimeForward;
  num? meanTimeReverse;
  num? forwardMax;
  num? reverseMax;
}

class Trade {
  Trade(
      {this.historyClosePeriod,
      this.historyTickPeriod,
      this.historyKbarPeriod,
      this.holdTimeFromOpen,
      this.totalOpenTime,
      this.tradeInWaitTime,
      this.tradeOutWaitTime,
      this.tradeInEndTime,
      this.tradeOutEndTime});

  Trade.fromJson(Map<String, dynamic> json) {
    historyClosePeriod = json['history_close_period'];
    historyTickPeriod = json['history_tick_period'];
    historyKbarPeriod = json['history_kbar_period'];
    holdTimeFromOpen = json['hold_time_from_open'];
    totalOpenTime = json['total_open_time'];
    tradeInWaitTime = json['trade_in_wait_time'];
    tradeOutWaitTime = json['trade_out_wait_time'];
    tradeInEndTime = json['trade_in_end_time'];
    tradeOutEndTime = json['trade_out_end_time'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['history_close_period'] = historyClosePeriod;
    data['history_tick_period'] = historyTickPeriod;
    data['history_kbar_period'] = historyKbarPeriod;
    data['hold_time_from_open'] = holdTimeFromOpen;
    data['total_open_time'] = totalOpenTime;
    data['trade_in_wait_time'] = tradeInWaitTime;
    data['trade_out_wait_time'] = tradeOutWaitTime;
    data['trade_in_end_time'] = tradeInEndTime;
    data['trade_out_end_time'] = tradeOutEndTime;
    return data;
  }

  num? historyClosePeriod;
  num? historyTickPeriod;
  num? historyKbarPeriod;
  num? holdTimeFromOpen;
  num? totalOpenTime;
  num? tradeInWaitTime;
  num? tradeOutWaitTime;
  num? tradeInEndTime;
  num? tradeOutEndTime;
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
    var data = <String, dynamic>{};
    data['trade_quota'] = tradeQuota;
    data['trade_tax_ratio'] = tradeTaxRatio;
    data['trade_fee_ratio'] = tradeFeeRatio;
    data['fee_discount'] = feeDiscount;
    return data;
  }

  num? tradeQuota;
  num? tradeTaxRatio;
  num? tradeFeeRatio;
  num? feeDiscount;
}

class TargetCond {
  TargetCond({this.limitPriceLow, this.limitPriceHigh, this.limitVolume, this.blackStock, this.blackCategory, this.realTimeTargetsCount});

  TargetCond.fromJson(Map<String, dynamic> json) {
    limitPriceLow = json['limit_price_low'];
    limitPriceHigh = json['limit_price_high'];
    limitVolume = json['limit_volume'];
    blackStock = json['black_stock'].cast<String>();
    blackCategory = json['black_category'].cast<String>();
    realTimeTargetsCount = json['real_time_targets_count'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['limit_price_low'] = limitPriceLow;
    data['limit_price_high'] = limitPriceHigh;
    data['limit_volume'] = limitVolume;
    data['black_stock'] = blackStock;
    data['black_category'] = blackCategory;
    data['real_time_targets_count'] = realTimeTargetsCount;
    return data;
  }

  num? limitPriceLow;
  num? limitPriceHigh;
  num? limitVolume;
  List<String>? blackStock;
  List<String>? blackCategory;
  num? realTimeTargetsCount;
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
      this.maxLoss});

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
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
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
    return data;
  }

  num? closeChangeRatioLow;
  num? closeChangeRatioHigh;
  num? openCloseChangeRatioLow;
  num? openCloseChangeRatioHigh;
  num? outInRatio;
  num? inOutRatio;
  num? volumePrLow;
  num? volumePrHigh;
  num? tickAnalyzeMinPeriod;
  num? tickAnalyzeMaxPeriod;
  num? rsiMinCount;
  num? rsiHigh;
  num? rsiLow;
  num? maxLoss;
}

class Schedule {
  Schedule({this.cleanEvent, this.restartSinopac});

  Schedule.fromJson(Map<String, dynamic> json) {
    cleanEvent = json['clean_event'];
    restartSinopac = json['restart_sinopac'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['clean_event'] = cleanEvent;
    data['restart_sinopac'] = restartSinopac;
    return data;
  }

  String? cleanEvent;
  String? restartSinopac;
}
