import 'package:floor/floor.dart';
import 'package:trade_agent_v2/models/model.dart';

@dao
abstract class FutureTickDao {
  @Query('SELECT * FROM future_tick Order by id desc limit 1')
  Future<RealTimeFutureTick?> getLastFutureTick();

  @Query('SELECT * FROM future_tick')
  Future<List<RealTimeFutureTick>> getAllFutureTick();

  @Query('DELETE FROM future_tick WHERE id !=0')
  Future<void> deleteAllFutureTick();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertFutureTick(List<RealTimeFutureTick> records);
}
