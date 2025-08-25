// features/auth/data/datasources/auth_remote_datasource.dart

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginUser(String email, String password);
  Future<UserModel> registerUser(String email, String password, String name);
  Future<void> logoutUser();
  Future<UserModel> signInWithGoogle();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> sendEmailVerification();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  // final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    required firebase_auth.FirebaseAuth firebaseAuth,
    // GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth;
        // _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<UserModel> loginUser(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw const ServerException('User not found after login.');
      }

      return UserModel.fromFirebaseUser(firebaseUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Convert Firebase exceptions to our custom ServerException
      throw ServerException(e.message ?? 'An unknown authentication error occurred.');
    }
  }

  @override
  Future<UserModel> registerUser(
    String email,
    String password,
    String name,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw const ServerException('User not found after registration.');
      }

      // Update the user's display name
      await firebaseUser.updateDisplayName(name);

      // We need to reload the user to get the updated info
      await firebaseUser.reload();
      final updatedUser = _firebaseAuth.currentUser;
      
      if (updatedUser == null) {
        throw const ServerException('Could not retrieve updated user info.');
      }

      return UserModel.fromFirebaseUser(updatedUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'An unknown registration error occurred.');
    }
  }

  @override
  Future<void> logoutUser() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw const ServerException('Failed to sign out.');
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser =  await GoogleSignIn.instance.authenticate();;
      if (googleUser == null) {
        throw const ServerException('Google sign-in aborted.');
      }
      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.idToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw const ServerException('User not found after Google sign-in.');
      }
      return UserModel.fromFirebaseUser(firebaseUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'An unknown Google sign-in error occurred.');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Failed to send password reset email.');
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }
}