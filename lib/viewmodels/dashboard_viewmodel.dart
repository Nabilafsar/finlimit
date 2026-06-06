import 'package:flutter/material.dart';
import '../data/db/db_helper.dart';
import '../models/transaction_model.dart';

class DashboardViewModel extends ChangeNotifier {
  bool isLoading = false;
  double balance = 0;
  double dailyLimit = 0;
  List<TransactionModel> recentTransactions = [];

  // Total pengeluaran hari ini
  double get todaySpending {
    final today = DateTime.now();
    return recentTransactions
        .where((t) =>
            t.isExpense &&
            t.date.year == today.year &&
            t.date.month == today.month &&
            t.date.day == today.day)
        .fold(0.0, (sum, t) => sum + t.amount.abs());
  }

  double get yesterdaySpending {
  final yesterday = DateTime.now().subtract(const Duration(days: 1));
  return recentTransactions
      .where((t) =>
          t.isExpense &&
          t.date.year == yesterday.year &&
          t.date.month == yesterday.month &&
          t.date.day == yesterday.day)
      .fold(0.0, (sum, t) => sum + t.amount.abs());
}

// Selisih pengeluaran hari ini vs kemarin
double get spendingDiff => todaySpending - yesterdaySpending;

  // Persentase 0.0 - 1.5 untuk LinearProgressIndicator
  double get limitPercent {
    if (dailyLimit <= 0) return 0;
    return (todaySpending / dailyLimit).clamp(0.0, 1.5);
  }

  // Teks persen untuk ditampilkan, misal "78%" atau "150%"
  String get limitPercentDisplay {
    if (dailyLimit <= 0) return '0%';
    final pct = (todaySpending / dailyLimit * 100).clamp(0.0, 150.0);
    return '${pct.toStringAsFixed(0)}%';
  }

  // Warna progress bar
  Color get limitColor {
    if (limitPercent >= 1.0) return Colors.red;
    if (limitPercent >= 0.75) return Colors.orange;
    return const Color(0xFF2E5BFF);
  }

  // Teks motivasi dinamis
  String get motivationText {
    if (dailyLimit <= 0) {
      return 'Yuk set limit harian kamu agar pengeluaran lebih terkontrol!';
    }
    if (limitPercent >= 1.0) {
      return 'Limit harian kamu sudah terlampaui. Yuk kendalikan pengeluaran besok ya!';
    }
    if (limitPercent >= 0.75) {
      return 'Hampir mencapai limit! Sisa ${formatRupiah(dailyLimit - todaySpending)} lagi hari ini.';
    }
    if (todaySpending == 0) {
      return 'Belum ada pengeluaran hari ini. Tetap bijak dalam berbelanja!';
    }
    return 'Kerja bagus! Kamu masih dalam batas limit harian. Terus pertahankan!';
  }

  // Load data dashboard dari DB
  Future<void> loadDashboard(
    String userId, {
    double userBalance = 0,
    double userDailyLimit = 0,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      balance = userBalance;
      dailyLimit = userDailyLimit;

      final rawList = await DbHelper.getTransactionsByUser(userId);
      recentTransactions = rawList
          .map((e) => TransactionModel.fromMap(e))
          .toList();
    } catch (e) {
      debugPrint('DashboardViewModel error: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // Tambah transaksi baru
  Future<void> addTransaction(TransactionModel tx) async {
    await DbHelper.insertTransaction(tx.toMap());

    if (tx.isExpense) {
      balance -= tx.amount.abs();
    } else {
      balance += tx.amount.abs();
    }

    recentTransactions.insert(0, tx);
    notifyListeners();
  }

  String _formatRupiah(double amount) {
    final str = amount.abs().toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  String formatRupiah(double amount) => 'Rp.${_formatRupiah(amount)}';
}

