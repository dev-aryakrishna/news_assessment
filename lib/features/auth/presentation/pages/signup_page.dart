import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/l10n/app_localizations.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_state.dart';
import '../../../../routes/route_names.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          context.go(RouteNames.login);
        }

        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.signup)),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameController,
                    hintText: l10n.fullName,
                    validator: (value) => Validators.validateName(context, value),
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _phoneController,
                    hintText: l10n.phoneNumber,
                    validator: (value) => Validators.validatePhone(context, value),
                  ),

                  const SizedBox(height: 16),

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

                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: l10n.confirmPassword,
                    obscureText: true,
                    validator: (value) => Validators.validateConfirmPassword(
                      context,
                      value,
                      _passwordController.text,
                    ),
                  ),

                  const SizedBox(height: 24),

                  PrimaryButton(
                    text: l10n.signup,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                          SignUpRequested(
                            fullName: _nameController.text.trim(),
                            phone: _phoneController.text.trim(),
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
                      context.pop();
                    },
                    child: Text(l10n.alreadyHaveAccount),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}