// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'auth_state.dart';
// import 'auth_event.dart';

// mixin AuthFirebaseListener on BlocBase<AuthState> {
//   void listenToAuthChanges() {
//     firebase_auth.FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
//       if (firebaseUser != null) {
//         // User is signed in
//         add(LoginRequested(email: firebaseUser.email ?? '', password: ''));
//       } else {
//         // User is signed out
//         emit(AuthInitial());
//       }
//     });
//   }
// }
