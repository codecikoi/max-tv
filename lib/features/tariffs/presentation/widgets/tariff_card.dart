import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/tariff_model.dart';

class TariffCard extends StatelessWidget {
  final TariffModel tariff;
  final Gradient buttonGradient;
  final List<Color> bgGradientColors;
  final VoidCallback? onTap;

  const TariffCard({
    super.key,
    required this.tariff,
    required this.buttonGradient,
    required this.bgGradientColors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.bottomCenter,
          radius: 0.95,
          colors: bgGradientColors,
        ),
        border: Border.all(color: AppColors.surfaceLight),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tariff.title, style: AppTextStyles.h3Mob),
          const SizedBox(height: 12),
          _buildTags(),
          const SizedBox(height: 20),
          Text('${tariff.price} ₪', style: AppTextStyles.titleBounded),
          const SizedBox(height: 20),
          Divider(color: AppColors.bw4.withValues(alpha: 0.4), height: 1),
          if (tariff.description.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(tariff.description, style: AppTextStyles.captionMob),
          ],
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: buttonGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Выбрать', style: AppTextStyles.fieldLabel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags() {
    final tags = <String>[
      '${tariff.channelsCount}+ каналов',
      // TODO: нужны данные (смотреть фигму)
      if (tariff.videoLibrary) 'Видеотека',
      if (tariff.archive) 'Архив каналов',
    ];

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (int i = 0; i < tags.length; i++) ...[
          Text(tags[i].toUpperCase(), style: AppTextStyles.tagMob),
          if (i < tags.length - 1)
            Text(
              '|',
              style: AppTextStyles.tagMob.copyWith(
                color: AppColors.surfaceLight,
              ),
            ),
        ],
      ],
    );
  }
}
