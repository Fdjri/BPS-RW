import 'package:flutter/material.dart';
import '../../../../core/presentation/utils/app_colors.dart';
import '../pages/profile_page.dart';

class SeksiData {
  final String nama;
  final String noWA;

  SeksiData({required this.nama, required this.noWA});
}

class BPSRWProfileData {
  final SeksiData ketuaBidang;
  final List<SeksiData> seksiOperasional;
  final List<SeksiData> seksiSosialisasiPengawasan;
  final SeksiData pjlpPendamping;
  final SeksiData supervisorPendamping;

  BPSRWProfileData({
    required this.ketuaBidang,
    required this.seksiOperasional,
    required this.seksiSosialisasiPengawasan,
    required this.pjlpPendamping,
    required this.supervisorPendamping,
  });
}

final BPSRWProfileData dummyBPSRWData = BPSRWProfileData(
  ketuaBidang: SeksiData(
    nama: 'Adhrul Ghulam',
    noWA: '81311308969',
  ),
  seksiOperasional: [
    SeksiData(nama: 'Jamaluddin', noWA: 'Nomor WA Seksi Operasional 1'),
    SeksiData(nama: 'Taryana', noWA: 'Nomor WA Seksi Operasional 2'),
  ],
  seksiSosialisasiPengawasan: [
    SeksiData(nama: 'Juwansyah', noWA: 'No WA Seksi Sosialisasi & Pengawasan 1'),
    SeksiData(nama: 'Roby dahlan', noWA: 'No WA Seksi Sosialisasi & Pengawasan 2'),
  ],
  pjlpPendamping: SeksiData(
    nama: 'Rhafael Pahala',
    noWA: 'No WA PJLP Pendamping',
  ),
  supervisorPendamping: SeksiData(
    nama: 'Muhamat Sofian',
    noWA: '87837822398',
  ),
);

class ProfileBPSRWView extends StatelessWidget {
  const ProfileBPSRWView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = dummyBPSRWData;
    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle('Ketua Bidang'),
          buildReadOnlyTextField('Nama Ketua Bidang', data.ketuaBidang.nama),
          buildReadOnlyTextField('Nomor WA Ketua Bidang', data.ketuaBidang.noWA),
          const SizedBox(height: 24.0),
          buildSectionTitle('Seksi Operasional'),
          ..._buildSeksiList(data.seksiOperasional, 'Seksi Operasional'),
          const SizedBox(height: 24.0),
          buildSectionTitle('Seksi Sosialisasi & Pengawasan'),
          ..._buildSeksiList(data.seksiSosialisasiPengawasan, 'Seksi Sosialisasi & Pengawasan'),
          const SizedBox(height: 24.0),
          buildSectionTitle('Pendamping'),
          _buildPendampingCard(
            title: 'PJLP Pendamping',
            data: data.pjlpPendamping,
          ),
          const SizedBox(height: 16.0),
          _buildPendampingCard(
            title: 'Supervisor Pendamping',
            data: data.supervisorPendamping,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSeksiList(List<SeksiData> seksiList, String baseTitle) {
    return seksiList.asMap().entries.map((entry) {
      final index = entry.key + 1;
      final seksi = entry.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Text(
              '$baseTitle $index',
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.black.darker,
              ),
            ),
          ),
          buildReadOnlyTextField('Nama $baseTitle $index', seksi.nama),
          buildReadOnlyTextField('Nomor WA $baseTitle $index', seksi.noWA),
        ],
      );
    }).toList();
  }

  Widget _buildPendampingCard({
    required String title,
    required SeksiData data,
  }) {
    final labelName = title.contains('PJLP') ? 'Nama PJLP Pendamping' : 'Nama Supervisor Pendamping';
    final labelWA = title.contains('PJLP') ? 'No WA PJLP Pendamping' : 'No WA Supervisor Pendamping';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.blue.light,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blue.lightActive),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.black.darker,
            ),
          ),
          const SizedBox(height: 8.0),
          buildReadOnlyTextField(labelName, data.nama),
          buildReadOnlyTextField(labelWA, data.noWA),
        ],
      ),
    );
  }
}
