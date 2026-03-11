import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_images.dart';
import '../../../../core/theme/app_text_styles.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  int? _expandedIndex;

  static const _faqItems = [
    'Что мне нужно для подключения?',
    'Где вы находитесь и как с вами связаться?',
    'Как смотреть MAX TV?',
    'Что делать если у меня пропал канал?',
  ];

  static const _faqAnswer =
      'Мы можем изменять список телеканалов, входящих в пакет вещания, '
      'не злоупотребляя этим. Также, мы можем добавлять телеканалы в пакет '
      'предоставляемых услуг. Добавленные каналы появятся в списке автоматически.';

  @override
  void initState() {
    super.initState();
    _expandedIndex = 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 8),
            _buildHeader(),
            const SizedBox(height: 32),
            _buildHeroSection(),
            const SizedBox(height: 24),
            _buildContactButton(),
            const SizedBox(height: 32),
            _buildFaqSection(),
            const SizedBox(height: 32),
            _buildContactInfo(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => context.pop(),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: AppIcons.svg(
            'ic_arrow_back',
            width: 12,
            height: 12,
            color: AppColors.bw6,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        AppImages.png('img_support', width: 149, height: 130),
        const SizedBox(height: 20),
        Text(
          'Поддержка',
          style: AppTextStyles.titleBounded,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Ознакомьтесь с часто задаваемыми\nвопросами, если ответа нет, напишите нам',
          style: AppTextStyles.captionMob.copyWith(color: AppColors.bw6),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContactButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          'Написать нам',
          style: AppTextStyles.fieldLabel.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildFaqSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Частые вопросы',
          style: TextStyle(
            fontFamily: 'Bounded',
            fontVariations: const [FontVariation('wght', 566)],
            fontSize: 24,
            height: 30 / 24,
            color: AppColors.bw9999,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(_faqItems.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < _faqItems.length - 1 ? 12 : 0,
            ),
            child: _buildFaqCard(index),
          );
        }),
      ],
    );
  }

  Widget _buildFaqCard(int index) {
    final isExpanded = _expandedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedIndex = isExpanded ? null : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceLight),
          gradient: isExpanded
              ? const RadialGradient(
                  center: Alignment.bottomLeft,
                  radius: 2.6,
                  colors: [Color(0x66FB6051), Colors.transparent],
                )
              : null,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(_faqItems[index], style: AppTextStyles.h3Mob),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(70),
                  ),
                  child: Center(
                    child: AnimatedRotation(
                      turns: isExpanded ? 0 : 0.5,
                      duration: const Duration(milliseconds: 250),
                      child: AppIcons.svg(
                        'ic_arrow_up',
                        width: 8,
                        height: 8,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _faqAnswer,
                  style: AppTextStyles.fieldLabel.copyWith(
                    color: AppColors.bw6,
                    letterSpacing: -0.14,
                  ),
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('*2769', style: AppTextStyles.h3Mob),
            const SizedBox(width: 16),
            _buildSocialIcon('ic_facebook', 10, 19),
            const SizedBox(width: 16),
            _buildSocialIcon('ic_whatsapp', 20, 20),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          'Время работы',
          style: AppTextStyles.fieldLabel.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Технический отдел',
                    style: AppTextStyles.fieldLabel.copyWith(
                      color: AppColors.bw4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Круглосуточно\nБез выходных',
                    style: AppTextStyles.captionMob.copyWith(
                      color: AppColors.bw4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Отдел продаж',
                    style: AppTextStyles.fieldLabel.copyWith(
                      color: AppColors.bw4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '11:00 — 19:00\nКроме субботы',
                    style: AppTextStyles.captionMob.copyWith(
                      color: AppColors.bw4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(
    String iconName,
    double iconWidth,
    double iconHeight,
  ) {
    return Container(
      width: 39,
      height: 39,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(24.375),
      ),
      child: Center(
        child: AppIcons.svg(
          iconName,
          width: iconWidth,
          height: iconHeight,
          color: Colors.white,
        ),
      ),
    );
  }
}
