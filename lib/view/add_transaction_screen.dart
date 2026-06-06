import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import '../viewmodels/notification_viewmodel.dart';
import '../viewmodels/transaction_viewmodel.dart';
import 'add_transaction_success_screen.dart';


class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final List<_CategoryItem> _categories = [
    _CategoryItem(
      TransactionCategory.drink,
      'Drink',
      Icons.local_drink,
      const Color(0xFF4CAF50),
    ),
    _CategoryItem(
      TransactionCategory.transportation,
      'Transportation',
      Icons.directions_bus,
      const Color(0xFFE91E8C),
    ),
    _CategoryItem(
      TransactionCategory.health,
      'Health',
      Icons.local_hospital,
      const Color(0xFF1A3A6B),
    ),
    _CategoryItem(
      TransactionCategory.food,
      'Food',
      Icons.restaurant,
      const Color(0xFF3949AB),
    ),
    _CategoryItem(
      TransactionCategory.bill,
      'Bill',
      Icons.vpn_key,
      const Color(0xFF90CAF9),
    ),
    _CategoryItem(
      TransactionCategory.invest,
      'Invest',
      Icons.monetization_on,
      const Color(0xFF90CAF9),
    ),
    _CategoryItem(
      TransactionCategory.ticket,
      'Ticket',
      Icons.confirmation_num,
      const Color(0xFF90CAF9),
    ),
    _CategoryItem(
      TransactionCategory.other,
      'Other',
      Icons.add,
      const Color(0xFF90CAF9),
    ),
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TransactionViewModel vm) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: vm.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) vm.setDate(picked);
  }

  Future<void> _submit(TransactionViewModel vm) async {
    final authVM = context.read<AuthViewModel>();
    final dashVM = context.read<DashboardViewModel>();
    final notifVM = context.read<NotificationViewModel>();
    final user = authVM.currentUser;

    if (user == null) return;

    final tx = await vm.saveTransaction(
      userId: user.id,
      userFullname: user.fullname,
      notificationVM: notifVM,
      dailyLimit: user.dailyLimit,
    );

    if (!mounted) return;

    if (tx != null) {
      dashVM.addTransaction(tx);
      await authVM.refreshUser(user.id);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AddTransactionSuccessScreen(transaction: tx),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage ?? 'Gagal menyimpan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TransactionViewModel dibuat di sini,
    // AuthViewModel & DashboardViewModel diakses dari parent provider
    return ChangeNotifierProvider(
      create: (_) => TransactionViewModel(),
      child: Consumer<TransactionViewModel>(
        builder: (context, vm, _) => _buildScaffold(context, vm),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, TransactionViewModel vm) {
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
      body: Column(
        children: [
          // ── TOP BLUE SECTION ────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  // AppBar
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Record Transactions',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 26),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Amount input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Rp',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 46,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '0',
                            hintStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 46,
                            ),
                          ),
                          onChanged: (val) {
                            final cleaned = val.replaceAll('.', '');
                            final parsed = double.tryParse(cleaned) ?? 0;
                            vm.setAmount(parsed);
                          },
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Date picker
                  GestureDetector(
                    onTap: () => _pickDate(vm),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: Colors.black87,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat('dd MMMM yyyy').format(vm.selectedDate),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── BOTTOM WHITE SHEET ───────────────────────────
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Category grid
                    // SESUDAH — ganti dengan ini:
                    // Category grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 8,
                        childAspectRatio:
                            0.78, // ← lebih tinggi dari lebar, cukup untuk icon + teks
                      ),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = vm.selectedCategory == cat.category;
                        return GestureDetector(
                          onTap: () => vm.setCategory(cat.category),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? cat.color
                                      : cat.color.withValues(alpha: 0.55),
                                  borderRadius: BorderRadius.circular(16),
                                  border: isSelected
                                      ? Border.all(
                                          color: Colors.black26,
                                          width: 2.5,
                                        )
                                      : null,
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: cat.color.withValues(alpha: 0.4),
                                            blurRadius: 8,
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Icon(
                                  cat.icon,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                cat.label,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? const Color(0xFF1A3A6B)
                                      : Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow
                                    .ellipsis, // ← teks panjang tidak overflow
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Payment method
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        value: vm.paymentMethod,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: vm.paymentMethods
                            .map(
                              (m) => DropdownMenuItem(value: m, child: Text(m)),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) vm.setPaymentMethod(val);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Note
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _noteController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Note :',
                          labelStyle: TextStyle(color: Colors.black54),
                        ),
                        maxLines: 2,
                        onChanged: vm.setNote,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: vm.isLoading ? null : () => _submit(vm),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A3A6B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: vm.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Add Transaction',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem {
  final TransactionCategory category;
  final String label;
  final IconData icon;
  final Color color;
  const _CategoryItem(this.category, this.label, this.icon, this.color);
}
