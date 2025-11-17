import 'package:equatable/equatable.dart';

class SeksiData extends Equatable {
  final String nama;
  final String noWA;

  const SeksiData({required this.nama, required this.noWA});

  SeksiData copyWith({
    String? nama,
    String? noWA,
  }) {
    return SeksiData(
      nama: nama ?? this.nama,
      noWA: noWA ?? this.noWA,
    );
  }

  @override
  List<Object?> get props => [nama, noWA];
}