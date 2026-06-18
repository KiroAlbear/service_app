import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service/core/services/google_sheets_service.dart';
import 'package:service/core/services/secure_storage/secure_storage_keys.dart';
import 'package:service/core/services/secure_storage/secure_storage_manager.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<getChildrenRowsEvent>(_getChildrenRows);
    on<incrementColumnEvent>(_incrementColumn);
  }

  FutureOr<void> _getChildrenRows(
    getChildrenRowsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());

    try {
      final sheetName = await SecureStorageManager.getInstance().getValue(
        SecureStorageKeys.sheetName,
      );

      if (sheetName == null || sheetName.trim().isEmpty) {
        throw Exception('Sheet name was not found. Please log in again.');
      }

      final childrenRows = await GoogleSheetsService.getInstance()
          .getFullNamesInTable(sheetName: sheetName);

      emit(HomeSuccessState(childrenRows));
    } catch (error) {
      final message = error is Exception
          ? error.toString().replaceFirst('Exception: ', '')
          : "Something went wrong. Please try again.";

      emit(HomeErrorState(errorMessage: message));
    }
  }

  FutureOr<void> _incrementColumn(
    incrementColumnEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());

    try {
      final sheetName = await SecureStorageManager.getInstance().getValue(
        SecureStorageKeys.sheetName,
      );

      if (sheetName == null || sheetName.trim().isEmpty) {
        throw Exception('Sheet name was not found. Please log in again.');
      }

      final Map<String, int> childrenRows =
          await GoogleSheetsService.getInstance().incrementColumnByExactName(
            firstName: event.firstName,
            fatherName: event.fatherName,
            grandfatherName: event.grandfatherName,
            targetColumnLetter: event.targetColumnLetter,
            sheetName: sheetName,
          );

      emit(HomeIncrementSuccessState());
    } catch (error) {
      final message = error is Exception
          ? error.toString().replaceFirst('Exception: ', '')
          : "Something went wrong. Please try again.";

      emit(HomeErrorState(errorMessage: message));
    }
  }
}
