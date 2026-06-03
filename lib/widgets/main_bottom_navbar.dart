import 'package:flutter/material.dart';

class MainBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const MainBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = const [
      _NavItem(icon: Icons.home_rounded, label: 'Home'),
      _NavItem(icon: Icons.history_rounded, label: 'History'),
      _NavItem(icon: Icons.school_rounded, label: 'Education'),
      _NavItem(icon: Icons.bar_chart_rounded, label: 'Grafik'),
      _NavItem(icon: Icons.settings_rounded, label: 'Settings'),
    ];

    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = selectedIndex == index;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: isSelected ? 52 : 40,
                      height: isSelected ? 52 : 40,
                      decoration: isSelected
                          ? const BoxDecoration(
                              color: Color(0xFF1E4FC8),
                              shape: BoxShape.circle,
                            )
                          : null,
                      child: Icon(
                        item.icon,
                        size: isSelected ? 26 : 22,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                    if (!isSelected)
                      Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.label,
  });
}