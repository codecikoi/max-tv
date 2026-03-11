class UserModel {
  final String id;
  final String name;
  final String? email;
  final String subscriptionPlan;
  final DateTime? subscriptionExpiresAt;

  const UserModel({
    required this.id,
    required this.name,
    this.email,
    required this.subscriptionPlan,
    this.subscriptionExpiresAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      subscriptionPlan: json['subscription_plan'] as String,
      subscriptionExpiresAt: json['subscription_expires_at'] != null
          ? DateTime.parse(json['subscription_expires_at'] as String)
          : null,
    );
  }
}
