import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cv_maker/models/auth/login_response.dart';
import 'package:flutter_cv_maker/services/api_call.dart';
import 'package:flutter_cv_maker/utils/shared_preferences_service.dart';

part 'authen_event.dart';
part 'authen_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Repository

  // Constructor
  AuthBloc(AuthInitial authInitial) : super(AuthInitial());
  Repository repository = Repository();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is RequestAuthEvent) {
      // Loading state
      yield AuthLoading();
      try {
        final response = await repository.signIn(event.account, event.password);
        final sharedPrefService = await SharedPreferencesService.instance..saveAccessToken(response.token)..saveUserNm(response.fullName);
        yield AuthSuccess(response: response);
      } catch (e) {
        yield AuthError(message: e.toString());
      }
    }    else if (event is RequestUpdatePasswordEvent) {
      // Loading state
      yield AuthLoading();
      try {
        final response = await repository.updatePassWord(event.token, event.body);
        String a = response.toString();
        yield UpdatePasswordSuccess(success: response);
      } catch (e) {
        yield UpdatePasswordError(message: e.toString());
      }
    }
  }
}
