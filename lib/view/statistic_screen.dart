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
    return const _StatisticViewContent();
  }
}

class _StatisticViewContent extends StatefulWidget {
  const _StatisticViewContent();

  @override
  State<_StatisticViewContent> createState() => _StatisticViewContentState();
}

class _StatisticViewContentState extends State<_StatisticViewContent> {
  String? _lastLoadedUserId;
  double? _lastBalance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
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
    final newBalance = authVM.currentUser?.balance ?? 0.0;
    final newUserId = authVM.currentUser?.id ?? '';

    if (newBalance != _lastBalance || newUserId != _lastLoadedUserId) {
      _loadData();
    }
  }

  void _loadData() {
    if (!mounted) return;
    final authVM = context.read<AuthViewModel>();
    final userId = authVM.currentUser?.id ?? '';
    final balance = authVM.currentUser?.balance ?? 0.0;

    context.read<StatisticViewModel>().loadStatistic(
          userId,
          userBalance: balance,
        );

    _lastLoadedUserId = userId;
    _lastBalance = balance;
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
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Center(
        child: Text(
          'Statistik',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
    );
  }
}