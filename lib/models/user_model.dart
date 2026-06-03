class UserModel {
  final String id;
  final String fullname;
  final String email;
  final String password;
  final double monthlyLimit;
  final String createdAt;

  UserModel({
    required this.id,
    required this.fullname,
    required this.email,
    required this.password,
    required this.monthlyLimit,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
      'password': password,
      'monthly_limit': monthlyLimit,
      'created_at': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      fullname: map['fullname'],
      email: map['email'],
      password: map['password'],
      monthlyLimit: map['monthly_limit'],
      createdAt: map['created_at'],
    );
  }
}