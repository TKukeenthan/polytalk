import 'dart:io';
import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../entities/user.dart';
import '../../../../core/errors/failures.dart';

class LoginUser {
  final AuthRepository repository;
  LoginUser(this.repository);
  Future<Either<Failure, User>> call(String email, String password) => repository.loginUser(email, password);
}

class RegisterUser {
  final AuthRepository repository;
  RegisterUser(this.repository);
  Future<Either<Failure, User>> call(String email, String password, String name, {File? profileImage}) =>
      repository.registerUser(email, password, name, profileImage: profileImage);
}

class SignInWithGoogle {
  final AuthRepository repository;
  SignInWithGoogle(this.repository);
  Future<Either<Failure, User>> call() => repository.signInWithGoogle();
}

class SendPasswordResetEmail {
  final AuthRepository repository;
  SendPasswordResetEmail(this.repository);
  Future<Either<Failure, void>> call(String email) => repository.sendPasswordResetEmail(email);
}

class SendEmailVerification {
  final AuthRepository repository;
  SendEmailVerification(this.repository);
  Future<Either<Failure, void>> call() => repository.sendEmailVerification();
}

class LogoutUser {
  final AuthRepository repository;
  LogoutUser(this.repository);
  Future<Either<Failure, void>> call() => repository.logoutUser();
}
