import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_images.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/repositories/account_repository.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String email;

  const ChangePasswordScreen({super.key, required this.email});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _emailController = TextEditingController();
  bool _sent = false;
  bool _loading = false;
  Timer? _timer;
  int _secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

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
                  _sent ? _buildSuccessContent() : _buildFormContent(),
                  const Spacer(flex: 2),
                  _sent ? _buildSuccessButtons() : _buildFormButtons(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent() {
    return Column(
      children: [
        Text('Смена пароля', style: AppTextStyles.h3Mob),
        const SizedBox(height: 8),
        Text(
          'Введите email. Мы вышлем вам ссылку\nдля восстановления пароля',
          style: AppTextStyles.captionMob.copyWith(color: AppColors.bw6),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
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
        GestureDetector(
          onTap: _loading ? null : _send,
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
                : Text('Далее', style: AppTextStyles.fieldLabel),
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
      ],
    );
  }

  Widget _buildSuccessContent() {
    return Column(
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
    );
  }

  Widget _buildSuccessButtons() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('Понятно', style: AppTextStyles.fieldLabel),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _secondsLeft > 0 ? null : _send,
          child: Container(
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.bw4,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Отправить повторно', style: AppTextStyles.fieldLabel),
                if (_secondsLeft > 0) ...[
                  const SizedBox(width: 8),
                  Text(
                    _timerText,
                    style: AppTextStyles.fieldLabel.copyWith(
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
