import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cv_maker/models/cv_model/admin_page_model.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:flutter_cv_maker/services/api_call.dart';
import 'package:flutter_cv_maker/utils/shared_preferences_service.dart';

part 'cv_event.dart';
part 'cv_state.dart';

class CVBloc extends Bloc<CVEvent, CVState> {
  CVBloc(GetCVListInitial getMasterDataInitial)
      : super(GetCVListInitial());
  Repository repository = Repository();

  @override
  Stream<CVState> mapEventToState(
    CVEvent event,
  ) async* {
    if (event is RequestGetCVListEvent) {
      yield CVListLoading();
      try {
        final pref = await SharedPreferencesService.instance;
        final response = await repository.fetchMasterData(pref.getAccessToken);
        yield GetCVListSuccess(response);
      } catch (e) {
        yield GetCVListError(message: e.toString());
      }
    }else if(event is RequestCreateCvEvent){
      yield CVListLoading();
      try{
        final responseCreate = await repository.createCv(event.accessToken,event.requestBody);
        yield CreateCvSuccess(responseCreate);
      }catch(e){
        yield CreateCvError(message: e.toString());
      }
    }else if(event is RequestGetCVModel){
      yield CVListLoading();
      try{
        final responseCreate = await repository.fetchDataCV(event.accessToken);
        yield GetCvSuccess(responseCreate);
      }catch(e){
        yield GetCvError(message: e.toString());
      }
    }
  }
}
