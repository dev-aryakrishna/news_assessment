import 'package:flutter/material.dart';

import 'core/themes/app_theme.dart';
import 'routes/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
