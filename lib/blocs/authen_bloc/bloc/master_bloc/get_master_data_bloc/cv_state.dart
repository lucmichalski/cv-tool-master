part of 'cv_bloc.dart';

abstract class CVState extends Equatable {
  const CVState();

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class CVListLoading extends CVState {}

class GetCVListInitial extends CVState {}

class GetCVListSuccess extends CVState {
  final MasterData masterData;

  GetCVListSuccess(this.masterData);

  @override
  List<Object> get props => [masterData];
}

class GetCVListError extends CVState {
  final String message;

  GetCVListError({this.message});
  @override
  List<Object> get props => [message];
}
// create CV success
class CreateCvSuccess extends CVState {
  final CVModel cvModel;

  CreateCvSuccess(this.cvModel);

  @override
  List<Object> get props => [cvModel];
}

// create cv error
class CreateCvError extends CVState {
  final String message;

  CreateCvError({this.message});
  @override
  List<Object> get props => [message];
}
// get CV success
class GetCvSuccess extends CVState {
  final List<CVModel> cvList;

  GetCvSuccess(this.cvList);

  @override
  List<Object> get props => [cvList];
}

// create cv error
class GetCvError extends CVState {
  final String message;

  GetCvError({this.message});
  @override
  List<Object> get props => [message];
}
