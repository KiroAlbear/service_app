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

class HomeListLoadingState extends HomeState {
  final List<MonthServiceValues> childrenRows;
  final String firstName;
  final String fatherName;
  final String grandfatherName;

  HomeListLoadingState({
    required this.childrenRows,
    required this.firstName,
    required this.fatherName,
    required this.grandfatherName,
  });
}

class HomeErrorState extends HomeState {
  final String errorMessage;

  HomeErrorState({required this.errorMessage});
}
