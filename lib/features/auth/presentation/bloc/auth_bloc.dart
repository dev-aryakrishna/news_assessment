import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckSessionRequested>(_onCheckSessionRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {

    emit(AuthLoading());

    try {
      await authRepository.login(email: event.email, password: event.password);

      emit(AuthAuthenticated());
    } catch (e) {

      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
  SignUpRequested event,
  Emitter<AuthState> emit,
) async {
  emit(AuthLoading());

  try {
    await authRepository.signUp(
      fullName: event.fullName,
      phone: event.phone,
      email: event.email,
      password: event.password,
    );

    emit(const AuthSuccess('Account created successfully!')); 
  } catch (e) {
    emit(AuthFailure(e.toString()));
  }
}

  Future<void> _onLogoutRequested(
  LogoutRequested event,
  Emitter<AuthState> emit,
) async {

  await authRepository.logout();


  emit(AuthUnauthenticated());
}

  Future<void> _onCheckSessionRequested(
    CheckSessionRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (authRepository.isLoggedIn) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }
}

