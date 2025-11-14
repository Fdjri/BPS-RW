import 'package:equatable/equatable.dart';

class Laporan extends Equatable {
  final String id;
  final String bulan;
  final String tahun; 
  final int jumlahRumah;
  final String status;

  const Laporan({
    required this.id,
    required this.bulan,
    required this.tahun, 
    required this.jumlahRumah,
    required this.status,
  });

  @override
  List<Object?> get props => [id, bulan, tahun, jumlahRumah, status];
  factory Laporan.fromMock(Map<String, dynamic> map) {
    return Laporan(
      id: map['id'] ?? '',
      bulan: map['bulan'] ?? 'Nama Bulan',
      tahun: map['tahun'] ?? 'Tahun', 
      jumlahRumah: (map['jumlah_rumah'] ?? 0).toInt(),
      status: map['status'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bulan': bulan,
      'tahun': tahun, 
      'jumlah_rumah': jumlahRumah,
      'status': status,
    };
  }
}