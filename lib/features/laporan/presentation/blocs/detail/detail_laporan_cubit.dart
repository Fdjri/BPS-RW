import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/laporan_entities.dart';
import '../../../domain/entities/dokumentasi_laporan.dart';

part 'detail_laporan_state.dart';

class DetailLaporanCubit extends Cubit<DetailLaporanState> {
  DetailLaporanCubit() : super(const DetailLaporanState());
  final Map<String, dynamic> _mockDataLengkap = {
    "laporan": {
      "id": "1",
      "bulan": "Mei",
      "tahun": "2025",
      "jumlah_rumah": 120,
      "status": "VERIFIKASI SUDIN",
    },
    "dokumentasi": [
      {
        "id": "doc_1",
        "keterangan": "Lorem Ipsum Dolor Sit Amet 1",
        "tanggalPelaksanaan": DateTime(2025, 11, 13),
        "pelaksanaKegiatan": "Sule Prikitiw 1",
        "fotoUrl": "https://placehold.co/600x400/000000/FFFFFF/png?text=Dokumentasi+1"
      },
      {
        "id": "doc_2",
        "keterangan": "Lorem Ipsum Dolor Sit Amet 2",
        "tanggalPelaksanaan": DateTime(2025, 11, 14),
        "pelaksanaKegiatan": "Sule Prikitiw 2",
        "fotoUrl": "https://placehold.co/600x400/E3E3E3/000000/png?text=Dokumentasi+2"
      }
    ]
  };


  Future<void> fetchDetail(String laporanId) async {
    emit(state.copyWith(status: DetailLaporanStatus.loading));
    try {
      // Simulasi ngambil data (statis)
      await Future.delayed(const Duration(milliseconds: 500));
      // 1. Konversi data info laporan
      final laporan = Laporan.fromMock(_mockDataLengkap['laporan']);
      // 2. Konversi list dokumentasi
      final List<Map<String, dynamic>> docsData = 
          List<Map<String, dynamic>>.from(_mockDataLengkap['dokumentasi']);
      final listDokumentasiRevisi = docsData.map((map) {
        return DokumentasiLaporan(
          id: map['id'],
          keterangan: map['keterangan'],
          tanggalPelaksanaan: map['tanggalPelaksanaan'],
          pelaksanaKegiatan: map['pelaksanaKegiatan'],
          isPhotoUploaded: true,
          fotoUrl: map['fotoUrl'], 
        );
      }).toList();
      emit(state.copyWith(
        status: DetailLaporanStatus.success,
        laporan: laporan,
        listDokumentasi: listDokumentasiRevisi,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DetailLaporanStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}