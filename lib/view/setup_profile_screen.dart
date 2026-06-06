import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'login_screen.dart';

class SetupProfileScreen extends StatefulWidget {
  final String userId; // ID user yang baru register

  const SetupProfileScreen({super.key, required this.userId});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final TextEditingController balanceController = TextEditingController();
  final TextEditingController dailyLimitController = TextEditingController();

  @override
  void dispose() {
    balanceController.dispose();
    dailyLimitController.dispose();
    super.dispose();
  }

  // Parse angka dari input (hapus titik pemisah ribuan)
  double _parseAmount(String value) {
    final cleaned = value.replaceAll('.', '').replaceAll(',', '');
    return double.tryParse(cleaned) ?? 0;
  }

  Future<void> _handleSetup() async {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);

    final balance = _parseAmount(balanceController.text.trim());
    final dailyLimit = _parseAmount(dailyLimitController.text.trim());

    final success = await authVM.setupProfile(
      userId: widget.userId,
      balance: balance,
      dailyLimit: dailyLimit,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profil berhasil disimpan! Silakan login."),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authVM.errorMessage ?? "Gagal menyimpan profil"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Background gradient atas
          Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Logo
                Center(
                  child: Image.asset(
                    "assets/img/logoputih.png",
                    width: 160,
                  ),
                ),

                const SizedBox(height: 80),

                // Card form
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 36,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Judul
                          const Center(
                            child: Text(
                              "Setup Profil",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Center(
                            child: Text(
                              "Atur saldo dan limit pengeluaran kamu",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // ── BALANCE ──
                          const Text(
                            "Balance",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: balanceController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              _ThousandsSeparatorFormatter(),
                            ],
                            decoration: InputDecoration(
                              hintText: "Rp.0",
                              prefixText: "Rp. ",
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFF2453E6),
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFF2453E6),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFF2453E6),
                                  width: 2.5,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ── DAILY LIMIT ──
                          const Text(
                            "Daily Limit",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: dailyLimitController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              _ThousandsSeparatorFormatter(),
                            ],
                            decoration: InputDecoration(
                              hintText: "Rp.0",
                              prefixText: "Rp. ",
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFF2453E6),
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // ── TOMBOL SET ──
                          Consumer<AuthViewModel>(
                            builder: (context, authVM, child) {
                              return SizedBox(
                                width: double.infinity,
                                height: 58,
                                child: ElevatedButton(
                                  onPressed: authVM.isLoading
                                      ? null
                                      : _handleSetup,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2453E6),
                                    disabledBackgroundColor:
                                        const Color(0xFF2453E6).withValues(alpha: 0.6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                  child: authVM.isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : const Text(
                                          "Set",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // ── SKIP ──
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Lewati untuk sekarang",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
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
          ),
        ],
      ),
    );
  }
}

// ─── Helper: format angka ribuan otomatis ────────────────────────
class _ThousandsSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final digits = newValue.text.replaceAll('.', '');
    final formatted = _formatNumber(digits);

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatNumber(String digits) {
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i != 0 && (digits.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}