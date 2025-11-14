part of 'tambah_laporan_cubit.dart';

enum TambahLaporanStatus {
  initial, 
  loading, 
  success, 
  failure, 
  pickingImage, 
  imagePreviewReady, 
  imagePickSuccess, 
  imagePickFailed, 
}

class TambahLaporanState extends Equatable {
  final TambahLaporanStatus status;
  final String selectedBulan;
  final String selectedTahun;
  final String jumlahRumah;
  final List<DokumentasiLaporan> listDokumentasi;
  final List<String> listBulan;
  final List<String> listTahun;
  final String? errorMessage;
  final XFile? tempPickedImage;
  final double? tempImageSizeKB;
  final String? tempImageDocId; 

  const TambahLaporanState({
    this.status = TambahLaporanStatus.initial,
    this.selectedBulan = 'September', 
    this.selectedTahun = '2025', 
    this.jumlahRumah = '0',
    this.listDokumentasi = const [],
    this.listBulan = const [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ],
    this.listTahun = const ['2025', '2024', '2023'],
    this.errorMessage,
    this.tempPickedImage,
    this.tempImageSizeKB,
    this.tempImageDocId,
  });

  TambahLaporanState copyWith({
    TambahLaporanStatus? status,
    String? selectedBulan,
    String? selectedTahun,
    String? jumlahRumah,
    List<DokumentasiLaporan>? listDokumentasi,
    String? errorMessage,
    XFile? tempPickedImage,
    double? tempImageSizeKB,
    String? tempImageDocId,
    bool clearTempImage = false,
  }) {
    return TambahLaporanState(
      status: status ?? this.status,
      selectedBulan: selectedBulan ?? this.selectedBulan,
      selectedTahun: selectedTahun ?? this.selectedTahun,
      jumlahRumah: jumlahRumah ?? this.jumlahRumah,
      listDokumentasi: listDokumentasi ?? this.listDokumentasi,
      listBulan: listBulan, 
      listTahun: listTahun,
      errorMessage: errorMessage ?? this.errorMessage,
      tempPickedImage: clearTempImage ? null : (tempPickedImage ?? this.tempPickedImage),
      tempImageSizeKB: clearTempImage ? null : (tempImageSizeKB ?? this.tempImageSizeKB),
      tempImageDocId: clearTempImage ? null : (tempImageDocId ?? this.tempImageDocId),
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedBulan,
        selectedTahun,
        jumlahRumah,
        listDokumentasi,
        listBulan,
        listTahun,
        errorMessage,
        tempPickedImage,
        tempImageSizeKB,
        tempImageDocId,
      ];
}