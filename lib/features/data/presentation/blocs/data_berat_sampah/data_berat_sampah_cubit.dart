import 'package:flutter_bloc/flutter_bloc.dart';
import 'data_berat_sampah_state.dart'; 
import '../../../domain/entities/data_berat_sampah.dart'; 
import 'dart:async';

class BeratSampahCubit extends Cubit<BeratSampahState> {
  BeratSampahCubit() : super(BeratSampahState.initial());

  Future<void> fetchDataBeratSampah() async {
    emit(state.copyWith(status: BeratSampahStatus.loading));
    try {
      await Future.delayed(const Duration(seconds: 1));
      final mockData = _getMockData();
      final rtOptions = _extractRTs(mockData);
      final filteredData = _applyFilter(
        mockData,
        state.selectedBulan,
        state.selectedTahun,
        state.selectedRT,
      );

      emit(state.copyWith(
        status: BeratSampahStatus.success,
        allDataBerat: mockData,
        filteredDataBerat: filteredData,
        rtOptions: rtOptions,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BeratSampahStatus.failure,
        errorMessage: 'Gagal memuat data: ${e.toString()}',
      ));
    }
  }

  void changeFilter({String? bulan, String? tahun, String? rt}) {
    final newBulan = bulan ?? state.selectedBulan;
    final newTahun = tahun ?? state.selectedTahun;
    final newRT = rt ?? state.selectedRT;

    final filteredList = _applyFilter(
      state.allDataBerat,
      newBulan,
      newTahun,
      newRT,
    );

    emit(state.copyWith(
      selectedBulan: newBulan,
      selectedTahun: newTahun,
      selectedRT: newRT,
      filteredDataBerat: filteredList,
    ));
  }

  List<BeratSampah> _applyFilter(
    List<BeratSampah> allData,
    String newBulan,
    String newTahun,
    String newRT,
  ) {
    List<BeratSampah> filtered = List.from(allData);
    if (newRT != 'Semua RT') {
      filtered = filtered.where((data) => data.rt == newRT).toList();
    }
    if (newTahun != 'Semua Tahun') { 
      filtered = filtered.where((data) => data.tanggal.year.toString() == newTahun).toList();
    }
    final int bulanNum = _getMonthNumber(newBulan);
    if (bulanNum != 0) { 
      filtered = filtered.where((data) => data.tanggal.month == bulanNum).toList();
    }
    return filtered;
  }
  
  int _getMonthNumber(String monthName) {
    final index = state.bulanOptions.indexOf(monthName);
    return index; 
  }

  List<String> _extractRTs(List<BeratSampah> data) {
    final rtSet = data.map((e) => e.rt).toSet();
    final rtList = rtSet.toList();
    rtList.sort();
    return ['Semua RT', ...rtList];
  }

  List<BeratSampah> _getMockData() {
    return [
      BeratSampah(
        tanggal: DateTime(2025, 1, 15), 
        rt: "001",
        mudahTerurai: 12.50,
        materialDaur: 8.30,
        b3: 1.20,
        residu: 5.80,
        total: 27.80
      ),
      BeratSampah(
        tanggal: DateTime(2025, 1, 14),
        rt: "002",
        mudahTerurai: 10.00,
        materialDaur: 5.10,
        b3: 0.50,
        residu: 3.20,
        total: 18.80
      ),
      BeratSampah(
        tanggal: DateTime(2025, 1, 13), 
        rt: "001",
        mudahTerurai: 11.20,
        materialDaur: 7.00,
        b3: 0.80,
        residu: 4.50,
        total: 23.50
      ),
       BeratSampah(
        tanggal: DateTime(2025, 2, 5),
        rt: "003",
        mudahTerurai: 15.0,
        materialDaur: 6.0,
        b3: 0.0,
        residu: 3.0,
        total: 24.0
      ),
       BeratSampah(
        tanggal: DateTime(2024, 12, 20), 
        rt: "001",
        mudahTerurai: 9.5,
        materialDaur: 4.5,
        b3: 1.5,
        residu: 2.5,
        total: 18.0
      ),
    ];
  }
}