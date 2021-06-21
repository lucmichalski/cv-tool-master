part of 'master_bloc.dart';

@immutable
abstract class MasterEvent extends Equatable {
  const MasterEvent();

  @override
  List<Object> get props => [];
}

class RequestGetMasterEvent extends MasterEvent {
  final String accessToken;

  const RequestGetMasterEvent(this.accessToken);

  @override
  List<Object> get props => [accessToken];
}

class RequestAddMasterEvent extends MasterEvent {
  final String accessToken;

  final String requestBody;

  const RequestAddMasterEvent(this.accessToken, this.requestBody);

  @override
  List<Object> get props => [accessToken, requestBody];
}

class RequestUpdateMasterEvent extends MasterEvent {
  final String accessToken;

  final String requestBody;

  const RequestUpdateMasterEvent(this.accessToken, this.requestBody);

  @override
  List<Object> get props => [accessToken, requestBody];
}
