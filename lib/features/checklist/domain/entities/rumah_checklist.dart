import 'package:equatable/equatable.dart';

class RumahChecklist extends Equatable {
  final String id; 
  final String nama;
  final String alamat;
  final String rt;
  final Map<String, bool> sampah;
  final bool fotoUploaded;

  const RumahChecklist({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.rt,
    required this.sampah,
    required this.fotoUploaded,
  });

  RumahChecklist copyWith({
    String? id,
    String? nama,
    String? alamat,
    String? rt,
    Map<String, bool>? sampah,
    bool? fotoUploaded,
  }) {
    return RumahChecklist(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      rt: rt ?? this.rt,
      sampah: sampah ?? this.sampah,
      fotoUploaded: fotoUploaded ?? this.fotoUploaded,
    );
  }

  @override
  List<Object?> get props => [id, nama, alamat, rt, sampah, fotoUploaded];

  factory RumahChecklist.fromMock(Map<String, dynamic> map) {
    return RumahChecklist(
      id: (map['nama'] ?? '') + (map['alamat'] ?? ''), 
      nama: map['nama'] ?? 'Unknown',
      alamat: map['alamat'] ?? 'Unknown',
      rt: map['rt'] ?? '???',
      sampah: Map<String, bool>.from(map['sampah'] ?? {}),
      fotoUploaded: map['foto_uploaded'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'rt': rt,
      'sampah': sampah,
      'foto_uploaded': fotoUploaded,
    };
  }
}