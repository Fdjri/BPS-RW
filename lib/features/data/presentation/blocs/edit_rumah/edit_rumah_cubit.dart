import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_rumah_state.dart';
import '../../../domain/entities/data_rumah.dart';
import 'dart:async';

class EditRumahCubit extends Cubit<EditRumahState> {
  EditRumahCubit({
    required DataRumah initialData,
    required List<String> allRtOptions,
  }) : super(EditRumahState(
          status: EditRumahStatus.initial,
          initialDataRumah: initialData,
          nama: initialData.nama,
          alamat: initialData.alamatDinas,
          selectedRT: initialData.rt,
          rtOptions: allRtOptions, 
        ));

  void namaChanged(String nama) {
    emit(state.copyWith(nama: nama));
  }

  void alamatChanged(String alamat) {
    emit(state.copyWith(alamat: alamat));
  }

  void rtChanged(String rt) {
    emit(state.copyWith(selectedRT: rt));
  }

  Future<void> saveChanges() async {
    emit(state.copyWith(status: EditRumahStatus.submitting));
    try {
      final dataToSave = state.initialDataRumah.copyWith(
        nama: state.nama,
        alamatDinas: state.alamat,
        rt: state.selectedRT,
      );
      print("Sending data to API: ${dataToSave.toMap()}");
      await Future.delayed(const Duration(milliseconds: 1500));
      print("API update success!");
      emit(state.copyWith(status: EditRumahStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: EditRumahStatus.failure,
        errorMessage: "Gagal simpan data: ${e.toString()}",
      ));
    }
  }
}