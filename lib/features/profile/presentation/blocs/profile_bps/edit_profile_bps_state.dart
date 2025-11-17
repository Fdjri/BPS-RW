part of 'edit_profile_bps_cubit.dart';

// State ini ngatur logic pas nge-submit form
abstract class EditProfileBpsState extends Equatable {
  const EditProfileBpsState();

  @override
  List<Object> get props => [];
}

class EditProfileBpsInitial extends EditProfileBpsState {}

class EditProfileBpsLoading extends EditProfileBpsState {}

class EditProfileBpsSuccess extends EditProfileBpsState {}

class EditProfileBpsError extends EditProfileBpsState {
  final String message;

  const EditProfileBpsError(this.message);

  @override
  List<Object> get props => [message];
}