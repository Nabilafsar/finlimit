class LimitModel {
  final int dailyLimit;
  final int usedLimit;

  LimitModel({
    required this.dailyLimit,
    required this.usedLimit,
  });

  double get percentageUsed {
    return usedLimit / dailyLimit;
  }
}