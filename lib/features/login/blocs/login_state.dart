class LoginState {}

class LoginSuccessState extends LoginState {
  LoginSuccessState();
}

class LoginLoadingState extends LoginState {}

class LoginErrorState extends LoginState {
  LoginErrorState({required this.errorMessage});

  final String errorMessage;
}
