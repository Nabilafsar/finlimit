import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../data/db/db_helper.dart';
import '../viewmodels/auth_viewmodel.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final TextEditingController _ctrl = TextEditingController();
  double? _selected;

  final List<double> _quickAmounts = [
    50000, 100000, 200000, 500000, 1000000, 2000000
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
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

  Future<void> _onTopUp() async {
    final amount = double.tryParse(_ctrl.text.trim().replaceAll('.', ''));
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nominal yang valid'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ── Dialog konfirmasi
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Konfirmasi Top Up',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_balance_wallet,
                size: 48, color: Color(0xFF2E5BFF)),
            const SizedBox(height: 12),
            Text(_fmt(amount),
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E5BFF))),
            const SizedBox(height: 8),
            const Text('akan ditambahkan ke saldo kamu.',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E5BFF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    // ── Simpan ke DB
    final authVM = context.read<AuthViewModel>();
    final userId = authVM.currentUser?.id ?? '';
    final currentBalance = authVM.currentUser?.balance ?? 0.0;
    await DbHelper.updateBalance(userId, currentBalance + amount);
    await authVM.refreshUser(userId);

    if (!mounted) return;

    // ── Dialog sukses
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Color(0xFF2E5BFF)),
            const SizedBox(height: 16),
            const Text('Top Up Berhasil!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${_fmt(amount)} berhasil\nditambahkan ke saldo kamu.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E5BFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Oke'),
              ),
            ),
          ],
        ),
      ),
    );

    if (mounted) Navigator.pop(context); // kembali ke dashboard
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().currentUser;
    final balance = user?.balance ?? 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E5BFF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Top Up Saldo',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Kartu saldo sekarang
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2E5BFF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Saldo Sekarang',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 6),
                  Text(
                    () {
                      final s = balance.toInt().toString();
                      final buf = StringBuffer();
                      for (int i = 0; i < s.length; i++) {
                        if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
                        buf.write(s[i]);
                      }
                      return 'Rp.$buf';
                    }(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Input nominal manual
            const Text('Nominal Top Up',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ],
              ),
              child: TextField(
                controller: _ctrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => setState(() => _selected = null),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E5BFF)),
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  prefixText: 'Rp. ',
                  prefixStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E5BFF)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Grid nominal cepat
            const Text('Nominal Cepat',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.2,
              ),
              itemCount: _quickAmounts.length,
              itemBuilder: (ctx, i) {
                final amt = _quickAmounts[i];
                final isSelected = _selected == amt;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selected = amt;
                    _ctrl.text = amt.toInt().toString();
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF2E5BFF)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2E5BFF)
                              : Colors.grey.shade200,
                          width: 1.5),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                  color: const Color(0xFF2E5BFF)
                                      .withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2))
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(_fmt(amt),
                          style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // ── Tombol Top Up Sekarang
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _onTopUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E5BFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Top Up Sekarang',
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}