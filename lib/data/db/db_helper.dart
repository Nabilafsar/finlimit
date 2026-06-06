import 'package:finlimit/data/db/app_database.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  // ─────────────────────────────────────────
  // USERS
  // ─────────────────────────────────────────

  static Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await AppDatabase.getDatabase();
    return await db.insert('users', user,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Map<String, dynamic>?> getUserById(String id) async {
    final db = await AppDatabase.getDatabase();
    final result =
        await db.query('users', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  static Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await AppDatabase.getDatabase();
    final result =
        await db.query('users', where: 'email = ?', whereArgs: [email]);
    return result.isNotEmpty ? result.first : null;
  }

  static Future<int> updateUser(Map<String, dynamic> user) async {
    final db = await AppDatabase.getDatabase();
    return await db
        .update('users', user, where: 'id = ?', whereArgs: [user['id']]);
  }

  static Future<int> updateMonthlyLimit(String userId, double limit) async {
    final db = await AppDatabase.getDatabase();
    return await db.update(
      'users',
      {'monthly_limit': limit},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  static Future<int> updateDailyLimit(String userId, double limit) async {
  final db = await AppDatabase.getDatabase();
  return await db.update(
    'users',
    {'daily_limit': limit},
    where: 'id = ?',
    whereArgs: [userId],
  );
}

static Future<int> updateBalance(String userId, double balance) async {
  final db = await AppDatabase.getDatabase();
  return await db.update(
    'users',
    {'balance': balance},
    where: 'id = ?',
    whereArgs: [userId],
  );
}

  static Future<int> deleteUser(String id) async {
    final db = await AppDatabase.getDatabase();
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // ─────────────────────────────────────────
  // TRANSACTIONS
  // ─────────────────────────────────────────

  static Future<int> insertTransaction(Map<String, dynamic> transaction) async {
    final db = await AppDatabase.getDatabase();
    return await db.insert('transactions', transaction,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getTransactionsByUser(
      String userId) async {
    final db = await AppDatabase.getDatabase();
    return await db.query(
      'transactions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
  }

  static Future<List<Map<String, dynamic>>> getTransactionsByCategory(
      String userId, String category) async {
    final db = await AppDatabase.getDatabase();
    return await db.query(
      'transactions',
      where: 'user_id = ? AND category = ?',
      whereArgs: [userId, category],
      orderBy: 'date DESC',
    );
  }

  static Future<double> getTotalSpendingByUser(String userId) async {
    final db = await AppDatabase.getDatabase();
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE user_id = ?',
      [userId],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  static Future<int> updateTransaction(Map<String, dynamic> transaction) async {
    final db = await AppDatabase.getDatabase();
    return await db.update(
      'transactions',
      transaction,
      where: 'id = ?',
      whereArgs: [transaction['id']],
    );
  }

  static Future<int> deleteTransaction(String id) async {
    final db = await AppDatabase.getDatabase();
    return await db
        .delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  // ─────────────────────────────────────────
  // NOTIFICATIONS
  // ─────────────────────────────────────────

  static Future<int> insertNotification(
      Map<String, dynamic> notification) async {
    final db = await AppDatabase.getDatabase();
    return await db.insert('notifications', notification,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getNotificationsByUser(
      String userId) async {
    final db = await AppDatabase.getDatabase();
    return await db.query(
      'notifications',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'time DESC',
    );
  }

  static Future<List<Map<String, dynamic>>> getStarredNotifications(
      String userId) async {
    final db = await AppDatabase.getDatabase();
    return await db.query(
      'notifications',
      where: 'user_id = ? AND is_starred = 1',
      whereArgs: [userId],
      orderBy: 'time DESC',
    );
  }

  static Future<int> markNotificationAsRead(String id) async {
    final db = await AppDatabase.getDatabase();
    return await db.update(
      'notifications',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> markAllNotificationsAsRead(String userId) async {
    final db = await AppDatabase.getDatabase();
    return await db.update(
      'notifications',
      {'is_read': 1},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  static Future<int> toggleStarNotification(String id, bool isStarred) async {
    final db = await AppDatabase.getDatabase();
    return await db.update(
      'notifications',
      {'is_starred': isStarred ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> deleteNotification(String id) async {
    final db = await AppDatabase.getDatabase();
    return await db
        .delete('notifications', where: 'id = ?', whereArgs: [id]);
  }

  // ─────────────────────────────────────────
  // EDUCATION ARTICLES
  // ─────────────────────────────────────────

  static Future<int> insertArticle(Map<String, dynamic> article) async {
    final db = await AppDatabase.getDatabase();
    return await db.insert('education_articles', article,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getAllArticles() async {
    final db = await AppDatabase.getDatabase();
    return await db.query('education_articles', orderBy: 'created_at DESC');
  }

  static Future<List<Map<String, dynamic>>> getArticlesByCategory(
      String category) async {
    final db = await AppDatabase.getDatabase();
    return await db.query(
      'education_articles',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'created_at DESC',
    );
  }

  static Future<Map<String, dynamic>?> getArticleById(String id) async {
    final db = await AppDatabase.getDatabase();
    final result = await db
        .query('education_articles', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  static Future<int> deleteArticle(String id) async {
    final db = await AppDatabase.getDatabase();
    return await db
        .delete('education_articles', where: 'id = ?', whereArgs: [id]);
  }
}

