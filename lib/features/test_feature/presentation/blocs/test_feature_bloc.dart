import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service/features/test_feature/presentation/blocs/test_feature_event.dart';
import 'package:service/features/test_feature/presentation/blocs/test_feature_state.dart';

class TestFeatureBloc extends Bloc<TestFeatureEvent, TestFeatureState> {
  TestFeatureBloc() : super(TestFeatureState()) {
    on<getTestFeatureEvent>(_getTestFeature);
  }

  FutureOr<void> _getTestFeature(
    getTestFeatureEvent event,
    Emitter<TestFeatureState> emit,
  ) async {
    // in case of loading
    emit(TestFeatureState());

    await Future.delayed(const Duration(seconds: 1));

    // in case of success
    emit(TestFeatureState(number: 3));

    // in case of failure
    // emit(ErrorState(errorMessage: "Problem has happened"));
  }
}
