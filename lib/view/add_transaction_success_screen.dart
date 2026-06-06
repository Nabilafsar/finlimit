import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

class AddTransactionSuccessScreen extends StatelessWidget {
  final TransactionModel transaction;

  const AddTransactionSuccessScreen({super.key, required this.transaction});

  String _formatRupiah(double amount) {
    final abs = amount.abs().toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < abs.length; i++) {
      if (i > 0 && (abs.length - i) % 3 == 0) buffer.write('.');
      buffer.write(abs[i]);
    }
    return buffer.toString();
  }

  Color _categoryColor(TransactionCategory cat) {
    switch (cat) {
      case TransactionCategory.drink:          return const Color(0xFF4CAF50);
      case TransactionCategory.food:           return const Color(0xFF3949AB);
      case TransactionCategory.transportation: return const Color(0xFFE91E8C);
      case TransactionCategory.health:         return const Color(0xFF1A3A6B);
      case TransactionCategory.bill:           return const Color(0xFF90CAF9);
      case TransactionCategory.invest:         return const Color(0xFF90CAF9);
      case TransactionCategory.ticket:         return const Color(0xFF90CAF9);
      case TransactionCategory.incomes:        return const Color(0xFF43A047);
      case TransactionCategory.other:          return const Color(0xFF90CAF9);
    }
  }

  IconData _categoryIcon(TransactionCategory cat) {
    switch (cat) {
      case TransactionCategory.drink:          return Icons.local_drink;
      case TransactionCategory.food:           return Icons.restaurant;
      case TransactionCategory.transportation: return Icons.directions_bus;
      case TransactionCategory.health:         return Icons.local_hospital;
      case TransactionCategory.bill:           return Icons.vpn_key;
      case TransactionCategory.invest:         return Icons.monetization_on;
      case TransactionCategory.ticket:         return Icons.confirmation_num;
      case TransactionCategory.incomes:        return Icons.arrow_downward;
      case TransactionCategory.other:          return Icons.add;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.isExpense;
    final amountText = isExpense
        ? '-Rp.${_formatRupiah(transaction.amount)}'
        : '+Rp.${_formatRupiah(transaction.amount)}';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Add Manually Transaction\nSucces',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Category icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _categoryColor(transaction.category),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _categoryIcon(transaction.category),
                color: Colors.white,
                size: 38,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              transaction.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Detail cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _detailCard([
                    _detailRow('Status', 'Completed', isStatus: true),
                    _detailRow('Category', transaction.category.name[0].toUpperCase() + transaction.category.name.substring(1)),
                    _detailRow('Add Note', transaction.subtitle),
                  ]),
                  const SizedBox(height: 12),
                  _detailCard([
                    _detailRow('Payment', transaction.paymentMethod),
                    _detailRow('Amount', amountText, isAmount: true, isExpense: isExpense),
                  ]),
                  const SizedBox(height: 12),
                  _detailCard([
                    _detailRow('Date', DateFormat('dd MMM, yyyy').format(transaction.date)),
                    _detailRow('Manual', ''),
                  ]),
                ],
              ),
            ),

            const Spacer(),

            // Close button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // Kembali ke main screen
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailCard(List<Widget> rows) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: rows,
      ),
    );
  }

  Widget _detailRow(String label, String value,
      {bool isStatus = false, bool isAmount = false, bool isExpense = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 14)),
          if (isStatus)
            Row(
              children: const [
                Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 18),
                SizedBox(width: 4),
                Text('Completed',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            )
          else
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isAmount
                    ? (isExpense ? Colors.black87 : Colors.green)
                    : Colors.black87,
              ),
            ),
        ],
      ),
    );
  }
}