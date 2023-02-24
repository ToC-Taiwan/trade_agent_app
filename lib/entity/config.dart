class Config {
  Config({
    this.http,
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
    this.futureAnalyze,
  });

  Config.fromJson(Map<String, dynamic> json) {
    http = json['http'] != null ? Http.fromJson(json['http'] as Map<String, dynamic>) : null;
    postgres = json['postgres'] != null ? Postgres.fromJson(json['postgres'] as Map<String, dynamic>) : null;
    sinopac = json['sinopac'] != null ? Sinopac.fromJson(json['sinopac'] as Map<String, dynamic>) : null;
    rabbitmq = json['rabbitmq'] != null ? Rabbitmq.fromJson(json['rabbitmq'] as Map<String, dynamic>) : null;
    simulation = json['simulation'] as bool?;
    stockTradeSwitch = json['stock_trade_switch'] != null ? StockTradeSwitch.fromJson(json['stock_trade_switch'] as Map<String, dynamic>) : null;
    futureTradeSwitch = json['future_trade_switch'] != null ? FutureTradeSwitch.fromJson(json['future_trade_switch'] as Map<String, dynamic>) : null;
    history = json['history'] != null ? History.fromJson(json['history'] as Map<String, dynamic>) : null;
    quota = json['quota'] != null ? Quota.fromJson(json['quota'] as Map<String, dynamic>) : null;
    targetCond = json['target_cond'] != null ? TargetCond.fromJson(json['target_cond'] as Map<String, dynamic>) : null;
    stockAnalyze = json['stock_analyze'] != null ? StockAnalyze.fromJson(json['stock_analyze'] as Map<String, dynamic>) : null;
    futureAnalyze = json['future_analyze'] != null ? FutureAnalyze.fromJson(json['future_analyze'] as Map<String, dynamic>) : null;
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
}

class Http {
  Http({this.port});
  Http.fromJson(Map<String, dynamic> json) {
    port = json['port'] as String;
  }
  String? port;
}

class Postgres {
  Postgres({this.poolMax, this.url, this.dbName});
  Postgres.fromJson(Map<String, dynamic> json) {
    poolMax = json['pool_max'] as int;
    url = json['url'] as String;
    dbName = json['db_name'] as String;
  }
  int? poolMax;
  String? url;
  String? dbName;
}

class Sinopac {
  Sinopac({this.poolMax, this.url});
  Sinopac.fromJson(Map<String, dynamic> json) {
    poolMax = json['pool_max'] as int;
    url = json['url'] as String;
  }
  int? poolMax;
  String? url;
}

class Rabbitmq {
  Rabbitmq({this.url, this.exchange, this.waitTime, this.attempts});
  Rabbitmq.fromJson(Map<String, dynamic> json) {
    url = json['url'] as String;
    exchange = json['exchange'] as String;
    waitTime = json['wait_time'] as int;
    attempts = json['attempts'] as int;
  }
  String? url;
  String? exchange;
  int? waitTime;
  int? attempts;
}

class StockTradeSwitch {
  StockTradeSwitch({
    this.allowTrade,
    this.holdTimeFromOpen,
    this.totalOpenTime,
    this.tradeInEndTime,
    this.tradeInWaitTime,
    this.tradeOutWaitTime,
    this.cancelWaitTime,
  });
  StockTradeSwitch.fromJson(Map<String, dynamic> json) {
    allowTrade = json['allow_trade'] as bool;
    holdTimeFromOpen = json['hold_time_from_open'] as int;
    totalOpenTime = json['total_open_time'] as int;
    tradeInEndTime = json['trade_in_end_time'] as int;
    tradeInWaitTime = json['trade_in_wait_time'] as int;
    tradeOutWaitTime = json['trade_out_wait_time'] as int;
    cancelWaitTime = json['cancel_wait_time'] as int;
  }
  bool? allowTrade;
  int? holdTimeFromOpen;
  int? totalOpenTime;
  int? tradeInEndTime;
  int? tradeInWaitTime;
  int? tradeOutWaitTime;
  int? cancelWaitTime;
}

class FutureTradeSwitch {
  FutureTradeSwitch({this.allowTrade, this.quantity, this.tradeInWaitTime, this.tradeOutWaitTime, this.cancelWaitTime, this.tradeTimeRange});
  FutureTradeSwitch.fromJson(Map<String, dynamic> json) {
    allowTrade = json['allow_trade'] as bool;
    quantity = json['quantity'] as int;
    tradeInWaitTime = json['trade_in_wait_time'] as int;
    tradeOutWaitTime = json['trade_out_wait_time'] as int;
    cancelWaitTime = json['cancel_wait_time'] as int;
    tradeTimeRange = json['trade_time_range'] != null ? TradeTimeRange.fromJson(json['trade_time_range'] as Map<String, dynamic>) : null;
  }
  bool? allowTrade;
  int? quantity;
  int? tradeInWaitTime;
  int? tradeOutWaitTime;
  int? cancelWaitTime;
  TradeTimeRange? tradeTimeRange;
}

class TradeTimeRange {
  TradeTimeRange({this.firstPartDuration, this.secondPartDuration});
  TradeTimeRange.fromJson(Map<String, dynamic> json) {
    firstPartDuration = json['first_part_duration'] as int;
    secondPartDuration = json['second_part_duration'] as int;
  }
  int? firstPartDuration;
  int? secondPartDuration;
}

class History {
  History({this.historyClosePeriod, this.historyTickPeriod, this.historyKbarPeriod});
  History.fromJson(Map<String, dynamic> json) {
    historyClosePeriod = json['history_close_period'] as int;
    historyTickPeriod = json['history_tick_period'] as int;
    historyKbarPeriod = json['history_kbar_period'] as int;
  }
  int? historyClosePeriod;
  int? historyTickPeriod;
  int? historyKbarPeriod;
}

class Quota {
  Quota({this.stockTradeQuota, this.stockFeeDiscount, this.futureTradeFee});
  Quota.fromJson(Map<String, dynamic> json) {
    stockTradeQuota = json['stock_trade_quota'] as int;
    stockFeeDiscount = json['stock_fee_discount'] as double;
    futureTradeFee = json['future_trade_fee'] as int;
  }
  int? stockTradeQuota;
  double? stockFeeDiscount;
  int? futureTradeFee;
}

class TargetCond {
  TargetCond({this.blackStock, this.blackCategory, this.realTimeRank, this.limitVolume, this.priceLimit});
  TargetCond.fromJson(Map<String, dynamic> json) {
    blackStock = json['black_stock'] != null ? List<String>.from(json['black_stock'] as List<dynamic>) : null;
    blackCategory = json['black_category'] != null ? List<String>.from(json['black_category'] as List<dynamic>) : null;
    realTimeRank = json['real_time_rank'] as int;
    limitVolume = json['limit_volume'] as int;
    if (json['price_limit'] != null) {
      priceLimit = <PriceLimit>[];
      for (final v in json['price_limit'] as List<Map<String, dynamic>>) {
        priceLimit!.add(PriceLimit.fromJson(v));
      }
    }
  }
  List<String>? blackStock;
  List<String>? blackCategory;
  int? realTimeRank;
  int? limitVolume;
  List<PriceLimit>? priceLimit;
}

class PriceLimit {
  PriceLimit({this.low, this.high});
  PriceLimit.fromJson(Map<String, dynamic> json) {
    low = json['low'] as int;
    high = json['high'] as int;
  }
  int? low;
  int? high;
}

class StockAnalyze {
  StockAnalyze({
    this.maxHoldTime,
    this.closeChangeRatioLow,
    this.closeChangeRatioHigh,
    this.allOutInRatio,
    this.allInOutRatio,
    this.volumePrLimit,
    this.tickAnalyzePeriod,
    this.rsiMinCount,
    this.maPeriod,
  });
  StockAnalyze.fromJson(Map<String, dynamic> json) {
    maxHoldTime = json['max_hold_time'] as int;
    closeChangeRatioLow = json['close_change_ratio_low'] as int;
    closeChangeRatioHigh = json['close_change_ratio_high'] as int;
    allOutInRatio = json['all_out_in_ratio'] as int;
    allInOutRatio = json['all_in_out_ratio'] as int;
    volumePrLimit = json['volume_pr_limit'] as int;
    tickAnalyzePeriod = json['tick_analyze_period'] as int;
    rsiMinCount = json['rsi_min_count'] as int;
    maPeriod = json['ma_period'] as int;
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
}

class FutureAnalyze {
  FutureAnalyze({this.maxHoldTime, this.tickArrAnalyzeCount, this.tickArrAnalyzeUnit});
  FutureAnalyze.fromJson(Map<String, dynamic> json) {
    maxHoldTime = json['max_hold_time'] as int;
    tickArrAnalyzeCount = json['tick_arr_analyze_count'] as int;
    tickArrAnalyzeUnit = json['tick_arr_analyze_unit'] as int;
  }
  int? maxHoldTime;
  int? tickArrAnalyzeCount;
  int? tickArrAnalyzeUnit;
}
