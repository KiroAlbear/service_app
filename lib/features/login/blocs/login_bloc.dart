import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service/core/services/google_sheets_service.dart';
import 'package:service/core/services/secure_storage/secure_storage_keys.dart';
import 'package:service/core/services/secure_storage/secure_storage_manager.dart';
import 'package:service/core/services/secure_storage/secure_storage_values.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<getSheetNameEvent>(_getLogin);
  }

  FutureOr<void> _getLogin(
    getSheetNameEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoadingState());

    try {
      final sheetName = await GoogleSheetsService().getSheetNameofServant(
        event.username,
        event.password,
      );

      SecureStorageManager.getInstance().setValue(
        SecureStorageKeys.sheetName,
        sheetName,
      );

      SecureStorageManager.getInstance().setValue(
        SecureStorageKeys.isLoggedIn,
        SecureStorageValues.trueValue,
      );

      emit(LoginSuccessState());
    } catch (error) {
      final message = error is Exception
          ? error.toString().replaceFirst('Exception: ', '')
          : "Something went wrong. Please try again.";

      emit(LoginErrorState(errorMessage: message));
    }
  }
}
