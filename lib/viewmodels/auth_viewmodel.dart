import 'package:flutter/material.dart';
import '../data/repository/auth_repository.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  bool isLoading = false;
  String? errorMessage;
  UserModel? currentUser;

  // VALIDASI EMAIL FORMAT
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // REGISTER
  Future<bool> register(UserModel user) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Validasi field kosong
      if (user.fullname.trim().isEmpty) {
        errorMessage = "Nama tidak boleh kosong";
        isLoading = false;
        notifyListeners();
        return false;
      }

      if (user.email.trim().isEmpty) {
        errorMessage = "Email tidak boleh kosong";
        isLoading = false;
        notifyListeners();
        return false;
      }

      if (!_isValidEmail(user.email)) {
        errorMessage = "Format email tidak valid";
        isLoading = false;
        notifyListeners();
        return false;
      }

      if (user.password.length < 6) {
        errorMessage = "Password minimal 6 karakter";
        isLoading = false;
        notifyListeners();
        return false;
      }

      // Cek email duplikat
      final emailExists = await _repo.isEmailExists(user.email);
      if (emailExists) {
        errorMessage = "Email sudah terdaftar";
        isLoading = false;
        notifyListeners();
        return false;
      }

      await _repo.register(user);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = "Terjadi kesalahan: ${e.toString()}";
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // LOGIN
  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Validasi field kosong
      if (email.trim().isEmpty) {
        errorMessage = "Email tidak boleh kosong";
        isLoading = false;
        notifyListeners();
        return false;
      }

      if (password.trim().isEmpty) {
        errorMessage = "Password tidak boleh kosong";
        isLoading = false;
        notifyListeners();
        return false;
      }

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
    } catch (e) {
      errorMessage = "Terjadi kesalahan: ${e.toString()}";
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // LOGOUT
  void logout() {
    currentUser = null;
    errorMessage = null;
    notifyListeners();
  }
}