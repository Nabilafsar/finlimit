import 'package:flutter/material.dart';
import '../data/db/db_helper.dart';
import '../models/user_model.dart';

class SettingsViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  // ── UPDATE FULLNAME ──────────────────────────────────────
  Future<bool> updateFullname({
    required UserModel currentUser,
    required String newFullname,
  }) async {
    if (newFullname.trim().isEmpty) {
      errorMessage = 'Nama tidak boleh kosong';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      final updatedMap = currentUser.toMap()
        ..['fullname'] = newFullname.trim();
      await DbHelper.updateUser(updatedMap);
      successMessage = 'Nama berhasil diperbarui';
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Gagal memperbarui nama: ${e.toString()}';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ── UPDATE EMAIL ─────────────────────────────────────────
  Future<bool> updateEmail({
    required UserModel currentUser,
    required String newEmail,
  }) async {
    if (newEmail.trim().isEmpty) {
      errorMessage = 'Email tidak boleh kosong';
      notifyListeners();
      return false;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(newEmail)) {
      errorMessage = 'Format email tidak valid';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      // Cek apakah email sudah dipakai user lain
      final existing = await DbHelper.getUserByEmail(newEmail.trim());
      if (existing != null && existing['id'] != currentUser.id) {
        errorMessage = 'Email sudah digunakan';
        isLoading = false;
        notifyListeners();
        return false;
      }

      final updatedMap = currentUser.toMap()
        ..['email'] = newEmail.trim();
      await DbHelper.updateUser(updatedMap);
      successMessage = 'Email berhasil diperbarui';
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Gagal memperbarui email: ${e.toString()}';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ── CHANGE PASSWORD ──────────────────────────────────────
  Future<bool> changePassword({
    required UserModel currentUser,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    errorMessage = null;
    successMessage = null;

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      errorMessage = 'Semua kolom wajib diisi';
      notifyListeners();
      return false;
    }
    if (oldPassword != currentUser.password) {
      errorMessage = 'Password lama tidak sesuai';
      notifyListeners();
      return false;
    }
    if (newPassword.length < 6) {
      errorMessage = 'Password baru minimal 6 karakter';
      notifyListeners();
      return false;
    }
    if (newPassword != confirmPassword) {
      errorMessage = 'Konfirmasi password tidak cocok';
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      final updatedMap = currentUser.toMap()
        ..['password'] = newPassword;
      await DbHelper.updateUser(updatedMap);
      successMessage = 'Password berhasil diubah';
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Gagal mengubah password: ${e.toString()}';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }
}