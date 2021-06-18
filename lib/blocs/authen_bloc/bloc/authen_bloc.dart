import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cv_maker/models/auth/login_response.dart';
import 'package:flutter_cv_maker/services/api_call.dart';
import 'package:flutter_cv_maker/utils/shared_preferences_service.dart';

part 'authen_event.dart';
part 'authen_state.dart';

class AuthBloc extends Bloc<AuthenEvent, AuthenState> {
  // Repository

  // Constructor
  AuthBloc(AuthInitial authInitial) : super(AuthInitial());
  Repository repository = Repository();

  @override
  Stream<AuthenState> mapEventToState(
    AuthenEvent event,
  ) async* {
    if (event is RequestAuthenEvent) {
      // Loading state
      yield AuthLoading();
      try {
        final response = await repository.signIn(event.account, event.password);
        final sharedPrefService = await SharedPreferencesService.instance..saveAccessToken(response.token);
        yield AuthenSuccess(response: response);
      } catch (e) {
        yield AuthenError(message: e.toString());
      }
    }
  }
}
