import 'package:equatable/equatable.dart';

import '../../data/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String accessToken;

  const AuthAuthenticated({required this.accessToken});

  @override
  List<Object?> get props => [accessToken];
}

class AuthRegistered extends AuthState {
  final UserModel user;

  const AuthRegistered({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthCodeSent extends AuthState {
  final String message;
  final String? expiresAt;

  const AuthCodeSent({required this.message, this.expiresAt});

  @override
  List<Object?> get props => [message, expiresAt];
}

class AuthCodeVerified extends AuthState {
  final String message;

  const AuthCodeVerified({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
