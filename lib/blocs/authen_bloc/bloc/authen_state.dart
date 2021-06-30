part of 'authen_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

// Loading state
class AuthLoading extends AuthState {}

// Success state
class AuthSuccess extends AuthState {
  final LoginResponse response;
  AuthSuccess({this.response});

  @override
  List<Object> get props => [response];
}

// Error state
class AuthError extends AuthState {
  final String message;
  const AuthError({this.message});

  @override
  List<Object> get props => [message];
}
// Success state
class UpdatePasswordSuccess extends AuthState {
  final String success;
  UpdatePasswordSuccess({this.success});

  @override
  List<Object> get props => [success];
}

// Error state
class UpdatePasswordError extends AuthState {
  final String message;
  const UpdatePasswordError({this.message});

  @override
  List<Object> get props => [message];
}
