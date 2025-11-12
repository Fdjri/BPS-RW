import 'package:equatable/equatable.dart';

class UnverifiedChecklist extends Equatable {
  final String id;
  final DateTime tanggal;
  final int mudahTerurai;
  final int materialDaur;
  final int b3;
  final int residu;
  final List<Map<String, dynamic>> detailRumah;

  const UnverifiedChecklist({
    required this.id,
    required this.tanggal,
    required this.mudahTerurai,
    required this.materialDaur,
    required this.b3,
    required this.residu,
    required this.detailRumah,
  });

  @override
  List<Object?> get props => [
        id,
        tanggal,
        mudahTerurai,
        materialDaur,
        b3,
        residu,
        detailRumah,
      ];
      
  factory UnverifiedChecklist.fromMock(Map<String, dynamic> map) {
    return UnverifiedChecklist(
      id: map['tanggal']?.toString() ?? DateTime.now().toString(),
      tanggal: map['tanggal'] ?? DateTime.now(),
      mudahTerurai: (map['mudah_terurai'] ?? 0).toInt(),
      materialDaur: (map['material_daur'] ?? 0).toInt(),
      b3: (map['b3'] ?? 0).toInt(),
      residu: (map['residu'] ?? 0).toInt(),
      detailRumah: List<Map<String, dynamic>>.from(map['detail_rumah'] ?? []),
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tanggal': tanggal,
      'mudah_terurai': mudahTerurai,
      'material_daur': materialDaur,
      'b3': b3,
      'residu': residu,
      'detail_rumah': detailRumah,
    };
  }
}