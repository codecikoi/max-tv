import '../../../account/data/models/user_model.dart';

class RegisterEmailResponse {
  final bool success;
  final String message;
  final String? expiresAt;

  const RegisterEmailResponse({
    required this.success,
    required this.message,
    this.expiresAt,
  });

  factory RegisterEmailResponse.fromJson(Map<String, dynamic> json) {
    return RegisterEmailResponse(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      expiresAt: json['expires_at'] as String?,
    );
  }
}

class RegisterConfirmResponse {
  final bool success;
  final String message;
  final String? verifiedAt;

  const RegisterConfirmResponse({
    required this.success,
    required this.message,
    this.verifiedAt,
  });

  factory RegisterConfirmResponse.fromJson(Map<String, dynamic> json) {
    return RegisterConfirmResponse(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      verifiedAt: json['verified_at'] as String?,
    );
  }
}

class RegisterCompleteResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final UserModel? user;

  const RegisterCompleteResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    this.user,
  });

  factory RegisterCompleteResponse.fromJson(Map<String, dynamic> json) {
    return RegisterCompleteResponse(
      accessToken: json['access_token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
      tokenType: json['token_type'] as String? ?? 'Bearer',
      expiresIn: json['expires_in'] as int? ?? 0,
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
}
