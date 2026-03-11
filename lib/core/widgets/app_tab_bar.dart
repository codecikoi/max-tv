import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: AppColors.background,
      child: Container(
        height: 56,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(48),
        ),
        child: Row(
          children: [
            _buildTab(
              index: 0,
              icon: Icons.live_tv,
              label: 'Просмотр ТВ',
            ),
            _buildTab(
              index: 1,
              icon: Icons.person,
              label: 'Профиль',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 51,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.pillActive : Colors.transparent,
            borderRadius: BorderRadius.circular(33),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (bounds) {
                  if (isSelected) {
                    return AppColors.primaryGradient.createShader(bounds);
                  }
                  return const LinearGradient(
                    colors: [AppColors.iconInactive, AppColors.iconInactive],
                  ).createShader(bounds);
                },
                child: Icon(
                  icon,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              ShaderMask(
                shaderCallback: (bounds) {
                  if (isSelected) {
                    return AppColors.primaryGradient.createShader(bounds);
                  }
                  return const LinearGradient(
                    colors: [AppColors.iconInactive, AppColors.iconInactive],
                  ).createShader(bounds);
                },
                child: Text(
                  label,
                  style: AppTextStyles.tabLabel.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
