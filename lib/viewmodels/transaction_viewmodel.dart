import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../database/database_helper.dart';

class TransactionViewModel extends ChangeNotifier {
  List<TransactionModel> _transactions = [];
  String _filterType = 'all'; // 'all', 'income', 'expense'
  String _filterMonth = ''; // format: 'yyyy-MM'
  bool _isLoading = false;

  List<TransactionModel> get transactions => _transactions;
  String get filterType => _filterType;
  String get filterMonth => _filterMonth;
  bool get isLoading => _isLoading;

  double get totalExpense => _transactions
      .where((t) => t.type == 'expense')
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalIncome => _transactions
      .where((t) => t.type == 'income')
      .fold(0.0, (sum, t) => sum + t.amount);

  // Kelompokkan transaksi berdasarkan tanggal
  Map<String, List<TransactionModel>> get groupedTransactions {
    final Map<String, List<TransactionModel>> grouped = {};
    for (final tx in _transactions) {
      final dateKey = tx.date.substring(0, 10); // ambil yyyy-MM-dd
      grouped.putIfAbsent(dateKey, () => []).add(tx);
    }
    return grouped;
  }

  Future<void> loadTransactions() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_filterMonth.isNotEmpty) {
        _transactions =
            await DatabaseHelper.instance.getTransactionsByMonth(_filterMonth);
        if (_filterType != 'all') {
          _transactions =
              _transactions.where((t) => t.type == _filterType).toList();
        }
      } else if (_filterType == 'all') {
        _transactions = await DatabaseHelper.instance.getAllTransactions();
      } else {
        _transactions =
            await DatabaseHelper.instance.getTransactionsByType(_filterType);
      }
    } catch (e) {
      _transactions = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void setFilterType(String type) {
    _filterType = type;
    loadTransactions();
  }

  void setFilterMonth(String yearMonth) {
    _filterMonth = yearMonth;
    loadTransactions();
  }

  void clearMonthFilter() {
    _filterMonth = '';
    loadTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await DatabaseHelper.instance.deleteTransaction(id);
    await loadTransactions();
  }

  // Untuk dummy/testing data awal
  Future<void> insertDummyData() async {
    final now = DateTime.now();
    final dummies = [
      TransactionModel(
        title: 'Makan Siang',
        category: 'Makanan',
        amount: 25000,
        type: 'expense',
        date: '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        note: 'Nasi padang',
      ),
      TransactionModel(
        title: 'Kopi',
        category: 'Makanan',
        amount: 18000,
        type: 'expense',
        date: '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        note: 'Kopi susu',
      ),
      TransactionModel(
        title: 'Transfer Masuk',
        category: 'Lainnya',
        amount: 500000,
        type: 'income',
        date: '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        note: '',
      ),
    ];

    for (final d in dummies) {
      await DatabaseHelper.instance.insertTransaction(d);
    }
    await loadTransactions();
  }
}
