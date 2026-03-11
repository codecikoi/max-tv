import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/repositories/account_repository.dart';

class ResetPinScreen extends StatefulWidget {
  final VoidCallback onChangePassword;

  const ResetPinScreen({super.key, required this.onChangePassword});

  @override
  State<ResetPinScreen> createState() => _ResetPinScreenState();
}

class _ResetPinScreenState extends State<ResetPinScreen> {
  final _repo = getIt<AccountRepository>();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _resetPin() async {
    if (_loading) return;
    final password = _passwordController.text.trim();
    if (password.isEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _repo.resetNsfwPin(password);
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        _passwordController.clear();
        setState(() {
          _loading = false;
          _error = 'Неверный пароль';
        });
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) setState(() => _error = null);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(color: Colors.black.withValues(alpha: 0.4)),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: AppIcons.svg(
                          'ic_arrow_back',
                          width: 12,
                          height: 12,
                          color: AppColors.bw6,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Введите пароль от аккаунта\nдля сброса ПИН-кода',
                    style: AppTextStyles.h3Mob,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: _passwordController,
                    hint: 'Введите пароль',
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    errorText: _error,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      widget.onChangePassword();
                    },
                    child: Text(
                      'Забыли пароль?',
                      style: AppTextStyles.fieldLabel.copyWith(
                        color: AppColors.hovered,
                        letterSpacing: -0.14,
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _loading ? null : _resetPin,
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Сбросить пин-код',
                              style: AppTextStyles.fieldLabel,
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Назад', style: AppTextStyles.fieldLabel),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
