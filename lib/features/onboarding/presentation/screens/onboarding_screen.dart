import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      title: 'Лучшие телеканалы\nв одном месте',
      subtitle: 'Тысячи фильмов и сериалов всегда под рукой в любое время',
    ),
    _OnboardingPage(
      title: 'Смотрите телеканалы\nсо всего мира в прямом эфире',
      subtitle: '',
    ),
    _OnboardingPage(
      title: 'Ваш умный ТВ-гид: расписание\nи поиск по всем передачам',
      subtitle: '',
    ),
    _OnboardingPage(
      title: 'Управляйте всеми подписками\nв одном личном кабинете',
      subtitle: '',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Container(
                color: AppColors.background,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Placeholder for illustration
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      page.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (page.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        page.subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          // Bottom section
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: Column(
              children: [
                // Page indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (index) {
                    return Container(
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppColors.gradientStart
                            : AppColors.textSecondary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.go('/channels');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gradientStart,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentPage < _pages.length - 1 ? 'Далее' : 'Начать',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (_currentPage < _pages.length - 1) ...[
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go('/channels'),
                    child: const Text(
                      'Пропустить',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final String title;
  final String subtitle;

  const _OnboardingPage({
    required this.title,
    required this.subtitle,
  });
}
