import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../channels/data/models/channel_model.dart';

class ProgramTile extends StatelessWidget {
  final CurrentProgram program;

  const ProgramTile({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (program.startTime != null)
            Text(
              '${program.startTime} - ${program.endTime ?? ''}',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          if (program.title != null) ...[
            const SizedBox(height: 4),
            Text(
              program.title!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
