import 'package:flutter/material.dart';

class AppColors {
  // BW Palette (from UI kit)
  static const bw0 = Color(0xFF19191A);
  static const bw1 = Color(0xFF121113);
  static const bw2 = Color(0xFF252527);
  static const bw3 = Color(0xFF242424);
  static const bw4 = Color(0xFF6C6C75);
  static const bw6 = Color(0xFFBDBDC2);
  static const bw5 = Color(0xFFFFFFFF);
  static const bw9999 = Color(0xFFFFFFFF);

  // Semantic aliases
  static const background = bw0;
  static const surface = bw3;
  static const surfaceLight = bw2;
  static const pillActive = bw1;
  static const textPrimary = bw9999;
  static const textSecondary = bw4;
  static const iconInactive = bw4;
  static const chevron = bw6;
  static const disabled = bw4;
  static const divider = Color(0xFF2C2C2E);

  // Gradient
  static const gradientStart = Color(0xFFFE5C96);
  static const gradientEnd = Color(0xFFFB5D48);
  static const hovered = Color(0xFFFD5D6B);

  static const primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [gradientStart, gradientEnd],
  );

  // LIVE badge
  static const live = Color(0xFFFF3B30);
}
