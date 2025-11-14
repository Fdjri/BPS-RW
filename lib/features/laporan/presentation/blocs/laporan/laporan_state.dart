part of 'laporan_cubit.dart';

enum LaporanStatus { initial, loading, success, failure }

class LaporanState extends Equatable {
  final LaporanStatus status;
  final List<Laporan> listLaporan; // Data asli
  final List<Laporan> filteredLaporanList; // Data yang sudah difilter
  final String selectedBulan;
  final String selectedTahun;
  final List<String> listBulan;
  final List<String> listTahun;
  final String? errorMessage;

  const LaporanState({
    this.status = LaporanStatus.initial,
    this.listLaporan = const [],
    this.filteredLaporanList = const [],
    this.selectedBulan = 'Semua Bulan',
    this.selectedTahun = '2025',
    this.listBulan = const [
      'Semua Bulan', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ],
    this.listTahun = const ['2025', '2024', '2023', '2022'],
    this.errorMessage,
  });

  LaporanState copyWith({
    LaporanStatus? status,
    List<Laporan>? listLaporan,
    List<Laporan>? filteredLaporanList,
    String? selectedBulan,
    String? selectedTahun,
    List<String>? listBulan,
    List<String>? listTahun,
    String? errorMessage,
  }) {
    return LaporanState(
      status: status ?? this.status,
      listLaporan: listLaporan ?? this.listLaporan,
      filteredLaporanList:
          filteredLaporanList ?? this.filteredLaporanList,
      selectedBulan: selectedBulan ?? this.selectedBulan,
      selectedTahun: selectedTahun ?? this.selectedTahun,
      listBulan: listBulan ?? this.listBulan,
      listTahun: listTahun ?? this.listTahun,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        listLaporan,
        filteredLaporanList,
        selectedBulan,
        selectedTahun,
        listBulan,
        listTahun,
        errorMessage,
      ];
}