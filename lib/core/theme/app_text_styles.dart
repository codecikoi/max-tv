import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const _inter = 'Inter';
  static const _bounded = 'Bounded';

  // Text L/1440 — button text
  static const buttonText = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w500,
    fontSize: 18,
    height: 24 / 18,
    letterSpacing: -0.18,
    color: AppColors.bw9999,
  );

  // Caption/1920 — header, labels
  static const caption = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 22 / 16,
    color: AppColors.bw9999,
  );

  // Text Regular/Mob — body, search placeholder
  static const bodyRegular = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 18 / 14,
    letterSpacing: -0.14,
    color: AppColors.bw9999,
  );

  // Placeholder style
  static const placeholder = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 18 / 14,
    letterSpacing: -0.14,
    color: AppColors.bw4,
  );

  // Tab bar label (Bounded font)
  static const tabLabel = TextStyle(
    fontFamily: _bounded,
    fontWeight: FontWeight.w400,
    fontSize: 10,
    height: 12 / 10,
  );

  // Title large — onboarding, screen headers
  static const titleLarge = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w700,
    fontSize: 22,
    height: 28 / 22,
    color: AppColors.bw9999,
  );

  // Title medium
  static const titleMedium = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w600,
    fontSize: 18,
    height: 24 / 18,
    color: AppColors.bw9999,
  );

  // Body small
  static const bodySmall = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 18 / 13,
    color: AppColors.textSecondary,
  );

  // Caption small
  static const captionSmall = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 16 / 12,
    color: AppColors.textSecondary,
  );
}
