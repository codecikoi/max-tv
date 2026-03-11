import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SkeletonProgramList extends StatelessWidget {
  const SkeletonProgramList({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: AppColors.surfaceLight,
        highlightColor: AppColors.surfaceLight.withValues(alpha: 0.5),
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        separatorBuilder: (_, _) => const SizedBox(height: 4),
        itemBuilder: (_, _) => const _SkeletonProgramTile(),
      ),
    );
  }
}

class _SkeletonProgramTile extends StatelessWidget {
  const _SkeletonProgramTile();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone.text(
            words: 2,
            style: AppTextStyles.h4Mob,
          ),
          const SizedBox(height: 8),
          Bone.text(
            words: 3,
            style: AppTextStyles.captionMob,
          ),
          const SizedBox(height: 2),
          Bone.text(
            words: 5,
            style: AppTextStyles.captionMob,
          ),
        ],
      ),
    );
  }
}
