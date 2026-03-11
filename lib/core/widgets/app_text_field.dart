import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool obscureText;
  final bool enabled;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 6),
            child: Text(label!, style: AppTextStyles.fieldLabel),
          ),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(10),
            border: hasError
                ? Border.all(color: AppColors.error, width: 1)
                : null,
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            enabled: enabled,
            keyboardType: keyboardType,
            onChanged: onChanged,
            autocorrect: false,
            enableSuggestions: false,
            style: enabled
                ? AppTextStyles.inputText
                : AppTextStyles.inputText.copyWith(
                    color: AppColors.iconInactive,
                  ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.placeholder,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        if (hasError)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcons.svg('ic_error', width: 20, height: 20),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      errorText!,
                      style: AppTextStyles.captionSmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
