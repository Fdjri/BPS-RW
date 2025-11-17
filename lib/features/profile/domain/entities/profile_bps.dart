import 'package:equatable/equatable.dart';
import 'seksi_data.dart';

class ProfileBps extends Equatable {
  final SeksiData ketuaBidang;
  final List<SeksiData> seksiOperasional;
  final List<SeksiData> seksiSosialisasiPengawasan;
  final SeksiData pjlpPendamping;
  final SeksiData supervisorPendamping;

  const ProfileBps({
    required this.ketuaBidang,
    required this.seksiOperasional,
    required this.seksiSosialisasiPengawasan,
    required this.pjlpPendamping,
    required this.supervisorPendamping,
  });

  ProfileBps copyWith({
    SeksiData? ketuaBidang,
    List<SeksiData>? seksiOperasional,
    List<SeksiData>? seksiSosialisasiPengawasan,
    SeksiData? pjlpPendamping,
    SeksiData? supervisorPendamping,
  }) {
    return ProfileBps(
      ketuaBidang: ketuaBidang ?? this.ketuaBidang,
      seksiOperasional: seksiOperasional ?? this.seksiOperasional,
      seksiSosialisasiPengawasan:
          seksiSosialisasiPengawasan ?? this.seksiSosialisasiPengawasan,
      pjlpPendamping: pjlpPendamping ?? this.pjlpPendamping,
      supervisorPendamping: supervisorPendamping ?? this.supervisorPendamping,
    );
  }

  // Dummy Data
  factory ProfileBps.dummy() {
    return ProfileBps(
      ketuaBidang: SeksiData(
        nama: 'Adhrul Ghulam',
        noWA: '081311308969',
      ),
      seksiOperasional: [
        SeksiData(nama: 'Jamaluddin', noWA: '081236549870'),
        SeksiData(nama: 'Taryana', noWA: '087894561230'),
      ],
      seksiSosialisasiPengawasan: [
        SeksiData(nama: 'Juwansyah', noWA: '081596231784'),
        SeksiData(nama: 'Roby dahlan', noWA: '087841593260'),
      ],
      pjlpPendamping: SeksiData(
        nama: 'Rhafael Pahala',
        noWA: '088498456187',
      ),
      supervisorPendamping: SeksiData(
        nama: 'Muhamat Sofian',
        noWA: '087837822398',
      ),
    );
  }

  @override
  List<Object?> get props => [
        ketuaBidang,
        seksiOperasional,
        seksiSosialisasiPengawasan,
        pjlpPendamping,
        supervisorPendamping,
      ];
}