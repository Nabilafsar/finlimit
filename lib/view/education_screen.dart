import 'package:flutter/material.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              const SizedBox(height: 20),

              const Text(
                "Education",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              // SPENDING CARD
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Spend",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Rp.150.000",
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Rp.80.000 ",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "More than yesterday",
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // MINI CHART
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.end,
                        mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                        children: [
                          _bar(45),
                          _bar(25),
                          _bar(35),
                          _bar(60, active: true),
                          _bar(5),
                          _bar(5),
                          _bar(5),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // MOTIVATION BANNER
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E5BFF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  "Hey Miftah, your spending has exceeded the limit—but this is your chance to take control. Start learning, set limits, and build smarter financial habits. You've got this!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.5,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: const [
                    Text(
                      "Recommendation Blog",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              const _BlogCard(
                image: Icons.trending_up,
                title: "Mastering Your Personal Finance",
                description:
                    "Learn how to manage your money wisely and build a secure financial future.",
              ),

              const _BlogCard(
                image: Icons.account_balance_wallet,
                title: "Smart Budgeting for Beginners",
                description:
                    "Learn when to save and when to spend wisely.",
              ),

              const _BlogCard(
                image: Icons.savings,
                title: "Building Healthy Financial Habits",
                description:
                    "Small habits today can create big financial success tomorrow.",
              ),

              const _BlogCard(
                image: Icons.payments,
                title: "Saving vs Spending: Finding the Balance",
                description:
                    "Learn when to save and when to spend wisely.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bar(
    double height, {
    bool active = false,
  }) {
    return Container(
      width: 10,
      height: height,
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFF2E5BFF)
            : Colors.indigo.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class _BlogCard extends StatelessWidget {
  final IconData image;
  final String title;
  final String description;

  const _BlogCard({
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 95,
            height: 95,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              image,
              size: 50,
              color: const Color(0xFF2E5BFF),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Text(
                      "2 Days Ago",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "View All",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor:
                          Color(0xFF2E5BFF),
                      child: Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}