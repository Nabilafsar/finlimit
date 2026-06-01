import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/settings_viewmodel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsViewModel>().loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Consumer<SettingsViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              // ─── APP BAR ────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 140,
                floating: false,
                pinned: true,
                backgroundColor: const Color(0xFF2453E6),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF2453E6), Color(0xFF1A3BB5)],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            const Text(
                              'Pengaturan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Profile Summary
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.2),
                                  child: Text(
                                    vm.userName.isNotEmpty
                                        ? vm.userName[0].toUpperCase()
                                        : 'U',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      vm.userName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (vm.userEmail.isNotEmpty)
                                      Text(
                                        vm.userEmail,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ─── BODY ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profil Section
                      _SectionHeader(title: 'Profil'),
                      _SettingsCard(
                        children: [
                          _SettingsTile(
                            icon: Icons.person_outline,
                            iconColor: const Color(0xFF2453E6),
                            title: 'Edit Profil',
                            subtitle: vm.userName,
                            onTap: () => _showEditProfileDialog(context, vm),
                          ),
                          const _Divider(),
                          _SettingsTile(
                            icon: Icons.phone_outlined,
                            iconColor: const Color(0xFF2453E6),
                            title: 'Nomor Telepon',
                            subtitle: vm.userPhone.isEmpty
                                ? 'Belum diset'
                                : vm.userPhone,
                            onTap: () => _showEditProfileDialog(context, vm),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Wallet Section
                      _SectionHeader(title: 'Dompet'),
                      _SettingsCard(
                        children: [
                          _SettingsTile(
                            icon: Icons.account_balance_wallet_outlined,
                            iconColor: const Color(0xFF43A047),
                            title: 'Nama Dompet',
                            subtitle: vm.walletName,
                            onTap: () =>
                                _showEditWalletDialog(context, vm),
                          ),
                          const _Divider(),
                          _SettingsTile(
                            icon: Icons.today_outlined,
                            iconColor: const Color(0xFFFF6B6B),
                            title: 'Limit Harian',
                            subtitle: _formatAmount(vm.dailyLimit),
                            onTap: () =>
                                _showEditWalletDialog(context, vm),
                          ),
                          const _Divider(),
                          _SettingsTile(
                            icon: Icons.calendar_month_outlined,
                            iconColor: const Color(0xFFFF9671),
                            title: 'Limit Bulanan',
                            subtitle: _formatAmount(vm.monthlyLimit),
                            onTap: () =>
                                _showEditWalletDialog(context, vm),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Preferensi Section
                      _SectionHeader(title: 'Preferensi'),
                      _SettingsCard(
                        children: [
                          _SettingsSwitchTile(
                            icon: Icons.dark_mode_outlined,
                            iconColor: const Color(0xFF845EC2),
                            title: 'Mode Gelap',
                            subtitle: 'Tampilan tema gelap',
                            value: vm.isDarkMode,
                            onChanged: (val) => vm.toggleDarkMode(val),
                          ),
                          const _Divider(),
                          _SettingsSwitchTile(
                            icon: Icons.notifications_outlined,
                            iconColor: const Color(0xFFFFBE0B),
                            title: 'Notifikasi',
                            subtitle: 'Pengingat limit pengeluaran',
                            value: vm.notificationEnabled,
                            onChanged: (val) =>
                                vm.toggleNotification(val),
                          ),
                          const _Divider(),
                          _SettingsTile(
                            icon: Icons.currency_exchange,
                            iconColor: const Color(0xFF4ECDC4),
                            title: 'Mata Uang',
                            subtitle: vm.currency,
                            onTap: () =>
                                _showCurrencyDialog(context, vm),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Lainnya Section
                      _SectionHeader(title: 'Lainnya'),
                      _SettingsCard(
                        children: [
                          _SettingsTile(
                            icon: Icons.info_outline,
                            iconColor: Colors.grey,
                            title: 'Tentang Aplikasi',
                            subtitle: 'Finlimit v1.0.0',
                            onTap: () => _showAboutDialog(context),
                          ),
                          const _Divider(),
                          _SettingsTile(
                            icon: Icons.logout,
                            iconColor: const Color(0xFFE53935),
                            title: 'Keluar',
                            titleColor: const Color(0xFFE53935),
                            onTap: () => _showLogoutDialog(context),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─── DIALOGS ───────────────────────────────────────────────────

  void _showEditProfileDialog(
      BuildContext context, SettingsViewModel vm) {
    final nameCtrl = TextEditingController(text: vm.userName);
    final emailCtrl = TextEditingController(text: vm.userEmail);
    final phoneCtrl = TextEditingController(text: vm.userPhone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Profil',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _InputField(controller: nameCtrl, label: 'Nama', icon: Icons.person),
            const SizedBox(height: 12),
            _InputField(
                controller: emailCtrl, label: 'Email', icon: Icons.email),
            const SizedBox(height: 12),
            _InputField(
                controller: phoneCtrl,
                label: 'Nomor Telepon',
                icon: Icons.phone,
                keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await vm.updateProfile(
                    name: nameCtrl.text,
                    email: emailCtrl.text,
                    phone: phoneCtrl.text,
                  );
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2453E6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditWalletDialog(BuildContext context, SettingsViewModel vm) {
    final nameCtrl = TextEditingController(text: vm.walletName);
    final dailyCtrl =
        TextEditingController(text: vm.dailyLimit.toStringAsFixed(0));
    final monthlyCtrl =
        TextEditingController(text: vm.monthlyLimit.toStringAsFixed(0));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pengaturan Dompet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _InputField(
                controller: nameCtrl,
                label: 'Nama Dompet',
                icon: Icons.account_balance_wallet),
            const SizedBox(height: 12),
            _InputField(
              controller: dailyCtrl,
              label: 'Limit Harian (Rp)',
              icon: Icons.today,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _InputField(
              controller: monthlyCtrl,
              label: 'Limit Bulanan (Rp)',
              icon: Icons.calendar_month,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await vm.updateWallet(
                    name: nameCtrl.text,
                    dailyLimit:
                        double.tryParse(dailyCtrl.text) ?? vm.dailyLimit,
                    monthlyLimit:
                        double.tryParse(monthlyCtrl.text) ?? vm.monthlyLimit,
                  );
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2453E6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, SettingsViewModel vm) {
    final currencies = ['IDR', 'USD', 'SGD', 'MYR', 'JPY'];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Pilih Mata Uang'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies
              .map(
                (c) => RadioListTile<String>(
                  title: Text(c),
                  value: c,
                  groupValue: vm.currency,
                  activeColor: const Color(0xFF2453E6),
                  onChanged: (val) {
                    if (val != null) {
                      vm.setCurrency(val);
                      Navigator.pop(ctx);
                    }
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Tentang Finlimit'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Versi: 1.0.0'),
            SizedBox(height: 8),
            Text(
              'Finlimit adalah aplikasi manajemen limit pengeluaran QRIS yang membantu kamu mengontrol keuangan harian dan bulanan.',
            ),
            SizedBox(height: 12),
            Text(
              'Dikembangkan untuk keperluan akademik.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar'),
        content: const Text('Apakah kamu yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: Nabil - tambahkan logika logout di sini
              // Contoh: Navigator.pushAndRemoveUntil ke LoginScreen
            },
            child: const Text(
              'Keluar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    final formatted = amount.toStringAsFixed(0);
    final buffer = StringBuffer();
    int count = 0;
    for (int i = formatted.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(formatted[i]);
      count++;
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }
}

// ─── HELPER WIDGETS ─────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2453E6),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Color? titleColor;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.titleColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: titleColor ?? Colors.black87,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            )
          : null,
      trailing: onTap != null
          ? Icon(Icons.chevron_right, color: Colors.grey[400], size: 20)
          : null,
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            )
          : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF2453E6),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 68,
      color: Colors.grey[100],
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;

  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF2453E6), size: 20),
        filled: true,
        fillColor: const Color(0xFFF5F6FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFF2453E6), width: 1.5),
        ),
      ),
    );
  }
}
