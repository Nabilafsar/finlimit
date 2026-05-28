import 'package:flutter/material.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [

          // Background Image
          Container(
            height: 350,
            width: double.infinity,

            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/img/background.png",
                ),
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
                  child: Image.asset(
                    "assets/img/logoputih.png",
                    width: 180,
                  ),
                ),

                const SizedBox(height: 120),

                // White Container
                Expanded(
                  child: Container(
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
                          "Register",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Name Field
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Input Name",

                            filled: true,
                            fillColor: const Color(0xFFEAEAEA),

                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 12,
                            ),

                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(40),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Email Field
                        TextField(
                          decoration: InputDecoration(
                            hintText:
                                "Email or Phone Number",

                            filled: true,
                            fillColor: const Color(0xFFEAEAEA),

                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 12,
                            ),

                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(40),
                              borderSide: BorderSide.none,
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

                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 12,
                            ),

                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(40),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Register Button
                        SizedBox(
                          width: double.infinity,
                          height: 60,

                          child: ElevatedButton(
                            onPressed: () {},

                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF2453E6),

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        40),
                              ),
                            ),

                            child: const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                                color: Colors.white,
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
                                color: const Color(
                                    0xFF2453E6),
                              ),
                            ),

                            const Padding(
                              padding:
                                  EdgeInsets.symmetric(
                                      horizontal: 15),
                              child: Text(
                                "Register With",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Container(
                                height: 1,
                                color: const Color(
                                    0xFF2453E6),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // Social Icons
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [

                            Image.asset(
                              "assets/img/google.png",
                              width: 55,
                            ),

                            const SizedBox(width: 15),

                            Image.asset(
                              "assets/img/facebook.png",
                              width: 55,
                            ),

                            const SizedBox(width: 15),

                            Image.asset(
                              "assets/img/apple.png",
                              width: 55,
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Login Text
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },

                          

                          child: RichText(
                            text: const TextSpan(
                              text:
                                  "Do You Have an Account? ",
                              style: TextStyle(
                                color: Colors.black,
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

                        const SizedBox(height: 10),
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
}