import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/user_model.dart';

class CurrentTariffCard extends StatelessWidget {
  final TariffModel tariff;
  final VoidCallback? onTap;

  const CurrentTariffCard({super.key, required this.tariff, this.onTap});

  String _formatDate(String isoDate) {
    final date = DateTime.tryParse(isoDate);
    if (date == null) return isoDate;
    return DateFormat('dd.MM.yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromRGBO(34, 28, 28, 1),
              Color.fromRGBO(251, 96, 81, 0.6),
            ],
            stops: [0.0, 0.5],
          ),
          border: Border.all(color: AppColors.surfaceLight),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tariff.title, style: AppTextStyles.h3Mob),
                if (tariff.isExpired)
                  Text(
                    'Требуется продление',
                    style: AppTextStyles.captionMob.copyWith(
                      color: AppColors.hovered,
                    ),
                  )
                else if (tariff.expirationDate != null)
                  Text(
                    'До ${_formatDate(tariff.expirationDate!)}',
                    style: AppTextStyles.captionMob.copyWith(
                      color: AppColors.bw9999,
                    ),
                  ),
              ],
            ),
            if (tariff.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                tariff.description,
                style: AppTextStyles.fieldLabel.copyWith(color: AppColors.bw6),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
