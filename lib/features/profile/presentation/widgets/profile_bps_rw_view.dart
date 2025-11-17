import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // <-- Import Bloc
import '../../../../core/presentation/utils/app_colors.dart';
// Import helper yang udah dipisah
import '../widgets/profile_shared_widgets.dart'; 
// Import Cubit & State
import '../blocs/profile_bps/profile_bps_cubit.dart';
// Import Entity
import '../../domain/entities/profile_bps.dart';
import '../../domain/entities/seksi_data.dart';

// Semua class Model Data dan Dummy Data DIHAPUS DARI SINI

class ProfileBPSRWView extends StatelessWidget {
  const ProfileBPSRWView({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita pake BlocBuilder di sini
    return BlocBuilder<ProfileBpsCubit, ProfileBpsState>(
      builder: (context, state) {
        if (state is ProfileBpsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ProfileBpsLoaded) {
          // Kirim data ke method _buildContent
          return _buildContent(context, state.profileBps);
        }
        if (state is ProfileBpsError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('Profil BPS tidak ditemukan.'));
      },
    );
  }

  Widget _buildContent(BuildContext context, ProfileBps data) {
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
          ..._buildSeksiList(
              data.seksiSosialisasiPengawasan, 'Seksi Sosialisasi & Pengawasan'),
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
    final labelName = title.contains('PJLP')
        ? 'Nama PJLP Pendamping'
        : 'Nama Supervisor Pendamping';
    final labelWA = title.contains('PJLP')
        ? 'No WA PJLP Pendamping'
        : 'No WA Supervisor Pendamping';

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