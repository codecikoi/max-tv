import '../../../../core/network/token_storage.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_response_model.dart';
import '../models/register_response_model.dart';

class AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final TokenStorage _tokenStorage;

  AuthRepository(this._remoteDatasource, this._tokenStorage);

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _remoteDatasource.login(
      email: email,
      password: password,
    );
    await _tokenStorage.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    return response;
  }

  Future<RegisterEmailResponse> registerEmail({
    required String email,
    required String language,
  }) {
    return _remoteDatasource.registerEmail(email: email, language: language);
  }

  Future<RegisterConfirmResponse> registerConfirm({
    required String email,
    required String code,
  }) {
    return _remoteDatasource.registerConfirm(email: email, code: code);
  }

  Future<RegisterCompleteResponse> registerComplete({
    required String email,
    required String login,
    required String password,
  }) async {
    final response = await _remoteDatasource.registerComplete(
      email: email,
      login: login,
      password: password,
    );
    await _tokenStorage.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    return response;
  }

  Future<RegisterEmailResponse> registerResend({
    required String email,
    required String language,
  }) {
    return _remoteDatasource.registerResend(email: email, language: language);
  }

  Future<void> logout() async {
    await _tokenStorage.clearTokens();
  }

  Future<bool> isLoggedIn() => _tokenStorage.hasToken();
}
