import '../db/app_database.dart';
import '../../models/user_model.dart';

class AuthRepository {

  // CEK APAKAH EMAIL SUDAH TERDAFTAR
  Future<bool> isEmailExists(String email) async {
    final db = await AppDatabase.getDatabase();

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    return result.isNotEmpty;
  }

  // REGISTER
  Future<void> register(UserModel user) async {
    final db = await AppDatabase.getDatabase();

    await db.insert(
      'users',
      user.toMap(),
    );
  }

  // LOGIN
  Future<UserModel?> login(String email, String password) async {
    final db = await AppDatabase.getDatabase();

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }

    return null;
  }

  // GET USER BY ID
  Future<UserModel?> getUserById(String id) async {
    final db = await AppDatabase.getDatabase();

    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }

    return null;
  }
}