import 'package:service/features/models/SheetFullName.dart';

class HomeState {}

class HomeSuccessState extends HomeState {
  final List<SheetFullName> childrenRows;
  HomeSuccessState(this.childrenRows);
}

class HomeIncrementSuccessState extends HomeState {
  HomeIncrementSuccessState();
}

class HomeLoadingState extends HomeState {}

class HomeErrorState extends HomeState {
  final String errorMessage;

  HomeErrorState({required this.errorMessage});
}
