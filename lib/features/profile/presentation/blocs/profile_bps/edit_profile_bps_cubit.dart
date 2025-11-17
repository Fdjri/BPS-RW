import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/profile_bps.dart';
// import '../../domain/use_cases/update_profile_bps_usecase.dart'; 

part 'edit_profile_bps_state.dart';

class EditProfileBpsCubit extends Cubit<EditProfileBpsState> {
  // TODO: inject -> final UpdateProfileBpsUseCase updateProfileBpsUseCase; 

  EditProfileBpsCubit(
    // {required this.updateProfileBpsUseCase}
  ) : super(EditProfileBpsInitial());

  void submitProfileBps({
    required ProfileBps updatedProfile,
  }) { 
    emit(EditProfileBpsLoading());

    // --- SIMULASI SUKSES ---
    emit(EditProfileBpsSuccess());
  }
}