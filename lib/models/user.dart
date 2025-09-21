class User {
  final String id;
  final String username;
  final String email;
  final String passwordHash;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      username: json['username'] as String,
      email: json['email'] as String,
      passwordHash: json['password_hash'] as String,
      createdAt: json['created_at'] is DateTime
          ? json['created_at'] as DateTime
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] is DateTime
          ? json['updated_at'] as DateTime
          : DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password_hash': passwordHash,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? username,
    String? email,
    String? passwordHash,
  }) {
    return User(
      id: id,
      username: username ?? this.username,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
