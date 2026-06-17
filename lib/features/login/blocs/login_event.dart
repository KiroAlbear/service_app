import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class getLoginEvent extends LoginEvent {
  final int number;
  const getLoginEvent(this.number);

  @override
  List<Object> get props => [number];
}
