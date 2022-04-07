import 'package:floor/floor.dart';
import 'package:trade_agent_v2/models/pick_stock.dart';

@dao
abstract class PickStockDao {
  @Query('SELECT * FROM pick_stock')
  Future<List<PickStock>> getAllPickStock();

  @Query('DELETE FROM pick_stock WHERE id !=0')
  Future<void> deleteAllPickStock();

  @delete
  Future<void> deletePickStock(PickStock record);

  @Insert()
  Future<void> insertPickStock(PickStock record);
}
