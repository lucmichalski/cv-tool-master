import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cv_maker/models/cv_model/master_model.dart';
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
    // Loading state
    yield MasterLoading();
    if (event is RequestAddMasterEvent) {
      try {
        final response = await repository.addMasterData(event.accessToken, event.requestBody);
        yield MasterSuccess(response);
      } catch (e) {
        yield MasterError(message: e.toString());
      }
    } else if (event is RequestUpdateMasterEvent) {
      try {
        final response = await repository.updateMasterData(event.accessToken, event.requestBody);
        yield UpdateMasterSuccess(response);
      } catch (e) {
        yield UpdateMasterError(message: e.toString());
      }
    } else if (event is RequestGetMasterEvent) {
      try {
        final response = await repository.fetchMasterData(event.accessToken);
        yield GetMasterSuccess(response);
      } catch (e) {
        yield GetMasterError(message: e.toString());
      }
    }
  }
}
