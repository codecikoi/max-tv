import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
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

  String? _validate() {
    final login = _loginController.text.trim();
    final password = _passwordController.text;
    if (login.isEmpty || password.isEmpty) {
      return 'Заполните все поля';
    }
    if (!_loginRegex.hasMatch(login)) {
      return 'Логин: 4–30 символов, латиница, цифры, _, -';
    }
    if (!_passwordRegex.hasMatch(password)) {
      return 'Пароль: 8–64 символа';
    }
    return null;
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
          if (state is AuthRegistered) {
            context.go('/channels');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.live,
              ),
            );
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
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Создайте логин и пароль',
                    style: AppTextStyles.h3Mob,
                  ),
                  const SizedBox(height: 32),
                  AppTextField(
                    controller: _loginController,
                    label: 'Логин',
                    hint: 'Придумайте логин',
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _passwordController,
                    label: 'Пароль',
                    hint: 'Придумайте пароль',
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
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
                          if (error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error),
                                backgroundColor: AppColors.live,
                              ),
                            );
                            return;
                          }
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
