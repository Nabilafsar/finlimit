import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/welcome_screen.dart';
import 'viewmodels/transaction_viewmodel.dart';
import 'viewmodels/settings_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionViewModel()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settings, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF2453E6),
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF2453E6),
                brightness: Brightness.dark,
              ),
            ),
            themeMode:
                settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const WelcomeScreen(),
          );
        },
      ),
    );
  }
}
