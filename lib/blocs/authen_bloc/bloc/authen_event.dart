part of 'authen_bloc.dart';

abstract class AuthenEvent extends Equatable {
  const AuthenEvent();

  @override
  List<Object> get props => [];
}

// Request singin event
class RequestAuthenEvent extends AuthenEvent {
  final String account;
  final String password;
  const RequestAuthenEvent(this.account, this.password);
  @override
  List<Object> get props => [account, password];
}
