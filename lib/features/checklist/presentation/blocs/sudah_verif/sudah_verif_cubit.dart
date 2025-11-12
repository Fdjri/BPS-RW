import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/sudah_verif.dart';

part 'sudah_verif_state.dart';

class VerifiedChecklistCubit extends Cubit<VerifiedChecklistState> {
  VerifiedChecklistCubit() : super(const VerifiedChecklistState());
  final List<Map<String, dynamic>> _mockDetailRumah = const [
    {
      "nama": "Jl. Makaliwe I - (Triyono)", "rt": "002",
      "sampah": {"mudah_terurai": true, "material_daur": false, "b3": false, "residu": false} 
    },
    {
      "nama": "Jl Gogol no 999 - ()", "rt": "002",
      "sampah": {"mudah_terurai": false, "material_daur": true, "b3": false, "residu": false}
    },
  ];
  
  late final List<Map<String, dynamic>> _mockDataMentah = [
    {
      "tanggal": DateTime(2025, 8, 15), 
      "mudah_terurai": 2,
      "material_daur": 1,
      "b3": 0,
      "residu": 1,
      "detail_rumah": _mockDetailRumah.sublist(0,1),
    },
    {
      "tanggal": DateTime(2025, 8, 15), 
      "mudah_terurai": 5,
      "material_daur": 3,
      "b3": 1,
      "residu": 2,
      "detail_rumah": _mockDetailRumah,
    },
     {
      "tanggal": DateTime(2025, 7, 14), 
      "mudah_terurai": 4,
      "material_daur": 2,
      "b3": 0,
      "residu": 1,
      "detail_rumah": _mockDetailRumah.sublist(1,2),
    },
  ];

  Future<void> fetchData() async {
    emit(state.copyWith(status: VerifiedChecklistStatus.loading));
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final listData = _mockDataMentah.map((map) => VerifiedChecklist.fromMock(map)).toList();
      emit(state.copyWith(
        status: VerifiedChecklistStatus.success,
        listData: listData,
        filteredListData: listData,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VerifiedChecklistStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _filterData(String bulan, String tahun) {
    List<VerifiedChecklist> filteredList = state.listData;
    if (tahun != 'Semua Tahun') {
      int tahunInt = int.parse(tahun);
      filteredList = filteredList.where((item) => item.tanggal.year == tahunInt).toList();
    }
    if (bulan != 'Semua Bulan') {
      int bulanInt = state.listBulan.indexOf(bulan);
      filteredList = filteredList.where((item) => item.tanggal.month == bulanInt).toList();
    }
    emit(state.copyWith(
      status: VerifiedChecklistStatus.success,
      filteredListData: filteredList,
    ));
  }

  void filterBulanChanged(String bulan) {
    if (bulan == state.selectedBulan) return;
    emit(state.copyWith(
      status: VerifiedChecklistStatus.loading, 
      selectedBulan: bulan
    ));
    _filterData(bulan, state.selectedTahun);
  }

  void filterTahunChanged(String tahun) {
    if (tahun == state.selectedTahun) return;
    emit(state.copyWith(
      status: VerifiedChecklistStatus.loading,
      selectedTahun: tahun
    ));
    _filterData(state.selectedBulan, tahun);
  }
}