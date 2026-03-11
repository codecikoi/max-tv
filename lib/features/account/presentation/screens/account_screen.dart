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
                // Header
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
                        mainAxisAlignment: .center,
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
              ],
            );
          },
        ),
      ),
    );
  }
}
