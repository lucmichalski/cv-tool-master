import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cv_maker/models/cv_model/master_model.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model_response.dart';
import 'package:flutter_cv_maker/services/api_call.dart';
import 'package:flutter_cv_maker/utils/shared_preferences_service.dart';

part 'cv_event.dart';

part 'cv_state.dart';

class CVBloc extends Bloc<CVEvent, CVState> {
  CVBloc(GetCVListInitial getMasterDataInitial) : super(GetCVListInitial());
  Repository repository = Repository();

  @override
  Stream<CVState> mapEventToState(
    CVEvent event,
  ) async* {
    yield CVListLoading();
    if (event is RequestGetCVListEvent) {
      try {
        final pref = await SharedPreferencesService.instance;
        final response = await repository.fetchMasterData(pref.getAccessToken);
        yield GetMasterDataSuccess(response);
      } catch (e) {
        yield GetMasterDataError(message: e.toString());
      }
    } else if (event is RequestCreateCvEvent) {
      try {
        final responseCreate =
            await repository.createCv(event.accessToken, event.requestBody);
        yield CreateCvSuccess(responseCreate);
      } catch (e) {
        yield CreateCvError(message: e.toString());
      }
    } else if (event is RequestGetCVModel) {
      try {
        final response = await repository.fetchDataCV(event.accessToken,
            event.pageIndex, event.status, event.createdDate);
        yield GetCvListSuccess(response);
      } catch (e) {
        yield GetCvListError(message: e.toString());
      }
    } else if (event is RequestUpdateCvEvent) {
      try {
        final response = await repository.updateCv(
            event.accessToken, event.requestBody, event.id);
        yield UpdateCvSuccess(response);
      } catch (e) {
        yield UpdateCvError(message: e.toString());
      }
    } else if (event is RequestDeleteCvEvent) {
      try {
        final response =
            await repository.requestDeleteCv(event.accessToken, event.id);
        yield DeleteCvSuccess(response);
      } catch (e) {
        yield DeleteCvError(message: e.toString());
      }
    } else if (event is RequestGetDataPositionEvent) {
      try {
        final response = await repository.fetchTotalPosition(event.accessToken);
        yield GetDataPositionSuccess(response);
      } catch (e) {
        yield GetDataPositionError(message: e.toString());
      }
    }
  }
}
