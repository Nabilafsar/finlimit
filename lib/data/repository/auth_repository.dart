import '../db/app_database.dart';
import '../../models/user_model.dart';

class AuthRepository {

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
}