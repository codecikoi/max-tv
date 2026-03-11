import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_images.dart';
import '../../../../core/theme/app_text_styles.dart';

class PinSuccessScreen extends StatelessWidget {
  final String title;
  final String? subtitle;

  const PinSuccessScreen({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.pop(context, true),
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
                      onTap: () => Navigator.pop(context, true),
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
                  AppImages.png('img_pin_restart', width: 107, height: 124),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: AppTextStyles.h3Mob,
                    textAlign: TextAlign.center,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      style: AppTextStyles.captionMob.copyWith(
                        color: AppColors.bw6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context, true),
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
