import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_images.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../data/models/tariff_model.dart';
import '../../data/repositories/tariffs_repository.dart';
import '../cubit/tariffs_cubit.dart';
import '../cubit/tariffs_state.dart';
import '../widgets/tariff_card.dart';
import 'payment_webview_screen.dart';

class TariffsScreen extends StatelessWidget {
  const TariffsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TariffsCubit>()..loadTariffs(),
      child: const _TariffsView(),
    );
  }
}

class _TariffsView extends StatelessWidget {
  const _TariffsView();

  static const _redBgColors = [
    Color.fromRGBO(252, 101, 94, 0.3),
    Color.fromRGBO(34, 28, 28, 0),
  ];

  static const _purpleBgColors = [
    Color.fromRGBO(147, 94, 252, 0.3),
    Color.fromRGBO(34, 28, 28, 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: AppIcons.svg(
                  'ic_arrow_back',
                  width: 16,
                  height: 16,
                  color: AppColors.chevron,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: BlocBuilder<TariffsCubit, TariffsState>(
                builder: (context, state) {
                  if (state is TariffsLoading) {
                    return const Center(child: AppLoader());
                  }
                  if (state is TariffsError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is TariffsLoaded) {
                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        Text('Тарифные планы', style: AppTextStyles.h2Mob),
                        const SizedBox(height: 16),
                        ...state.tariffs.asMap().entries.map((entry) {
                          final index = entry.key;
                          final tariff = entry.value;
                          final isEven = index % 2 == 0;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TariffCard(
                              tariff: tariff,
                              buttonGradient: isEven
                                  ? AppColors.primaryGradient
                                  : AppColors.purpleGradient,
                              bgGradientColors: isEven
                                  ? _redBgColors
                                  : _purpleBgColors,
                              onTap: () => _openPayment(context, tariff),
                            ),
                          );
                        }),
                        const SizedBox(height: 24),
                        _buildHelpSection(),
                        const SizedBox(height: 40),
                      ],
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

  Future<void> _openPayment(BuildContext context, TariffModel tariff) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: AppLoader()),
      );
      final link = await getIt<TariffsRepository>().getPaymentLink(
        amount: tariff.price,
      );
      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PaymentWebViewScreen(
              url: link,
              tariffName: tariff.title,
            ),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  Widget _buildHelpSection() {
    return Column(
      children: [
        AppImages.png('img_support', height: 130),
        const SizedBox(height: 20),
        Text('Вопросы по тарифам?', style: AppTextStyles.titleBounded),
        const SizedBox(height: 16),
        Text(
          'Напишите нам, чтобы мы помогли с выбором',
          style: AppTextStyles.captionMob.copyWith(color: AppColors.bw6),
          textAlign: TextAlign.center,
        ),
        // const SizedBox(height: 40),
        // GestureDetector(
        //   onTap: () {
        //     // TODO: открыть чат
        //   },
        //   child: Container(
        //     width: double.infinity,
        //     height: 44,
        //     alignment: Alignment.center,
        //     decoration: BoxDecoration(
        //       color: AppColors.surfaceLight,
        //       borderRadius: BorderRadius.circular(8),
        //     ),
        //     child: Text('Написать в чат', style: AppTextStyles.fieldLabel),
        //   ),
        // ),
      ],
    );
  }
}
