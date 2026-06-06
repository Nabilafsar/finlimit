import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/statistic_viewmodel.dart';
import '../widgets/saved_balance_chart.dart';
import '../widgets/donut_chart_widget.dart';
import '../widgets/recent_activity_widget.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  @override
  Widget build(BuildContext context) {
    // Tidak buat provider baru — pakai yang sudah ada di main.dart
    return const _StatisticViewContent();
  }
}

class _StatisticViewContent extends StatefulWidget {
  const _StatisticViewContent();

  @override
  State<_StatisticViewContent> createState() => _StatisticViewContentState();
}

class _StatisticViewContentState extends State<_StatisticViewContent> {
  @override
  void initState() {
    super.initState();
    // Panggil loadStatistic() setelah frame pertama selesai render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authVM = context.read<AuthViewModel>();
      final userId = authVM.currentUser?.id ?? '';
      final balance = authVM.currentUser?.balance ?? 0.0;
      context.read<StatisticViewModel>().loadStatistic(
        userId,
        userBalance: balance,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StatisticViewModel>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        body: SafeArea(
          child: vm.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF1565C0),
                  ),
                )
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: _AppBarSection(),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          const SavedBalanceChart(),
                          const SizedBox(height: 20),
                          const DonutChartWidget(),
                          const SizedBox(height: 28),
                          const RecentActivityWidget(),
                          const SizedBox(height: 16),
                        ]),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _AppBarSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
          ),
          const Text(
            'Statistik',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}