import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import '../../../domain/entities/profile_rw.dart';

part 'edit_profile_rw_state.dart';

class EditProfileRwCubit extends Cubit<EditProfileRwState> {
  // final UpdateProfileRwUseCase updateProfileRwUseCase;

  EditProfileRwCubit(
    // {required this.updateProfileRwUseCase}
  ) : super(EditProfileRwInitial());

  Future<void> submitProfile({
    required ProfileRw updatedProfile,
    PlatformFile? newSkFile,
  }) async {
    emit(EditProfileRwLoading());

    // Di sini logic buat upload file (if newSkFile != null)
    // dan kirim data ke use case

    // --- TODO: PANGGIL USE CASE ---
    // final params = UpdateProfileRwParams(updatedProfile, newSkFile);
    // final failureOrSuccess = await updateProfileRwUseCase(params);
    // failureOrSuccess.fold(
    //   (failure) => emit(EditProfileRwError(failure.message)),
    //   (_) => emit(EditProfileRwSuccess()),
    // );

    // ---  SIMULASI SUKSES ---
    await Future.delayed(const Duration(seconds: 2));
    // Cek kalo error buat testing
    // emit(EditProfileRwError('Gagal update, coba lagi.'));
    emit(EditProfileRwSuccess());
  }
}