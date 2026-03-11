import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_images.dart';
import '../../../../core/theme/app_text_styles.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          Positioned.fill(child: _PosterBackground()),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.scaffoldBackground.withValues(alpha: 0.0),
                    AppColors.scaffoldBackground.withValues(alpha: 0.4),
                    AppColors.scaffoldBackground.withValues(alpha: 0.9),
                    AppColors.scaffoldBackground,
                  ],
                  stops: const [0.0, 0.3, 0.5, 0.6],
                ),
              ),
              child: const SizedBox.expand(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Spacer(),
                  AppImages.png('img_logo', width: 143, height: 60),
                  const SizedBox(height: 40),
                  Text(
                    'Лучшие телеканалы\nв одном месте',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleBounded,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Тысячи фильмов и сериалов всегда под рукой\nв любое время всего за 79 ₪',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyRegular.copyWith(
                      color: AppColors.chevron,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 56),
                  _GradientButton(
                    label: 'Войти',
                    onTap: () => context.go('/login'),
                  ),
                  const SizedBox(height: 8),
                  _GlassButton(
                    label: 'Зарегистрироваться',
                    onTap: () => context.go('/register'),
                  ),
                  const SizedBox(height: 34),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PosterBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppImages.png('img_login_bg', fit: BoxFit.cover);
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _GradientButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(label, style: AppTextStyles.buttonText),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _GlassButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(label, style: AppTextStyles.buttonText),
          ),
        ),
      ),
    );
  }
}
