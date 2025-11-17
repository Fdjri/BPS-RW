part of 'profile_rw_cubit.dart';

abstract class ProfileRwState extends Equatable {
  const ProfileRwState();

  @override
  List<Object> get props => [];
}

class ProfileRwInitial extends ProfileRwState {}

class ProfileRwLoading extends ProfileRwState {}

class ProfileRwLoaded extends ProfileRwState {
  final ProfileRw profileRw;

  const ProfileRwLoaded(this.profileRw);

  @override
  List<Object> get props => [profileRw];
}

class ProfileRwError extends ProfileRwState {
  final String message;

  const ProfileRwError(this.message);

  @override
  List<Object> get props => [message];
}