import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SkeletonChannelList extends StatelessWidget {
  const SkeletonChannelList({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: AppColors.surfaceLight,
        highlightColor: AppColors.surfaceLight.withValues(alpha: 0.5),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        separatorBuilder: (_, _) => const SizedBox(height: 2),
        itemBuilder: (_, _) => const _SkeletonChannelCard(),
      ),
    );
  }
}

class _SkeletonChannelCard extends StatelessWidget {
  const _SkeletonChannelCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone.square(
            size: 42,
            uniRadius: 8,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(
                  words: 2,
                  style: AppTextStyles.h4Mob,
                ),
                const SizedBox(height: 4),
                Bone.text(
                  words: 3,
                  style: AppTextStyles.captionMob,
                ),
                const SizedBox(height: 2),
                Bone.text(
                  words: 2,
                  style: AppTextStyles.captionMob,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
