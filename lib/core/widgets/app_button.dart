import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum AppButtonVariant { primary, disabled, icon }

class AppButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Widget? icon;
  final double? width;

  const AppButton({
    super.key,
    this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.width,
  });

  const AppButton.primary({
    super.key,
    required String this.label,
    required this.onPressed,
    this.icon,
    this.width,
  }) : variant = AppButtonVariant.primary;

  const AppButton.disabled({
    super.key,
    required String this.label,
    this.icon,
    this.width,
  })  : variant = AppButtonVariant.disabled,
       onPressed = null;

  const AppButton.icon({
    super.key,
    required Widget this.icon,
    this.onPressed,
    this.width,
  })  : variant = AppButtonVariant.icon,
       label = null;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      AppButtonVariant.primary => _buildPrimary(),
      AppButtonVariant.disabled => _buildDisabled(),
      AppButtonVariant.icon => _buildIcon(),
    };
  }

  Widget _buildPrimary() {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: 44,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(label!, style: AppTextStyles.buttonText),
          ],
        ),
      ),
    );
  }

  Widget _buildDisabled() {
    return Container(
      width: width,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.disabled,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      child: Text(label!, style: AppTextStyles.buttonText),
    );
  }

  Widget _buildIcon() {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: icon,
          ),
        ),
      ),
    );
  }
}
