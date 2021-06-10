import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cv_maker/models/auth/login_response.dart';
import 'package:flutter_cv_maker/services/api_call.dart';
import 'package:flutter_cv_maker/utils/shared_preferences_service.dart';

part 'authen_event.dart';
part 'authen_state.dart';

class AuthenBloc extends Bloc<AuthenEvent, AuthenState> {
  // Repository
  Repository repository = Repository();
  // Constructor
  AuthenBloc() : super(AuthenInitial());

  @override
  Stream<AuthenState> mapEventToState(
    AuthenEvent event,
  ) async* {
    if (event is RequestAuthenEvent) {
      // Loading state
      yield AuthenLoading();
      try {
        final response = await repository.signIn(event.account, event.password);
        final sharedPrefService = await SharedPreferencesService.instance;
        sharedPrefService.saveAccessToken(response.authToken);
        yield AuthenSuccess(response: response);
      } catch (e) {
        yield AuthenError(message: e.toString());
      }
    }
  }
}
