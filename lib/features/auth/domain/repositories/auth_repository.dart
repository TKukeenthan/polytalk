import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> loginUser(String email, String password);
  Future<Either<Failure, User>> registerUser(String email, String password, String name, {File? profileImage});
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
  Future<Either<Failure, void>> sendEmailVerification();
  Future<Either<Failure, void>> logoutUser();
}