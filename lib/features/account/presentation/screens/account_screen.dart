import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_loader.dart';
import '../cubit/account_cubit.dart';
import '../cubit/account_state.dart';
import '../widgets/account_menu_tile.dart';
import '../widgets/current_tariff_card.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AccountCubit>()..loadProfile(),
      child: const _AccountView(),
    );
  }
}

class _AccountView extends StatelessWidget {
  const _AccountView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AccountCubit, AccountState>(
          builder: (context, state) {
            if (state is AccountLoading) {
              return const Center(child: AppLoader());
            }

            final user = state is AccountLoaded ? state.user : null;
            final displayName = user?.name.isNotEmpty == true
                ? user!.name
                : 'Аккаунт';

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(33),
                      ),
                      child: Center(
                        child: AppIcons.svg(
                          'ic_profile_unselected',
                          width: 21,
                          height: 21,
                          color: AppColors.iconInactive,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        Text(displayName, style: AppTextStyles.h3Mob),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () async {
                            if (user == null) return;
                            final result = await context.push<bool>(
                              '/account/edit',
                              extra: user,
                            );
                            if (result == true && context.mounted) {
                              context.read<AccountCubit>().loadProfile();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: AppIcons.svg(
                              'ic_edit',
                              width: 24,
                              height: 24,
                              color: AppColors.iconInactive,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        context.read<AccountCubit>().clearProfile();
                        context.go('/login');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Выйти',
                            style: AppTextStyles.fieldLabel.copyWith(
                              color: AppColors.hovered,
                            ),
                          ),
                          const SizedBox(width: 12),
                          AppIcons.svg('ic_arrow_right', height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
                if (state is AccountEmpty) ...[
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'Войдите, чтобы увидеть профиль.',
                      style: AppTextStyles.bodySmall,
                    ),
                  ),
                ],
                if (user?.tariff != null) ...[
                  const SizedBox(height: 16),
                  CurrentTariffCard(tariff: user!.tariff!),
                ],
                const SizedBox(height: 12),
                _buildSubscriptionsCard(context),
                const SizedBox(height: 12),
                // AccountMenuTile(
                //   icon: 'ic_orders',
                //   title: 'Покупки',
                //   onTap: () {},
                // ),
                // const SizedBox(height: 12),
                AccountMenuTile(
                  icon: 'ic_settings',
                  title: 'Настройки',
                  onTap: () {
                    if (user == null) return;
                    context.push('/account/settings', extra: user);
                  },
                ),
                const SizedBox(height: 12),
                AccountMenuTile(
                  icon: 'ic_help',
                  title: 'Помощь',
                  onTap: () => context.push('/account/help'),
                ),
                const SizedBox(height: 24),
                _buildDeviceLink(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSubscriptionsCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/tariffs'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.surfaceLight, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Все подписки', style: AppTextStyles.h3Mob),
            const SizedBox(height: 8),
            Text(
              'Список всех тарифов',
              style: AppTextStyles.fieldLabel.copyWith(color: AppColors.bw6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: подключить устройство
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(color: Colors.transparent),
        child: Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: AppIcons.svg(
                'ic_devices',
                width: 24,
                height: 24,
                color: AppColors.bw9999,
              ),
            ),
            const SizedBox(width: 8),
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: Text('Подключить устройство', style: AppTextStyles.h4Mob),
            ),
          ],
        ),
      ),
    );
  }
}
