import 'package:flutter_bloc/flutter_bloc.dart';
import 'potensi_rumah_state.dart';
import '../../../domain/entities/potensi_rumah.dart'; 
import 'dart:async';

class PotensiRumahCubit extends Cubit<PotensiRumahState> {
  PotensiRumahCubit() : super(PotensiRumahState.initial());

  Future<void> fetchDataPotensiRumah() async {
    emit(state.copyWith(status: PotensiRumahStatus.loading));

    try {
      await Future.delayed(const Duration(seconds: 1));
      final mockData = _getMockData();
      final rtOptions = _extractRTs(mockData);
      emit(state.copyWith(
        status: PotensiRumahStatus.success,
        allDataPotensi: mockData,
        filteredDataPotensi: mockData, 
        rtOptions: rtOptions,
        selectedRT: 'Semua RT',
        selectedStatus: 'Semua Status',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PotensiRumahStatus.failure,
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
      filteredDataPotensi: filteredList,
    ));
  }

  List<PotensiRumah> _applyFilter(String status, String rt) {
    List<PotensiRumah> filtered = List.from(state.allDataPotensi);
    if (status == 'Potensi') {
      filtered = filtered.where((data) => data.statusPotensi).toList();
    } else if (status == 'Bukan Potensi') {
      filtered = filtered.where((data) => !data.statusPotensi).toList();
    }
    if (rt != 'Semua RT') {
      filtered = filtered.where((data) => data.rt == rt).toList();
    }
    return filtered;
  }
  
  List<String> _extractRTs(List<PotensiRumah> data) {
    final rtSet = data.map((e) => e.rt).toSet();
    final rtList = rtSet.toList();
    rtList.sort();
    return ['Semua RT', ...rtList];
  }

  List<PotensiRumah> _getMockData() {
    return [
      const PotensiRumah(
        rt: "012", rw: "007",
        alamat: "Jalan Sawo Raya",
        alamatFull: "KOTA ADM. JAKARTA BARAT, Grogol Petamburan, Grogol",
        nama: "yusuf",
        bangunanId: "5000042",
        statusPotensi: true,
      ),
      const PotensiRumah(
        rt: "015", rw: "007",
        alamat: "Jalan Mangga Dua",
        alamatFull: "KOTA ADM. JAKARTA BARAT, Sawah Besar, Mangga Dua",
        nama: "ani",
        bangunanId: "5000043",
        statusPotensi: false,
      ),
      const PotensiRumah(
        rt: "020", rw: "007",
        alamat: "Jalan Melati Indah",
        alamatFull: "KOTA ADM. JAKARTA BARAT, Taman Sari, Melati Indah",
        nama: "budi",
        bangunanId: "5000044",
        statusPotensi: false,
      ),
    ];
  }
}