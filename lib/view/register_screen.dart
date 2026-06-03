import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/user_model.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // GENERATE SIMPLE UNIQUE ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<void> _handleRegister() async {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);

    final user = UserModel(
      id: _generateId(),
      fullname: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      monthlyLimit: 0,
      createdAt: DateTime.now().toIso8601String(),
    );

    final success = await authVM.register(user);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registrasi berhasil! Silakan login."),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authVM.errorMessage ?? "Registrasi gagal"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
                image: AssetImage("assets/img/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [

                const SizedBox(height: 80),

                Center(
                  child: Image.asset(
                    "assets/img/logoputih.png",
                    width: 180,
                  ),
                ),

                const SizedBox(height: 120),

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

                    child: SingleChildScrollView(
                      child: Column(
                        children: [

                          // TITLE
                          const Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // NAME
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: "Input Name",
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

                          // EMAIL
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "Email",
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

                          // PASSWORD
                          TextField(
                            controller: passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: "Password",
                              filled: true,
                              fillColor: const Color(0xFFEAEAEA),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 12,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
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

                          // REGISTER BUTTON
                          Consumer<AuthViewModel>(
                            builder: (context, authVM, child) {
                              return SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: authVM.isLoading
                                      ? null
                                      : _handleRegister,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2453E6),
                                    disabledBackgroundColor:
                                        const Color(0xFF2453E6).withOpacity(0.6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                  child: authVM.isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : const Text(
                                          "Register",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 10),

                          // DIVIDER
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
                                  "Register With",
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

                          const SizedBox(height: 25),

                          // SOCIAL ICONS
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

                          const SizedBox(height: 30),

                          // LOGIN TEXT
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginScreen(),
                                ),
                              );
                            },
                            child: RichText(
                              text: const TextSpan(
                                text: "Do You Have an Account? ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Login",
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