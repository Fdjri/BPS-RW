import 'package:equatable/equatable.dart';

class PotensiRumah extends Equatable {
  final String rt;
  final String rw;
  final String alamat;
  final String alamatFull;
  final String nama;
  final String bangunanId;
  final bool statusPotensi;

  const PotensiRumah({
    required this.rt,
    required this.rw,
    required this.alamat,
    required this.alamatFull,
    required this.nama,
    required this.bangunanId,
    required this.statusPotensi,
  });

  PotensiRumah copyWith({
    String? rt,
    String? rw,
    String? alamat,
    String? alamatFull,
    String? nama,
    String? bangunanId,
    bool? statusPotensi,
  }) {
    return PotensiRumah(
      rt: rt ?? this.rt,
      rw: rw ?? this.rw,
      alamat: alamat ?? this.alamat,
      alamatFull: alamatFull ?? this.alamatFull,
      nama: nama ?? this.nama,
      bangunanId: bangunanId ?? this.bangunanId,
      statusPotensi: statusPotensi ?? this.statusPotensi,
    );
  }

  @override
  List<Object?> get props => [
        rt,
        rw,
        alamat,
        alamatFull,
        nama,
        bangunanId,
        statusPotensi,
      ];
}