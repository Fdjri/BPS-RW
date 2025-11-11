import 'package:flutter_bloc/flutter_bloc.dart';
import 'tambah_nik_state.dart';
import 'dart:async';

class TambahNikCubit extends Cubit<TambahNikState> {
  TambahNikCubit() : super(TambahNikState.initial());

  Future<void> cekData(String nik) async {
    if (nik.isEmpty || nik.length < 16) {
      emit(state.copyWith(
        checkStatus: TambahNikCheckStatus.failure,
        errorMessage: 'NIK tidak valid. Harap isi 16 digit.',
      ));
      emit(state.copyWith(checkStatus: TambahNikCheckStatus.initial));
      return;
    }
    emit(state.copyWith(checkStatus: TambahNikCheckStatus.loading));
    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      final dataFromApi = {
        "namaKepala": "Bambang Sudarsono (Dummy)",
        "namaPemilik": "Bambang Sudarsono (Dummy)",
        "bangunanId": "50001234 (Dummy)",
        "nasabahStatus": "True (Dummy)",
      };
      emit(state.copyWith(
        checkStatus: TambahNikCheckStatus.success,
        checkedData: dataFromApi,
      ));
      emit(state.copyWith(checkStatus: TambahNikCheckStatus.initial));
    } catch (e) {
      emit(state.copyWith(
        checkStatus: TambahNikCheckStatus.failure,
        errorMessage: 'Data NIK tidak ditemukan: ${e.toString()}',
      ));
      emit(state.copyWith(checkStatus: TambahNikCheckStatus.initial));
    }
  }

  Future<void> saveData(Map<String, dynamic> formData) async {
    if (formData['ktp'] == null || formData['ktp'].isEmpty) {
      emit(state.copyWith(
        submitStatus: TambahNikSubmitStatus.failure,
        errorMessage: 'NIK tidak boleh kosong.',
      ));
      emit(state.copyWith(submitStatus: TambahNikSubmitStatus.initial));
      return;
    }
    if (formData['namaKepala'] == null || formData['namaKepala'].isEmpty) {
      emit(state.copyWith(
        submitStatus: TambahNikSubmitStatus.failure,
        errorMessage: 'Nama Kepala Keluarga tidak boleh kosong. (Tekan CEK DATA dulu)',
      ));
      emit(state.copyWith(submitStatus: TambahNikSubmitStatus.initial));
      return;
    }
    emit(state.copyWith(submitStatus: TambahNikSubmitStatus.loading));
    try {
      print("Saving data to API: $formData");
      await Future.delayed(const Duration(milliseconds: 1500));
      print("Save success!");
      emit(state.copyWith(submitStatus: TambahNikSubmitStatus.success));
    } catch (e) {
      emit(state.copyWith(
        submitStatus: TambahNikSubmitStatus.failure,
        errorMessage: 'Gagal menyimpan data: ${e.toString()}',
      ));
      emit(state.copyWith(submitStatus: TambahNikSubmitStatus.initial));
    }
  }
}