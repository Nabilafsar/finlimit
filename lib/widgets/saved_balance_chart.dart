import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../viewmodels/statistic_viewmodel.dart';

class SavedBalanceChart extends StatelessWidget {
  const SavedBalanceChart({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StatisticViewModel>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1565C0), Color(0xFF1E88E5), Color(0xFF42A5F5)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withValues(alpha:0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Saved Balance',
                      style: TextStyle(
                        color: Colors.white, fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vm.formatRupiah(vm.savedBalance),
                      style: const TextStyle(
                        color: Colors.white, fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                _PeriodToggle(),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(height: 160, child: _LineChart()),
          ],
        ),
      ),
    );
  }
}

class _PeriodToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StatisticViewModel>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          _ToggleButton(
            label: 'Month',
            isSelected: vm.selectedPeriod == PeriodFilter.month,
            onTap: () => vm.setPeriodFilter(PeriodFilter.month),
          ),
          _ToggleButton(
            label: 'Year',
            isSelected: vm.selectedPeriod == PeriodFilter.year,
            onTap: () => vm.setPeriodFilter(PeriodFilter.year),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF1565C0) : Colors.white,
            fontSize: 12, fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StatisticViewModel>();
    final data = vm.chartData;
    final maxY = data.reduce((a, b) => a > b ? a : b) * 1.3;
    final spots = data.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        clipData: const FlClipData.all(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 3,
          getDrawingHorizontalLine: (_) => FlLine(
            color: Colors.white.withValues(alpha:0.15),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              interval: maxY / 2,
              getTitlesWidget: (value, meta) => Text(
                value == 0 ? '0' : vm.formatChartValue(value),
                style: TextStyle(
                  color: Colors.white.withValues(alpha:0.7), fontSize: 10,
                ),
              ),
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: data.length <= 6 ? 1 : (data.length / 4).roundToDouble(),
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= vm.chartLabels.length) return const SizedBox();
                return Text(
                  vm.chartLabels[index],
                  style: TextStyle(
                    color: Colors.white.withValues(alpha:0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchCallback: (event, response) {
            if (response?.lineBarSpots != null && response!.lineBarSpots!.isNotEmpty) {
              final spot = response.lineBarSpots!.first;
              vm.setTouchedLine(spot.spotIndex, spot.x);
            }
          },
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => const Color(0xFF0D2137),
            tooltipRoundedRadius: 10,
            tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            getTooltipItems: (spots) => spots.map((s) => LineTooltipItem(
              vm.formatChartValue(s.y),
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
            )).toList(),
          ),
          getTouchedSpotIndicator: (barData, spotIndexes) => spotIndexes.map((i) =>
            TouchedSpotIndicatorData(
              FlLine(color: Colors.transparent),
              FlDotData(
                getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                  radius: 8,
                  color: Colors.white,
                  strokeWidth: 3,
                  strokeColor: const Color(0xFF1565C0),
                ),
              ),
            ),
          ).toList(),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.4,
            color: Colors.white,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha:0.25),
                  Colors.white.withValues(alpha:0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}