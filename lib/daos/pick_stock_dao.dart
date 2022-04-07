import 'package:floor/floor.dart';
import 'package:trade_agent_v2/models/pick_stock.dart';

@dao
abstract class PickStockDao {
  @Query('SELECT * FROM time_line')
  Future<List<PickStock>> getAllPickStock();

  @Insert()
  Future<void> insertPickStock(PickStock t);
}
