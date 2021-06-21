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

  const RequestGetCVModel(this.accessToken);

  @override
  List<Object> get props => [accessToken];
}
