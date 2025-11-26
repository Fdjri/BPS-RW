import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/rumah_checklist.dart';
import '../../../domain/use_cases/get_input_checklist.dart';

part 'checklist_input_state.dart';

class ChecklistInputCubit extends Cubit<ChecklistInputState> {
  final GetInputChecklist getInputChecklist;

  ChecklistInputCubit({required this.getInputChecklist})
      : super(const ChecklistInputState()); 

  Future<void> fetchListRumah() async {
    emit(state.copyWith(status: ChecklistInputStatus.loading));

    final result = await getInputChecklist();

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ChecklistInputStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (data) {
        final uniqueRTs = data.map((RumahChecklist e) => e.rt).toSet().toList();
        uniqueRTs.sort();
        
        final listRT = ['Semua RT', ...uniqueRTs];

        emit(state.copyWith(
          status: ChecklistInputStatus.success,
          listRumah: data,
          filteredListRumah: data,
          listRT: listRT,
          selectedRT: 'Semua RT',
        ));
      },
    );
  }

  void filterRtChanged(String rt) {
    if (rt == state.selectedRT) return;

    List<RumahChecklist> filteredList;
    if (rt == 'Semua RT') {
      filteredList = state.listRumah;
    } else {
      filteredList = state.listRumah.where((rumah) => rumah.rt == rt).toList();
    }

    emit(state.copyWith(
      status: ChecklistInputStatus.success,
      selectedRT: rt,
      filteredListRumah: filteredList,
    ));
  }

  // --- FITUR UPDATE LOKAL ---

  void updateSampahChecklist(String rumahId, String jenisSampah, bool isChecked) {
    final newList = state.listRumah.map((rumah) {
      if (rumah.id == rumahId) {
        final newSampah = Map<String, bool>.from(rumah.sampah);
        newSampah[jenisSampah] = isChecked;
        return rumah.copyWith(sampah: newSampah);
      }
      return rumah;
    }).toList();

    _updateFilteredList(newList);
  }

  Future<void> submitFoto(String rumahId, File foto) async {
    emit(state.copyWith(status: ChecklistInputStatus.uploadingFoto));
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      final newList = state.listRumah.map((rumah) {
        if (rumah.id == rumahId) {
          return rumah.copyWith(fotoUploaded: true);
        }
        return rumah;
      }).toList();

      emit(state.copyWith(status: ChecklistInputStatus.uploadFotoSuccess));
      _updateFilteredList(newList);
      
    } catch (e) {
      emit(state.copyWith(
        status: ChecklistInputStatus.uploadFotoFailure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> submitTotalWeight(Map<String, String> dataBerat) async {
    emit(state.copyWith(status: ChecklistInputStatus.submittingTotal));
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: ChecklistInputStatus.submitTotalSuccess));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(state.copyWith(status: ChecklistInputStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ChecklistInputStatus.submitTotalFailure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _updateFilteredList(List<RumahChecklist> newList) {
     final newFilteredList = (state.selectedRT == 'Semua RT')
        ? newList
        : newList.where((rumah) => rumah.rt == state.selectedRT).toList();

    emit(state.copyWith(
      listRumah: newList,
      filteredListRumah: newFilteredList,
      status: ChecklistInputStatus.success, 
    ));
  }
}