enum TransactionCategory {
  incomes,
  food,
  drink,
  transportation,
  health,
  bill,
  invest,
  ticket,
  other,
}

class TransactionModel {
  final String id;
  final String userId;
  final String title;
  final String subtitle;
  final double amount;
  final TransactionCategory category;
  final String paymentMethod;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.category,
    this.paymentMethod = '',
    required this.date,
  });

  bool get isExpense => category != TransactionCategory.incomes;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'subtitle': subtitle,
      'amount': amount,
      'category': category.name,
      'payment_method': paymentMethod,
      'date': date.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      userId: map['user_id'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      category: TransactionCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => TransactionCategory.other,
      ),
      paymentMethod: map['payment_method'] ?? '',
      date: DateTime.parse(map['date']),
    );
  }
}