import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'finlimit.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  static Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        fullname TEXT,
        email TEXT,
        password TEXT,
        monthly_limit REAL,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        title TEXT,
        subtitle TEXT,
        amount REAL,
        category TEXT,
        payment_method TEXT,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        subject TEXT,
        message TEXT,
        time TEXT,
        type TEXT,
        is_read INTEGER,
        is_starred INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE education_articles (
        id TEXT PRIMARY KEY,
        title TEXT,
        content TEXT,
        image_url TEXT,
        category TEXT,
        created_at TEXT
      )
    ''');
  }
}