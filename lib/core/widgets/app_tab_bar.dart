import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
              selectedIcon: 'ic_tv_selected',
              unselectedIcon: 'ic_tv_unselected',
              label: 'Просмотр ТВ',
            ),
            _buildTab(
              index: 1,
              selectedIcon: 'ic_profile_selected',
              unselectedIcon: 'ic_profile_unselected',
              label: 'Профиль',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required int index,
    required String selectedIcon,
    required String unselectedIcon,
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
              if (isSelected)
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: SvgPicture.asset(
                    'assets/icons/$selectedIcon.svg',
                    width: 24,
                    height: 24,
                  ),
                )
              else
                SvgPicture.asset(
                  'assets/icons/$unselectedIcon.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.iconInactive,
                    BlendMode.srcIn,
                  ),
                ),
              if (isSelected) ...[
                const SizedBox(height: 4),
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    label,
                    style:
                        AppTextStyles.tabLabel.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
