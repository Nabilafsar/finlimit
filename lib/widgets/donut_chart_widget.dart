import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../viewmodels/statistic_viewmodel.dart';
import '../models/transaction_model.dart';

class DonutChartWidget extends StatelessWidget {
  const DonutChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StatisticViewModel>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 75,
                    startDegreeOffset: -90,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        if (response?.touchedSection != null) {
                          vm.setTouchedDonutIndex(
                            response!.touchedSection!.touchedSectionIndex,
                          );
                        } else {
                          vm.setTouchedDonutIndex(-1);
                        }
                      },
                    ),
                    sections: TransactionCategory.values.asMap().entries.map((entry) {
                      final index = entry.key;
                      final cat = entry.value;
                      final isTouched = vm.touchedDonutIndex == index;
                      return PieChartSectionData(
                        color: vm.categoryColor(cat),
                        value: vm.categorySpend[cat] ?? 0,
                        title: '',
                        radius: isTouched ? 38 : 30,
                        borderSide: isTouched
                            ? BorderSide(
                                color: vm.categoryColor(cat).withValues(alpha:0.5),
                                width: 3)
                            : BorderSide.none,
                      );
                    }).toList(),
                  ),
                  duration: const Duration(milliseconds: 300),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${vm.totalSpendPercent.toInt()}%',
                      style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A), height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Total Spend',
                      style: TextStyle(
                        fontSize: 13, color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: TransactionCategory.values.map((cat) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12, height: 12,
                  decoration: BoxDecoration(
                    color: vm.categoryColor(cat),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  vm.categoryLabel(cat),
                  style: const TextStyle(
                    fontSize: 13, color: Color(0xFF475569),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }
}