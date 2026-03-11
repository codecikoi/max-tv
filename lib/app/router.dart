import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../core/di/injection.dart';
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
import '../features/account/data/models/user_model.dart';
import '../features/account/presentation/screens/edit_profile_screen.dart';
import '../features/tariffs/presentation/screens/tariffs_screen.dart';

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
    GoRoute(
      path: '/account/edit',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => EditProfileScreen(
        user: state.extra! as UserModel,
      ),
    ),
    GoRoute(
      path: '/tariffs',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const TariffsScreen(),
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
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>?;
                    return PlayerScreen(
                      channelId: state.pathParameters['channelId']!,
                      streamUrl: extra?['streamUrl'] as String?,
                      channelName: extra?['channelName'] as String?,
                      channelLogoUrl: extra?['channelLogoUrl'] as String?,
                      isFavourite: extra?['isFavourite'] as bool? ?? false,
                    );
                  },
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

class MainScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  double _dx = -1;
  double _dy = -1;
  bool _initialized = false;

  void _initPosition(BoxConstraints constraints) {
    if (!_initialized) {
      _dx = (constraints.maxWidth - 40) / 2;
      _dy = (constraints.maxHeight - 40) / 2;
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          _initPosition(constraints);
          return Stack(
            children: [
              widget.navigationShell,
              if (kDebugMode)
                Positioned(
                  left: _dx,
                  top: _dy,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        _dx = (_dx + details.delta.dx)
                            .clamp(0, constraints.maxWidth - 40);
                        _dy = (_dy + details.delta.dy)
                            .clamp(0, constraints.maxHeight - 40);
                      });
                    },
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TalkerScreen(
                            talker: getIt<Talker>(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '</>',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: AppTabBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
