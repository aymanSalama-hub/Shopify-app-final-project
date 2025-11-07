import 'package:bisky_shop/core/constants/user_type.dart';
import 'package:bisky_shop/features/auth/presentation/cubit/auths_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitial());

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  UserType selectedUserType = UserType.customer;
  var role = '';
  login() async {
    emit(AuthsLoadingState());
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      name.text = credential.user?.displayName ?? '';
      role = credential.user?.photoURL ?? '';
      emit(AuthsSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(AuthsErrorState());
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      emit(AuthsErrorState());
      print(e);
    }
  }

  loginWithGoogle() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    emit(AuthsLoadingState());
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      emit(AuthsSuccessState());
    } catch (e) {
      emit(AuthsErrorState());
      print(e);
    }
  }

  signUp() async {
    emit(AuthsLoadingState());
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.text,
            password: password.text,
          );
      credential.user?.updateDisplayName(name.text);
      if (selectedUserType == UserType.admin) {
        credential.user?.updatePhotoURL('Admin');
      } else {
        credential.user?.updatePhotoURL('Customer');
      }
      emit(AuthsSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(AuthsErrorState());
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      emit(AuthsErrorState());
      print(e);
    }
  }
}
