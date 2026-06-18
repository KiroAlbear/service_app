import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service/constants.dart';
import 'package:service/core/services/google_sheets_service.dart';
import 'package:service/core/services/secure_storage/secure_storage_keys.dart';
import 'package:service/core/services/secure_storage/secure_storage_manager.dart';
import '../../models/month_values.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<getChildrenRowsEvent>(_getChildrenRows);
    on<incrementColumnEvent>(_incrementColumn);
    on<decremntColumnEvent>(_decrementColumn);
  }

  List<MonthServiceValues> _visibleChildrenRows() {
    final currentState = state;

    if (currentState is HomeSuccessState) {
      return currentState.childrenRows;
    }

    if (currentState is HomeListLoadingState) {
      return currentState.childrenRows;
    }

    return const [];
  }

  bool _isSameChild(
    MonthServiceValues child,
    String firstName,
    String fatherName,
    String grandfatherName,
  ) {
    return child.firstName == firstName &&
        child.fatherName == fatherName &&
        child.grandfatherName == grandfatherName;
  }

  List<MonthServiceValues> _updateChildColumnValue({
    required List<MonthServiceValues> childrenRows,
    required String targetColumnLetter,
    required String firstName,
    required String fatherName,
    required String grandfatherName,
    required int newValue,
  }) {
    final monthColumns =
        Constants.monthCountColumns[Constants.currentMonth.toString()];

    if (monthColumns == null) return childrenRows;

    final targetColumn = targetColumnLetter.trim().toUpperCase();

    return childrenRows.map((child) {
      if (!_isSameChild(child, firstName, fatherName, grandfatherName)) {
        return child;
      }

      return MonthServiceValues(
        firstName: child.firstName,
        fatherName: child.fatherName,
        grandfatherName: child.grandfatherName,
        morningService: targetColumn == monthColumns.morningServiceColumn
            ? newValue
            : child.morningService,
        communion: targetColumn == monthColumns.communionColumn
            ? newValue
            : child.communion,
        service: targetColumn == monthColumns.serviceColumn
            ? newValue
            : child.service,
        confession: targetColumn == monthColumns.confessionColumn
            ? newValue
            : child.confession,
      );
    }).toList();
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

      final List<MonthServiceValues> childrenRows =
          await GoogleSheetsService.getInstance().getMonthServiceValues(
            sheetName: sheetName,
            monthNumber: Constants.currentMonth,
          );

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
    final visibleChildrenRows = _visibleChildrenRows();

    emit(
      HomeListLoadingState(
        childrenRows: visibleChildrenRows,
        firstName: event.firstName,
        fatherName: event.fatherName,
        grandfatherName: event.grandfatherName,
      ),
    );

    try {
      final sheetName = await SecureStorageManager.getInstance().getValue(
        SecureStorageKeys.sheetName,
      );

      if (sheetName == null || sheetName.trim().isEmpty) {
        throw Exception('Sheet name was not found. Please log in again.');
      }

      final Map<String, int> result = await GoogleSheetsService.getInstance()
          .incrementColumnByExactName(
            firstName: event.firstName,
            fatherName: event.fatherName,
            grandfatherName: event.grandfatherName,
            targetColumnLetter: event.targetColumnLetter,
            sheetName: sheetName,
          );

      emit(
        HomeSuccessState(
          _updateChildColumnValue(
            childrenRows: visibleChildrenRows,
            targetColumnLetter: event.targetColumnLetter,
            firstName: event.firstName,
            fatherName: event.fatherName,
            grandfatherName: event.grandfatherName,
            newValue: result['newValue'] ?? 0,
          ),
        ),
      );
    } catch (error) {
      final message = error is Exception
          ? error.toString().replaceFirst('Exception: ', '')
          : "Something went wrong. Please try again.";

      emit(HomeErrorState(errorMessage: message));
    }
  }

  FutureOr<void> _decrementColumn(
    decremntColumnEvent event,
    Emitter<HomeState> emit,
  ) async {
    final visibleChildrenRows = _visibleChildrenRows();

    emit(
      HomeListLoadingState(
        childrenRows: visibleChildrenRows,
        firstName: event.firstName,
        fatherName: event.fatherName,
        grandfatherName: event.grandfatherName,
      ),
    );

    try {
      final sheetName = await SecureStorageManager.getInstance().getValue(
        SecureStorageKeys.sheetName,
      );

      if (sheetName == null || sheetName.trim().isEmpty) {
        throw Exception('Sheet name was not found. Please log in again.');
      }

      final Map<String, int> result = await GoogleSheetsService.getInstance()
          .decrementColumnByExactName(
            firstName: event.firstName,
            fatherName: event.fatherName,
            grandfatherName: event.grandfatherName,
            targetColumnLetter: event.targetColumnLetter,
            sheetName: sheetName,
          );

      emit(
        HomeSuccessState(
          _updateChildColumnValue(
            childrenRows: visibleChildrenRows,
            targetColumnLetter: event.targetColumnLetter,
            firstName: event.firstName,
            fatherName: event.fatherName,
            grandfatherName: event.grandfatherName,
            newValue: result['newValue'] ?? 0,
          ),
        ),
      );
    } catch (error) {
      final message = error is Exception
          ? error.toString().replaceFirst('Exception: ', '')
          : "Something went wrong. Please try again.";

      emit(HomeErrorState(errorMessage: message));
    }
  }
}
