part of 'detail_laporan_cubit.dart';

enum DetailLaporanStatus { initial, loading, success, failure }

class DetailLaporanState extends Equatable {
  final DetailLaporanStatus status;
  final Laporan? laporan; 
  final List<DokumentasiLaporan> listDokumentasi; 
  final String? errorMessage;

  const DetailLaporanState({
    this.status = DetailLaporanStatus.initial,
    this.laporan,
    this.listDokumentasi = const [],
    this.errorMessage,
  });

  DetailLaporanState copyWith({
    DetailLaporanStatus? status,
    Laporan? laporan,
    List<DokumentasiLaporan>? listDokumentasi,
    String? errorMessage,
  }) {
    return DetailLaporanState(
      status: status ?? this.status,
      laporan: laporan ?? this.laporan,
      listDokumentasi: listDokumentasi ?? this.listDokumentasi,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, laporan, listDokumentasi, errorMessage];
}