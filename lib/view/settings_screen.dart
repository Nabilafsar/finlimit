import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'sub-settings/account_info_screen.dart';
import 'sub-settings/change_password_screen.dart';
import 'sub-settings/language_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Warna konsisten dengan proyek (biru utama dari dashboard & login)
  static const Color _primaryBlue = Color(0xFF1565C0);
  static const Color _bgBlue = Color(0xFF1976D2);
  static const Color _cardBg = Color(0xFFE8EEF9);

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final user = authVM.currentUser;
    final userName = user?.fullname ?? 'User';

    return Scaffold(
      backgroundColor: _bgBlue,
      body: Stack(
        children: [
          // ── Background biru atas ──────────────────────────
          Container(
            height: MediaQuery.of(context).size.height * 0.42,
            color: _bgBlue,
          ),
          // ── Background putih bawah (wave) ────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(0),
                ),
              ),
            ),
          ),
          // ── Konten utama ─────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Avatar
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    color: Colors.grey[300],
                  ),
                  child: const CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xFFE0E0E0),
                    child: Icon(Icons.person, size: 60, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
                // Nama user
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                // Menu list
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildMenuTile(
                          icon: Icons.person_outline,
                          label: 'Account Information',
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AccountInfoScreen(),
                              ),
                            );
                            if (context.mounted && user != null) {
                              await context
                                  .read<AuthViewModel>()
                                  .refreshUser(user.id);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildMenuTile(
                          icon: Icons.lock_outline,
                          label: 'Password',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ChangePasswordScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildMenuTile(
                          icon: Icons.logout,
                          label: 'Logout',
                          isLogout: true,
                          onTap: () => _confirmLogout(context),
                        ),
                      ],
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

  Widget _buildMenuTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Material(
      color: _cardBg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Icon(
                icon,
                color: isLogout ? Colors.red : Colors.black87,
                size: 24,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isLogout ? Colors.red : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah kamu yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthViewModel>().logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text('Logout',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}