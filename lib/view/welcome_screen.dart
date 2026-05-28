import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Stack(
          children: [

            // Background Image
            Positioned(
              top: -20,

              child: Image.asset(
                "assets/img/bgwelcome.png",

                width:
                    MediaQuery.of(context).size.width,

                fit: BoxFit.cover,
              ),
            ),

            // Bottom Content
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
              ),

              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.end,

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // Title
                  const Text(
                    "Easiest way to\nmanage your\nwallet",

                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2453E6),
                      height: 1.0,
                    ),
                  ),

                  const SizedBox(height: 35),

                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,

                    child: ElevatedButton(
                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const RegisterScreen(),
                          ),
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF2453E6),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),

                      child: const Text(
                        "Get Started",

                        style: TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Login Text
                  Center(
                    child: GestureDetector(
                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const LoginScreen(),
                          ),
                        );
                      },

                      child: RichText(
                        text: const TextSpan(
                          text:
                              "Already have an Account? ",

                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                          ),

                          children: [

                            TextSpan(
                              text: "Login",

                              style: TextStyle(
                                color:
                                    Color(0xFF2453E6),

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}