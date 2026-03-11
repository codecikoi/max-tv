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
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: 12 + bottomPadding,
      ),
      color: AppColors.background,
      child: Container(
        height: 56,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(48),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tabWidth = constraints.maxWidth / 2;
            return Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  left: currentIndex * tabWidth,
                  top: 0,
                  bottom: 0,
                  width: tabWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.pillActive,
                      borderRadius: BorderRadius.circular(33),
                    ),
                  ),
                ),
                Row(
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
              ],
            );
          },
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isSelected
                  ? ShaderMask(
                      key: ValueKey('${index}_selected'),
                      shaderCallback: (bounds) =>
                          AppColors.primaryGradient.createShader(bounds),
                      blendMode: BlendMode.srcIn,
                      child: SvgPicture.asset(
                        'assets/icons/$selectedIcon.svg',
                        width: 24,
                        height: 24,
                      ),
                    )
                  : SvgPicture.asset(
                      key: ValueKey('${index}_unselected'),
                      'assets/icons/$unselectedIcon.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppColors.iconInactive,
                        BlendMode.srcIn,
                      ),
                    ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: isSelected
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.primaryGradient.createShader(bounds),
                        blendMode: BlendMode.srcIn,
                        child: Text(
                          label,
                          style: AppTextStyles.tabLabel
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
