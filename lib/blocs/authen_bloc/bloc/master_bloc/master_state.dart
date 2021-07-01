part of 'master_bloc.dart';

abstract class MasterState extends Equatable {
  const MasterState();

  @override
  List<Object> get props => [];
}

class MasterInitial extends MasterState {}

class MasterLoading extends MasterState {}

class MasterSuccess extends MasterState {
  final String msg;

  MasterSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

// GET
class GetMasterSuccess extends MasterState {
  final MasterData masterData;

  GetMasterSuccess(this.masterData);

  @override
  List<Object> get props => [masterData];
}

class GetMasterError extends MasterState {
  final String message;

  GetMasterError({this.message});

  @override
  List<Object> get props => [message];
}
// ADD
class MasterError extends MasterState {
  final String message;

  MasterError({this.message});

  @override
  List<Object> get props => [message];
}

/// UPDATE
class UpdateMasterSuccess extends MasterState {
  final String msg;

  UpdateMasterSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

class UpdateMasterError extends MasterState {
  final String message;

  UpdateMasterError({this.message});

  @override
  List<Object> get props => [message];
}
