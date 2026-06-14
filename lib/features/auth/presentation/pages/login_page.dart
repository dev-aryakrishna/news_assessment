import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/l10n/app_localizations.dart';
import '../bloc/auth_state.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/route_names.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(RouteNames.news);
        }

        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.login)),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: _emailController,
                  hintText: l10n.email,
                  validator: (value) => Validators.validateEmail(context, value),
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: _passwordController,
                  hintText: l10n.password,
                  obscureText: true,
                  validator: (value) => Validators.validatePassword(context, value),
                ),

                const SizedBox(height: 24),

                PrimaryButton(
                  text: l10n.login,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                        LoginRequested(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    context.push(RouteNames.signup);
                  },
                  child: Text(l10n.dontHaveAccount),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}