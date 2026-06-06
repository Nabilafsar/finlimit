import 'package:flutter/material.dart';
import '../data/repository/auth_repository.dart';
import '../models/user_model.dart';
import '../data/db/db_helper.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  bool isLoading = false;
  String? errorMessage;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // ── REGISTER ────────────────────────────────────────────
  Future<bool> register(UserModel user) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
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

  // ── SETUP PROFILE ────────────────────────────────────────
  Future<bool> setupProfile({
    required String userId,
    required double balance,
    required double dailyLimit,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (balance <= 0) {
        errorMessage = "Saldo harus lebih dari 0";
        isLoading = false;
        notifyListeners();
        return false;
      }
      if (dailyLimit <= 0) {
        errorMessage = "Limit harian harus lebih dari 0";
        isLoading = false;
        notifyListeners();
        return false;
      }

      await DbHelper.updateBalance(userId, balance);
      await DbHelper.updateDailyLimit(userId, dailyLimit);

      // Refresh currentUser supaya balance & dailyLimit terupdate
      await refreshUser(userId);

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

  // ── LOGIN ────────────────────────────────────────────────
  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
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

      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = "Terjadi kesalahan: ${e.toString()}";
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ── REFRESH USER (dipanggil setelah add transaction) ────
  Future<void> refreshUser(String userId) async {
    try {
      final map = await DbHelper.getUserById(userId);
      if (map != null) {
        _currentUser = UserModel.fromMap(map);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('refreshUser error: $e');
    }
  }

  // ── LOGOUT ───────────────────────────────────────────────
  void logout() {
    _currentUser = null;
    errorMessage = null;
    notifyListeners();
  }
}

