part of 'authen_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Request singin event
class RequestAuthEvent extends AuthEvent {
  final String account;
  final String password;
  const RequestAuthEvent(this.account, this.password);
  @override
  List<Object> get props => [account, password];
}
