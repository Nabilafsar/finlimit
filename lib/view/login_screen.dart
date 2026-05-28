import 'package:flutter/material.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background Image
            Container(
              height: 350,
              width: double.infinity,

              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/img/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Content
            SafeArea(
              child: Column(
                children: [
                  // Logo
                  const SizedBox(height: 80),

                  Center(
                    child: Image.asset("assets/img/logoputih.png", width: 180),
                  ),

                  const SizedBox(height: 120),

                  // White Container
                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 40,
                    ),

                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),

                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),

                    child: Column(
                      children: [
                        // Title
                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Email Field
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Email or Phone Number",

                            filled: true,
                            fillColor: const Color(0xFFEAEAEA),

                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 12,
                            ),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide.none,
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide.none,
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(
                                color: Color(0xFF2453E6),
                                width: 2,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Password Field
                        TextField(
                          obscureText: true,

                          decoration: InputDecoration(
                            hintText: "Password",

                            filled: true,
                            fillColor: const Color(0xFFEAEAEA),

                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 12,
                            ),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide.none,
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide.none,
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(
                                color: Color(0xFF2453E6),
                                width: 2,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Forgot Password
                        const SizedBox(height: 4),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 60,

                          child: ElevatedButton(
                            onPressed: () {},

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2453E6),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),

                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Forgot Password
                        Center(
                          child: TextButton(
                            onPressed: () {},

                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Color(0xFF2453E6),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 2,
                                color: const Color(0xFF2453E6),
                              ),
                            ),

                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "Login With",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),

                            Expanded(
                              child: Container(
                                height: 1,
                                color: const Color(0xFF2453E6),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // Social Icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/img/google.png", width: 55),

                            const SizedBox(width: 15),

                            Image.asset("assets/img/facebook.png", width: 55),

                            const SizedBox(width: 15),

                            Image.asset("assets/img/apple.png", width: 55),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Register Text
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },

                          child: RichText(
                            text: const TextSpan(
                              text: "Don't Have an Account Yet? ",

                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),

                              children: [
                                TextSpan(
                                  text: "Register",
                                  style: TextStyle(
                                    color: Color(0xFF2453E6),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
