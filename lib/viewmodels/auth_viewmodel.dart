import 'package:flutter/material.dart';
import '../data/repository/auth_repository.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  bool isLoading = false;
  String? errorMessage;
  UserModel? currentUser;

  // REGISTER
  Future<bool> register(UserModel user) async {
    isLoading = true;
    notifyListeners();

    await _repo.register(user);

    isLoading = false;
    notifyListeners();

    return true;
  }

  // LOGIN
  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final user = await _repo.login(email, password);

    isLoading = false;

    if (user == null) {
      errorMessage = "Email atau password salah";
      notifyListeners();
      return false;
    }

    currentUser = user;
    notifyListeners();

    return true;
  }
}