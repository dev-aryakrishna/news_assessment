import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/themes/app_theme.dart';
import 'routes/app_router.dart';

import 'dependency_injection/injection.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/news/presentation/bloc/news_bloc.dart';
import 'core/connectivity/connectivity_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),

        BlocProvider(create: (_) => sl<ConnectivityCubit>()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'News App',
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
