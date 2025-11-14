import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class DokumentasiLaporan extends Equatable {
  final String? keterangan;
  final DateTime? tanggalPelaksanaan;
  final String? pelaksanaKegiatan;
  final bool isPhotoUploaded;
  final XFile? pickedImage; 
  final String? fotoUrl;
  final String id; 

  const DokumentasiLaporan({
    this.keterangan,
    this.tanggalPelaksanaan,
    this.pelaksanaKegiatan,
    this.isPhotoUploaded = false,
    this.pickedImage,
    this.fotoUrl, 
    required this.id,
  });

  DokumentasiLaporan copyWith({
    String? keterangan,
    DateTime? tanggalPelaksanaan,
    String? pelaksanaKegiatan,
    bool? isPhotoUploaded,
    XFile? pickedImage,
    String? fotoUrl,
    bool clearPickedImage = false,
  }) {
    return DokumentasiLaporan(
      keterangan: keterangan ?? this.keterangan,
      tanggalPelaksanaan: tanggalPelaksanaan ?? this.tanggalPelaksanaan,
      pelaksanaKegiatan: pelaksanaKegiatan ?? this.pelaksanaKegiatan,
      isPhotoUploaded: isPhotoUploaded ?? this.isPhotoUploaded,
      pickedImage: clearPickedImage ? null : (pickedImage ?? this.pickedImage),
      fotoUrl: fotoUrl ?? this.fotoUrl, 
      id: id, 
    );
  }

  @override
  List<Object?> get props => [
        keterangan,
        tanggalPelaksanaan,
        pelaksanaKegiatan,
        isPhotoUploaded,
        pickedImage,
        fotoUrl, 
        id,
      ];
}