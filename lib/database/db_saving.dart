import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('savings.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Increment version if schema is updated
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE IF NOT EXISTS saving_goals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        target_amount REAL NOT NULL,
        saved_amount REAL DEFAULT 0,
        created_at TEXT NOT NULL,
        isCompleted INTEGER DEFAULT 0
      );
    ''');

    await db.execute(''' 
      CREATE TABLE IF NOT EXISTS goal_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        target_amount REAL NOT NULL,
        saved_amount REAL NOT NULL,
        created_at TEXT NOT NULL,
        completed_at TEXT NOT NULL
      );
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(''' 
        CREATE TABLE IF NOT EXISTS goal_history (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          target_amount REAL NOT NULL,
          saved_amount REAL NOT NULL,
          created_at TEXT NOT NULL,
          completed_at TEXT NOT NULL
        );
      ''');
    }
  }

  // Method to add a new saving goal to the saving_goals table
  Future<int> addSavingGoal(String title, double targetAmount) async {
    final db = await instance.database;
    return await db.insert('saving_goals', {
      'title': title,
      'target_amount': targetAmount,
      'saved_amount': 0, // Initial saved amount is 0
      'created_at': DateTime.now().toIso8601String(), // Timestamp when goal is created
      'isCompleted': 0, // Initially the goal is not completed
    });
  }

  Future<int> updateGoalProgress(int id, double newSavedAmount) async {
    final db = await instance.database;

    // Update the saved_amount for the goal with the given id
    int rowsUpdated = await db.update(
      'saving_goals',
      {'saved_amount': newSavedAmount},
      where: 'id = ?',
      whereArgs: [id],
    );

    // Check if the goal is completed
    final goal = await db.query('saving_goals', where: 'id = ?', whereArgs: [id]);
    if (goal.isNotEmpty) {
      double targetAmount = goal.first['target_amount'] as double;
      if (newSavedAmount >= targetAmount) {
        await markGoalAsCompleted(id);
      }
    }
    return rowsUpdated;
  }

  Future<int> markGoalAsCompleted(int id) async {
    final db = await instance.database;

    // Fetch the goal details
    final goal = await db.query('saving_goals', where: 'id = ?', whereArgs: [id]);
    if (goal.isNotEmpty) {
      final goalData = goal.first;

      // Move the completed goal to goal_history
      await db.insert('goal_history', {
        'title': goalData['title'],
        'target_amount': goalData['target_amount'],
        'saved_amount': goalData['saved_amount'],
        'created_at': goalData['created_at'],
        'completed_at': DateTime.now().toIso8601String(),
      });

      // Delete the goal from saving_goals
      return await db.delete('saving_goals', where: 'id = ?', whereArgs: [id]);
    }
    return 0;
  }

  Future<List<Map<String, dynamic>>> fetchAllGoals() async {
    final db = await instance.database;
    return await db.query(
      'saving_goals',
      where: 'isCompleted = 0', // Fetch only active goals
      orderBy: 'id DESC',
    );
  }

  Future<List<Map<String, dynamic>>> fetchGoalHistory() async {
    final db = await instance.database;
    return await db.query(
      'goal_history',
      orderBy: 'id DESC', // Fetch completed goals ordered by id
    );
  }

  Future<double> fetchTotalSavings() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT SUM(saved_amount) AS total_savings FROM saving_goals WHERE isCompleted = 0',
    );
    return result.isNotEmpty && result.first['total_savings'] != null
        ? result.first['total_savings'] as double
        : 0.0;
  }
}