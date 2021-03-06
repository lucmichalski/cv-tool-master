part of 'cv_bloc.dart';

abstract class CVState extends Equatable {
  const CVState();

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class CVListLoading extends CVState {}

class GetCVListInitial extends CVState {}

class GetMasterDataSuccess extends CVState {
  final MasterData masterData;

  GetMasterDataSuccess(this.masterData);

  @override
  List<Object> get props => [masterData];
}

class GetMasterDataError extends CVState {
  final String message;

  GetMasterDataError({this.message});
  @override
  List<Object> get props => [message];
}
// create CV success
class CreateCvSuccess extends CVState {
  final String cvId;

  CreateCvSuccess(this.cvId);

  @override
  List<Object> get props => [cvId];
}

// create cv error
class CreateCvError extends CVState {
  final String message;

  CreateCvError({this.message});
  @override
  List<Object> get props => [message];
}
// get CV success
class GetCvListSuccess extends CVState {
  final ListCVResponse cvList;

  GetCvListSuccess(this.cvList);

  @override
  List<Object> get props => [cvList];
}

// create cv error
class GetCvListError extends CVState {
  final String message;


  GetCvListError({this.message});
  @override
  List<Object> get props => [message];
}
// get CV success
class UpdateCvSuccess extends CVState {
  final CVModel cvModel;

  UpdateCvSuccess(this.cvModel);

  @override
  List<Object> get props => [cvModel];
}

// create cv error
class UpdateCvError extends CVState {
  final String message;

  UpdateCvError({this.message});
  @override
  List<Object> get props => [message];
}
// get CV success
class DeleteCvSuccess extends CVState {
  final bool isDeleted;

  DeleteCvSuccess(this.isDeleted);

  @override
  List<Object> get props => [isDeleted];
}
// delete cv error
class DeleteCvError extends CVState {
  final String message;

  DeleteCvError({this.message});
  @override
  List<Object> get props => [message];
}

// get CV success
class GetCVByIdSuccess extends CVState {
  final CVModel cvModel;

  GetCVByIdSuccess(this.cvModel);

  @override
  List<Object> get props => [cvModel];
}

// create cv error
class GetCVByIdError extends CVState {
  final String message;

  GetCVByIdError({this.message});
  @override
  List<Object> get props => [message];
}
// get CV data position
class GetDataPositionSuccess extends CVState {
  final List<DataPosition> dataPosition;

  GetDataPositionSuccess(this.dataPosition);

  @override
  List<Object> get props => [dataPosition];
}
// get data error
class GetDataPositionError extends CVState {
  final String message;

  GetDataPositionError({this.message});
  @override
  List<Object> get props => [message];
}
