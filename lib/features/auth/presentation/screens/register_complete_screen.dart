import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class RegisterCompleteScreen extends StatefulWidget {
  final String email;

  const RegisterCompleteScreen({super.key, required this.email});

  @override
  State<RegisterCompleteScreen> createState() => _RegisterCompleteScreenState();
}

class _RegisterCompleteScreenState extends State<RegisterCompleteScreen> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cubit = getIt<AuthCubit>();

  static final _loginRegex = RegExp(r'^[a-zA-Z0-9_-]{4,30}$');
  static final _passwordRegex = RegExp(r'^.{8,64}$');

  String? _loginError;
  String? _passwordError;

  String? _validate() {
    final login = _loginController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _loginError = null;
      _passwordError = null;
    });

    if (login.isEmpty) {
      setState(() => _loginError = 'Введите логин');
      return '';
    }
    if (!_loginRegex.hasMatch(login)) {
      setState(() => _loginError = 'Логин: 4–30 символов, латиница, цифры, _, -');
      return '';
    }
    if (password.isEmpty) {
      setState(() => _passwordError = 'Введите пароль');
      return '';
    }
    if (!_passwordRegex.hasMatch(password)) {
      setState(() => _passwordError = 'Пароль: 8–64 символа');
      return '';
    }
    return null;
  }

  void _clearErrors() {
    if (_loginError != null || _passwordError != null) {
      setState(() {
        _loginError = null;
        _passwordError = null;
      });
    }
    final state = _cubit.state;
    if (state is AuthError) {
      _cubit.resetState();
    }
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/channels');
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: AppIcons.svg(
                      'ic_arrow_back',
                      width: 12,
                      height: 12,
                      color: AppColors.bw6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Создайте логин и пароль',
                    style: AppTextStyles.h3Mob,
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<AuthCubit, AuthState>(
                    buildWhen: (prev, curr) =>
                        curr is AuthError || curr is AuthInitial || curr is AuthLoading,
                    builder: (context, state) {
                      final serverError = state is AuthError ? state.message : null;
                      return Column(
                        children: [
                          AppTextField(
                            controller: _loginController,
                            label: 'Логин',
                            hint: 'Придумайте логин',
                            keyboardType: TextInputType.visiblePassword,
                            errorText: _loginError,
                            onChanged: (_) => _clearErrors(),
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            controller: _passwordController,
                            label: 'Пароль',
                            hint: 'Придумайте пароль',
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            errorText: _passwordError ?? serverError,
                            onChanged: (_) => _clearErrors(),
                          ),
                        ],
                      );
                    },
                  ),
                  const Spacer(),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Center(
                          child: AppLoader(),
                        );
                      }
                      return AppButton.primary(
                        label: 'Подтвердить',
                        width: double.infinity,
                        onPressed: () {
                          final error = _validate();
                          if (error != null) return;
                          _cubit.registerComplete(
                            email: widget.email,
                            login: _loginController.text.trim(),
                            password: _passwordController.text,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 34),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
