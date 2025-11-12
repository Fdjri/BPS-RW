import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/belum_verif.dart';

part 'belum_verif_state.dart';

class UnverifiedChecklistCubit extends Cubit<UnverifiedChecklistState> {
  UnverifiedChecklistCubit() : super(const UnverifiedChecklistState());
  final List<Map<String, dynamic>> _mockDetailRumah = const [
    {
      "nama": "Jl. Makaliwe I - (Triyono)",
      "rt": "002",
      "sampah": {"mudah_terurai": true, "material_daur": false, "b3": false, "residu": false} 
    },
    {
      "nama": "Jl Gogol no 999 - ()",
      "rt": "002",
      "sampah": {"mudah_terurai": false, "material_daur": true, "b3": false, "residu": false}
    },
    {
      "nama": "Jl. Makaliwe II - (Samsul)",
      "rt": "003",
      "sampah": {"mudah_terurai": true, "material_daur": true, "b3": false, "residu": false}
    },
  ];
  late final List<Map<String, dynamic>> _mockDataMentah = [
    {
      "tanggal": DateTime(2025, 10, 9),
      "mudah_terurai": 0,
      "material_daur": 0,
      "b3": 0,
      "residu": 0,
      "detail_rumah": _mockDetailRumah.sublist(0,2), 
    },
    {
      "tanggal": DateTime(2025, 10, 9), 
      "mudah_terurai": 6,
      "material_daur": 6,
      "b3": 0,
      "residu": 1,
      "detail_rumah": _mockDetailRumah, 
    },
     {
      "tanggal": DateTime(2025, 10, 8),
      "mudah_terurai": 5,
      "material_daur": 3,
      "b3": 1,
      "residu": 2,
      "detail_rumah": _mockDetailRumah.sublist(1,3), 
    },
     {
      "tanggal": DateTime(2025, 9, 7),
      "mudah_terurai": 8,
      "material_daur": 4,
      "b3": 0,
      "residu": 3,
      "detail_rumah": _mockDetailRumah.sublist(0,1), 
    },
  ];

  Future<void> fetchData() async {
    emit(state.copyWith(status: UnverifiedChecklistStatus.loading));
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final listData = _mockDataMentah.map((map) => UnverifiedChecklist.fromMock(map)).toList();
      emit(state.copyWith(
        status: UnverifiedChecklistStatus.success,
        listData: listData,
        filteredListData: listData, 
      ));
    } catch (e) {
      emit(state.copyWith(
        status: UnverifiedChecklistStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _filterData(String bulan, String tahun) {
    List<UnverifiedChecklist> filteredList = state.listData;
    if (tahun != 'Semua Tahun') {
      int tahunInt = int.parse(tahun);
      filteredList = filteredList.where((item) => item.tanggal.year == tahunInt).toList();
    }
    if (bulan != 'Semua Bulan') {
      int bulanInt = state.listBulan.indexOf(bulan);
      filteredList = filteredList.where((item) => item.tanggal.month == bulanInt).toList();
    }
    emit(state.copyWith(
      status: UnverifiedChecklistStatus.success,
      filteredListData: filteredList,
    ));
  }

  void filterBulanChanged(String bulan) {
    if (bulan == state.selectedBulan) return;
    
    emit(state.copyWith(
      status: UnverifiedChecklistStatus.loading, 
      selectedBulan: bulan
    ));
    _filterData(bulan, state.selectedTahun);
  }

  void filterTahunChanged(String tahun) {
    if (tahun == state.selectedTahun) return;
    
    emit(state.copyWith(
      status: UnverifiedChecklistStatus.loading,
      selectedTahun: tahun
    ));
    _filterData(state.selectedBulan, tahun);
  }
}