part of 'profile_bps_cubit.dart';

abstract class ProfileBpsState extends Equatable {
  const ProfileBpsState();

  @override
  List<Object> get props => [];
}

class ProfileBpsInitial extends ProfileBpsState {}

class ProfileBpsLoading extends ProfileBpsState {}

class ProfileBpsLoaded extends ProfileBpsState {
  final ProfileBps profileBps;

  const ProfileBpsLoaded(this.profileBps);

  @override
  List<Object> get props => [profileBps];
}

class ProfileBpsError extends ProfileBpsState {
  final String message;

  const ProfileBpsError(this.message);

  @override
  List<Object> get props => [message];
}