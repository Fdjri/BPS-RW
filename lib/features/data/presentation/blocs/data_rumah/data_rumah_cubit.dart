import 'package:flutter_bloc/flutter_bloc.dart';
import 'data_rumah_state.dart'; 
import '../../../domain/entities/data_rumah.dart'; 
import 'dart:async'; 

class DataRumahCubit extends Cubit<DataRumahState> {
  DataRumahCubit() : super(DataRumahState.initial());

  Future<void> fetchDataRumah() async {
    emit(state.copyWith(status: DataRumahStatus.loading));

    try {
      await Future.delayed(const Duration(seconds: 1));
      final mockData = _getMockData();
      final rtOptions = _extractRTs(mockData);
      emit(state.copyWith(
        status: DataRumahStatus.success,
        allDataRumah: mockData,
        filteredDataRumah: mockData, 
        rtOptions: rtOptions,
        selectedRT: 'Semua RT',
        selectedStatus: 'Semua Status', 
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DataRumahStatus.failure,
        errorMessage: 'Gagal memuat data: ${e.toString()}',
      ));
    }
  }

  void changeFilter({String? status, String? rt}) {
    final newStatus = status ?? state.selectedStatus;
    final newRT = rt ?? state.selectedRT;
    final filteredList = _applyFilter(newStatus, newRT);

    emit(state.copyWith(
      selectedStatus: newStatus,
      selectedRT: newRT,
      filteredDataRumah: filteredList,
    ));
  }

  List<DataRumah> _applyFilter(String status, String rt) {
    List<DataRumah> filtered = List.from(state.allDataRumah);
    if (status == 'Aktif') {
      filtered = filtered.where((data) => data.statusAktif).toList();
    } else if (status == 'Tidak Aktif') {
      filtered = filtered.where((data) => !data.statusAktif).toList();
    } else if (status == 'Sudah Checklist') {
      filtered = filtered.where((data) => data.statusChecklist).toList();
    } else if (status == 'Belum Checklist') {
      filtered = filtered.where((data) => !data.statusChecklist).toList();
    }
    if (rt != 'Semua RT') {
      filtered = filtered.where((data) => data.rt == rt).toList();
    }
    return filtered;
  }
  
  List<String> _extractRTs(List<DataRumah> data) {
    final rtSet = data.map((e) => e.rt).toSet();
    final rtList = rtSet.toList();
    rtList.sort(); 
    return ['Semua RT', ...rtList]; 
  }

  List<DataRumah> _getMockData() {
    return [
      const DataRumah(
        alamatDinas: 'Jl. Melati No. 1',
        alamatFull: 'Jl. Melati No. 1, Blok A, Kel. Suka Maju',
        nama: 'Budi Santoso',
        rt: '001',
        rw: '005',
        statusAktif: true,
        statusChecklist: false,
      ),
      const DataRumah(
        alamatDinas: 'Jl. Mawar No. 10',
        alamatFull: 'Jl. Mawar No. 10, Blok B, Kel. Suka Maju',
        nama: 'Siti Aminah',
        rt: '002',
        rw: '005',
        statusAktif: true,
        statusChecklist: true,
      ),
      const DataRumah(
        alamatDinas: 'Jl. Kenanga No. 5',
        alamatFull: 'Jl. Kenanga No. 5, Blok C, Kel. Suka Maju',
        nama: 'Ahmad Dahlan',
        rt: '001',
        rw: '005',
        statusAktif: false,
        statusChecklist: false,
      ),
      const DataRumah(
        alamatDinas: 'Jl. Kamboja No. 8',
        alamatFull: 'Jl. Kamboja No. 8, Blok D, Kel. Suka Maju',
        nama: 'Dewi Lestari',
        rt: '003',
        rw: '005',
        statusAktif: true,
        statusChecklist: true,
      ),
    ];
  }
}