// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

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

  MealDao? _mealDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
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
            'CREATE TABLE IF NOT EXISTS `Meals` (`localId` INTEGER PRIMARY KEY AUTOINCREMENT, `id` INTEGER, `name` TEXT NOT NULL, `type` TEXT NOT NULL, `calories` REAL NOT NULL, `date` INTEGER NOT NULL, `notes` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MealDao get mealDao {
    return _mealDaoInstance ??= _$MealDao(database, changeListener);
  }
}

class _$MealDao extends MealDao {
  _$MealDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _mealInsertionAdapter = InsertionAdapter(
            database,
            'Meals',
            (Meal item) => <String, Object?>{
                  'localId': item.localId,
                  'id': item.id,
                  'name': item.name,
                  'type': item.type,
                  'calories': item.calories,
                  'date': _dateTimeConverter.encode(item.date),
                  'notes': item.notes
                }),
        _mealUpdateAdapter = UpdateAdapter(
            database,
            'Meals',
            ['localId'],
            (Meal item) => <String, Object?>{
                  'localId': item.localId,
                  'id': item.id,
                  'name': item.name,
                  'type': item.type,
                  'calories': item.calories,
                  'date': _dateTimeConverter.encode(item.date),
                  'notes': item.notes
                }),
        _mealDeletionAdapter = DeletionAdapter(
            database,
            'Meals',
            ['localId'],
            (Meal item) => <String, Object?>{
                  'localId': item.localId,
                  'id': item.id,
                  'name': item.name,
                  'type': item.type,
                  'calories': item.calories,
                  'date': _dateTimeConverter.encode(item.date),
                  'notes': item.notes
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Meal> _mealInsertionAdapter;

  final UpdateAdapter<Meal> _mealUpdateAdapter;

  final DeletionAdapter<Meal> _mealDeletionAdapter;

  @override
  Future<List<Meal>> getAllMeals() async {
    return _queryAdapter.queryList('SELECT * FROM Meals',
        mapper: (Map<String, Object?> row) => Meal(
            id: row['id'] as int?,
            name: row['name'] as String,
            type: row['type'] as String,
            calories: row['calories'] as double,
            date: _dateTimeConverter.decode(row['date'] as int),
            notes: row['notes'] as String));
  }

  @override
  Future<void> clearMeals() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Meals');
  }

  @override
  Future<int> insertMeal(Meal meal) {
    return _mealInsertionAdapter.insertAndReturnId(
        meal, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertMeals(List<Meal> meal) {
    return _mealInsertionAdapter.insertListAndReturnIds(
        meal, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMeal(Meal meal) async {
    await _mealUpdateAdapter.update(meal, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMeals(List<Meal> meals) async {
    await _mealUpdateAdapter.updateList(meals, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteMeal(Meal meal) async {
    await _mealDeletionAdapter.delete(meal);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
