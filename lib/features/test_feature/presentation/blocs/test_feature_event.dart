import 'package:equatable/equatable.dart';

abstract class TestFeatureEvent extends Equatable {
  const TestFeatureEvent();
  @override
  List<Object> get props => [];
}

class getTestFeatureEvent extends TestFeatureEvent {
  final int number;
  const getTestFeatureEvent(this.number);

  @override
  List<Object> get props => [number];
}
