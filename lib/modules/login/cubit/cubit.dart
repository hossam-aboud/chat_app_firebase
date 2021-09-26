import 'package:chat_app/modules/login/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  void loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingUserState());
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(LoginSuccessUserState(value.user!.uid));
    }).catchError(
      (error) {
        emit(
          LoginErrorUserState(error.toString()),
        );
      },
    );
  }

  bool isSecure = true;
  IconData secureVisibility = Icons.visibility_outlined;

  void checkVisibility() {
    isSecure = isSecure ? false : true;
    secureVisibility =
        isSecure ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(LoginVisibilityPasswordState());
  }
}
