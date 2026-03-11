import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    final loggedIn = await _repository.isLoggedIn();
    emit(loggedIn ? AuthAuthenticated(accessToken: '') : AuthUnauthenticated());
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final response = await _repository.login(
        email: email,
        password: password,
      );
      emit(AuthAuthenticated(accessToken: response.accessToken));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> registerEmail({
    required String email,
    String language = 'ru',
  }) async {
    emit(AuthLoading());
    try {
      final response = await _repository.registerEmail(
        email: email,
        language: language,
      );
      emit(AuthCodeSent(
        message: response.message,
        expiresAt: response.expiresAt,
      ));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> registerConfirm({
    required String email,
    required String code,
  }) async {
    emit(AuthLoading());
    try {
      final response = await _repository.registerConfirm(
        email: email,
        code: code,
      );
      emit(AuthCodeVerified(message: response.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> registerComplete({
    required String email,
    required String login,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final response = await _repository.registerComplete(
        email: email,
        login: login,
        password: password,
      );
      emit(AuthRegistered(user: response.user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> resendCode({
    required String email,
    String language = 'ru',
  }) async {
    emit(AuthLoading());
    try {
      final response = await _repository.registerResend(
        email: email,
        language: language,
      );
      emit(AuthCodeSent(
        message: response.message,
        expiresAt: response.expiresAt,
      ));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(AuthUnauthenticated());
  }
}
