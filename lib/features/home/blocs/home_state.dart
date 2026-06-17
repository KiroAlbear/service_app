import 'package:service/features/models/SheetFullName.dart';

class HomeState {}

class HomeSuccessState extends HomeState {
  final List<SheetFullName> childrenRows;
  HomeSuccessState(this.childrenRows);
}

class HomeLoadingState extends HomeState {}

class HomeErrorState extends HomeState {
  final String errorMessage;

  HomeErrorState({required this.errorMessage});
}
