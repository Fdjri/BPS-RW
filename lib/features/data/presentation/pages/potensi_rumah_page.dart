import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:lottie/lottie.dart';
import '../widgets/data_menu_drawer_widget.dart';
import '../../../../core/presentation/utils/app_colors.dart';
import '../../../../core/presentation/widgets/custom_bottom_navbar.dart';
import 'package:bps_rw/features/checklist/presentation/pages/checklist_page.dart';
import 'package:bps_rw/features/laporan/presentation/pages/laporan_page.dart';
import 'package:bps_rw/features/profile/presentation/pages/profile_page.dart';
import '../blocs/data_potensi/potensi_rumah_cubit.dart';
import '../blocs/data_potensi/potensi_rumah_state.dart';
import '../../domain/entities/potensi_rumah.dart';

class DataPotensiRumahPage extends StatefulWidget {
  const DataPotensiRumahPage({super.key});
  static const String routeName = '/data-potensi';
  @override
  State<DataPotensiRumahPage> createState() => _DataPotensiRumahPageState();
}

class _DataPotensiRumahPageState extends State<DataPotensiRumahPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PotensiRumahCubit()..fetchDataPotensiRumah(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.white.normal,
        drawer: const DataMenuDrawer(activeRoute: DataPotensiRumahPage.routeName),
        bottomNavigationBar: CustomBottomNavbar(
          selectedIndex: 1,
           onItemTapped: (index) {
            if (index == 0) Navigator.pushReplacementNamed(context, '/home');
            if (index == 1) {}
            if (index == 2) Navigator.pushReplacementNamed(context, ChecklistPage.routeName);
            if (index == 3) Navigator.pushReplacementNamed(context, LaporanPage.routeName);
            if (index == 4) Navigator.pushReplacementNamed(context, ProfilePage.routeName);
          },
        ),
        body: BlocBuilder<PotensiRumahCubit, PotensiRumahState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeaderAndFilters(context, state), 
                  if (state.status == PotensiRumahStatus.loading)
                    const Padding(
                      padding: EdgeInsets.only(top: 150),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (state.status == PotensiRumahStatus.failure)
                    Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: Center(child: Text(state.errorMessage ?? 'Gagal memuat data')),
                    ),
                  if (state.status == PotensiRumahStatus.success)
                    state.filteredDataPotensi.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder( 
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: state.filteredDataPotensi.length, 
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final data = state.filteredDataPotensi[index];
                            return _buildDataCard(data); 
                          },
                        ),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderAndFilters(BuildContext context, PotensiRumahState state) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppColors.blue.normal,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(LucideIcons.menu, color: AppColors.white.normal),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  const SizedBox(width: 8),
                  Icon(LucideIcons.trendingUp, color: AppColors.white.normal),
                  const SizedBox(width: 12),
                  Text(
                    'Potensi Rumah',
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
                children: [
                  _buildFilterButton(
                    context, 
                    'Filter Status:', 
                    state.selectedStatus, 
                    state.statusOptions
                  ),
                  const SizedBox(width: 16),
                  _buildFilterButton(
                    context, 
                    'Filter RT:', 
                    state.selectedRT, 
                    state.rtOptions
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, String title, String value, List<String> items) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title, 
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              fontSize: 12, 
              color: AppColors.white.normal.withOpacity(0.7)
            )
          ),
          const SizedBox(height: 4),
          Material(
            color: AppColors.white.normal,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                _showFilterSheet(context, title, items, value);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontSize: 14
                      )
                    ),
                    Icon(LucideIcons.chevronDown, size: 20, color: AppColors.black.normal.withOpacity(0.54)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context, String title, List<String> items, String currentValue) {
    final cubit = context.read<PotensiRumahCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white.normal,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, 
                style: const TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontSize: 18, 
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = item == currentValue;
                    return ListTile(
                      title: Text(
                        item,
                        style: TextStyle(
                          fontFamily: 'InstrumentSans',
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppColors.blue.normal : AppColors.black.normal,
                        ), 
                      ),
                      trailing: isSelected 
                        ? Icon(LucideIcons.check, color: AppColors.blue.normal) 
                        : null,
                      onTap: () {
                        if (title == 'Filter Status:') {
                          cubit.changeFilter(status: item);
                        } else {
                          cubit.changeFilter(rt: item);
                        }
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDataCard(PotensiRumah data) {
    return Card(
      elevation: 4,
      shadowColor: AppColors.black.normal.withOpacity(0.08),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.5), 
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildTag(
                  'RT ${data.rt}', 
                  AppColors.blue.light, 
                  icon: LucideIcons.home
                ),
                const SizedBox(width: 8),
                _buildTag('RW ${data.rw}', AppColors.blue.light), 
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(LucideIcons.mapPin, data.alamat, AppColors.blue.normal), 
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Text(
                data.alamatFull, 
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontSize: 12, 
                  color: AppColors.black.normal.withOpacity(0.54)
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(LucideIcons.user, data.nama, AppColors.blue.normal), 
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.black.light,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bangunan ID', 
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontSize: 12, 
                      color: AppColors.black.normal.withOpacity(0.54)
                    )
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.bangunanId, 
                    style: const TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  "Potensi Nasabah:", 
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    fontSize: 12, 
                    color: AppColors.black.normal.withOpacity(0.54)
                  )
                ),
                const SizedBox(width: 12),
                data.statusPotensi
                  ? _buildStatusChip(
                      "Potensi", 
                      LucideIcons.checkCircle2, 
                      AppColors.green.dark,
                      AppColors.green.light
                    )
                  : _buildStatusChip(
                      "Bukan Potensi", 
                      LucideIcons.xCircle, 
                      AppColors.red.normal,
                      AppColors.red.light
                    ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: AppColors.blue.dark),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              color: AppColors.blue.dark, 
              fontSize: 12, 
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'InstrumentSans',
              fontSize: 14, 
              fontWeight: FontWeight.w500
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String label, IconData icon, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            label, 
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              fontSize: 12, 
              color: color,
              fontWeight: FontWeight.w500
            )
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/lottie/nodata.json', width: 250, height: 250),
            const SizedBox(height: 16),
            Text(
              'Data Tidak Ditemukan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.black.normal.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Data yang Anda cari tidak tersedia saat ini atau filter Anda tidak cocok.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                fontSize: 14,
                color: AppColors.black.normal.withOpacity(0.54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}