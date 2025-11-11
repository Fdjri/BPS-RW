import 'package:equatable/equatable.dart';

class BeratSampah extends Equatable {
  final DateTime tanggal; 
  final String rt;
  final double mudahTerurai;
  final double materialDaur;
  final double b3;
  final double residu;
  final double total;

  const BeratSampah({
    required this.tanggal,
    required this.rt,
    required this.mudahTerurai,
    required this.materialDaur,
    required this.b3,
    required this.residu,
    required this.total,
  });

  String get displayTanggal {
    const dayNames = {
      1: 'Senin', 2: 'Selasa', 3: 'Rabu', 4: 'Kamis',
      5: 'Jumat', 6: 'Sabtu', 7: 'Minggu'
    };
    const monthNames = {
      1: 'Januari', 2: 'Februari', 3: 'Maret', 4: 'April', 5: 'Mei', 
      6: 'Juni', 7: 'Juli', 8: 'Agustus', 9: 'September', 10: 'Oktober', 
      11: 'November', 12: 'Desember'
    };
    return "${dayNames[tanggal.weekday]}, ${tanggal.day} ${monthNames[tanggal.month]} ${tanggal.year}";
  }

  @override
  List<Object?> get props => [
        tanggal,
        rt,
        mudahTerurai,
        materialDaur,
        b3,
        residu,
        total
      ];

  BeratSampah copyWith({
    DateTime? tanggal,
    String? rt,
    double? mudahTerurai,
    double? materialDaur,
    double? b3,
    double? residu,
    double? total,
  }) {
    return BeratSampah(
      tanggal: tanggal ?? this.tanggal,
      rt: rt ?? this.rt,
      mudahTerurai: mudahTerurai ?? this.mudahTerurai,
      materialDaur: materialDaur ?? this.materialDaur,
      b3: b3 ?? this.b3,
      residu: residu ?? this.residu,
      total: total ?? this.total,
    );
  }
}