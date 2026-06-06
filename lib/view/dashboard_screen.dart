import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import 'add_transaction_screen.dart';
import 'topup_screen.dart';
import 'set_limit_screen.dart';

// ── DashboardScreen: StatefulWidget supaya bisa reload saat pop dari add tx ──
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardViewModel _vm;

  @override
  void initState() {
    super.initState();
    final authVM = context.read<AuthViewModel>();
    _vm = DashboardViewModel()
      ..loadDashboard(
        authVM.currentUser?.id ?? '',
        userBalance: authVM.currentUser?.balance ?? 0,
        userDailyLimit: authVM.currentUser?.dailyLimit ?? 0,
      );
  }

  // Reload dari DB setiap kali layar ini muncul kembali (setelah pop)
  Future<void> _goToAddTransaction() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
    );
    // Saat user kembali ke sini, reload data terbaru dari DB
    if (!mounted) return;
    final authVM = context.read<AuthViewModel>();
    await authVM.refreshUser(authVM.currentUser?.id ?? '');
    if (!mounted) return;
    await _vm.loadDashboard(
      authVM.currentUser?.id ?? '',
      userBalance: authVM.currentUser?.balance ?? 0,
      userDailyLimit: authVM.currentUser?.dailyLimit ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _vm,
      child: _DashboardContent(onAddTransaction: _goToAddTransaction),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final VoidCallback onAddTransaction;
  const _DashboardContent({required this.onAddTransaction});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final userName = authVM.currentUser?.fullname ?? 'User';

    if (vm.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF4F6F8),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // ── HEADER ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hello,',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, size: 28),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── BALANCE CARD ──────────────────────────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E5BFF),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Balance',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        vm.formatRupiah(vm.balance),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ActionButton(
                          icon: Icons.add,
                          label: 'Top Up',
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TopUpScreen(),
                              ),
                            );
                            // Refresh dashboard setelah top up
                            if (!context.mounted) return;
                            final authVM = context.read<AuthViewModel>();
                            await authVM.refreshUser(
                              authVM.currentUser?.id ?? '',
                            );
                            if (!context.mounted) return;
                            final dashVM = context.read<DashboardViewModel>();
                            await dashVM.loadDashboard(
                              authVM.currentUser?.id ?? '',
                              userBalance: authVM.currentUser?.balance ?? 0,
                              userDailyLimit:
                                  authVM.currentUser?.dailyLimit ?? 0,
                            );
                          },
                        ),
                        _ActionButton(
                          icon: Icons.track_changes,
                          label: 'Limit',
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SetLimitScreen(),
                              ),
                            );
                            // Refresh dashboard setelah set limit
                            if (!context.mounted) return;
                            final authVM = context.read<AuthViewModel>();
                            await authVM.refreshUser(
                              authVM.currentUser?.id ?? '',
                            );
                            if (!context.mounted) return;
                            final dashVM = context.read<DashboardViewModel>();
                            await dashVM.loadDashboard(
                              authVM.currentUser?.id ?? '',
                              userBalance: authVM.currentUser?.balance ?? 0,
                              userDailyLimit:
                                  authVM.currentUser?.dailyLimit ?? 0,
                            );
                          },
                        ),
                        _ActionButton(
                          icon: Icons.receipt_long,
                          label: 'Add Transaction',
                          onTap: onAddTransaction,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── YOUR LIMIT ────────────────────────────────────
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your Limit',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          vm.limitPercentDisplay,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: vm.limitColor,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${vm.formatRupiah(vm.todaySpending)} / ${vm.formatRupiah(vm.dailyLimit)}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: vm.limitPercent > 1.0 ? 1.0 : vm.limitPercent,
                        minHeight: 18,
                        backgroundColor: const Color(0xFFE8E8E8),
                        color: vm.limitColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── MOTIVATION ────────────────────────────────────
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Motivation',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 120),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Text(
                          vm.motivationText,
                          style: const TextStyle(fontSize: 15, height: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E5BFF),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.smart_toy,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── HISTORY ───────────────────────────────────────
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'History',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              vm.recentTransactions.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Text(
                        'Belum ada transaksi.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : Column(
                      children: vm.recentTransactions
                          .take(10)
                          .map((t) => _HistoryItem(transaction: t, vm: vm))
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Color(0xFF2E5BFF)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final TransactionModel transaction;
  final DashboardViewModel vm;

  const _HistoryItem({required this.transaction, required this.vm});

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
String _formatDate(DateTime date) {
    final now = DateTime.now();
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;

    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final time = '$hour:$minute $period';

    if (isToday) return 'Today $time';

    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month]} ${date.day}, $time';
  }
  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.isExpense;
    final color = _colorForCategory(transaction.category);
    final icon = _iconForCategory(transaction.category);
    final amountText =
        '${isExpense ? '-' : '+'}${vm.formatRupiah(transaction.amount.abs())}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  transaction.subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(transaction.date),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amountText,
            style: TextStyle(
              color: isExpense ? Colors.red : const Color(0xFF16A34A),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
