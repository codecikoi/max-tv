import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'router.dart';

class MaxTVApp extends StatelessWidget {
  const MaxTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MAX TV',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
