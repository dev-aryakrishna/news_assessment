import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/localization/localization_service.dart';
import '../../../../dependency_injection/injection.dart';
import '../../../../routes/route_names.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      final isLanguageSelected =
          sl<LocalizationService>().isLanguageSelected; // 👈 check

      if (!isLanguageSelected) {
        context.go(RouteNames.languageSelect); // 👈 first time → language select
        return;
      }

      context.read<AuthBloc>().add(CheckSessionRequested()); // 👈 already selected → auth check
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(RouteNames.news);
        }
        if (state is AuthUnauthenticated) {
          context.go(RouteNames.login);
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.newspaper, size: 100),
              SizedBox(height: 24),
              Text(
                'News App',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}