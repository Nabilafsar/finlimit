import 'package:flutter/material.dart';
import '../data/db/db_helper.dart';
import '../models/transaction_model.dart';

enum PeriodFilter { month, year }

class StatisticViewModel extends ChangeNotifier {
  PeriodFilter _selectedPeriod = PeriodFilter.month;
  TransactionCategory? _selectedCategory;
  int _touchedDonutIndex = -1;
  int _touchedLineIndex = -1;
  double _touchedLineX = 0;

  bool isLoading = false;

  List<TransactionModel> _allTransactions = [];
  double _savedBalance = 0;

  PeriodFilter get selectedPeriod => _selectedPeriod;
  TransactionCategory? get selectedCategory => _selectedCategory;
  int get touchedDonutIndex => _touchedDonutIndex;
  int get touchedLineIndex => _touchedLineIndex;
  double get touchedLineX => _touchedLineX;

  double get savedBalance => _savedBalance;

  double get totalSpendPercent {
    if (_allTransactions.isEmpty) return 0;
    final totalExpense = _allTransactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount.abs());
    final totalIncome = _allTransactions
        .where((t) => !t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount.abs());
    if (totalIncome <= 0) return 0;
    return ((totalExpense / totalIncome) * 100).clamp(0.0, 100.0);
  }

  Map<TransactionCategory, double> get categorySpend {
    final result = <TransactionCategory, double>{};
    final totalExpense = _allTransactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount.abs());

    for (final cat in TransactionCategory.values) {
      if (cat == TransactionCategory.incomes) continue;
      final catTotal = _allTransactions
          .where((t) => t.category == cat)
          .fold(0.0, (sum, t) => sum + t.amount.abs());
      result[cat] = totalExpense > 0 ? (catTotal / totalExpense) * 100 : 0;
    }

    final totalIncome = _allTransactions
        .where((t) => !t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount.abs());
    final grandTotal = totalExpense + totalIncome;
    result[TransactionCategory.incomes] =
        grandTotal > 0 ? (totalIncome / grandTotal) * 100 : 0;

    return result;
  }

  List<double> get monthlyBalance {
    final now = DateTime.now();
    return List.generate(12, (i) {
      final month = DateTime(now.year, now.month - 11 + i);
      final income = _allTransactions
          .where((t) =>
              !t.isExpense &&
              t.date.year == month.year &&
              t.date.month == month.month)
          .fold(0.0, (sum, t) => sum + t.amount.abs());
      final expense = _allTransactions
          .where((t) =>
              t.isExpense &&
              t.date.year == month.year &&
              t.date.month == month.month)
          .fold(0.0, (sum, t) => sum + t.amount.abs());
      final net = (income - expense) / 1000000;
      return net < 0 ? 0 : net;
    });
  }

  List<String> get monthLabels {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final now = DateTime.now();
    return List.generate(12, (i) => names[(now.month - 12 + i + 12) % 12]);
  }

  List<double> get yearlyBalance {
    final now = DateTime.now();
    return List.generate(6, (i) {
      final year = now.year - 5 + i;
      final income = _allTransactions
          .where((t) => !t.isExpense && t.date.year == year)
          .fold(0.0, (sum, t) => sum + t.amount.abs());
      final expense = _allTransactions
          .where((t) => t.isExpense && t.date.year == year)
          .fold(0.0, (sum, t) => sum + t.amount.abs());
      final net = (income - expense) / 1000000;
      return net < 0 ? 0 : net;
    });
  }

  List<String> get yearLabels {
    final now = DateTime.now();
    return List.generate(6, (i) => '${now.year - 5 + i}');
  }

  List<double> get chartData =>
      _selectedPeriod == PeriodFilter.month ? monthlyBalance : yearlyBalance;

  List<String> get chartLabels =>
      _selectedPeriod == PeriodFilter.month ? monthLabels : yearLabels;

  List<TransactionModel> get filteredTransactions {
    if (_selectedCategory == null) return _allTransactions;
    return _allTransactions
        .where((t) => t.category == _selectedCategory)
        .toList();
  }

  Future<void> loadStatistic(String userId, {double userBalance = 0}) async {
    isLoading = true;
    notifyListeners();

    try {
      _savedBalance = userBalance;
      final rawList = await DbHelper.getTransactionsByUser(userId);
      _allTransactions = rawList.map((e) => TransactionModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('StatisticViewModel error: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Color categoryColor(TransactionCategory cat) {
    switch (cat) {
      case TransactionCategory.incomes:        return const Color(0xFF7C3AED);
      case TransactionCategory.food:           return const Color(0xFF2563EB);
      case TransactionCategory.transportation: return const Color(0xFFDC2626);
      case TransactionCategory.drink:          return const Color(0xFF16A34A);
      case TransactionCategory.health:         return const Color(0xFF0891B2);
      case TransactionCategory.bill:           return const Color(0xFFF59E0B);
      case TransactionCategory.invest:         return const Color(0xFF10B981);
      case TransactionCategory.ticket:         return const Color(0xFFEC4899);
      case TransactionCategory.other:          return const Color(0xFF6B7280);
    }
  }

  String categoryLabel(TransactionCategory cat) {
    switch (cat) {
      case TransactionCategory.incomes:        return 'Incomes';
      case TransactionCategory.food:           return 'Food';
      case TransactionCategory.transportation: return 'Transportation';
      case TransactionCategory.drink:          return 'Drink';
      case TransactionCategory.health:         return 'Health';
      case TransactionCategory.bill:           return 'Bill';
      case TransactionCategory.invest:         return 'Invest';
      case TransactionCategory.ticket:         return 'Ticket';
      case TransactionCategory.other:          return 'Other';
    }
  }

  IconData categoryIcon(TransactionCategory cat) {
    switch (cat) {
      case TransactionCategory.incomes:        return Icons.attach_money_rounded;
      case TransactionCategory.food:           return Icons.restaurant_rounded;
      case TransactionCategory.transportation: return Icons.directions_bus_rounded;
      case TransactionCategory.drink:          return Icons.local_cafe_rounded;
      case TransactionCategory.health:         return Icons.local_hospital_rounded;
      case TransactionCategory.bill:           return Icons.vpn_key_rounded;
      case TransactionCategory.invest:         return Icons.monetization_on_rounded;
      case TransactionCategory.ticket:         return Icons.confirmation_num_rounded;
      case TransactionCategory.other:          return Icons.category_rounded;
    }
  }

  void setPeriodFilter(PeriodFilter period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  void setCategoryFilter(TransactionCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setTouchedDonutIndex(int index) {
    _touchedDonutIndex = index;
    notifyListeners();
  }

  void setTouchedLine(int index, double x) {
    _touchedLineIndex = index;
    _touchedLineX = x;
    notifyListeners();
  }

  String formatRupiah(double amount) {
    final abs = amount.abs();
    if (abs >= 1000000) {
      return 'Rp${(abs / 1000000).toStringAsFixed(0)}.000.000';
    }
    final str = abs.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return 'Rp${buffer.toString()}';
  }

  String formatChartValue(double val) {
    if (val >= 10) return '${val.toInt()}Jt';
    return val.toStringAsFixed(1);
  }
}