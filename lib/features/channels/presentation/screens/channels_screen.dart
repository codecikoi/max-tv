import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/channels_cubit.dart';
import '../cubit/channels_state.dart';
import '../widgets/channel_card.dart';

class ChannelsScreen extends StatelessWidget {
  const ChannelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChannelsCubit>()..loadChannels(),
      child: const _ChannelsView(),
    );
  }
}

class _ChannelsView extends StatelessWidget {
  const _ChannelsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (query) {
                  context.read<ChannelsCubit>().searchChannels(query);
                },
                decoration: InputDecoration(
                  hintText: 'Поиск канала',
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    'Все телеканалы',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.grid_view, color: AppColors.textSecondary),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list, size: 18),
                    label: const Text('Фильтр'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ChannelsCubit, ChannelsState>(
                builder: (context, state) {
                  if (state is ChannelsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ChannelsError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is ChannelsLoaded) {
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.channels.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        return ChannelCard(channel: state.channels[index]);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
