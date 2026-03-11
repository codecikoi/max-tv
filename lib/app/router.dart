import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../core/widgets/app_tab_bar.dart';
import '../core/theme/app_colors.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/channels/presentation/screens/channels_screen.dart';
import '../features/epg/presentation/screens/epg_screen.dart';
import '../features/player/presentation/screens/player_screen.dart';
import '../features/account/presentation/screens/account_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/channels',
              builder: (context, state) => const ChannelsScreen(),
              routes: [
                GoRoute(
                  path: 'epg/:channelId',
                  builder: (context, state) => EpgScreen(
                    channelId: state.pathParameters['channelId']!,
                  ),
                ),
                GoRoute(
                  path: 'player/:channelId',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => PlayerScreen(
                    channelId: state.pathParameters['channelId']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/account',
              builder: (context, state) => const AccountScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      bottomNavigationBar: AppTabBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
