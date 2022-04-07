import 'package:floor/floor.dart';
import 'package:trade_agent_v2/models/pick_stock.dart';

@dao
abstract class PickStockDao {
  @Query('SELECT * FROM pick_stock')
  Future<List<PickStock>> getAllPickStock();

  @Query('SELECT * FROM pick_stock WHERE id = :id')
  Stream<PickStock?> getPickStockByID(int id);

  @Insert()
  Future<void> insertPickStock(PickStock record);
}
