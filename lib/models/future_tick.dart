import 'package:floor/floor.dart';
import 'package:trade_agent_v2/models/base.dart';

@Entity(tableName: 'future_tick')
class RealTimeFutureTick extends BaseObject {
  RealTimeFutureTick(
    this.code,
    this.tickTime,
    this.open,
    this.underlyingPrice,
    this.bidSideTotalVol,
    this.askSideTotalVol,
    this.avgPrice,
    this.close,
    this.high,
    this.low,
    this.amount,
    this.totalAmount,
    this.volume,
    this.totalVolume,
    this.tickType,
    this.chgType,
    this.priceChg,
    this.pctChg,
    this.simtrade, {
    int? id,
    int? createTime,
    int? updateTime,
  }) : super(id: id, updateTime: updateTime, createTime: createTime);

  RealTimeFutureTick.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    tickTime = json['tick_time'];
    open = json['open'];
    underlyingPrice = json['underlying_price'];
    bidSideTotalVol = json['bid_side_total_vol'];
    askSideTotalVol = json['ask_side_total_vol'];
    avgPrice = json['avg_price'];
    close = json['close'];
    high = json['high'];
    low = json['low'];
    amount = json['amount'];
    totalAmount = json['total_amount'];
    volume = json['volume'];
    totalVolume = json['total_volume'];
    tickType = json['tick_type'];
    chgType = json['chg_type'];
    priceChg = json['price_chg'];
    pctChg = json['pct_chg'];
    simtrade = json['simtrade'];
  }

  @ColumnInfo(name: 'code')
  String? code = '';

  @ColumnInfo(name: 'tick_time')
  String? tickTime = '';

  @ColumnInfo(name: 'open')
  int? open = 0;

  @ColumnInfo(name: 'underlying_price')
  double? underlyingPrice = 0;

  @ColumnInfo(name: 'bid_side_total_vol')
  int? bidSideTotalVol = 0;

  @ColumnInfo(name: 'ask_side_total_vol')
  int? askSideTotalVol = 0;

  @ColumnInfo(name: 'avg_price')
  double? avgPrice = 0;

  @ColumnInfo(name: 'close')
  int? close = 0;

  @ColumnInfo(name: 'high')
  int? high = 0;

  @ColumnInfo(name: 'low')
  int? low = 0;

  @ColumnInfo(name: 'amount')
  int? amount = 0;

  @ColumnInfo(name: 'total_amount')
  int? totalAmount = 0;

  @ColumnInfo(name: 'volume')
  int? volume = 0;

  @ColumnInfo(name: 'total_volume')
  int? totalVolume = 0;

  @ColumnInfo(name: 'tick_type')
  int? tickType = 0;

  @ColumnInfo(name: 'chg_type')
  int? chgType = 0;

  @ColumnInfo(name: 'price_chg')
  int? priceChg = 0;

  @ColumnInfo(name: 'pct_chg')
  double? pctChg = 0;

  @ColumnInfo(name: 'simtrade')
  int? simtrade = 0;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['tick_time'] = tickTime;
    data['open'] = open;
    data['underlying_price'] = underlyingPrice;
    data['bid_side_total_vol'] = bidSideTotalVol;
    data['ask_side_total_vol'] = askSideTotalVol;
    data['avg_price'] = avgPrice;
    data['close'] = close;
    data['high'] = high;
    data['low'] = low;
    data['amount'] = amount;
    data['total_amount'] = totalAmount;
    data['volume'] = volume;
    data['total_volume'] = totalVolume;
    data['tick_type'] = tickType;
    data['chg_type'] = chgType;
    data['price_chg'] = priceChg;
    data['pct_chg'] = pctChg;
    data['simtrade'] = simtrade;
    return data;
  }

  // Future<RealTimeFutureTick> init() async {
  //   return RealTimeFutureTick();
  // }

  // Future<List<RealTimeFutureTick>> initArr() async {
  //   return <RealTimeFutureTick>[];
  // }
}
