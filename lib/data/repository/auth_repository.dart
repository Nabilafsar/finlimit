import 'package:uuid/uuid.dart';
import '../db/db_helper.dart';
import '../../models/user_model.dart';

class AuthRepository {

  // CEK APAKAH EMAIL SUDAH TERDAFTAR
  Future<bool> isEmailExists(String email) async {
    final user = await DbHelper.getUserByEmail(email);
    return user != null;
  }

  // REGISTER
  Future<void> register(UserModel user) async {
    await DbHelper.insertUser(user.toMap());
  }

  // LOGIN
  Future<UserModel?> login(String email, String password) async {
    final result = await DbHelper.getUserByEmail(email);

    if (result != null && result['password'] == password) {
      return UserModel.fromMap(result);
    }

    return null;
  }

  // GET USER BY ID
  Future<UserModel?> getUserById(String id) async {
    final result = await DbHelper.getUserById(id);

    if (result != null) {
      return UserModel.fromMap(result);
    }

    return null;
  }
}