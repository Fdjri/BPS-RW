import 'package:equatable/equatable.dart';

class RumahChecklist extends Equatable {
  final String id;
  final String checkDetailId;
  final String nama;
  final String alamat;
  final String rt;
  final String? rw; 
  final Map<String, bool> sampah;
  final bool fotoUploaded;

  const RumahChecklist({
    required this.id,
    required this.checkDetailId,
    required this.nama,
    required this.alamat,
    required this.rt,
    this.rw,
    required this.sampah,
    required this.fotoUploaded,
  });

  RumahChecklist copyWith({
    String? id,
    String? checkDetailId,
    String? nama,
    String? alamat,
    String? rt,
    String? rw,
    Map<String, bool>? sampah,
    bool? fotoUploaded,
  }) {
    return RumahChecklist(
      id: id ?? this.id,
      checkDetailId: checkDetailId ?? this.checkDetailId,
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      rt: rt ?? this.rt,
      rw: rw ?? this.rw,
      sampah: sampah ?? this.sampah,
      fotoUploaded: fotoUploaded ?? this.fotoUploaded,
    );
  }

  @override
  List<Object?> get props => [id, checkDetailId, nama, alamat, rt, rw, sampah, fotoUploaded];
}