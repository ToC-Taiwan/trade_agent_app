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
            'CREATE TABLE IF NOT EXISTS `pick_stock` (`stock_num` TEXT NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `create_time` INTEGER NOT NULL, `update_time` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PickStockDao get pickStockDao {
    return _pickStockDaoInstance ??= _$PickStockDao(database, changeListener);
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
                  'id': item.id,
                  'create_time': item.createTime,
                  'update_time': item.updateTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PickStock> _pickStockInsertionAdapter;

  final DeletionAdapter<PickStock> _pickStockDeletionAdapter;

  @override
  Future<List<PickStock>> getAllPickStock() async {
    return _queryAdapter.queryList('SELECT * FROM pick_stock',
        mapper: (Map<String, Object?> row) => PickStock(
            row['stock_num'] as String,
            id: row['id'] as int?,
            createTime: row['create_time'] as int?,
            updateTime: row['update_time'] as int?));
  }

  @override
  Future<void> deleteAllPickStock() async {
    await _queryAdapter.queryNoReturn('DELETE FROM pick_stock WHERE id !=0');
  }

  @override
  Future<void> insertPickStock(PickStock record) async {
    await _pickStockInsertionAdapter.insert(record, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePickStock(PickStock record) async {
    await _pickStockDeletionAdapter.delete(record);
  }
}
