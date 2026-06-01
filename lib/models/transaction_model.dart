enum TransactionCategory { incomes, food, drink, transportation }

class TransactionModel {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final TransactionCategory category;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.category,
    required this.date,
  });

  bool get isExpense => category != TransactionCategory.incomes;
}