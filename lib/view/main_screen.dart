import 'package:flutter/material.dart';

import '../widgets/main_bottom_navbar.dart';

import 'dashboard_screen.dart';
import 'history_screen.dart';
import 'education_screen.dart';
import 'statistic_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = const [
      DashboardScreen(),
      HistoryScreen(),
      EducationScreen(),
      StatisticScreen(),
      SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: MainBottomNavBar(
        selectedIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}