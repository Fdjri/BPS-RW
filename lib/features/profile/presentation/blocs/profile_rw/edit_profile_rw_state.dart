part of 'edit_profile_rw_cubit.dart';

abstract class EditProfileRwState extends Equatable {
  const EditProfileRwState();

  @override
  List<Object> get props => [];
}

class EditProfileRwInitial extends EditProfileRwState {}

class EditProfileRwLoading extends EditProfileRwState {}

class EditProfileRwSuccess extends EditProfileRwState {}

class EditProfileRwError extends EditProfileRwState {
  final String message;

  const EditProfileRwError(this.message);

  @override
  List<Object> get props => [message];
}