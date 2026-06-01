import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class SettingsViewModel extends ChangeNotifier {
  // User Profile
  String _userName = 'Pengguna';
  String _userEmail = '';
  String _userPhone = '';

  // Wallet
  String _walletName = 'Dompet Utama';
  double _dailyLimit = 100000;
  double _monthlyLimit = 3000000;

  // Theme
  bool _isDarkMode = false;
  String _currency = 'IDR';
  bool _notificationEnabled = true;

  bool _isLoading = false;

  // Getters
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String get walletName => _walletName;
  double get dailyLimit => _dailyLimit;
  double get monthlyLimit => _monthlyLimit;
  bool get isDarkMode => _isDarkMode;
  String get currency => _currency;
  bool get notificationEnabled => _notificationEnabled;
  bool get isLoading => _isLoading;

  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();

    final settings = await DatabaseHelper.instance.getAllSettings();

    _userName = settings['user_name'] ?? 'Pengguna';
    _userEmail = settings['user_email'] ?? '';
    _userPhone = settings['user_phone'] ?? '';
    _walletName = settings['wallet_name'] ?? 'Dompet Utama';
    _dailyLimit = double.tryParse(settings['daily_limit'] ?? '100000') ?? 100000;
    _monthlyLimit =
        double.tryParse(settings['monthly_limit'] ?? '3000000') ?? 3000000;
    _isDarkMode = (settings['dark_mode'] ?? 'false') == 'true';
    _currency = settings['currency'] ?? 'IDR';
    _notificationEnabled =
        (settings['notification'] ?? 'true') == 'true';

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    await DatabaseHelper.instance.saveSetting('user_name', name);
    await DatabaseHelper.instance.saveSetting('user_email', email);
    await DatabaseHelper.instance.saveSetting('user_phone', phone);

    _userName = name;
    _userEmail = email;
    _userPhone = phone;
    notifyListeners();
  }

  Future<void> updateWallet({
    required String name,
    required double dailyLimit,
    required double monthlyLimit,
  }) async {
    await DatabaseHelper.instance.saveSetting('wallet_name', name);
    await DatabaseHelper.instance.saveSetting('daily_limit', dailyLimit.toString());
    await DatabaseHelper.instance.saveSetting('monthly_limit', monthlyLimit.toString());

    _walletName = name;
    _dailyLimit = dailyLimit;
    _monthlyLimit = monthlyLimit;
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    await DatabaseHelper.instance.saveSetting('dark_mode', value.toString());
    _isDarkMode = value;
    notifyListeners();
  }

  Future<void> toggleNotification(bool value) async {
    await DatabaseHelper.instance.saveSetting('notification', value.toString());
    _notificationEnabled = value;
    notifyListeners();
  }

  Future<void> setCurrency(String value) async {
    await DatabaseHelper.instance.saveSetting('currency', value);
    _currency = value;
    notifyListeners();
  }
}
