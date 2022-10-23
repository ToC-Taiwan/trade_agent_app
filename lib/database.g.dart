// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PickStockDao? _pickStockDaoInstance;

  BasickDao? _basicDaoInstance;

  FutureTickDao? _futureTickDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `pick_stock` (`stock_num` TEXT NOT NULL, `stock_name` TEXT NOT NULL, `price` REAL NOT NULL, `price_change_rate` REAL NOT NULL, `price_change` REAL NOT NULL, `is_target` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `create_time` INTEGER NOT NULL, `update_time` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `basic` (`key` TEXT NOT NULL, `value` TEXT NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `create_time` INTEGER NOT NULL, `update_time` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `future_tick` (`code` TEXT, `tick_time` TEXT, `open` INTEGER, `underlying_price` REAL, `bid_side_total_vol` INTEGER, `ask_side_total_vol` INTEGER, `avg_price` REAL, `close` INTEGER, `high` INTEGER, `low` INTEGER, `amount` INTEGER, `total_amount` INTEGER, `volume` INTEGER, `total_volume` INTEGER, `tick_type` INTEGER, `chg_type` INTEGER, `price_chg` INTEGER, `pct_chg` REAL, `simtrade` INTEGER, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `create_time` INTEGER NOT NULL, `update_time` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PickStockDao get pickStockDao {
    return _pickStockDaoInstance ??= _$PickStockDao(database, changeListener);
  }

  @override
  BasickDao get basicDao {
    return _basicDaoInstance ??= _$BasickDao(database, changeListener);
  }

  @override
  FutureTickDao get futureTickDao {
    return _futureTickDaoInstance ??= _$FutureTickDao(database, changeListener);
  }
}

class _$PickStockDao extends PickStockDao {
  _$PickStockDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _pickStockInsertionAdapter = InsertionAdapter(
            database,
            'pick_stock',
            (PickStock item) => <String, Object?>{
                  'stock_num': item.stockNum,
                  'stock_name': item.stockName,
                  'price': item.price,
                  'price_change_rate': item.priceChangeRate,
                  'price_change': item.priceChange,
                  'is_target': item.isTarget,
                  'id': item.id,
                  'create_time': item.createTime,
                  'update_time': item.updateTime
                }),
        _pickStockUpdateAdapter = UpdateAdapter(
            database,
            'pick_stock',
            ['id'],
            (PickStock item) => <String, Object?>{
                  'stock_num': item.stockNum,
                  'stock_name': item.stockName,
                  'price': item.price,
                  'price_change_rate': item.priceChangeRate,
                  'price_change': item.priceChange,
                  'is_target': item.isTarget,
                  'id': item.id,
                  'create_time': item.createTime,
                  'update_time': item.updateTime
                }),
        _pickStockDeletionAdapter = DeletionAdapter(
            database,
            'pick_stock',
            ['id'],
            (PickStock item) => <String, Object?>{
                  'stock_num': item.stockNum,
                  'stock_name': item.stockName,
                  'price': item.price,
                  'price_change_rate': item.priceChangeRate,
                  'price_change': item.priceChange,
                  'is_target': item.isTarget,
                  'id': item.id,
                  'create_time': item.createTime,
                  'update_time': item.updateTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PickStock> _pickStockInsertionAdapter;

  final UpdateAdapter<PickStock> _pickStockUpdateAdapter;

  final DeletionAdapter<PickStock> _pickStockDeletionAdapter;

  @override
  Future<List<PickStock>> getAllPickStock() async {
    return _queryAdapter.queryList('SELECT * FROM pick_stock',
        mapper: (Map<String, Object?> row) => PickStock(
            row['stock_num'] as String,
            row['stock_name'] as String,
            row['is_target'] as int,
            row['price_change'] as double,
            row['price_change_rate'] as double,
            row['price'] as double,
            id: row['id'] as int?,
            createTime: row['create_time'] as int?,
            updateTime: row['update_time'] as int?));
  }

  @override
  Future<PickStock?> getPickStockByStockNum(String stockNum) async {
    return _queryAdapter.query('SELECT * FROM pick_stock WHERE stock_num = ?1',
        mapper: (Map<String, Object?> row) => PickStock(
            row['stock_num'] as String,
            row['stock_name'] as String,
            row['is_target'] as int,
            row['price_change'] as double,
            row['price_change_rate'] as double,
            row['price'] as double,
            id: row['id'] as int?,
            createTime: row['create_time'] as int?,
            updateTime: row['update_time'] as int?),
        arguments: [stockNum]);
  }

  @override
  Future<void> deleteAllPickStock() async {
    await _queryAdapter.queryNoReturn('DELETE FROM pick_stock WHERE id !=0');
  }

  @override
  Future<void> insertPickStock(PickStock record) async {
    await _pickStockInsertionAdapter.insert(record, OnConflictStrategy.replace);
  }

  @override
  Future<void> updatePickStock(PickStock record) async {
    await _pickStockUpdateAdapter.update(record, OnConflictStrategy.replace);
  }

  @override
  Future<int> updatePickStocks(List<PickStock> record) {
    return _pickStockUpdateAdapter.updateListAndReturnChangedRows(
        record, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePickStock(PickStock record) async {
    await _pickStockDeletionAdapter.delete(record);
  }
}

class _$BasickDao extends BasickDao {
  _$BasickDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _basicInsertionAdapter = InsertionAdapter(
            database,
            'basic',
            (Basic item) => <String, Object?>{
                  'key': item.key,
                  'value': item.value,
                  'id': item.id,
                  'create_time': item.createTime,
                  'update_time': item.updateTime
                }),
        _basicUpdateAdapter = UpdateAdapter(
            database,
            'basic',
            ['id'],
            (Basic item) => <String, Object?>{
                  'key': item.key,
                  'value': item.value,
                  'id': item.id,
                  'create_time': item.createTime,
                  'update_time': item.updateTime
                }),
        _basicDeletionAdapter = DeletionAdapter(
            database,
            'basic',
            ['id'],
            (Basic item) => <String, Object?>{
                  'key': item.key,
                  'value': item.value,
                  'id': item.id,
                  'create_time': item.createTime,
                  'update_time': item.updateTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Basic> _basicInsertionAdapter;

  final UpdateAdapter<Basic> _basicUpdateAdapter;

  final DeletionAdapter<Basic> _basicDeletionAdapter;

  @override
  Future<List<Basic>> getAllBasic() async {
    return _queryAdapter.queryList('SELECT * FROM basic',
        mapper: (Map<String, Object?> row) => Basic(
            row['key'] as String, row['value'] as String,
            id: row['id'] as int?,
            createTime: row['create_time'] as int?,
            updateTime: row['update_time'] as int?));
  }

  @override
  Future<Basic?> getBasicByKey(String key) async {
    return _queryAdapter.query('SELECT * FROM basic WHERE key = ?1',
        mapper: (Map<String, Object?> row) => Basic(
            row['key'] as String, row['value'] as String,
            id: row['id'] as int?,
            createTime: row['create_time'] as int?,
            updateTime: row['update_time'] as int?),
        arguments: [key]);
  }

  @override
  Future<void> deleteAllBasic() async {
    await _queryAdapter.queryNoReturn('DELETE FROM basic WHERE id !=0');
  }

  @override
  Future<void> insertBasic(Basic record) async {
    await _basicInsertionAdapter.insert(record, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateBasic(Basic record) async {
    await _basicUpdateAdapter.update(record, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateBasics(List<Basic> record) {
    return _basicUpdateAdapter.updateListAndReturnChangedRows(
        record, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteBasic(Basic record) async {
    await _basicDeletionAdapter.delete(record);
  }
}

class _$FutureTickDao extends FutureTickDao {
  _$FutureTickDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _realTimeFutureTickInsertionAdapter = InsertionAdapter(
            database,
            'future_tick',
            (RealTimeFutureTick item) => <String, Object?>{
                  'code': item.code,
                  'tick_time': item.tickTime,
                  'open': item.open,
                  'underlying_price': item.underlyingPrice,
                  'bid_side_total_vol': item.bidSideTotalVol,
                  'ask_side_total_vol': item.askSideTotalVol,
                  'avg_price': item.avgPrice,
                  'close': item.close,
                  'high': item.high,
                  'low': item.low,
                  'amount': item.amount,
                  'total_amount': item.totalAmount,
                  'volume': item.volume,
                  'total_volume': item.totalVolume,
                  'tick_type': item.tickType,
                  'chg_type': item.chgType,
                  'price_chg': item.priceChg,
                  'pct_chg': item.pctChg,
                  'simtrade': item.simtrade,
                  'id': item.id,
                  'create_time': item.createTime,
                  'update_time': item.updateTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RealTimeFutureTick>
      _realTimeFutureTickInsertionAdapter;

  @override
  Future<RealTimeFutureTick?> getLastFutureTick() async {
    return _queryAdapter.query(
        'SELECT * FROM future_tick Order by id desc limit 1',
        mapper: (Map<String, Object?> row) => RealTimeFutureTick(
            row['code'] as String?,
            row['tick_time'] as String?,
            row['open'] as int?,
            row['underlying_price'] as double?,
            row['bid_side_total_vol'] as int?,
            row['ask_side_total_vol'] as int?,
            row['avg_price'] as double?,
            row['close'] as int?,
            row['high'] as int?,
            row['low'] as int?,
            row['amount'] as int?,
            row['total_amount'] as int?,
            row['volume'] as int?,
            row['total_volume'] as int?,
            row['tick_type'] as int?,
            row['chg_type'] as int?,
            row['price_chg'] as int?,
            row['pct_chg'] as double?,
            row['simtrade'] as int?,
            id: row['id'] as int?,
            createTime: row['create_time'] as int?,
            updateTime: row['update_time'] as int?));
  }

  @override
  Future<List<RealTimeFutureTick>> getAllFutureTick() async {
    return _queryAdapter.queryList('SELECT * FROM future_tick',
        mapper: (Map<String, Object?> row) => RealTimeFutureTick(
            row['code'] as String?,
            row['tick_time'] as String?,
            row['open'] as int?,
            row['underlying_price'] as double?,
            row['bid_side_total_vol'] as int?,
            row['ask_side_total_vol'] as int?,
            row['avg_price'] as double?,
            row['close'] as int?,
            row['high'] as int?,
            row['low'] as int?,
            row['amount'] as int?,
            row['total_amount'] as int?,
            row['volume'] as int?,
            row['total_volume'] as int?,
            row['tick_type'] as int?,
            row['chg_type'] as int?,
            row['price_chg'] as int?,
            row['pct_chg'] as double?,
            row['simtrade'] as int?,
            id: row['id'] as int?,
            createTime: row['create_time'] as int?,
            updateTime: row['update_time'] as int?));
  }

  @override
  Future<void> deleteAllFutureTick() async {
    await _queryAdapter.queryNoReturn('DELETE FROM future_tick WHERE id !=0');
  }

  @override
  Future<void> insertFutureTick(List<RealTimeFutureTick> records) async {
    await _realTimeFutureTickInsertionAdapter.insertList(
        records, OnConflictStrategy.replace);
  }
}
