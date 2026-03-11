import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';

class AccountMenuTile extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback? onTap;

  const AccountMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.surfaceLight, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            AppIcons.svg(icon, width: 24, height: 24, color: AppColors.bw4),
            const SizedBox(width: 8),
            Text(title, style: AppTextStyles.h4Mob),
          ],
        ),
      ),
    );
  }
}
