import 'package:flutter/material.dart';
import '../../../../core/presentation/utils/app_colors.dart';
import '../pages/profile_page.dart';

class ProfileData {
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

  ProfileData({
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
  });
}

final ProfileData dummyProfileData = ProfileData(
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
);

class ProfileRWView extends StatelessWidget {
  const ProfileRWView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = dummyProfileData;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle('Informasi Ketua RW'),
        buildReadOnlyTextField('Nama Ketua RW', data.namaKetuaRW),
        buildReadOnlyTextField('Nomor Handphone Ketua RW', data.noHPKetuaRW),
        const SizedBox(height: 24.0),
        buildSectionTitle('Data Wilayah'),
        _buildTwoColumnData(
          'Jumlah KK', data.jumlahKK.toString(),
          'Jumlah Rumah', data.jumlahRumah.toString(),
        ),
        _buildTwoColumnData(
          'Jumlah RT', data.jumlahRT.toString(),
          'Luas RW (m²)', data.luasRW.toString().replaceAll('.', ','),
        ),
        _buildTwoColumnData(
          'Jumlah Jiwa', data.jumlahJiwa.toString(),
          'Timbulan Sampah per Hari (Kg)', data.timbulanSampah.toString().replaceAll('.', ','), 
        ),
        const SizedBox(height: 24.0),
        buildSectionTitle('Alamat Administratif'),
        buildReadOnlyTextField('Kota/Kabupaten', data.kotaKabupaten),
        buildReadOnlyTextField('Kecamatan', data.kecamatan),
        _buildTwoColumnData(
          'Kelurahan', data.kelurahan,
          'RW', data.rw.toString(),
        ),
        const SizedBox(height: 24.0),
        buildSectionTitle('Dokumen SK RW'),
        buildReadOnlyTextField('NO SK RW', data.noSKRW),
        const SizedBox(height: 16.0),
        _buildLihatSKButton(),
      ],
    );
  }

  Widget _buildTwoColumnData(
      String label1, String value1,
      String label2, String value2,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: buildReadOnlyTextField(label1, value1),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: buildReadOnlyTextField(label2, value2),
          ),
        ],
      ),
    );
  }

  Widget _buildLihatSKButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: Implement logic to view SK
        },
        icon: Icon(
          Icons.description_outlined,
          color: AppColors.white.normal,
          size: 20,
        ),
        label: Text(
          'LIHAT SK',
          style: TextStyle(
            fontFamily: 'InstrumentSans',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.white.normal,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue.normal,
          padding: const EdgeInsets.symmetric(vertical: 7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
