import 'package:flutter/material.dart';
import '../data/db/db_helper.dart';
import '../models/education_model.dart';

class EducationViewModel extends ChangeNotifier {
  bool isLoading = false;
  List<EducationModel> articles = [];

  Future<void> loadArticles() async {
    isLoading = true;
    notifyListeners();

    try {
      final raw = await DbHelper.getAllArticles();
      if (raw.isEmpty) {
        await _seedArticles();
        final seeded = await DbHelper.getAllArticles();
        articles = seeded.map((e) => EducationModel.fromMap(e)).toList();
      } else {
        articles = raw.map((e) => EducationModel.fromMap(e)).toList();
      }
    } catch (e) {
      debugPrint('EducationViewModel error: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // Seed data awal supaya DB tidak kosong
  Future<void> _seedArticles() async {
    final seeds = [
      {
        'id': 'edu_001',
        'title': 'Mastering Your Personal Finance',
        'content':
            'Understanding personal finance is the cornerstone of a stable and prosperous life. It\'s not just about how much money you earn, but how effectively you manage, save, and invest what you have. Mastering these skills allows you to navigate economic uncertainties with confidence and build a legacy for your future self.\n\n## The Importance of Budgeting\n\nBudgeting is often perceived as a restrictive practice, but in reality, it is a tool for liberation. By creating a clear roadmap for your income, you gain the power to prioritize what truly matters to you—whether that\'s traveling the world, purchasing a home, or achieving early retirement.\n\n> "Small, disciplined adjustments today lead to exponential growth and security tomorrow. Financial mastery is a marathon, not a sprint."\n\nA successful budget starts with awareness. Tracking every expense for a month can reveal surprising patterns and opportunities for saving. Once you understand your flow, you can apply the 50/30/20 rule: allocating 50% to needs, 30% to wants, and 20% to financial goals like debt repayment or savings.\n\nFinally, consistency is more important than perfection. Start today by reviewing your latest transactions and setting one clear financial goal for the upcoming month.',
        'image_url': '',
        'category': 'EDUCATION',
        'created_at': '2024-01-14T00:00:00.000Z',
      },
      {
        'id': 'edu_002',
        'title': 'Smart Budgeting for Beginners',
        'content':
            'Budgeting doesn\'t have to be complicated. For beginners, the key is to start simple and build consistency over time.\n\n## Start with Your Income\n\nWrite down your monthly take-home pay. This is your starting point. Everything else—expenses, savings, and goals—must fit within this number.\n\n## Track Every Expense\n\nFor the first month, track every single purchase. Use an app or even a notebook. You\'ll likely be surprised where your money actually goes versus where you think it goes.\n\n## The 50/30/20 Rule\n\nA popular framework for beginners:\n- 50% for needs (rent, food, utilities)\n- 30% for wants (dining out, entertainment)\n- 20% for savings and debt repayment\n\n## Build an Emergency Fund First\n\nBefore investing or paying off debt aggressively, aim to save 3–6 months of living expenses. This cushion prevents small setbacks from derailing your financial plan.\n\nRemember: a budget is not a restriction—it\'s permission to spend confidently within your means.',
        'image_url': '',
        'category': 'BUDGETING',
        'created_at': '2024-01-12T00:00:00.000Z',
      },
      {
        'id': 'edu_003',
        'title': 'Investing 101: Building Your First Portfolio',
        'content':
            'Investing can feel intimidating, but the fundamentals are simpler than you think. The most important step is just getting started.\n\n## Why Invest?\n\nMoney sitting in a savings account loses purchasing power to inflation over time. Investing allows your money to grow faster than inflation, building real wealth over the long term.\n\n## Key Investment Types\n\n**Stocks** represent ownership in a company. They carry higher risk but also higher potential returns over long periods.\n\n**Bonds** are loans you give to governments or corporations in exchange for regular interest payments. Lower risk, lower return.\n\n**Mutual Funds & ETFs** pool money from many investors to buy a diversified collection of stocks or bonds. Great for beginners.\n\n## The Power of Compound Interest\n\nEinstein allegedly called compound interest the eighth wonder of the world. When your returns generate their own returns, your wealth can grow exponentially over decades.\n\n## Start Small, Start Now\n\nYou don\'t need a lot of money to start investing. Many platforms allow you to begin with as little as Rp.100.000. The key is consistency and time in the market.',
        'image_url': '',
        'category': 'INVESTING',
        'created_at': '2024-01-10T00:00:00.000Z',
      },
      {
        'id': 'edu_004',
        'title': 'Building Healthy Financial Habits',
        'content':
            'Financial success is less about big decisions and more about the small habits you build every day.\n\n## Pay Yourself First\n\nBefore paying any bills or expenses, transfer a set amount to your savings account the moment you receive your income. This ensures saving always happens, not just when there\'s money left over.\n\n## Automate Your Finances\n\nSet up automatic transfers for savings and automatic payments for recurring bills. Automation removes the need for willpower and reduces the chance of late payments.\n\n## Review Your Finances Weekly\n\nSpend 10–15 minutes each week reviewing your transactions. Are you on track with your budget? Did anything unexpected come up? This habit keeps you informed and in control.\n\n## Avoid Lifestyle Inflation\n\nAs your income grows, resist the urge to immediately increase your spending. Instead, channel raises and bonuses into savings and investments first.\n\n## Celebrate Small Wins\n\nReached your emergency fund goal? Paid off a credit card? Celebrate it. Positive reinforcement helps maintain healthy habits long-term.',
        'image_url': '',
        'category': 'HABITS',
        'created_at': '2024-01-08T00:00:00.000Z',
      },
    ];

    for (final article in seeds) {
      await DbHelper.insertArticle(article);
    }
  }
}