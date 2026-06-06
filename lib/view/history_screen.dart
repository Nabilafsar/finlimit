import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/history_viewmodel.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? _lastUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      // Dengarkan perubahan AuthViewModel (dipanggil tiap refreshUser)
      context.read<AuthViewModel>().addListener(_onAuthChanged);
    });
  }

  @override
  void dispose() {
    // Hapus listener saat widget di-dispose
    context.read<AuthViewModel>().removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    // Setiap kali AuthViewModel notify (termasuk setelah add transaksi),
    // reload history
    _loadData();
  }

  void _loadData() {
    final userId = context.read<AuthViewModel>().currentUser?.id ?? '';
    if (userId.isEmpty) return;
    context.read<HistoryViewModel>().loadTransactions(userId);
  }

  @override
  Widget build(BuildContext context) {
    return const _HistoryContent();
  }
}

  @override
  Widget build(BuildContext context) {
    return const _HistoryContent();
  }


class _HistoryContent extends StatefulWidget {
  const _HistoryContent();

  // ── Filter chip categories — urutan sesuai UI ──────────
  static const List<_FilterItem> _filters = [
    _FilterItem(label: 'All', category: null),
    _FilterItem(label: 'Food', category: TransactionCategory.food),
    _FilterItem(label: 'Drink', category: TransactionCategory.drink),
    _FilterItem(
        label: 'Transportation',
        category: TransactionCategory.transportation),
    _FilterItem(label: 'Health', category: TransactionCategory.health),
    _FilterItem(label: 'Bill', category: TransactionCategory.bill),
    _FilterItem(label: 'Invest', category: TransactionCategory.invest),
    _FilterItem(label: 'Ticket', category: TransactionCategory.ticket),
    _FilterItem(label: 'Income', category: TransactionCategory.incomes),
    _FilterItem(label: 'Other', category: TransactionCategory.other),
  ];

  @override
  State<_HistoryContent> createState() => _HistoryContentState();
}

class _HistoryContentState extends State<_HistoryContent> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HistoryViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Center(
                child: Text(
                  'My Transactions',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Filter Chips ─────────────────────────────────
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _HistoryContent._filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final item = _HistoryContent._filters[index];
                  final isSelected =
                      vm.selectedCategory == item.category;
                  return GestureDetector(
                    onTap: () =>
                        vm.selectCategory(item.category),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1976D2)
                            : const Color(0xFFE8EEF9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // ── List Transaksi ───────────────────────────────
            Expanded(
              child: vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : vm.filteredTransactions.isEmpty
                      ? _buildEmpty()
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          itemCount: vm.filteredTransactions.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            return _TransactionTile(
                              transaction:
                                  vm.filteredTransactions[index],
                              vm: vm,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 64, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'Belum ada transaksi',
            style: TextStyle(
                fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

// ── Tile item transaksi ──────────────────────────────────────
class _TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final HistoryViewModel vm;

  const _TransactionTile(
      {required this.transaction, required this.vm});

  // ── Icon — SAMA PERSIS dengan dashboard_screen.dart ─────
  IconData _iconForCategory(TransactionCategory cat) {
    switch (cat) {
      case TransactionCategory.incomes:
        return Icons.attach_money_rounded;
      case TransactionCategory.food:
        return Icons.restaurant_rounded;
      case TransactionCategory.transportation:
        return Icons.directions_bus_rounded;
      case TransactionCategory.drink:
        return Icons.local_cafe_rounded;
      case TransactionCategory.health:
        return Icons.local_hospital_rounded;
      case TransactionCategory.bill:
        return Icons.vpn_key_rounded;
      case TransactionCategory.invest:
        return Icons.monetization_on_rounded;
      case TransactionCategory.ticket:
        return Icons.confirmation_num_rounded;
      case TransactionCategory.other:
        return Icons.category_rounded;
    }
  }

  // ── Warna — SAMA PERSIS dengan dashboard_screen.dart ────
  Color _colorForCategory(TransactionCategory cat) {
    switch (cat) {
      case TransactionCategory.incomes:
        return const Color(0xFF7C3AED);
      case TransactionCategory.food:
        return const Color(0xFF2563EB);
      case TransactionCategory.transportation:
        return const Color(0xFFDC2626);
      case TransactionCategory.drink:
        return const Color(0xFF16A34A);
      case TransactionCategory.health:
        return const Color(0xFF0891B2);
      case TransactionCategory.bill:
        return const Color(0xFFF59E0B);
      case TransactionCategory.invest:
        return const Color(0xFF10B981);
      case TransactionCategory.ticket:
        return const Color(0xFFEC4899);
      case TransactionCategory.other:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.isExpense;
    final color = _colorForCategory(transaction.category);
    final icon = _iconForCategory(transaction.category);
    final amountText =
        '${isExpense ? '-' : '+'}${vm.formatRupiah(transaction.amount.abs())}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon lingkaran
          CircleAvatar(
            radius: 26,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          // Title & tanggal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vm.formatDate(transaction.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          // Nominal & subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amountText,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isExpense
                      ? Colors.black87
                      : const Color(0xFF16A34A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                transaction.subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Helper data class filter chip ───────────────────────────
class _FilterItem {
  final String label;
  final TransactionCategory? category;
  const _FilterItem({required this.label, required this.category});
}