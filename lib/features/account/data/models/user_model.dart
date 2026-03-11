class UserModel {
  final int id;
  final String name;
  final String login;
  final String email;
  final bool hasNsfwPin;
  final bool allowNsfw;
  final TariffModel? tariff;
  final String? language;

  const UserModel({
    required this.id,
    required this.name,
    required this.login,
    required this.email,
    this.hasNsfwPin = false,
    this.allowNsfw = false,
    this.tariff,
    this.language,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      login: json['login'] as String? ?? '',
      email: json['email'] as String? ?? '',
      hasNsfwPin: json['has_nsfw_pin'] as bool? ?? false,
      allowNsfw: json['allow_nsfw'] as bool? ?? false,
      tariff: json['tariff'] is Map<String, dynamic>
          ? TariffModel.fromJson(json['tariff'] as Map<String, dynamic>)
          : null,
      language: json['language'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'login': login,
        'email': email,
        'has_nsfw_pin': hasNsfwPin,
        'allow_nsfw': allowNsfw,
        'tariff': tariff?.toJson(),
        'language': language,
      };
}

class TariffModel {
  final int id;
  final String title;
  final String description;
  final String? expirationDate;
  final bool isExpired;

  const TariffModel({
    required this.id,
    required this.title,
    required this.description,
    this.expirationDate,
    this.isExpired = false,
  });

  factory TariffModel.fromJson(Map<String, dynamic> json) {
    return TariffModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      expirationDate: json['expiration_date'] as String?,
      isExpired: json['is_expired'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'expiration_date': expirationDate,
        'is_expired': isExpired,
      };
}
