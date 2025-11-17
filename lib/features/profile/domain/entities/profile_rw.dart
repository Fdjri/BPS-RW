import 'package:equatable/equatable.dart';

class ProfileRw extends Equatable {
  final String namaKetuaRW;
  final String noHPKetuaRW;
  final int jumlahKK;
  final int jumlahRumah;
  final int jumlahRT;
  final double luasRW;
  final int jumlahJiwa;
  final double timbulanSampah;
  final String kotaKabupaten;
  final String kecamatan;
  final String kelurahan;
  final int rw;
  final String noSKRW;
  final String? skFileUrl; 

  const ProfileRw({
    required this.namaKetuaRW,
    required this.noHPKetuaRW,
    required this.jumlahKK,
    required this.jumlahRumah,
    required this.jumlahRT,
    required this.luasRW,
    required this.jumlahJiwa,
    required this.timbulanSampah,
    required this.kotaKabupaten,
    required this.kecamatan,
    required this.kelurahan,
    required this.rw,
    required this.noSKRW,
    this.skFileUrl,
  });

  ProfileRw copyWith({
    String? namaKetuaRW,
    String? noHPKetuaRW,
    int? jumlahKK,
    int? jumlahRumah,
    int? jumlahRT,
    double? luasRW,
    int? jumlahJiwa,
    double? timbulanSampah,
    String? kotaKabupaten,
    String? kecamatan,
    String? kelurahan,
    int? rw,
    String? noSKRW,
    String? skFileUrl,
  }) {
    return ProfileRw(
      namaKetuaRW: namaKetuaRW ?? this.namaKetuaRW,
      noHPKetuaRW: noHPKetuaRW ?? this.noHPKetuaRW,
      jumlahKK: jumlahKK ?? this.jumlahKK,
      jumlahRumah: jumlahRumah ?? this.jumlahRumah,
      jumlahRT: jumlahRT ?? this.jumlahRT,
      luasRW: luasRW ?? this.luasRW,
      jumlahJiwa: jumlahJiwa ?? this.jumlahJiwa,
      timbulanSampah: timbulanSampah ?? this.timbulanSampah,
      kotaKabupaten: kotaKabupaten ?? this.kotaKabupaten,
      kecamatan: kecamatan ?? this.kecamatan,
      kelurahan: kelurahan ?? this.kelurahan,
      rw: rw ?? this.rw,
      noSKRW: noSKRW ?? this.noSKRW,
      skFileUrl: skFileUrl ?? this.skFileUrl,
    );
  }

  factory ProfileRw.dummy() {
    return const ProfileRw(
      namaKetuaRW: 'Sumarkum',
      noHPKetuaRW: '81280903773',
      jumlahKK: 812,
      jumlahRumah: 428,
      jumlahRT: 15,
      luasRW: 20.1,
      jumlahJiwa: 2383,
      timbulanSampah: 1811.08,
      kotaKabupaten: 'KOTA ADM. JAKARTA BARAT',
      kecamatan: 'Grogol Petamburan',
      kelurahan: 'Grogol',
      rw: 7,
      noSKRW: '123',
      skFileUrl: 'https://example.com/sk_rw.pdf', 
    );
  }

  @override
  List<Object?> get props => [
        namaKetuaRW,
        noHPKetuaRW,
        jumlahKK,
        jumlahRumah,
        jumlahRT,
        luasRW,
        jumlahJiwa,
        timbulanSampah,
        kotaKabupaten,
        kecamatan,
        kelurahan,
        rw,
        noSKRW,
        skFileUrl,
      ];
}