import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class getSheetNameEvent extends LoginEvent {
  final String username;
  final String password;
  const getSheetNameEvent(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}
