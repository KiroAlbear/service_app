import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class getChildrenRowsEvent extends HomeEvent {
  const getChildrenRowsEvent();

  @override
  List<Object> get props => [];
}

class incrementColumnEvent extends HomeEvent {
  final String targetColumnLetter;
  final String firstName;
  final String fatherName;
  final String grandfatherName;
  const incrementColumnEvent({
    required this.targetColumnLetter,
    required this.firstName,
    required this.fatherName,
    required this.grandfatherName,
  });

  @override
  List<Object> get props => [
    targetColumnLetter,
    firstName,
    fatherName,
    grandfatherName,
  ];
}
