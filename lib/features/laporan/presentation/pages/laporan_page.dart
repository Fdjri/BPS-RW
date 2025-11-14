import 'package:bps_rw/features/laporan/presentation/pages/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:lottie/lottie.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'tambah_laporan_page.dart';
import '../../../../core/presentation/utils/app_colors.dart';
import '../../../../core/presentation/widgets/custom_bottom_navbar.dart';
import 'package:bps_rw/features/checklist/presentation/pages/checklist_page.dart';
import 'package:bps_rw/features/data/presentation/pages/data_page.dart';
import 'package:bps_rw/features/profile/presentation/pages/profile_page.dart';
import '../blocs/laporan/laporan_cubit.dart'; 
import '../../domain/entities/laporan_entities.dart'; 

class LaporanPage extends StatelessWidget {
  static const String routeName = '/laporan';
  const LaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LaporanCubit()..fetchLaporan(),
      child: Scaffold(
        backgroundColor: AppColors.black.light,
        bottomNavigationBar: CustomBottomNavbar(
          selectedIndex: 3,
          onItemTapped: (index) {
            if (index == 0) Navigator.pushReplacementNamed(context, '/home');
            if (index == 1)
              Navigator.pushReplacementNamed(context, DataPage.routeName);
            if (index == 2)
              Navigator.pushReplacementNamed(context, ChecklistPage.routeName);
            if (index == 3) {}
            if (index == 4)
              Navigator.pushReplacementNamed(context, ProfilePage.routeName);
          },
        ),
        body: const _LaporanBody(),
      ),
    );
  }
}

class _LaporanBody extends StatelessWidget {
  const _LaporanBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LaporanCubit, LaporanState>(
      builder: (context, state) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context, state), 
                  _buildBody(context, state), 
                ],
              ),
            ),
            if (state.status == LaporanStatus.loading && state.listLaporan.isNotEmpty)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, LaporanState state) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 16),
      decoration: BoxDecoration(
        color: AppColors.blue.normal,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.fileText, color: AppColors.white.normal, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Data Input Laporan RW',
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    color: AppColors.white.normal,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildFilterButton(
                    value: state.selectedBulan,
                    onTap: () => _showFilterOptions(
                      context,
                      title: "Pilih Bulan",
                      options: state.listBulan, 
                      currentValue: state.selectedBulan,
                      onSelect: (newValue) {
                        context.read<LaporanCubit>().filterBulanChanged(newValue);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFilterButton(
                    value: state.selectedTahun,
                    onTap: () => _showFilterOptions(
                      context,
                      title: "Pilih Tahun",
                      options: state.listTahun, 
                      currentValue: state.selectedTahun,
                      onSelect: (newValue) {
                        context.read<LaporanCubit>().filterTahunChanged(newValue);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(LucideIcons.plus, size: 18, color: AppColors.blue.dark),
              label: Text(
                'TAMBAH',
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue.dark,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TambahLaporanPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white.normal,
                foregroundColor: AppColors.blue.dark,
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton({
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.white.normal,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.white.normal, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(LucideIcons.chevronDown, color: AppColors.black.lightActive, size: 20),
          ],
        ),
      ),
    );
  }

  void _showFilterOptions(
    BuildContext context, {
    required String title,
    required List<String> options,
    required String? currentValue,
    required Function(String) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, 
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white.normal,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            top: false, 
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black.normal,
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true, 
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final item = options[index];
                      final isSelected = item == currentValue;
                      return InkWell(
                        onTap: () {
                          onSelect(item);
                          Navigator.pop(context); 
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontFamily: 'InstrumentSans',
                                    fontSize: 15,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                    color: isSelected ? AppColors.blue.dark : AppColors.black.normal,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  LucideIcons.check,
                                  color: AppColors.blue.dark,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16), 
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, LaporanState state) {
    if (state.status == LaporanStatus.loading && state.listLaporan.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 64),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.filteredLaporanList.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 16),
        alignment: Alignment.center,
        child: Column(
          children: [
            Lottie.asset(
              'assets/lottie/nodata.json',
              width: 250,
              height: 250,
              repeat: true,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada data laporan',
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.black.lightActive,
              ),
            ),
            Text(
              'Silakan filter bulan/tahun atau tambahkan data baru.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                fontSize: 14,
                color: AppColors.black.lightActive,
              ),
            ),
          ],
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: ListView.builder(
        itemCount: state.filteredLaporanList.length,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final laporan = state.filteredLaporanList[index];
          return _buildLaporanCard(context, laporan); 
        },
      ),
    );
  }

  Widget _buildLaporanCard(BuildContext context, Laporan laporan) {
    return Card(
      elevation: 0,
      color: AppColors.white.normal,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppColors.black.light.withOpacity(0.5), width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.calendarDays, color: AppColors.black.lightActive, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Bulan ${laporan.bulan}',
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.blue.light.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.blue.normal.withOpacity(0.5)),
              ),
              child: Column( 
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Text(
                    'Jumlah Rumah yang Memilah',
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontSize: 12,
                      color: AppColors.black.lightActive,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        laporan.jumlahRumah.toString(),
                        style: TextStyle(
                          fontFamily: 'InstrumentSans',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black.normal,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'rumah',
                        style: TextStyle(
                          fontFamily: 'InstrumentSans',
                          fontSize: 14,
                          color: AppColors.black.lightActive,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.white.normal,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.black.lightActive.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Text(
                    'Status:',
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontSize: 14,
                      color: AppColors.black.lightActive,
                    ),
                  ),
                  const Spacer(),
                  _buildStatusChip(laporan.status), 
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              label: Text(
                'DETAIL',
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontWeight: FontWeight.bold,
                  color: AppColors.white.normal,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailLaporanPage(laporanId: laporan.id),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue.normal,
                foregroundColor: AppColors.blue.light, 
                minimumSize: const Size(double.infinity, 40), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color bgColor;
    Color textColor;
    switch (status.toUpperCase()) {
      case 'VERIFIKASI SUDIN':
        bgColor = AppColors.green.light;
        textColor = AppColors.green.dark;
        break;
      case 'VERIFIKASI SATPEL':
        bgColor = AppColors.blue.light;
        textColor = AppColors.blue.dark;
        break;
      default: 
        bgColor = AppColors.black.light; 
        textColor = AppColors.black.dark; 
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(), 
        style: TextStyle(
          fontFamily: 'InstrumentSans',
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
