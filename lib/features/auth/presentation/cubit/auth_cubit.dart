import 'package:bisky_shop/features/auth/presentation/cubit/auths_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitial());

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  login() async {
    emit(AuthsLoadingState());
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      name.text=credential.user?.displayName??'';
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

  signUp() async {
    emit(AuthsLoadingState());
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.text,
            password: password.text,
          );
      credential.user?.updateDisplayName(name.text);
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
