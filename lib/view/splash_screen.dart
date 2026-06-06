import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/welcome');
    });
  }

  @override  
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF2D69FF),
      body: Center(
        child: Image(
          image: AssetImage("assets/img/logoputih.png"),
          width: 200,
        ),
      ),
    );
  }
}