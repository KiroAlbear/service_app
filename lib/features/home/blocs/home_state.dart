import '../../models/month_values.dart';

class HomeState {}

class HomeSuccessState extends HomeState {
  final List<MonthServiceValues> childrenRows;
  HomeSuccessState(this.childrenRows);
}

class HomeIncrementSuccessState extends HomeState {
  HomeIncrementSuccessState();
}

class HomeLoadingState extends HomeState {}

class HomeListLoadingState extends HomeState {}

class HomeErrorState extends HomeState {
  final String errorMessage;

  HomeErrorState({required this.errorMessage});
}
