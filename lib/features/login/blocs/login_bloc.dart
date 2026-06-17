import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<getLoginEvent>(_getLogin);
  }

  FutureOr<void> _getLogin(
    getLoginEvent event,
    Emitter<LoginState> emit,
  ) async {
    // in case of loading
    emit(LoginState());

    await Future.delayed(const Duration(seconds: 1));

    // in case of success
    emit(LoginState(number: 3));

    // in case of failure
    // emit(ErrorState(errorMessage: "Problem has happened"));
  }
}
