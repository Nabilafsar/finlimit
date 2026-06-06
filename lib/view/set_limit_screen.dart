import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../data/db/db_helper.dart';
import '../viewmodels/auth_viewmodel.dart';

class SetLimitScreen extends StatefulWidget {
  const SetLimitScreen({super.key});

  @override
  State<SetLimitScreen> createState() => _SetLimitScreenState();
}

class _SetLimitScreenState extends State<SetLimitScreen> {
  final TextEditingController _dailyCtrl = TextEditingController();
  final TextEditingController _monthlyCtrl = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Isi dengan nilai limit yang sudah ada
    final user = context.read<AuthViewModel>().currentUser;
    if (user != null) {
      if (user.dailyLimit > 0) {
        _dailyCtrl.text = user.dailyLimit.toInt().toString();
      }
      if (user.monthlyLimit > 0) {
        _monthlyCtrl.text = user.monthlyLimit.toInt().toString();
      }
    }
  }

  @override
  void dispose() {
    _dailyCtrl.dispose();
    _monthlyCtrl.dispose();
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

  Future<void> _onSave() async {
    final daily = double.tryParse(_dailyCtrl.text.trim());
    final monthly = double.tryParse(_monthlyCtrl.text.trim());

    // ── Validasi
    if (daily == null || daily <= 0) {
      setState(() => _errorMessage = 'Limit harian tidak valid');
      return;
    }
    if (monthly == null || monthly <= 0) {
      setState(() => _errorMessage = 'Limit bulanan tidak valid');
      return;
    }
    if (daily > monthly) {
      setState(() =>
          _errorMessage = 'Limit harian tidak boleh melebihi limit bulanan');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // ── Simpan ke DB
    final authVM = context.read<AuthViewModel>();
    final userId = authVM.currentUser?.id ?? '';
    await DbHelper.updateDailyLimit(userId, daily);
    await DbHelper.updateMonthlyLimit(userId, monthly);
    await authVM.refreshUser(userId);

    setState(() => _isLoading = false);

    if (!mounted) return;

    // ── Dialog sukses
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle,
                size: 64, color: Color(0xFF2E5BFF)),
            const SizedBox(height: 16),
            const Text('Limit Berhasil Disimpan!',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Daily: ${_fmt(daily)}\nMonthly: ${_fmt(monthly)}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
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

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E5BFF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Set Limit',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Info limit sekarang
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2E5BFF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Daily Limit',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(
                          user?.dailyLimit != null && user!.dailyLimit > 0
                              ? _fmt(user.dailyLimit)
                              : 'Belum diset',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white30,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Monthly Limit',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(
                            user?.monthlyLimit != null &&
                                    user!.monthlyLimit > 0
                                ? _fmt(user.monthlyLimit)
                                : 'Belum diset',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Error banner
            if (_errorMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(_errorMessage!,
                          style: TextStyle(
                              color: Colors.red.shade700, fontSize: 13)),
                    ),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _errorMessage = null),
                      child: Icon(Icons.close,
                          size: 18, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),

            // ── Daily Limit input
            const Text('Daily Limit',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87)),
            const SizedBox(height: 10),
            _buildInput(
              controller: _dailyCtrl,
              hint: 'Masukkan limit harian',
            ),

            const SizedBox(height: 20),

            // ── Monthly Limit input
            const Text('Monthly Limit',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87)),
            const SizedBox(height: 10),
            _buildInput(
              controller: _monthlyCtrl,
              hint: 'Masukkan limit bulanan',
            ),

            const SizedBox(height: 12),

            // ── Tips
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF2E5BFF).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb_outline,
                      color: Color(0xFF2E5BFF), size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tips: Pastikan limit harian tidak melebihi limit bulanan kamu.',
                      style: TextStyle(
                          color: Color(0xFF2E5BFF), fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E5BFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5))
                    : const Text('Simpan Limit',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
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
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixText: 'Rp. ',
          prefixStyle:
              const TextStyle(color: Colors.black87, fontSize: 15),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}