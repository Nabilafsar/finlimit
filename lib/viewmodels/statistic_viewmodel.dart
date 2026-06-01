import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

enum PeriodFilter { month, year }

class StatisticViewModel extends ChangeNotifier {
  PeriodFilter _selectedPeriod = PeriodFilter.month;
  TransactionCategory? _selectedCategory;
  int _touchedDonutIndex = -1;
  int _touchedLineIndex = -1;
  double _touchedLineX = 0;

  PeriodFilter get selectedPeriod => _selectedPeriod;
  TransactionCategory? get selectedCategory => _selectedCategory;
  int get touchedDonutIndex => _touchedDonutIndex;
  int get touchedLineIndex => _touchedLineIndex;
  double get touchedLineX => _touchedLineX;

  final List<double> monthlyBalance = [20, 45, 100, 60, 85, 30, 55, 90, 40, 70, 50, 35];
  final List<String> monthLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final List<double> yearlyBalance = [300, 450, 600, 500, 700, 550];
  final List<String> yearLabels = ['2019', '2020', '2021', '2022', '2023', '2024'];

  List<double> get chartData => _selectedPeriod == PeriodFilter.month ? monthlyBalance : yearlyBalance;
  List<String> get chartLabels => _selectedPeriod == PeriodFilter.month ? monthLabels : yearLabels;

  double get savedBalance => 10000000;
  double get totalSpendPercent => 78;

  final Map<TransactionCategory, double> categorySpend = {
    TransactionCategory.incomes: 35,
    TransactionCategory.food: 28,
    TransactionCategory.transportation: 15,
    TransactionCategory.drink: 22,
  };

  Color categoryColor(TransactionCategory cat) {
    switch (cat) {
      case TransactionCategory.incomes:      return const Color(0xFF7C3AED);
      case TransactionCategory.food:         return const Color(0xFF2563EB);
      case TransactionCategory.transportation: return const Color(0xFFDC2626);
      case TransactionCategory.drink:        return const Color(0xFF16A34A);
    }
  }

  String categoryLabel(TransactionCategory cat) {
    switch (cat) {
      case TransactionCategory.incomes:        return 'Incomes';
      case TransactionCategory.food:           return 'Food';
      case TransactionCategory.transportation: return 'Transportation';
      case TransactionCategory.drink:          return 'Drink';
    }
  }

  IconData categoryIcon(TransactionCategory cat) {
    switch (cat) {
      case TransactionCategory.incomes:        return Icons.attach_money_rounded;
      case TransactionCategory.food:           return Icons.restaurant_rounded;
      case TransactionCategory.transportation: return Icons.directions_bus_rounded;
      case TransactionCategory.drink:          return Icons.local_cafe_rounded;
    }
  }

  final List<TransactionModel> _allTransactions = [
    TransactionModel(
      id: '1', title: 'Payment', subtitle: 'Today 8:20 PM',
      amount: -12000, category: TransactionCategory.food,
      date: DateTime.now(),
    ),
    TransactionModel(
      id: '2', title: 'Payment', subtitle: 'Jan 15, 4:10 PM',
      amount: -15000, category: TransactionCategory.transportation,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    TransactionModel(
      id: '3', title: 'Income Salary', subtitle: 'Jan 14, 9:00 AM',
      amount: 5000000, category: TransactionCategory.incomes,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    TransactionModel(
      id: '4', title: 'Buy Coffee', subtitle: 'Jan 13, 7:30 AM',
      amount: -35000, category: TransactionCategory.drink,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    TransactionModel(
      id: '5', title: 'Lunch', subtitle: 'Jan 12, 12:00 PM',
      amount: -45000, category: TransactionCategory.food,
      date: DateTime.now().subtract(const Duration(days: 4)),
    ),
    TransactionModel(
      id: '6', title: 'Bus Ticket', subtitle: 'Jan 11, 8:00 AM',
      amount: -8000, category: TransactionCategory.transportation,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  List<TransactionModel> get filteredTransactions {
    if (_selectedCategory == null) return _allTransactions;
    return _allTransactions.where((t) => t.category == _selectedCategory).toList();
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
    return '${val.toInt()}';
  }
}