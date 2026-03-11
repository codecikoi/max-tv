import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_loader.dart';
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
        child: BlocBuilder<ChannelsCubit, ChannelsState>(
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
                    onTap: () {
                      // TODO: open search
                    },
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text('Все телеканалы', style: AppTextStyles.caption),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          // TODO: filter
                        },
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
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state is ChannelsLoading) {
                        return const Center(child: AppLoader());
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
            );
          },
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
                  onTap: () {
                    // TODO: выбрать тариф
                  },
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
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: GestureDetector(
                  onTap: () {
                    // TODO: открыть чат
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Открыть чат', style: AppTextStyles.fieldLabel),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
