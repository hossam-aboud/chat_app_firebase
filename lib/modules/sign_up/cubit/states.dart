import 'package:chat_app/model/user_model.dart';

abstract class RegisterStates {}

class RegsiterInitialState extends RegisterStates {}

class RegisterVisibilityPasswordState extends RegisterStates {}

class RegisterLoadingUserState extends RegisterStates {}

class RegisterSuccessUserState extends RegisterStates {}

class RegisterErrorUserState extends RegisterStates {
  final String errorMsg;

  RegisterErrorUserState(this.errorMsg);
}

// for register in firebase firestore
class RegisterLoadingUserInfoState extends RegisterStates {}

class RegisterSuccessUserInfoState extends RegisterStates {
  final UserModel userModel;

  RegisterSuccessUserInfoState(this.userModel);
}

class RegisterErrorUserInfoState extends RegisterStates {
  final String errroMsg;

  RegisterErrorUserInfoState(this.errroMsg);
}

class RegisterCheckPhoneValidatorSuccessState extends RegisterStates {}

class RegisterCheckPhoneValidatorErrorState extends RegisterStates {}
