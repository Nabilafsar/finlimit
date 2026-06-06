import 'package:flutter/material.dart';
import '../data/db/db_helper.dart';
import '../models/transaction_model.dart';

class HistoryViewModel extends ChangeNotifier {
  bool isLoading = false;
  List<TransactionModel> _allTransactions = [];
  TransactionCategory? _selectedCategory; // null = All

  TransactionCategory? get selectedCategory => _selectedCategory;

  List<TransactionModel> get filteredTransactions {
    if (_selectedCategory == null) return _allTransactions;
    return _allTransactions
        .where((t) => t.category == _selectedCategory)
        .toList();
  }

  Future<void> loadTransactions(String userId) async {
    isLoading = true;
    notifyListeners();

    try {
      final raw = await DbHelper.getTransactionsByUser(userId);
      _allTransactions = raw.map((e) => TransactionModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('HistoryViewModel error: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  void selectCategory(TransactionCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Format rupiah — konsisten dengan DashboardViewModel
  String formatRupiah(double amount) {
    final str = amount.abs().toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return 'Rp.$buffer';
  }

  // Format tanggal — "Today 8:20 PM" atau "Jan 15, 4:10 PM"
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;

    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final time = '$hour:$minute $period';

    if (isToday) return 'Today $time';

    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month]} ${date.day}, $time';
  }
}