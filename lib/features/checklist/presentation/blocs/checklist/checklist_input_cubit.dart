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

  // 1. Fetch Data Awal
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
        // Ambil daftar RT unik dan urutkan
        final uniqueRTs = data
            .map((e) => e.rt)
            .where((rt) => rt != null && rt.toString().isNotEmpty)
            .map((rt) => rt.toString())
            .toSet()
            .toList();
        
        uniqueRTs.sort();
        final listRT = ['Semua RT', ...uniqueRTs];

        // Set data awal, filter default (Semua RT & Search Kosong)
        emit(state.copyWith(
          status: ChecklistInputStatus.success,
          listRumah: data,
          filteredListRumah: data, 
          listRT: listRT,
        ));
      },
    );
  }

  // 2. Update Checklist (Checkbox)
  void updateSampahChecklist(String rumahId, String jenisSampah, bool val) {
    // Update di Master Data
    final updatedList = state.listRumah.map((rumah) {
      if (rumah.id == rumahId) {
        final newSampah = Map<String, bool>.from(rumah.sampah);
        newSampah[jenisSampah] = val;
        return rumah.copyWith(sampah: newSampah);
      }
      return rumah;
    }).toList();

    // Terapkan update ke state dan jalankan filter ulang
    _applyFiltersAndEmit(
      masterList: updatedList,
      rt: state.selectedRT,
      query: state.searchQuery,
    );
  }

  // 3. Filter Berdasarkan RT
  void filterRtChanged(String rt) {
    _applyFiltersAndEmit(
      masterList: state.listRumah,
      rt: rt,
      query: state.searchQuery, 
    );
  }

  // 4. Fitur SEARCH
  void searchChecklist(String query) {
    _applyFiltersAndEmit(
      masterList: state.listRumah,
      rt: state.selectedRT, 
      query: query,
    );
  }

  // 5. Submit Foto
  Future<void> submitFoto(String rumahId, File imageFile) async {
    emit(state.copyWith(status: ChecklistInputStatus.uploadingFoto));
    
    try {
      // Simulasi API Call
      await Future.delayed(const Duration(seconds: 2));
      
      // Update status foto di Master Data
      final updatedList = state.listRumah.map((rumah) {
        if (rumah.id == rumahId) {
          return rumah.copyWith(fotoUploaded: true);
        }
        return rumah;
      }).toList();

      emit(state.copyWith(status: ChecklistInputStatus.uploadFotoSuccess));
      
      // Kembalikan ke success dan update list
      _applyFiltersAndEmit(
        masterList: updatedList,
        rt: state.selectedRT,
        query: state.searchQuery,
        status: ChecklistInputStatus.success,
      );
      
    } catch (e) {
      emit(state.copyWith(
        status: ChecklistInputStatus.uploadFotoFailure,
        errorMessage: e.toString(),
      ));
    }
  }

  // 6. Submit Total Berat
  Future<void> submitTotalWeight(Map<String, String> dataBerat) async {
    emit(state.copyWith(status: ChecklistInputStatus.submittingTotal));
    try {
      // Simulasi Submit
      await Future.delayed(const Duration(seconds: 1));
      
      emit(state.copyWith(status: ChecklistInputStatus.submitTotalSuccess));
      
      // Reset status ke success biasa
      await Future.delayed(const Duration(milliseconds: 100));
      emit(state.copyWith(status: ChecklistInputStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ChecklistInputStatus.submitTotalFailure,
        errorMessage: e.toString(),
      ));
    }
  }

  // --- HELPER FUNCTION: SEARCH ---
  void _applyFiltersAndEmit({
    required List<RumahChecklist> masterList,
    required String rt,
    required String query,
    ChecklistInputStatus? status,
  }) {
    // 1. Normalisasi Query: Hapus simbol aneh, sisakan huruf & angka
    final cleanQuery = query.toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), ' ') 
        .trim(); 
        
    // Pecah query jadi list kata 
    final queryWords = cleanQuery.split(' ').where((word) => word.isNotEmpty).toList();

    // Debugging Print (Cek di Debug Console kalau masih error)
    // print("🔎 Search: '$query' -> Clean: '$cleanQuery' | Words: $queryWords");

    final filtered = masterList.where((rumah) {
      // --- Cek Filter RT ---
      final matchRT = (rt == 'Semua RT') || (rumah.rt == rt);
      if (!matchRT) return false;

      // --- Cek Search ---
      if (cleanQuery.isEmpty) return true;

      final alamatRaw = rumah.alamat;
      
      // Normalisasi Alamat: "Jl. Makaliwe I - (Triyono)" -> "jl makaliwe i triyono"
      final cleanAlamat = alamatRaw.toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9]'), ' '); 

      // Logika: Semua kata dalam query HARUS ada di dalam alamat
      bool matchAllWords = true;
      for (final word in queryWords) {
        if (!cleanAlamat.contains(word)) {
          matchAllWords = false;
          break;
        }
      }
      return matchAllWords;
    }).toList();

    emit(state.copyWith(
      status: status ?? ChecklistInputStatus.success,
      listRumah: masterList,
      filteredListRumah: filtered,
      selectedRT: rt,
      searchQuery: query,
    ));
  }
}