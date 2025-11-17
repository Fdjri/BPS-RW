import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import '../../../../core/presentation/utils/app_colors.dart';
import '../widgets/profile_shared_widgets.dart'; 
import '../blocs/profile_rw/profile_rw_cubit.dart'; 
import '../../domain/entities/profile_rw.dart'; 

class ProfileRWView extends StatelessWidget {
  const ProfileRWView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileRwCubit, ProfileRwState>(
      builder: (context, state) {
        if (state is ProfileRwLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ProfileRwLoaded) {
          return _buildContent(context, state.profileRw);
        }
        if (state is ProfileRwError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('Profil tidak ditemukan.'));
      },
    );
  }

  Widget _buildContent(BuildContext context, ProfileRw data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle('Informasi Ketua RW'),
        buildReadOnlyTextField('Nama Ketua RW', data.namaKetuaRW),
        buildReadOnlyTextField('Nomor Handphone Ketua RW', data.noHPKetuaRW),
        const SizedBox(height: 24.0),
        buildSectionTitle('Data Wilayah'),
        _buildTwoColumnData(
          'Jumlah KK',
          data.jumlahKK.toString(),
          'Jumlah Rumah',
          data.jumlahRumah.toString(),
        ),
        _buildTwoColumnData(
          'Jumlah RT',
          data.jumlahRT.toString(),
          'Luas RW (m²)',
          data.luasRW.toString().replaceAll('.', ','),
        ),
        _buildTwoColumnData(
          'Jumlah Jiwa',
          data.jumlahJiwa.toString(),
          'Timbulan Sampah per Hari (Kg)',
          data.timbulanSampah.toString().replaceAll('.', ','),
        ),
        const SizedBox(height: 24.0),
        buildSectionTitle('Alamat Administratif'),
        buildReadOnlyTextField('Kota/Kabupaten', data.kotaKabupaten),
        buildReadOnlyTextField('Kecamatan', data.kecamatan),
        _buildTwoColumnData(
          'Kelurahan',
          data.kelurahan,
          'RW',
          data.rw.toString(),
        ),
        const SizedBox(height: 24.0),
        buildSectionTitle('Dokumen SK RW'),
        buildReadOnlyTextField('NO SK RW', data.noSKRW),
        const SizedBox(height: 16.0),
        _buildLihatSKButton(data.skFileUrl), 
      ],
    );
  }

  Widget _buildTwoColumnData(
    String label1,
    String value1,
    String label2,
    String value2,
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

  Widget _buildLihatSKButton(String? skFileUrl) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: skFileUrl == null ? null : () {
          // TODO: Implement logic to view SK pake url_launcher
          // launchUrl(Uri.parse(skFileUrl));
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
          disabledBackgroundColor: AppColors.black.light, 
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
