class TransactionModel {
  final int? id;
  final String title;
  final String category;
  final double amount;
  final String type; // 'income' or 'expense'
  final String date;
  final String? note;

  TransactionModel({
    this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.type,
    required this.date,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'type': type,
      'date': date,
      'note': note ?? '',
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      amount: map['amount'],
      type: map['type'],
      date: map['date'],
      note: map['note'],
    );
  }
}
