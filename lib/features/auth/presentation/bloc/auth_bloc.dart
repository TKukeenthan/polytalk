import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polytalk/features/auth/domain/usecases/auth_usecases.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entities/user.dart';
import '../../domain/usecases/log_out_user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final SignInWithGoogle signInWithGoogle;
  final SendPasswordResetEmail sendPasswordResetEmail;
  final SendEmailVerification sendEmailVerification;
  final LogoutUser logoutUser;

  AuthBloc({
    required this.loginUser,
    required this.registerUser,
    required this.signInWithGoogle,
    required this.sendPasswordResetEmail,
    required this.sendEmailVerification,
    required this.logoutUser,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    // on<SendEmailVerificationRequested>(_onSendEmailVerificationRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<_AuthenticatedFromFirebase>((event, emit) => emit(Authenticated(event.user)));
    on<_UnauthenticatedFromFirebase>((event, emit) => emit(AuthInitial()));
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    final firebaseUser = await firebase_auth.FirebaseAuth.instance.authStateChanges().first;
    if (firebaseUser != null) {
      add(_AuthenticatedFromFirebase(
        User(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName,
          photoUrl: firebaseUser.photoURL,
        ),
      ));
    } else {
      add(_UnauthenticatedFromFirebase());
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUser(event.email, event.password);
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerUser(event.email, event.password, event.name, profileImage: event.profileImage);
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onGoogleSignInRequested(GoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signInWithGoogle();
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onForgotPasswordRequested(ForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await sendPasswordResetEmail(event.email);
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (_) => emit(AuthPasswordResetSent()),
    );
  }

  Future<void> _onSendEmailVerificationRequested(SendEmailVerificationRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await sendEmailVerification();
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (_) => emit(AuthEmailVerificationSent()),
    );
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await logoutUser();
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (_) => emit(AuthInitial()),
    );
  }
}

class _AuthenticatedFromFirebase extends AuthEvent {
  final User user;
  const _AuthenticatedFromFirebase(this.user);
}

class _UnauthenticatedFromFirebase extends AuthEvent {}