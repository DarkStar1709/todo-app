import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/firebase/firebase_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseService _firebaseService;

  AuthBloc(this._firebaseService) : super(AuthInitial()) {
    on<AuthCheckStatus>((event, emit) async {
      final user = _firebaseService.currentUser;
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCredential = await _firebaseService.signIn(
          event.email,
          event.password,
        );
        emit(AuthAuthenticated(userCredential.user!));
      } on AuthException catch (e) {
        emit(AuthError(e.message));
      } catch (e) {
        emit(AuthError('An unexpected error occurred'));
      }
    });

    on<AuthLogoutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _firebaseService.signOut();
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError('Failed to sign out'));
      }
    });

    _firebaseService.authStateChanges.listen((User? user) {
      if (user != null) {
        add(AuthStatusChanged(user));
      } else {
        add(AuthStatusChanged(null));
      }
    });

    on<AuthStatusChanged>((event, emit) {
      if (event.user != null) {
        emit(AuthAuthenticated(event.user!));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }
}
