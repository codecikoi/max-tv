import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/channel_model.dart';

class ChannelCard extends StatelessWidget {
  final ChannelModel channel;
  final bool isActive;
  final VoidCallback? onTap;

  const ChannelCard({
    super.key,
    required this.channel,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? AppColors.surfaceLight : null,
          borderRadius: BorderRadius.circular(8),
        ),
        padding:
            const EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: channel.logoUrl != null
                  ? CachedNetworkImage(
                      imageUrl: channel.logoUrl!,
                      width: 72,
                      height: 42,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => _logoPlaceholder(),
                      errorWidget: (_, _, _) => _logoPlaceholder(),
                    )
                  : _logoPlaceholder(),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          channel.name,
                          style: AppTextStyles.h4Mob.copyWith(
                            color: isActive ? Colors.white : AppColors.bw6,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (channel.num != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '${channel.num}',
                          style: AppTextStyles.fieldLabel.copyWith(
                            color: isActive ? Colors.white : AppColors.bw4,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (channel.currentProgram?.title != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      channel.currentProgram!.title!,
                      style: AppTextStyles.captionMob.copyWith(
                        color: isActive ? Colors.white : AppColors.bw6,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (channel.currentProgram?.formattedStartTime != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${channel.currentProgram!.formattedStartTime} - ${channel.currentProgram!.formattedEndTime ?? ''}',
                      style: AppTextStyles.captionMob.copyWith(
                        color: isActive ? Colors.white : AppColors.bw6,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoPlaceholder() {
    return Container(
      width: 72,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.tv, color: AppColors.textSecondary, size: 20),
    );
  }
}
