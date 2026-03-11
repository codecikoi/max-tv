import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppSearchField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String hintText;

  const AppSearchField({
    super.key,
    this.onChanged,
    this.controller,
    this.hintText = 'Поиск канала',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.bodyRegular,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.placeholder,
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.bw4,
            size: 24,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
        ),
      ),
    );
  }
}
