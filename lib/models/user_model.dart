class UserModel {
  final String id;
  final String fullname;
  final String email;
  final String password;
  final double monthlyLimit;
  final double dailyLimit;   
  final double balance;      
  final String createdAt;

UserModel({
    required this.id,
    required this.fullname,
    required this.email,
    required this.password,
    required this.monthlyLimit,
    required this.dailyLimit,   
    required this.balance,      
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
      'password': password,
      'monthly_limit': monthlyLimit,
      'daily_limit': dailyLimit,   
      'balance': balance,          
      'created_at': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      fullname: map['fullname'],
      email: map['email'],
      password: map['password'],
      monthlyLimit: (map['monthly_limit'] as num?)?.toDouble() ?? 0.0,
      dailyLimit: (map['daily_limit'] as num?)?.toDouble() ?? 0.0,   
      balance: (map['balance'] as num?)?.toDouble() ?? 0.0,          
      createdAt: map['created_at'],
    );
  }
}