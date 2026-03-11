import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../core/widgets/app_tab_bar.dart';
import '../core/theme/app_colors.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_email_screen.dart';
import '../features/auth/presentation/screens/register_confirm_screen.dart';
import '../features/auth/presentation/screens/register_complete_screen.dart';
import '../features/auth/presentation/screens/welcome_screen.dart';
import '../features/channels/presentation/screens/channels_screen.dart';
import '../features/epg/presentation/screens/epg_screen.dart';
import '../features/player/presentation/screens/player_screen.dart';
import '../features/account/presentation/screens/account_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterEmailScreen(),
    ),
    GoRoute(
      path: '/register/confirm',
      builder: (context, state) => RegisterConfirmScreen(
        email: state.extra as String,
      ),
    ),
    GoRoute(
      path: '/register/complete',
      builder: (context, state) => RegisterCompleteScreen(
        email: state.extra as String,
      ),
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
