import 'package:floor/floor.dart';
import 'package:trade_agent_v2/models/base.dart';

@Entity(tableName: 'pick_stock')
class PickStock extends BaseObject {
  PickStock(
    this.stockNum, {
    int? id,
    int? createTime,
    int? updateTime,
  }) : super(id: id, updateTime: updateTime, createTime: createTime);

  @ColumnInfo(name: 'stock_num')
  final String stockNum;
}
