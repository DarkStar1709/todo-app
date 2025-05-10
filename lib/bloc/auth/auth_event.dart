import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthCheckStatus extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthStatusChanged extends AuthEvent {
  final User? user;

  AuthStatusChanged(this.user);

  @override
  List<Object?> get props => [user];
}
