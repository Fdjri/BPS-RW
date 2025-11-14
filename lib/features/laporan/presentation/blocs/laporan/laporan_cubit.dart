import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/laporan_entities.dart';

part 'laporan_state.dart';

class LaporanCubit extends Cubit<LaporanState> {
  LaporanCubit() : super(const LaporanState());

  final List<Map<String, dynamic>> _mockDataMentah = [
    {
      "id": "1",
      "bulan": "Mei",
      "tahun": "2025",
      "jumlah_rumah": 120,
      "status": "VERIFIKASI SUDIN",
    },
    {
      "id": "2",
      "bulan": "Agustus",
      "tahun": "2025",
      "jumlah_rumah": 150,
      "status": "VERIFIKASI SATPEL",
    },
    {
      "id": "3",
      "bulan": "Desember",
      "tahun": "2024", 
      "jumlah_rumah": 100,
      "status": "N/A",
    },
  ];

  Future<void> fetchLaporan() async {
    emit(state.copyWith(status: LaporanStatus.loading));
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final listData =
          _mockDataMentah.map((map) => Laporan.fromMock(map)).toList();
      emit(state.copyWith(
        status: LaporanStatus.success,
        listLaporan: listData,
        filteredLaporanList: listData, 
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LaporanStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _filterData(String bulan, String tahun) {
    List<Laporan> filteredList = state.listLaporan;
    if (tahun != 'Semua Tahun') {
    }
    if (bulan != 'Semua Bulan') {
      filteredList =
          filteredList.where((item) => item.bulan == bulan).toList();
    }
    emit(state.copyWith(
      status: LaporanStatus.success,
      filteredLaporanList: filteredList,
    ));
  }

  void filterBulanChanged(String bulan) {
    if (bulan == state.selectedBulan) return;
    emit(state.copyWith(
      status: LaporanStatus.loading, 
      selectedBulan: bulan
    ));
    _filterData(bulan, state.selectedTahun);
  }

  void filterTahunChanged(String tahun) {
    if (tahun == state.selectedTahun) return;
    emit(state.copyWith(
      status: LaporanStatus.loading, 
      selectedTahun: tahun
    ));
    _filterData(state.selectedBulan, tahun);
  }
}