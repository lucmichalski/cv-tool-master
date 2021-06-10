part of 'authen_bloc.dart';

abstract class AuthenState extends Equatable {
  const AuthenState();

  @override
  List<Object> get props => [];
}

class AuthenInitial extends AuthenState {}

// Loading state
class AuthenLoading extends AuthenState {}

// Success state
class AuthenSuccess extends AuthenState {
  final LoginResponse response;
  AuthenSuccess({this.response});

  @override
  List<Object> get props => [response];
}

// Error state
class AuthenError extends AuthenState {
  final String message;
  const AuthenError({this.message});

  @override
  List<Object> get props => [message];
}
