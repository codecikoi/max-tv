import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_loader.dart';
import '../cubit/epg_cubit.dart';
import '../cubit/epg_state.dart';

class EpgScreen extends StatelessWidget {
  final String channelId;

  const EpgScreen({super.key, required this.channelId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EpgCubit>()..loadChannel(int.parse(channelId)),
      child: const _EpgView(),
    );
  }
}

class _EpgView extends StatelessWidget {
  const _EpgView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Channel Details'),
      ),
      body: BlocBuilder<EpgCubit, EpgState>(
        builder: (context, state) {
          if (state is EpgLoading) {
            return const Center(child: AppLoader());
          }
          if (state is EpgError) {
            return Center(child: Text(state.message));
          }
          if (state is EpgLoaded) {
            final channel = state.channel;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: channel.logoUrl != null
                          ? CachedNetworkImage(
                              imageUrl: channel.logoUrl!,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => _logoPlaceholder(),
                            )
                          : _logoPlaceholder(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        channel.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border, color: AppColors.gradientStart),
                    ),
                  ],
                ),
                if (channel.description != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    channel.description!,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
                if (channel.currentProgram != null) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Current Program',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (channel.currentProgram!.title != null)
                          Text(
                            channel.currentProgram!.title!,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        if (channel.currentProgram!.startTime != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${channel.currentProgram!.startTime} - ${channel.currentProgram!.endTime ?? ''}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
                if (channel.categories != null && channel.categories!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Categories',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: channel.categories!.map((cat) {
                      return Chip(
                        label: Text(cat.name),
                        backgroundColor: AppColors.surface,
                      );
                    }).toList(),
                  ),
                ],
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _logoPlaceholder() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.tv, color: AppColors.textSecondary),
    );
  }
}
