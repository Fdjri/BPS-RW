import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/profile_rw.dart';

part 'profile_rw_state.dart';

class ProfileRwCubit extends Cubit<ProfileRwState> {

  ProfileRwCubit(
    // {required this.getProfileRwUseCase}
  ) : super(ProfileRwInitial());

  Future<void> getProfileRw() async {
    emit(ProfileRwLoading());
    
    // --- TODO: PANGGIL USE CASE ---
    // final failureOrProfile = await getProfileRwUseCase(NoParams());
    // failureOrProfile.fold(
    //   (failure) => emit(ProfileRwError(failure.message)),
    //   (profile) => emit(ProfileRwLoaded(profile)),
    // );
    
    // --- PAKAI DUMMY DULU ---
    await Future.delayed(const Duration(seconds: 1));
    emit(ProfileRwLoaded(ProfileRw.dummy()));
  }
}