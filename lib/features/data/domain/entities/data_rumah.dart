import 'package:equatable/equatable.dart';

class DataRumah extends Equatable {
  final String alamatDinas;
  final String alamatFull;
  final String nama;
  final String rt;
  final String rw;
  final bool statusAktif;
  final bool statusChecklist;

  const DataRumah({
    required this.alamatDinas,
    required this.alamatFull,
    required this.nama,
    required this.rt,
    required this.rw,
    required this.statusAktif,
    required this.statusChecklist,
  });

  DataRumah copyWith({
    String? alamatDinas,
    String? alamatFull,
    String? nama,
    String? rt,
    String? rw,
    bool? statusAktif,
    bool? statusChecklist,
  }) {
    return DataRumah(
      alamatDinas: alamatDinas ?? this.alamatDinas,
      alamatFull: alamatFull ?? this.alamatFull,
      nama: nama ?? this.nama,
      rt: rt ?? this.rt,
      rw: rw ?? this.rw,
      statusAktif: statusAktif ?? this.statusAktif,
      statusChecklist: statusChecklist ?? this.statusChecklist,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'alamatDinas': alamatDinas,
      'alamatFull': alamatFull,
      'nama': nama,
      'rt': rt,
      'rw': rw,
      'statusAktif': statusAktif,
      'statusChecklist': statusChecklist,
    };
  }

  @override
  List<Object?> get props => [
        alamatDinas,
        alamatFull,
        nama,
        rt,
        rw,
        statusAktif,
        statusChecklist
      ];
}