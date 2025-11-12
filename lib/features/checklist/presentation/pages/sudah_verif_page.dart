import 'package:bps_rw/features/data/presentation/pages/data_page.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart'; 
import '../../../../core/presentation/utils/app_colors.dart';
import '../../../../core/presentation/widgets/custom_bottom_navbar.dart';
import '../widgets/menu_drawer_widget.dart';
import 'detail_checklist_page.dart';
import 'package:bps_rw/features/laporan/presentation/pages/laporan_page.dart';
import 'package:bps_rw/features/profile/presentation/pages/profile_page.dart';
import '../blocs/sudah_verif/sudah_verif_cubit.dart';
import '../../domain/entities/sudah_verif.dart';

class SudahVerifikasiPage extends StatefulWidget {
  const SudahVerifikasiPage({super.key});
  static const String routeName = '/checklist-sudah-verifikasi';

  @override
  State<SudahVerifikasiPage> createState() => _SudahVerifikasiPageState();
}

class _SudahVerifikasiPageState extends State<SudahVerifikasiPage> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id', null);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerifiedChecklistCubit()..fetchData(),
      child: _SudahVerifBody(),
    );
  }
}

class _SudahVerifBody extends StatelessWidget {
  _SudahVerifBody();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DateFormat _dateFormatter = DateFormat('EEEE, d MMMM yyyy', 'id');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white.normal,
      drawer:
          const ChecklistMenuDrawerWidget(activeRoute: SudahVerifikasiPage.routeName),
      bottomNavigationBar: CustomBottomNavbar(
        selectedIndex: 2,
        onItemTapped: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 1)
            Navigator.pushReplacementNamed(context, DataPage.routeName);
          if (index == 2) {}
          if (index == 3)
            Navigator.pushReplacementNamed(context, LaporanPage.routeName);
          if (index == 4)
            Navigator.pushReplacementNamed(context, ProfilePage.routeName);
        },
      ),
      body: BlocBuilder<VerifiedChecklistCubit, VerifiedChecklistState>(
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeaderAndFilters(context, state),
                    _buildListContent(context, state), 
                  ],
                ),
              ),
              if (state.status == VerifiedChecklistStatus.loading && state.filteredListData.isNotEmpty)
                Container(
                  color: AppColors.white.normal.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListContent(BuildContext context, VerifiedChecklistState state) {
    if (state.status == VerifiedChecklistStatus.loading && state.filteredListData.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.status == VerifiedChecklistStatus.failure) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(child: Text('Gagal memuat data: ${state.errorMessage ?? ''}')),
      );
    }
    if (state.filteredListData.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: Text('Tidak ada data untuk filter ini')),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: state.filteredListData.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final VerifiedChecklist data = state.filteredListData[index];
        return _buildVerificationCard(context, data);
      },
    );
  }

  Widget _buildHeaderAndFilters(BuildContext context, VerifiedChecklistState state) {
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
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  const SizedBox(width: 8),
                  Icon(LucideIcons.checkCircle2, color: AppColors.white.normal, size: 22),
                  const SizedBox(width: 12),
                  Text(
                    'Sudah Diverifikasi',
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      color: AppColors.white.normal,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(LucideIcons.filter,
                      color: AppColors.white.normal.withOpacity(0.8), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Filter',
                    style: TextStyle(
                        fontFamily: 'InstrumentSans',
                        color: AppColors.white.normal.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildFilterDropdown(state.selectedBulan, state.listBulan, () {
                      _showFilterSheet(
                          context, 'Pilih Bulan', state.listBulan, state.selectedBulan,
                          (value) {
                        if (value != null) {
                          context
                              .read<VerifiedChecklistCubit>()
                              .filterBulanChanged(value);
                        }
                      });
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFilterDropdown(state.selectedTahun, state.listTahun, () {
                      _showFilterSheet(
                          context, 'Pilih Tahun', state.listTahun, state.selectedTahun,
                          (value) {
                        if (value != null) {
                          context
                              .read<VerifiedChecklistCubit>()
                              .filterTahunChanged(value);
                        }
                      });
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown(
      String? currentValue, List<String> items, VoidCallback onTap) {
    return Material(
      color: AppColors.white.normal,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  currentValue ?? 'Pilih...',
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    fontSize: 14,
                    color: AppColors.black.normal.withOpacity(0.87),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(LucideIcons.chevronDown,
                  size: 20, color: AppColors.black.normal.withOpacity(0.6)),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, String title, List<String> items,
      String? currentSelection, ValueChanged<String?> onSelect) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
          padding: EdgeInsets.only(
              top: 20,
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewPadding.bottom + 16),
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
              Text(title,
                  style: const TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final bool isSelected = items[index] == currentSelection;
                    return ListTile(
                      title: Text(items[index],
                          style: TextStyle(
                            fontFamily: 'InstrumentSans',
                            color: isSelected
                                ? AppColors.blue.normal
                                : AppColors.black.normal,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          )),
                      trailing: isSelected
                          ? Icon(LucideIcons.check,
                              color: AppColors.blue.normal, size: 20)
                          : null,
                      onTap: () {
                        onSelect(items[index]);
                        Navigator.pop(context);
                      },
                      dense: true,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVerificationCard(BuildContext context, VerifiedChecklist data) {
    return Card(
      elevation: 4,
      shadowColor: AppColors.black.normal.withOpacity(0.08),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppColors.black.light.withOpacity(0.8), width: 1.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tanggal',
                      style: TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontSize: 12,
                        color: AppColors.black.normal.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _dateFormatter.format(data.tanggal), 
                      style: const TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.blue.light, 
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Diverifikasi Satpel", 
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      color: AppColors.blue.dark, 
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildWasteCountBox("Mudah Terurai", data.mudahTerurai, AppColors.green.normal, AppColors.green.light)),
                const SizedBox(width: 8),
                Expanded(child: _buildWasteCountBox("Material Daur", data.materialDaur, AppColors.blue.normal, AppColors.blue.light)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildWasteCountBox("B3", data.b3, AppColors.red.normal, AppColors.red.light)),
                const SizedBox(width: 8),
                Expanded(child: _buildWasteCountBox("Residu", data.residu, AppColors.black.normal, AppColors.black.light)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailChecklistPage(checklistData: data.toMap()),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue.normal,
                  foregroundColor: AppColors.blue.darker,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'DETAILS',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'InstrumentSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWasteCountBox(
      String title, int count, Color borderColor, Color bgColor) {
    Color textColor =
        (bgColor == AppColors.black.light) ? AppColors.black.normal : borderColor;
    Color titleColor = textColor.withOpacity(0.8);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}