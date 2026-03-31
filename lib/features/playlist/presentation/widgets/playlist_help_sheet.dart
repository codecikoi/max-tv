import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_images.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

Future<void> showPlaylistHelpSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const _PlaylistHelpContent(),
  );
}

class _PlaylistHelpContent extends StatelessWidget {
  const _PlaylistHelpContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.bw4,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AppImages.png(
              'img_link_onboarding',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(height: 16),
          Text('Ссылка на плейлист', style: AppTextStyles.h3Mob),
          const SizedBox(height: 16),
          _buildStepRich([
            const TextSpan(text: 'В '),
            TextSpan(
              text: 'веб-версии MaxTV',
              style: AppTextStyles.captionMob.copyWith(
                color: const Color(0xFFFF737F),
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => launchUrl(
                  Uri.parse('https://maxtv.co.il/login'),
                  mode: LaunchMode.externalApplication,
                ),
            ),
            const TextSpan(
              text:
                  ' перейдите в «Настройки профиля» и найдите поле «Ссылка на плейлист»',
            ),
          ]),
          const SizedBox(height: 12),
          _buildStep('Нажмите кнопку «Скопировать» справа от ссылки'),
          const SizedBox(height: 12),
          _buildStep('Вставьте скопированную ссылку'),
          const SizedBox(height: 50),
          AppButton.primary(
            label: 'Понятно',
            width: double.infinity,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildStep(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 4),
          decoration: const BoxDecoration(
            color: Color(0xFFD9D9D9),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.captionMob.copyWith(color: AppColors.bw6),
          ),
        ),
      ],
    );
  }

  Widget _buildStepRich(List<TextSpan> spans) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 4),
          decoration: const BoxDecoration(
            color: Color(0xFFD9D9D9),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.captionMob.copyWith(color: AppColors.bw6),
              children: spans,
            ),
          ),
        ),
      ],
    );
  }
}
