import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/db/db_helper.dart';
import '../models/transaction_model.dart';

class TransactionViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  // State form
  double amount = 0;
  TransactionCategory? selectedCategory;
  DateTime selectedDate = DateTime.now();
  String note = '';
  String paymentMethod = 'QRIS';

  // Pilihan payment method
  final List<String> paymentMethods = ['QRIS', 'Cash', 'Transfer', 'Debit', 'Credit'];

  void setAmount(double value) {
    amount = value;
    notifyListeners();
  }

  void setCategory(TransactionCategory category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setNote(String value) {
    note = value;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    paymentMethod = method;
    notifyListeners();
  }

  void reset() {
    amount = 0;
    selectedCategory = null;
    selectedDate = DateTime.now();
    note = '';
    paymentMethod = 'QRIS';
    errorMessage = null;
    notifyListeners();
  }

  bool get isValid =>
      amount > 0 && selectedCategory != null;

  /// Simpan transaksi ke DB, kurangi balance, return model yang disimpan
  Future<TransactionModel?> saveTransaction({
    required String userId,
    required String userFullname,
  }) async {
    if (!isValid) {
      errorMessage = 'Masukkan jumlah dan pilih kategori terlebih dahulu';
      notifyListeners();
      return null;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final id = const Uuid().v4();
      final isExpense = selectedCategory != TransactionCategory.incomes;

      final tx = TransactionModel(
        id: id,
        userId: userId,
        title: _categoryTitle(selectedCategory!),
        subtitle: note.isNotEmpty ? note : _categoryTitle(selectedCategory!),
        amount: isExpense ? -amount : amount,
        category: selectedCategory!,
        paymentMethod: paymentMethod,
        date: selectedDate,
      );

      await DbHelper.insertTransaction(tx.toMap());

      // Update balance di DB
      final userMap = await DbHelper.getUserById(userId);
      if (userMap != null) {
        final currentBalance = (userMap['balance'] as num?)?.toDouble() ?? 0.0;
        final newBalance = isExpense
            ? currentBalance - amount
            : currentBalance + amount;
        await DbHelper.updateBalance(userId, newBalance);
      }

      isLoading = false;
      notifyListeners();
      return tx;
    } catch (e) {
      errorMessage = 'Gagal menyimpan transaksi: $e';
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  String _categoryTitle(TransactionCategory cat) {
    switch (cat) {
      case TransactionCategory.food:        return 'Food';
      case TransactionCategory.drink:       return 'Drink';
      case TransactionCategory.transportation: return 'Transportation';
      case TransactionCategory.health:      return 'Health';
      case TransactionCategory.bill:        return 'Bill';
      case TransactionCategory.invest:      return 'Invest';
      case TransactionCategory.ticket:      return 'Ticket';
      case TransactionCategory.incomes:     return 'Income';
      case TransactionCategory.other:       return 'Other';
    }
  }
}