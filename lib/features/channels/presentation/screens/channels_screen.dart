import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/skeleton_channel_card.dart';
import '../../data/models/channel_model.dart';
import '../cubit/channels_cubit.dart';
import '../cubit/channels_state.dart';
import '../widgets/category_filter_sheet.dart';
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

class _ChannelsView extends StatefulWidget {
  const _ChannelsView();

  @override
  State<_ChannelsView> createState() => _ChannelsViewState();
}

class _ChannelsViewState extends State<_ChannelsView> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  ChannelModel? _activeChannel;
  bool _hasError = false;
  bool _playerInitialized = false;
  FilterResult _currentFilter = const FilterResult(type: FilterType.all);

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _initPlayer(ChannelModel channel) async {
    if (_activeChannel?.id == channel.id && _playerInitialized) return;

    _chewieController?.dispose();
    _videoController?.dispose();
    _chewieController = null;
    _videoController = null;
    _hasError = false;
    _playerInitialized = true;
    _activeChannel = channel;
    setState(() {});

    if (channel.streamUrl == null || channel.streamUrl!.isEmpty) {
      setState(() => _hasError = true);
      return;
    }

    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(channel.streamUrl!),
    );

    try {
      await _videoController!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        isLive: true,
        showOptions: false,
        showControls: true,
        allowFullScreen: true,
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.hovered,
          handleColor: AppColors.hovered,
          bufferedColor: AppColors.bw4,
          backgroundColor: AppColors.surfaceLight,
        ),
      );
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  Future<void> _onChannelTap(ChannelModel channel) async {
    // Stop current stream completely before navigating
    _chewieController?.pause();
    _videoController?.pause();

    // Update active channel for highlighting
    setState(() => _activeChannel = channel);

    // Navigate to player screen and wait for return
    await context.push(
      '/channels/player/${channel.id}',
      extra: {
        'streamUrl': channel.streamUrl,
        'channelName': channel.name,
        'channelLogoUrl': channel.logoUrl,
        'isFavourite': channel.isFavourite,
      },
    );

    // When returning, init player for the active channel
    if (mounted) {
      _playerInitialized = false;
      _initPlayer(channel);
    }
  }

  Future<void> _openFilter() async {
    final result = await showCategoryFilterSheet(
      context,
      currentFilter: _currentFilter,
    );
    if (result == null || !mounted) return;

    setState(() => _currentFilter = result);
    final cubit = context.read<ChannelsCubit>();

    switch (result.type) {
      case FilterType.all:
        cubit.loadChannels();
        break;
      case FilterType.favorites:
        cubit.loadFavorites();
        break;
      case FilterType.category:
        if (result.categoryId != null) {
          cubit.loadByCategory(result.categoryId!);
        }
        break;
    }
  }

  String get _filterLabel {
    switch (_currentFilter.type) {
      case FilterType.all:
        return 'Все телеканалы';
      case FilterType.favorites:
        return 'Избранные';
      case FilterType.category:
        return _currentFilter.categoryName ?? 'Категория';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ChannelsCubit, ChannelsState>(
          listener: (context, state) {
            if (state is ChannelsLoaded &&
                state.channels.isNotEmpty &&
                !_playerInitialized) {
              _initPlayer(state.channels.first);
            }
          },
          builder: (context, state) {
            if (state is ChannelsTariffExpired) {
              return const _TariffExpiredScreen();
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: GestureDetector(
                    onTap: () => context.push('/channels/search'),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          const SizedBox(width: 10),
                          Text(
                            'Поиск канала',
                            style: AppTextStyles.bodyRegular.copyWith(
                              color: AppColors.iconInactive,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Embedded player
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: _hasError
                          ? _buildErrorView()
                          : _chewieController != null
                          ? Chewie(controller: _chewieController!)
                          : const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.hovered,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(_filterLabel, style: AppTextStyles.caption),
                      const Spacer(),
                      GestureDetector(
                        onTap: _openFilter,
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 16,
                            top: 6,
                            bottom: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppIcons.svg(
                                'ic_sort',
                                width: 24,
                                height: 24,
                                color: AppColors.textPrimary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Фильтр',
                                style: AppTextStyles.fieldLabel.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state is ChannelsLoading) {
                        return const SkeletonChannelList();
                      }
                      if (state is ChannelsError) {
                        return Center(child: Text(state.message));
                      }
                      if (state is ChannelsLoaded) {
                        return NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification is ScrollEndNotification &&
                                notification.metrics.extentAfter < 200 &&
                                state.meta.hasNextPage) {
                              context.read<ChannelsCubit>().loadNextPage();
                            }
                            return false;
                          },
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: state.channels.length + (state.meta.hasNextPage ? 1 : 0),
                            separatorBuilder: (_, _) => const SizedBox(height: 2),
                            itemBuilder: (context, index) {
                              if (index >= state.channels.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.hovered,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              }
                              final channel = state.channels[index];
                              final isActive = _activeChannel?.id == channel.id;
                              return ChannelCard(
                                channel: channel,
                                isActive: isActive,
                                onTap: () => _onChannelTap(channel),
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Container(
      color: AppColors.surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcons.svg(
              'ic_play',
              width: 48,
              height: 48,
              color: AppColors.live,
            ),
            const SizedBox(height: 8),
            const Text(
              'Не удалось загрузить поток',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _TariffExpiredScreen extends StatelessWidget {
  const _TariffExpiredScreen();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(color: Colors.black.withValues(alpha: 0.4)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 120),
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 257,
                    height: 96,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E0E11),
                      gradient: const LinearGradient(
                        colors: [Color(0x000E0E11), Color(0xFFFD5D6B)],
                      ),
                      border: Border.all(color: AppColors.surfaceLight),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Требуется\nпродление',
                      style: AppTextStyles.titleBounded.copyWith(
                        fontSize: 28,
                        height: 40 / 28,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: -24,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: dismiss
                      },
                      child: Container(
                        width: 49,
                        height: 49,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 12.3,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: AppIcons.svg(
                            'ic_close',
                            width: 30,
                            height: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Срок вашей подписки истёк',
                style: AppTextStyles.h3Mob,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Для доступа к телеканалам необходимо\nактивировать новую подписку',
                style: AppTextStyles.captionSmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.bw6,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: GestureDetector(
                  onTap: () => context.push('/tariffs'),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Выбрать тариф',
                      style: AppTextStyles.fieldLabel,
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 12),
              // SizedBox(
              //   width: double.infinity,
              //   height: 40,
              //   child: GestureDetector(
              //     onTap: () {
              //       // TODO: открыть чат
              //     },
              //     child: Container(
              //       alignment: Alignment.center,
              //       decoration: BoxDecoration(
              //         color: AppColors.surfaceLight,
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //       child: Text('Открыть чат', style: AppTextStyles.fieldLabel),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
