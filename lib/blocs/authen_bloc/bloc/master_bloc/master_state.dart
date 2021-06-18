part of 'master_bloc.dart';

abstract class MasterState extends Equatable {
  const MasterState();

  @override
  List<Object> get props => [];
}

class MasterInitial extends MasterState {}

class MasterLoading extends MasterState {}

class MasterSuccess extends MasterState {
  final MasterData masterData;
  MasterSuccess(this.masterData);
  @override
  List<Object> get props => [masterData];
}

class MasterError extends MasterState {
  final String message;

  MasterError({this.message});

  @override
  List<Object> get props => [message];
}
