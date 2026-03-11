class UserModel {
  final int id;
  final String login;
  final String email;
  final String? language;

  const UserModel({
    required this.id,
    required this.login,
    required this.email,
    this.language,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      login: json['login'] as String,
      email: json['email'] as String,
      language: json['language'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'login': login,
        'email': email,
        'language': language,
      };
}
