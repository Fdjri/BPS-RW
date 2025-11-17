import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/profile_bps.dart';

part 'profile_bps_state.dart';

class ProfileBpsCubit extends Cubit<ProfileBpsState> {
  // TODO: inject -> final GetProfileBpsUseCase getProfileBpsUseCase;

  ProfileBpsCubit(
    // {required this.getProfileBpsUseCase}
  ) : super(ProfileBpsInitial());

  void getProfileBps() {
    emit(ProfileBpsLoading());
    
    // --- DUMMY ---
    emit(ProfileBpsLoaded(ProfileBps.dummy()));
  }
}