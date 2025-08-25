import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginRequested({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final File? profileImage;
  const RegisterRequested({required this.email, required this.password, required this.name, this.profileImage});
  @override
  List<Object> get props => [email, password, name, profileImage ?? ''];
}

class LogoutRequested extends AuthEvent {}

class GoogleSignInRequested extends AuthEvent {}

class ForgotPasswordRequested extends AuthEvent {
  final String email;
  const ForgotPasswordRequested({required this.email});
  @override
  List<Object> get props => [email];
}

class SendEmailVerificationRequested extends AuthEvent {}

// Optional: For RevenueCat or other integrations
class LoginPurchasesRequested extends AuthEvent {
  final String userId;
  const LoginPurchasesRequested(this.userId);
  @override
  List<Object> get props => [userId];
}
class LogoutPurchasesRequested extends AuthEvent {}