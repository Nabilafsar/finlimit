import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import '../models/transaction_model.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().addListener(_onAuthChanged);
    });
  }

  @override
  void dispose() {
    context.read<AuthViewModel>().removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    final authVM = context.read<AuthViewModel>();
    _vm.loadDashboard(
      authVM.currentUser?.id ?? '',
      userBalance: authVM.currentUser?.balance ?? 0,
      userDailyLimit: authVM.currentUser?.dailyLimit ?? 0,
    );
  }

  String _fmt(double v) {
    final s = v.toInt().toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return 'Rp.$buf';
  }

  @override
  Widget build(BuildContext context) {
    final userName =
        context.read<AuthViewModel>().currentUser?.fullname ?? 'User';

    return ChangeNotifierProvider.value(
      value: _vm,
      child: Consumer<DashboardViewModel>(
        builder: (context, vm, _) {
          final diff = vm.spendingDiff;
          final isMore = diff > 0;
          final isLess = diff < 0;

          String motivationText;
          if (vm.todaySpending == 0) {
            motivationText =
                'Hey $userName, belum ada pengeluaran hari ini. Tetap bijak dalam berbelanja dan jaga keuanganmu!';
          } else if (vm.limitPercent >= 1.0) {
            motivationText =
                'Hey $userName, pengeluaranmu sudah melampaui limit hari ini - tapi ini saatnya kamu ambil kendali. Mulai belajar, set limit, dan bangun kebiasaan keuangan yang lebih cerdas!';
          } else if (isMore) {
            motivationText =
                'Hey $userName, pengeluaranmu hari ini lebih tinggi dari kemarin. Yuk lebih bijak mengatur pengeluaran!';
          } else if (isLess) {
            motivationText =
                'Hey $userName, bagus! Pengeluaranmu hari ini lebih hemat dari kemarin. Pertahankan terus!';
          } else {
            motivationText =
                'Hey $userName, pengeluaranmu sama dengan kemarin. Coba lebih hemat lagi hari ini!';
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF4F6F8),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    const Text(
                      "Education",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // SPENDING CARD
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Your Spend",
                                  style: TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 8),
                                // Angka dari DB
                                Text(
                                  vm.isLoading ? '-' : _fmt(vm.todaySpending),
                                  style: const TextStyle(
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Perbandingan dengan kemarin
                                if (!vm.isLoading)
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        if (isMore) ...[
                                          TextSpan(
                                            text: '${_fmt(diff.abs())} ',
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: 'More than yesterday',
                                            style: TextStyle(
                                                color: Colors.black87),
                                          ),
                                        ] else if (isLess) ...[
                                          TextSpan(
                                            text: '${_fmt(diff.abs())} ',
                                            style: const TextStyle(
                                              color: Color(0xFF16A34A),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: 'Less than yesterday',
                                            style: TextStyle(
                                                color: Colors.black87),
                                          ),
                                        ] else ...[
                                          const TextSpan(
                                            text: 'Same as yesterday',
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // MINI CHART 7 hari dari data nyata
                          _MiniBarChart(transactions: vm.recentTransactions),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // MOTIVATION BANNER
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E5BFF),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        motivationText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          height: 1.5,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: const [
                          Text(
                            "Recommendation Blog",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    const _BlogCard(
                      image: Icons.trending_up,
                      title: "Mastering Your Personal Finance",
                      description:
                          "Learn how to manage your money wisely and build a secure financial future.",
                    ),

                    const _BlogCard(
                      image: Icons.account_balance_wallet,
                      title: "Smart Budgeting for Beginners",
                      description:
                          "Learn when to save and when to spend wisely.",
                    ),

                    const _BlogCard(
                      image: Icons.savings,
                      title: "Building Healthy Financial Habits",
                      description:
                          "Small habits today can create big financial success tomorrow.",
                    ),

                    const _BlogCard(
                      image: Icons.payments,
                      title: "Saving vs Spending: Finding the Balance",
                      description:
                          "Learn when to save and when to spend wisely.",
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Mini Bar Chart 7 hari terakhir dari data transaksi nyata
class _MiniBarChart extends StatelessWidget {
  final List<TransactionModel> transactions;
  const _MiniBarChart({required this.transactions});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    const maxHeight = 60.0;

    final List<double> dailySpend = List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return transactions
          .where((t) =>
              t.isExpense &&
              t.date.year == day.year &&
              t.date.month == day.month &&
              t.date.day == day.day)
          .fold(0.0, (sum, t) => sum + t.amount.abs());
    });

    final maxVal = dailySpend.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      width: 90,
      height: 90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (i) {
          final isToday = i == 6;
          final barHeight = maxVal > 0
              ? (dailySpend[i] / maxVal * maxHeight).clamp(4.0, maxHeight)
              : 4.0;
          return Container(
            width: 10,
            height: barHeight,
            decoration: BoxDecoration(
              color: isToday
                  ? const Color(0xFF2E5BFF)
                  : Colors.indigo.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
          );
        }),
      ),
    );
  }
}

class _BlogCard extends StatelessWidget {
  final IconData image;
  final String title;
  final String description;

  const _BlogCard({
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 95,
            height: 95,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              image,
              size: 50,
              color: const Color(0xFF2E5BFF),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Text(
                      "2 Days Ago",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const Spacer(),
                    Text(
                      "View All",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(width: 8),
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor: Color(0xFF2E5BFF),
                      child: Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}