import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/program_model.dart';

class ProgramTile extends StatelessWidget {
  final ProgramModel program;

  const ProgramTile({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                program.timeRange,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (program.isLive) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.live,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            program.title,
            style: TextStyle(
              color: program.isLive ? AppColors.textPrimary : AppColors.textSecondary,
              fontSize: 14,
              fontWeight: program.isLive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (program.season != null || program.episode != null)
            Text(
              [
                if (program.season != null) 'Сезон ${program.season}',
                if (program.episode != null) 'Эпизод ${program.episode}',
              ].join(', '),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          if (program.description != null) ...[
            const SizedBox(height: 4),
            Text(
              program.description!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
