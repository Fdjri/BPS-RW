import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:lottie/lottie.dart'; 
import '../widgets/data_menu_drawer_widget.dart';
import '../../../../core/presentation/utils/app_colors.dart';
import '../../../../core/presentation/widgets/custom_bottom_navbar.dart';
import 'edit_rumah_page.dart';
import 'tambah_nik_page.dart';
import 'package:bps_rw/features/checklist/presentation/pages/checklist_page.dart';
import 'package:bps_rw/features/laporan/presentation/pages/laporan_page.dart';
import 'package:bps_rw/features/profile/presentation/pages/profile_page.dart';
import '../blocs/data_rumah/data_rumah_cubit.dart';
import '../blocs/data_rumah/data_rumah_state.dart';
import '../../domain/entities/data_rumah.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});
  static const String routeName = '/data';

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _navigateToEditPage(BuildContext context, DataRumah data) async {
    final allRtOptions = context.read<DataRumahCubit>().state.rtOptions;
    if (!context.mounted) return; 
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRumahPage(
          dataRumah: data, 
          allRtOptions: allRtOptions, 
        ),
      ),
    );
    if (result == true && context.mounted) {
      context.read<DataRumahCubit>().fetchDataRumah();
    }
  }

  Future<void> _navigateToTambahNikPage(BuildContext context, DataRumah data) async {
    if (!context.mounted) return;
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => TambahNikPage(dataRumah: data),
      ),
    );
    if (result == true && context.mounted) {
      context.read<DataRumahCubit>().fetchDataRumah();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DataRumahCubit()..fetchDataRumah(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.white.normal,
        drawer: const DataMenuDrawer(activeRoute: DataPage.routeName),
        body: BlocBuilder<DataRumahCubit, DataRumahState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeaderAndFilters(context, state),
                  if (state.status == DataRumahStatus.loading)
                    const Padding(
                      padding: EdgeInsets.only(top: 150),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (state.status == DataRumahStatus.failure)
                    Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: Center(child: Text(state.errorMessage ?? 'Gagal memuat data')),
                    ),
                  if (state.status == DataRumahStatus.success)
                    state.filteredDataRumah.isEmpty
                      ? _buildEmptyState() 
                      : ListView.builder( 
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: state.filteredDataRumah.length, 
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final data = state.filteredDataRumah[index]; 
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

  Widget _buildHeaderAndFilters(BuildContext context, DataRumahState state) {
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
                  Icon(LucideIcons.database, color: AppColors.white.normal), 
                  const SizedBox(width: 12),
                  Text(
                    'Data Rumah Lama',
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
                    state.statusOptions,
                  ),
                  const SizedBox(width: 16),
                  _buildFilterButton(
                    context,
                    'Filter RT:', 
                    state.selectedRT,
                    state.rtOptions,
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
    final cubit = context.read<DataRumahCubit>();
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

  Widget _buildDataCard(DataRumah data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ClipRRect( 
        borderRadius: BorderRadius.circular(15.0),
        child: Slidable(
          key: ValueKey(data.alamatDinas),
          groupTag: 'data-rumah-list',
          endActionPane: ActionPane(
            motion: const StretchMotion(), 
            extentRatio: 0.5, 
            children: [
            SlidableAction(
              onPressed: (context) { 
                _navigateToEditPage(context, data);
              },
              backgroundColor: AppColors.yellow.normal,
                foregroundColor: AppColors.white.normal,
                icon: LucideIcons.edit,
                label: 'Edit',
              ),
            SlidableAction(
              onPressed: (context) {
                _navigateToTambahNikPage(context, data); 
              },
              backgroundColor: AppColors.green.normal,
                foregroundColor: AppColors.white.normal,
                icon: LucideIcons.userPlus,
                label: 'Tambah NIK',
              ),
            ],
          ),
          child: Card(
            elevation: 4,
            shadowColor: AppColors.black.normal.withOpacity(1),
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(
                color: AppColors.black.light.withOpacity(1), 
                width: 1.0, 
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  _buildInfoRow(LucideIcons.mapPin, data.alamatDinas, AppColors.blue.normal),
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
                  
                  Row( 
                    children: [
                      Text(
                        "Status:", 
                        style: TextStyle(
                          fontFamily: 'InstrumentSans', 
                          fontSize: 12, 
                          color: AppColors.black.normal.withOpacity(0.54) 
                        )
                      ),
                      const SizedBox(width: 12),
                      _buildStatusChip( 
                        "Aktif", 
                        data.statusAktif ? LucideIcons.checkCircle2 : LucideIcons.xCircle,
                        data.statusAktif ? AppColors.green.dark : AppColors.red.normal, 
                        data.statusAktif ? AppColors.green.light : AppColors.red.light
                      ),
                      const SizedBox(width: 12),
                      _buildStatusChip( 
                        "Checklist", 
                        data.statusChecklist ? LucideIcons.checkCircle2 : LucideIcons.xCircle,
                        data.statusChecklist ? AppColors.green.dark : AppColors.red.normal, 
                        data.statusChecklist ? AppColors.green.light : AppColors.red.light
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
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