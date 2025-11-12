import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/rumah_checklist.dart';

part 'checklist_input_state.dart';

class ChecklistInputCubit extends Cubit<ChecklistInputState> {
  ChecklistInputCubit() : super(const ChecklistInputState());
  final List<Map<String, dynamic>> _mockDataMentah = List.generate(10, (index) => {
        "nama": "Budi Santoso ${index + 1}",
        "alamat": "Jl. Mawar No. ${10 + index}",
        "rt": "00${(index % 3) + 1}",
        "sampah": <String, bool>{
          "mudah_terurai": index == 0,
          "material_daur": index == 0,
          "b3": index == 0,
          "residu": index == 0,
        },
        "foto_uploaded": index == 0,
      });

  Future<void> fetchListRumah() async {
    emit(state.copyWith(status: ChecklistInputStatus.loading));
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final listData = _mockDataMentah.map((map) => RumahChecklist.fromMock(map)).toList();
      final listRT = ['Semua RT', ...listData.map((e) => e.rt).toSet().toList()];
      
      emit(state.copyWith(
        status: ChecklistInputStatus.success,
        listRumah: listData,
        filteredListRumah: listData,
        listRT: listRT, 
        selectedRT: 'Semua RT',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ChecklistInputStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void filterRtChanged(String rt) {
    if (rt == state.selectedRT) return; 
    emit(state.copyWith(status: ChecklistInputStatus.loading, selectedRT: rt));
    List<RumahChecklist> filteredList;
    if (rt == 'Semua RT') {
      filteredList = state.listRumah;
    } else {
      filteredList = state.listRumah.where((rumah) => rumah.rt == rt).toList();
    }
    emit(state.copyWith(
      status: ChecklistInputStatus.success,
      filteredListRumah: filteredList,
    ));
  }
  
  void updateSampahChecklist(String rumahId, String jenisSampah, bool isChecked) {
    print("Simulasi API: Update rumah $rumahId, $jenisSampah = $isChecked");
    final newList = state.listRumah.map((rumah) {
      if (rumah.id == rumahId) {
        final newSampah = Map<String, bool>.from(rumah.sampah);
        newSampah[jenisSampah] = isChecked; 
        
        return rumah.copyWith(sampah: newSampah); 
      }
      return rumah;
    }).toList();
    final newFilteredList = (state.selectedRT == 'Semua RT')
      ? newList
      : newList.where((rumah) => rumah.rt == state.selectedRT).toList();
    emit(state.copyWith(
      listRumah: newList,
      filteredListRumah: newFilteredList,
    ));
  }

  Future<void> submitFoto(String rumahId, File foto) async {
    emit(state.copyWith(status: ChecklistInputStatus.uploadingFoto));
    try {
      await Future.delayed(const Duration(seconds: 2));
      print("Simulasi API: Sukses upload foto $rumahId, path: ${foto.path}");
      final newList = state.listRumah.map((rumah) {
        if (rumah.id == rumahId) {
          return rumah.copyWith(fotoUploaded: true); 
        }
        return rumah;
      }).toList();
      final newFilteredList = (state.selectedRT == 'Semua RT')
        ? newList
        : newList.where((rumah) => rumah.rt == state.selectedRT).toList();
      emit(state.copyWith(
        status: ChecklistInputStatus.uploadFotoSuccess, 
        listRumah: newList,
        filteredListRumah: newFilteredList,
      ));
    } catch (e) {
      print("Simulasi API: Gagal upload foto $rumahId. Error: $e");
      emit(state.copyWith(
        status: ChecklistInputStatus.uploadFotoFailure,
        errorMessage: e.toString()
      ));
    }
  }

  Future<void> submitTotalWeight(Map<String, String> dataBerat) async {
    emit(state.copyWith(status: ChecklistInputStatus.submittingTotal));
    try {
      await Future.delayed(const Duration(seconds: 1));
      print("Simulasi API: Submit total berat: $dataBerat");
      emit(state.copyWith(status: ChecklistInputStatus.submitTotalSuccess));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(state.copyWith(status: ChecklistInputStatus.success));
    } catch (e) {
      print("Simulasi API: Gagal submit total berat. Error: $e");
      emit(state.copyWith(
        status: ChecklistInputStatus.submitTotalFailure,
        errorMessage: e.toString()
      ));
    }
  }
}