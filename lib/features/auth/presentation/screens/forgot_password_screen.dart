import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(height: 24),
              Text('Восстановление пароля', style: AppTextStyles.h3Mob),
              const SizedBox(height: 8),
              Text(
                'Введите email. Мы вышлем вам ссылку\nдля восстановления пароля',
                style: AppTextStyles.bodyRegular.copyWith(
                  color: AppColors.chevron,
                ),
              ),
              const SizedBox(height: 24),
              AppTextField(
                controller: _emailController,
                label: 'Почта',
                hint: 'Введите почту',
                keyboardType: TextInputType.emailAddress,
              ),
              const Spacer(),
              AppButton.primary(
                label: 'Далее',
                width: double.infinity,
                onPressed: () {},
              ),
              const SizedBox(height: 8),
              _BackButton(onTap: () => context.pop()),
              const SizedBox(height: 34),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
    );
  }
}
