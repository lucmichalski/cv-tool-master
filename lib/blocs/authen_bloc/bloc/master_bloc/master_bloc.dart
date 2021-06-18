import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cv_maker/models/cv_model/admin_page_model.dart';
import 'package:flutter_cv_maker/services/api_call.dart';
import 'package:meta/meta.dart';

part 'master_event.dart';
part 'master_state.dart';

class MasterBloc extends Bloc<MasterEvent, MasterState> {
  MasterBloc(MasterInitial initial) : super(MasterInitial());
  Repository repository = Repository();
  @override
  Stream<MasterState> mapEventToState(
    MasterEvent event,
  ) async* {
    if (event is RequestAddMasterEvent) {
      // Loading state
      yield MasterLoading();
      try {
        final response = await repository.addMasterData(event.accessToken, event.requestBody);
        yield MasterSuccess(response);
      } catch (e) {
        yield MasterError(message: e.toString());
      }
    }
  }
}
