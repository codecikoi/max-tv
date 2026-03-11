import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const _inter = 'Inter';
  static const _bounded = 'Bounded';

  static const buttonText = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w500,
    fontSize: 18,
    height: 24 / 18,
    letterSpacing: -0.18,
    color: AppColors.bw9999,
  );

  static const caption = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 22 / 16,
    color: AppColors.bw9999,
  );

  static const bodyRegular = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 18 / 14,
    letterSpacing: -0.14,
    color: AppColors.bw9999,
  );

  static const inputText = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w400,
    fontSize: 18,
    height: 24 / 18,
    letterSpacing: -0.18,
    color: AppColors.bw9999,
  );

  static const placeholder = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w400,
    fontSize: 18,
    height: 24 / 18,
    letterSpacing: -0.18,
    color: AppColors.bw4,
  );

  static const tabLabel = TextStyle(
    fontFamily: _bounded,
    fontWeight: FontWeight.w400,
    fontSize: 10,
    height: 12 / 10,
  );

  static final titleBounded = TextStyle(
    fontFamily: _bounded,
    fontVariations: const [FontVariation('wght', 700)],
    fontSize: 20,
    height: 26 / 20,
    color: AppColors.bw9999,
  );

  static const titleLarge = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w700,
    fontSize: 22,
    height: 28 / 22,
    color: AppColors.bw9999,
  );

  static const titleMedium = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w600,
    fontSize: 18,
    height: 24 / 18,
    color: AppColors.bw9999,
  );

  static const bodySmall = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 18 / 13,
    color: AppColors.textSecondary,
  );

  static final h3Mob = TextStyle(
    fontFamily: _bounded,
    fontVariations: const [FontVariation('wght', 566)],
    fontSize: 16,
    height: 24 / 16,
    color: AppColors.bw9999,
  );

  static const fieldLabel = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 18 / 14,
    color: AppColors.bw9999,
  );

  static final h2Mob = TextStyle(
    fontFamily: _bounded,
    fontVariations: const [FontVariation('wght', 566)],
    fontSize: 18,
    height: 24 / 18,
    color: AppColors.bw9999,
  );

  static const tagMob = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 14 / 10,
    letterSpacing: 1.1,
    color: AppColors.bw4,
  );

  static const captionMob = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 14 / 12,
    color: AppColors.bw4,
  );

  static const captionSmall = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 16 / 12,
    color: AppColors.textSecondary,
  );
}
