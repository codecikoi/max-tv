import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/register_response_model.dart';

class AuthRemoteDatasource {
  final DioClient _dioClient;

  AuthRemoteDatasource(this._dioClient);

  Future<AuthResponseModel> login({
    required String email,
    required String password,
    String? scope,
  }) async {
    final response = await _dioClient.dio.post('/login', data: {
      'email': email,
      'password': password,
      if (scope != null) 'scope': scope,
    });
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<RegisterEmailResponse> registerEmail({
    required String email,
    required String language,
  }) async {
    final response = await _dioClient.dio.post('/register/email', data: {
      'email': email,
      'language': language,
    });
    return RegisterEmailResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<RegisterConfirmResponse> registerConfirm({
    required String email,
    required String code,
  }) async {
    final response = await _dioClient.dio.post('/register/confirm', data: {
      'email': email,
      'code': code,
    });
    return RegisterConfirmResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<RegisterCompleteResponse> registerComplete({
    required String email,
    required String login,
    required String password,
  }) async {
    final response = await _dioClient.dio.post('/register/complete', data: {
      'email': email,
      'login': login,
      'password': password,
    });
    return RegisterCompleteResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<RegisterEmailResponse> registerResend({
    required String email,
    required String language,
  }) async {
    final response = await _dioClient.dio.post('/register/resend', data: {
      'email': email,
      'language': language,
    });
    return RegisterEmailResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
