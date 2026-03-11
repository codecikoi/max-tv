import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_loader.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class RegisterConfirmScreen extends StatefulWidget {
  final String email;

  const RegisterConfirmScreen({super.key, required this.email});

  @override
  State<RegisterConfirmScreen> createState() => _RegisterConfirmScreenState();
}

class _RegisterConfirmScreenState extends State<RegisterConfirmScreen> {
  final _cubit = getIt<AuthCubit>();
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _secondsLeft = 600;
  bool _verified = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = 600;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        timer.cancel();
      }
    });
  }

  String get _timerText {
    final minutes = _secondsLeft ~/ 60;
    final seconds = _secondsLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get _code => _controllers.map((c) => c.text).join();

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthCodeVerified) {
            setState(() {
              _verified = true;
              _hasError = false;
            });
            final router = GoRouter.of(context);
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                router.push('/register/complete', extra: widget.email);
              }
            });
          } else if (state is AuthCodeSent) {
            _startTimer();
            for (final c in _controllers) {
              c.clear();
            }
            setState(() {
              _verified = false;
              _hasError = false;
            });
            _focusNodes[0].requestFocus();
          } else if (state is AuthError) {
            for (final c in _controllers) {
              c.clear();
            }
            setState(() {
              _hasError = true;
              _verified = false;
            });
            _focusNodes[0].requestFocus();
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
                    'На вашу почту отправлен код\nподтверждения',
                    style: AppTextStyles.h3Mob,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Пожалуйста, введите код подтверждения',
                    style: AppTextStyles.bodyRegular.copyWith(
                      color: AppColors.chevron,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                    children: List.generate(11, (i) {
                      if (i.isOdd) return const SizedBox(width: 14);
                      final index = i ~/ 2;
                      return Expanded(
                        child: _CodeCell(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          hasError: _hasError,
                          verified: _verified,
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              _focusNodes[index + 1].requestFocus();
                            }
                            if (value.isEmpty && index > 0) {
                              _focusNodes[index - 1].requestFocus();
                            }
                            setState(() {
                              if (_hasError) _hasError = false;
                            });
                          },
                        ),
                      );
                    }),
                  ),
                  ),
                  const SizedBox(height: 16),
                  if (_verified)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppIcons.svg('ic_approved', width: 24, height: 24),
                        const SizedBox(width: 6),
                        Text(
                          'Проверка пройдена успешно',
                          style: AppTextStyles.fieldLabel.copyWith(
                            color: AppColors.bw6,
                          ),
                        ),
                      ],
                    ),
                  if (_hasError)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppIcons.svg('ic_error', width: 24, height: 24),
                        const SizedBox(width: 10),
                        Text(
                          'Неверный код',
                          style: AppTextStyles.fieldLabel.copyWith(
                            color: AppColors.bw6,
                          ),
                        ),
                      ],
                    ),
                  const Spacer(),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Center(
                          child: AppLoader(),
                        );
                      }
                      if (_verified) {
                        return AppButton.primary(
                          label: 'Подтвердить',
                          width: double.infinity,
                          onPressed: () {
                            context.push(
                              '/register/complete',
                              extra: widget.email,
                            );
                          },
                        );
                      }
                      return Column(
                        children: [
                          _code.length == 6
                              ? AppButton.primary(
                                  label: 'Подтвердить',
                                  width: double.infinity,
                                  onPressed: () {
                                    _cubit.registerConfirm(
                                      email: widget.email,
                                      code: _code,
                                    );
                                  },
                                )
                              : AppButton.disabled(
                                  label: 'Подтвердить',
                                  width: double.infinity,
                                ),
                          const SizedBox(height: 8),
                          _ResendButton(
                            onTap: () {
                              _cubit.resendCode(email: widget.email);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      _timerText,
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: AppColors.chevron,
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

class _CodeCell extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final bool verified;
  final ValueChanged<String> onChanged;

  const _CodeCell({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.verified,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.transparent;
    if (hasError) borderColor = AppColors.error;
    if (verified) borderColor = AppColors.success;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: borderColor == Colors.transparent ? 0 : 1,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: AppTextStyles.titleBounded,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _ResendButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ResendButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.disabled,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text('Отправить снова', style: AppTextStyles.buttonText),
      ),
    );
  }
}
