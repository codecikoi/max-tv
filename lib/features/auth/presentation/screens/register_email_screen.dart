import 'package:flutter/gestures.dart';
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

class RegisterEmailScreen extends StatefulWidget {
  const RegisterEmailScreen({super.key});

  @override
  State<RegisterEmailScreen> createState() => _RegisterEmailScreenState();
}

class _RegisterEmailScreenState extends State<RegisterEmailScreen> {
  final _emailController = TextEditingController();
  final _cubit = getIt<AuthCubit>();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      final hasText = _emailController.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthCodeSent) {
            context.push(
              '/register/confirm',
              extra: _emailController.text.trim(),
            );
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
                  Text('Создайте аккаунт', style: AppTextStyles.h3Mob),
                  const SizedBox(height: 32),
                  AppTextField(
                    controller: _emailController,
                    label: 'Почта',
                    hint: 'Введите e-mail',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const Spacer(),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Center(
                          child: AppLoader(),
                        );
                      }
                      if (_hasText) {
                        return AppButton.primary(
                          label: 'Зарегистрироваться',
                          width: double.infinity,
                          onPressed: () {
                            _cubit.registerEmail(
                              email: _emailController.text.trim(),
                            );
                          },
                        );
                      }
                      return AppButton.disabled(
                        label: 'Зарегистрироваться',
                        width: double.infinity,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Уже есть аккаунт? ',
                        style: AppTextStyles.bodyRegular.copyWith(
                          color: AppColors.chevron,
                        ),
                        children: [
                          TextSpan(
                            text: 'Войти',
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: AppColors.gradientStart,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.go('/login'),
                          ),
                        ],
                      ),
                    ),
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
