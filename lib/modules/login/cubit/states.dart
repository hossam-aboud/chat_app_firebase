abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginVisibilityPasswordState extends LoginStates {}

class LoginLoadingUserState extends LoginStates {}

class LoginSuccessUserState extends LoginStates {
  final String uID;

  LoginSuccessUserState(this.uID);
}

class LoginErrorUserState extends LoginStates {
  final String errorMsg;

  LoginErrorUserState(this.errorMsg);
}
