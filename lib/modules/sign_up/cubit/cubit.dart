import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/modules/sign_up/cubit/states.dart';
import 'package:chat_app/shared/components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegsiterInitialState());

  static RegisterCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  // example - 1
  void registerUser({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(RegisterLoadingUserState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createInfoOfUser(
        uId: value.user!.uid.toString(),
        username: username,
        email: email,
        password: password,
        phone: phone,
      );
    }).catchError(
      (error) {
        emit(
          RegisterErrorUserState(error.toString()),
        );
      },
    );
  }

  // example - 2
  void registerToFirebaseAuth({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(RegisterLoadingUserState());
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        createInfoOfUser(
          uId: userCredential.user!.uid.toString(),
          username: username,
          email: email,
          password: password,
          phone: phone,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast(
          message: 'The password provided is too weak',
          stateType: StateType.error,
        );
        emit(
          RegisterErrorUserState(e.toString()),
        );
      } else if (e.code == 'email-already-in-use') {
        showToast(
          message: 'The account already exists for that email',
          stateType: StateType.error,
        );
        emit(
          RegisterErrorUserState(e.toString()),
        );
      }
    } catch (e) {
      showToast(
        message: 'something error when register user',
        stateType: StateType.error,
      );
      emit(
        RegisterErrorUserState(e.toString()),
      );
    }
  }

  void createInfoOfUser({
    required String uId,
    required String username,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(RegisterLoadingUserInfoState());
    UserModel userModel = UserModel(
      uId: uId,
      username: username,
      email: email,
      phone: phone,
      image:
          'https://image.freepik.com/free-vector/man-shows-gesture-great-idea_10045-637.jpg',
      coverImage:
          'https://image.freepik.com/free-photo/man-filming-with-professional-camera_23-2149066324.jpg',
      bio: 'Write you bio ....',
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(
          userModel.toMap(),
        )
        .then((value) {
      emit(RegisterSuccessUserInfoState(userModel));
    }).catchError(
      (error) {
        emit(RegisterErrorUserInfoState(error.toString()));
      },
    );
  }

  bool isSecure = true;
  IconData secureVisibility = Icons.visibility_outlined;

  void checkVisibility() {
    isSecure = isSecure ? false : true;
    secureVisibility =
        isSecure ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterVisibilityPasswordState());
  }

  bool isPhone = false;
  bool checkPhoneNumber(String value) {
    if (value.startsWith('059') && value.length == 10) {
      emit(RegisterCheckPhoneValidatorSuccessState());
      return isPhone = true;
    } else if (value.startsWith('059')) {
      emit(RegisterCheckPhoneValidatorErrorState());

      return isPhone = false;
    } else if (value.length <= 10) {
      emit(RegisterCheckPhoneValidatorErrorState());

      return isPhone = false;
    } else {
      emit(RegisterCheckPhoneValidatorErrorState());

      return isPhone = false;
    }
  }
}
