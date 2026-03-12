import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/channel_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchCubit>(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: AppIcons.svg(
                      'ic_arrow_back',
                      width: 12,
                      height: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          AppIcons.svg(
                            'ic_search',
                            width: 24,
                            height: 24,
                            color: AppColors.iconInactive,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              style: AppTextStyles.bodyRegular.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Поиск',
                                hintStyle: AppTextStyles.bodyRegular.copyWith(
                                  color: AppColors.iconInactive,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (value) => cubit.search(value),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SearchTabs(onModeChanged: (mode) => cubit.setMode(mode)),
            ),
            const SizedBox(height: 8),
            const Expanded(child: _SearchResults()),
          ],
        ),
      ),
    );
  }
}

class _SearchTabs extends StatefulWidget {
  final ValueChanged<SearchMode> onModeChanged;

  const _SearchTabs({required this.onModeChanged});

  @override
  State<_SearchTabs> createState() => _SearchTabsState();
}

class _SearchTabsState extends State<_SearchTabs> {
  SearchMode _selected = SearchMode.channels;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildTab('ТВ-каналы', SearchMode.channels),
        const SizedBox(width: 8),
        _buildTab('Телепередачи', SearchMode.programs),
      ],
    );
  }

  Widget _buildTab(String label, SearchMode mode) {
    final isActive = _selected == mode;
    return GestureDetector(
      onTap: () {
        setState(() => _selected = mode);
        widget.onModeChanged(mode);
      },
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: isActive ? AppColors.primaryGradient : null,
          color: isActive ? null : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.fieldLabel.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchInitial) {
          return const SizedBox.shrink();
        }
        if (state is SearchLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.hovered),
          );
        }
        if (state is SearchError) {
          return Center(
            child: Text(
              state.message,
              style: AppTextStyles.bodyRegular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          );
        }
        if (state is SearchChannelsLoaded) {
          if (state.channels.isEmpty) {
            return _buildEmpty();
          }
          return _buildChannelsList(context, state);
        }
        if (state is SearchProgramsLoaded) {
          if (state.programs.isEmpty) {
            return _buildEmpty();
          }
          return _buildProgramsList(context, state);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text(
        'Ничего не найдено',
        style: AppTextStyles.bodyRegular.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildChannelsList(BuildContext context, SearchChannelsLoaded state) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter < 200 &&
            state.meta.hasNextPage) {
          context.read<SearchCubit>().loadNextPage();
        }
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: state.channels.length,
        separatorBuilder: (_, _) => const SizedBox(height: 2),
        itemBuilder: (context, index) {
          final channel = state.channels[index];
          return ChannelCard(
            channel: channel,
            onTap: () => context.push(
              '/channels/player/${channel.id}',
              extra: {
                'streamUrl': channel.streamUrl,
                'channelName': channel.name,
                'channelLogoUrl': channel.logoUrl,
                'isFavourite': channel.isFavourite,
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgramsList(BuildContext context, SearchProgramsLoaded state) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter < 200 &&
            state.meta.hasNextPage) {
          context.read<SearchCubit>().loadNextPage();
        }
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: state.programs.length,
        separatorBuilder: (_, _) => const SizedBox(height: 2),
        itemBuilder: (context, index) {
          final program = state.programs[index];
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  program.title,
                  style: AppTextStyles.h4Mob,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (program.formattedStartTime != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${program.formattedStartTime} - ${program.formattedEndTime ?? ''}',
                    style: AppTextStyles.captionMob.copyWith(
                      color: AppColors.bw6,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
