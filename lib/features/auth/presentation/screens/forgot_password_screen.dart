import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_images.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../account/data/repositories/account_repository.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _sent = false;
  bool _loading = false;
  Timer? _timer;
  int _secondsLeft = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _send() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      await getIt<AccountRepository>().sendPasswordResetEmail(
        _emailController.text.trim(),
      );
      if (mounted) {
        setState(() {
          _sent = true;
          _loading = false;
        });
        _startTimer();
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _startTimer() {
    _secondsLeft = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 0) {
        timer.cancel();
        if (mounted) setState(() {});
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  String get _timerText {
    final min = _secondsLeft ~/ 60;
    final sec = _secondsLeft % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _sent ? _buildSuccessContent() : _buildFormContent(),
              const Spacer(),
              _sent ? _buildSuccessButtons() : _buildFormButtons(),
              const SizedBox(height: 34),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Восстановление пароля', style: AppTextStyles.h3Mob),
        const SizedBox(height: 8),
        Text(
          'Введите email. Мы вышлем вам ссылку\nдля восстановления пароля',
          style: AppTextStyles.captionMob.copyWith(color: AppColors.bw6),
        ),
        const SizedBox(height: 24),
        AppTextField(
          controller: _emailController,
          label: 'Почта',
          hint: 'Введите почту',
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildFormButtons() {
    return Column(
      children: [
        _loading
            ? const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              )
            : AppButton.primary(
                label: 'Далее',
                width: double.infinity,
                onPressed: _send,
              ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text('Назад', style: AppTextStyles.buttonText),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessContent() {
    return Center(
      child: Column(
        children: [
          AppImages.png('img_message_sent', width: 106, height: 106),
          const SizedBox(height: 8),
          Text('Письмо отправлено', style: AppTextStyles.h3Mob),
          const SizedBox(height: 8),
          Text(
            'Мы отправили ссылку для восстановления\nпароля на вашу электронную почту',
            style: AppTextStyles.captionMob.copyWith(color: AppColors.bw6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessButtons() {
    return Column(
      children: [
        AppButton.primary(
          label: 'Понятно',
          width: double.infinity,
          onPressed: () => context.pop(),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _secondsLeft > 0 ? null : _send,
          child: Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Отправить повторно', style: AppTextStyles.buttonText),
                if (_secondsLeft > 0) ...[
                  const SizedBox(width: 8),
                  Text(
                    _timerText,
                    style: AppTextStyles.buttonText.copyWith(
                      color: AppColors.bw6,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
