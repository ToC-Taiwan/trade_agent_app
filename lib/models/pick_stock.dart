import 'package:floor/floor.dart';
import 'package:trade_agent_v2/models/base.dart';

@Entity(tableName: 'pick_stock')
class PickStock extends BaseObject {
  PickStock(
    this.stockNum,
    this.stockName,
    this.isTarget,
    this.priceChange,
    this.priceChangeRate,
    this.price, {
    int? id,
    int? createTime,
    int? updateTime,
  }) : super(id: id, updateTime: updateTime, createTime: createTime);

  @ColumnInfo(name: 'stock_num')
  final String stockNum;

  @ColumnInfo(name: 'stock_name')
  final String stockName;

  @ColumnInfo(name: 'price')
  final num price;

  @ColumnInfo(name: 'price_change_rate')
  final num priceChangeRate;

  @ColumnInfo(name: 'price_change')
  final num priceChange;

  @ColumnInfo(name: 'is_target')
  final int isTarget;
}
