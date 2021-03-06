import 'package:eyes_in_body_app2/data/data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'dietapp.db';
  static const int _databaseVersion = 1;
  static const foodTable = 'food';
  static const workoutTable = 'workout';
  static const eyeBodyTable = 'eyeBody';
  static const weightTable = 'weight';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $foodTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date INTEGER DEFAULT 0,
      type INTEGER DEFAULT 0,
      meal INTEGER DEFAULT 0,
      kcal INTEGER DEFAULT 0,
      time INTEGER DEFAULT 0,
      memo String,
      image String
    )
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS $workoutTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date INTEGER DEFAULT 0,
      time INTEGER DEFAULT 0,
      type INTEGER DEFAULT 0,
      distance INTEGER DEFAULT 0,
      kcal INTEGER DEFAULT 0,
      intense INTEGER DEFAULT 0,
      part INTEGER DEFAULT 0,
      name String,
      memo String
    )
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS $eyeBodyTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date INTEGER DEFAULT 0,
      image String,
      memo String
    )
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS $weightTable (
      date INTEGER DEFAULT 0,
      weight INTEGER DEFAULT 0,
      fat INTEGER DEFAULT 0,
      muscle INTEGER DEFAULT 0
    )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}
  // ????????? ??????, ??????, ??????, ??????

  Future<int> insertFood(Food food) async {
    Database? db = await instance.database;

    if (food.id == null) {
      // ??????
      final _map = food.toMap();

      return await db!.insert(foodTable, _map);
    } else {
      // ??????
      final _map = food.toMap();

      return await db!.update(foodTable, _map, where: 'id = ?', whereArgs: [food.id]);
    }
  }

  Future<List<Food>> queryFoodByDate(int date) async {
    Database? db = await instance.database;

    List<Food> foods = [];

    final query = await db!.query(foodTable, where: 'date = ?', whereArgs: [date]);

    for (final q in query) {
      foods.add(Food.fromDB(q));
    }

    return foods;
  }

  Future<List<Food>> queryAllFood() async {
    Database? db = await instance.database;

    List<Food> foods = [];

    final query = await db!.query(foodTable);

    for (final q in query) {
      foods.add(Food.fromDB(q));
    }

    return foods;
  }

  Future<int> insertWorkout(Workout workout) async {
    Database? db = await instance.database;

    if (workout.id == null) {
      // ??????
      final _map = workout.toMap();

      return await db!.insert(workoutTable, _map);
    } else {
      // ??????
      final _map = workout.toMap();

      return await db!.update(workoutTable, _map, where: 'id = ?', whereArgs: [workout.id]);
    }
  }

  Future<List<Workout>> queryWorkoutByDate(int date) async {
    Database? db = await instance.database;

    List<Workout> workouts = [];

    final query = await db!.query(workoutTable, where: 'date = ?', whereArgs: [date]);

    for (final q in query) {
      workouts.add(Workout.fromDB(q));
    }

    return workouts;
  }

  Future<List<Workout>> queryAllWorkout() async {
    Database? db = await instance.database;

    List<Workout> workouts = [];

    final query = await db!.query(workoutTable);

    for (final q in query) {
      workouts.add(Workout.fromDB(q));
    }

    return workouts;
  }

  Future<int> insertEyeBody(EyeBody eyeBody) async {
    Database? db = await instance.database;

    if (eyeBody.id == null) {
      // ??????
      final _map = eyeBody.toMap();

      return await db!.insert(eyeBodyTable, _map);
    } else {
      // ??????
      final _map = eyeBody.toMap();

      return await db!.update(eyeBodyTable, _map, where: 'id = ?', whereArgs: [eyeBody.id]);
    }
  }

  Future<List<EyeBody>> queryEyeBodyByDate(int date) async {
    Database? db = await instance.database;

    List<EyeBody> eyeBodies = [];

    final query = await db!.query(eyeBodyTable, where: 'date = ?', whereArgs: [date]);

    for (final q in query) {
      eyeBodies.add(EyeBody.fromDB(q));
    }

    return eyeBodies;
  }

  Future<List<EyeBody>> queryAllEyeBody() async {
    Database? db = await instance.database;

    List<EyeBody> eyeBodies = [];

    final query = await db!.query(eyeBodyTable);

    for (final q in query) {
      eyeBodies.add(EyeBody.fromDB(q));
    }

    return eyeBodies;
  }

  Future<int> insertWeight(Weight weight) async {
    Database? db = await instance.database;

    List<Weight> _d = await queryWeightByDate(weight.date);

    if (_d.isEmpty) {
      // ??????
      final _map = weight.toMap();

      return await db!.insert(weightTable, _map);
    } else {
      // ??????
      final _map = weight.toMap();

      return await db!.update(weightTable, _map, where: 'date = ?', whereArgs: [weight.date]);
    }
  }

  Future<List<Weight>> queryWeightByDate(int date) async {
    Database? db = await instance.database;

    List<Weight> weights = [];

    final query = await db!.query(weightTable, where: 'date = ?', whereArgs: [date]);

    for (final q in query) {
      weights.add(Weight.fromDB(q));
    }

    return weights;
  }

  Future<List<Weight>> queryAllWeight() async {
    Database? db = await instance.database;

    List<Weight> weights = [];

    final query = await db!.query(weightTable);

    for (final q in query) {
      weights.add(Weight.fromDB(q));
    }

    return weights;
  }
}