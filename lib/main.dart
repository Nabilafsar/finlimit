import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/dashboard_viewmodel.dart';
import 'viewmodels/statistic_viewmodel.dart';
import 'viewmodels/settings_viewmodel.dart';   // ← TAMBAH
import 'viewmodels/history_viewmodel.dart'; 
import 'viewmodels/education_viewmodel.dart'; // ← TAMBAH INI
import 'viewmodels/notification_viewmodel.dart';
import 'view/splash_screen.dart';
import 'view/login_screen.dart';
import 'view/register_screen.dart';
import 'view/welcome_screen.dart';
import 'view/main_screen.dart';
import 'view/notification_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => StatisticViewModel()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),  // ← TAMBAH
        ChangeNotifierProvider(create: (_) => HistoryViewModel()),
        ChangeNotifierProvider(create: (_) => EducationViewModel()), // ← TAMBAH INI
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/main': (context) => const MainScreen(),
          '/notification': (context) => const NotificationScreen(),
        },
      ),
    );
  }
}