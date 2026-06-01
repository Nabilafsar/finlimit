import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/statistic_viewmodel.dart';
import '../models/transaction_model.dart';

class RecentActivityWidget extends StatelessWidget {
  const RecentActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StatisticViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        _CategoryFilterBar(),
        const SizedBox(height: 16),
        ...vm.filteredTransactions.map((t) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _TransactionTile(transaction: t),
        )),
      ],
    );
  }
}

class _CategoryFilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StatisticViewModel>();
    final filters = <TransactionCategory?>[
      null,
      TransactionCategory.incomes,
      TransactionCategory.food,
      TransactionCategory.drink,
      TransactionCategory.transportation,
    ];
    final labels = <TransactionCategory?, String>{
      null: 'All',
      TransactionCategory.incomes: 'Incomes',
      TransactionCategory.food: 'Food',
      TransactionCategory.drink: 'Drink',
      TransactionCategory.transportation: 'Transportation',
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((cat) {
          final isSelected = vm.selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => vm.setCategoryFilter(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1E4FC8) : Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1E4FC8)
                        : const Color(0xFF1E4FC8).withValues(alpha:0.5),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  labels[cat]!,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF1E4FC8),
                    fontSize: 13, fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<StatisticViewModel>();
    final isExpense = transaction.isExpense;
    final color = vm.categoryColor(transaction.category);
    final icon = vm.categoryIcon(transaction.category);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 12, offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  transaction.subtitle,
                  style: const TextStyle(
                    fontSize: 12, color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isExpense ? '-' : '+'}${vm.formatRupiah(transaction.amount)}',
                style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700,
                  color: isExpense ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                vm.categoryLabel(transaction.category),
                style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}