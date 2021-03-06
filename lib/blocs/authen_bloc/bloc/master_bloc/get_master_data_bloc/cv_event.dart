part of 'cv_bloc.dart';

abstract class CVEvent extends Equatable {
  const CVEvent();

  @override
  List<Object> get props => [];
}

class RequestGetCVListEvent extends CVEvent {
  RequestGetCVListEvent();

  @override
  List<Object> get props => [];
}
// create cv event
class RequestCreateCvEvent extends CVEvent {
  final String accessToken;

  final String requestBody;
  RequestCreateCvEvent(this.accessToken,this.requestBody);

  @override
  List<Object> get props => [accessToken,requestBody];
}
class RequestGetCVModel extends CVEvent {
  final String accessToken;
  final int pageIndex;
  final bool status;
  final bool createdDate;
  final List<String> positions;

  const RequestGetCVModel(this.accessToken, this.pageIndex, this.status, this.createdDate,this.positions);

  @override
  List<Object> get props => [accessToken, pageIndex, status, createdDate];
}
// create cv event
class RequestUpdateCvEvent extends CVEvent {
  final String accessToken;
   final String id;
  final String requestBody;
  RequestUpdateCvEvent(this.accessToken,this.requestBody,this.id);

  @override
  List<Object> get props => [accessToken,requestBody,id];
}
// delete cv event
class RequestDeleteCvEvent extends CVEvent {
  final String accessToken;
   final String id;
  RequestDeleteCvEvent(this.accessToken,this.id);

  @override
  List<Object> get props => [accessToken,id];
}

// delete cv event
class RequestGetCvByIdEvent extends CVEvent {
  final String accessToken;
  final String id;
  RequestGetCvByIdEvent(this.accessToken,this.id);

  @override
  List<Object> get props => [accessToken,id];
}

// get data position event
class RequestGetDataPositionEvent extends CVEvent {
  final String accessToken;
  RequestGetDataPositionEvent(this.accessToken);

  @override
  List<Object> get props => [accessToken];
}
