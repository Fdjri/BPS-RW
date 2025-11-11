import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:lucide_icons/lucide_icons.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/presentation/utils/app_colors.dart';
import '../widgets/data_menu_drawer_widget.dart';
import '../../../../core/presentation/widgets/custom_bottom_navbar.dart';
import 'package:bps_rw/features/checklist/presentation/pages/checklist_page.dart';
import 'package:bps_rw/features/laporan/presentation/pages/laporan_page.dart';
import 'package:bps_rw/features/profile/presentation/pages/profile_page.dart';
import '../blocs/data_berat_sampah/data_berat_sampah_cubit.dart';
import '../blocs/data_berat_sampah/data_berat_sampah_state.dart';
import '../../domain/entities/data_berat_sampah.dart';


class DataBeratSampahPage extends StatefulWidget {
  const DataBeratSampahPage({super.key});

  static const String routeName = DataMenuDrawer.sampahRoute;

  @override
  State<DataBeratSampahPage> createState() => _DataBeratSampahPageState();
}

class _DataBeratSampahPageState extends State<DataBeratSampahPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BeratSampahCubit()..fetchDataBeratSampah(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.white.normal,
        drawer: const DataMenuDrawer(activeRoute: DataBeratSampahPage.routeName), 
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
        body: BlocBuilder<BeratSampahCubit, BeratSampahState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeaderAndFilters(context, state),
                  if (state.status == BeratSampahStatus.loading)
                    const Padding(
                      padding: EdgeInsets.only(top: 150),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (state.status == BeratSampahStatus.failure)
                    Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: Center(child: Text(state.errorMessage ?? 'Gagal memuat data')),
                    ),
                  if (state.status == BeratSampahStatus.success)
                    _buildDataList(state),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderAndFilters(BuildContext context, BeratSampahState state) {
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
                  Icon(LucideIcons.trash2, color: AppColors.white.normal), 
                  const SizedBox(width: 12),
                  Text(
                    'Data Berat Sampah',
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
                    'Bulan:', 
                    state.selectedBulan, 
                    state.bulanOptions
                  ),
                  const SizedBox(width: 12),
                  _buildFilterButton(
                    context, 
                    'Tahun:', 
                    state.selectedTahun,
                    state.tahunOptions
                  ),
                  const SizedBox(width: 12),
                  _buildFilterButton(
                    context, 
                    'RT:', 
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
              color: AppColors.white.normal.withOpacity(0.7), 
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
                    Expanded(
                      child: Text(
                        value, 
                        style: const TextStyle(
                          fontFamily: 'InstrumentSans', 
                          fontSize: 14
                        ),
                        overflow: TextOverflow.ellipsis,
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
    final cubit = context.read<BeratSampahCubit>();
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
                  fontWeight: FontWeight.bold, 
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
                        if (title == 'Bulan:') {
                          cubit.changeFilter(bulan: item);
                        } else if (title == 'Tahun:') {
                          cubit.changeFilter(tahun: item);
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

  Widget _buildDataList(BeratSampahState state) {
    if (state.filteredDataBerat.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: state.filteredDataBerat.length, 
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final data = state.filteredDataBerat[index]; 
        return _buildDataCard(data); 
      },
    );
  }

  Widget _buildDataCard(BeratSampah data) {
    return Card(
      elevation: 4, 
      shadowColor: AppColors.black.normal.withOpacity(0.08), 
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppColors.black.light)  
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(LucideIcons.calendarDays, color: AppColors.blue.normal, size: 20),
                const SizedBox(width: 8),
                Text(
                  data.displayTanggal,
                  style: const TextStyle(
                    fontFamily: 'InstrumentSans', 
                    fontSize: 14, 
                    fontWeight: FontWeight.bold, 
                  ),
                ),
                const Spacer(),
                _buildRtTag(data.rt),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildWasteBox(
                    "Mudah Terurai", data.mudahTerurai,
                    AppColors.green.light, 
                    AppColors.green.dark,  
                    AppColors.green.dark, 
                    AppColors.green.normal, 
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildWasteBox(
                    "Material Daur", data.materialDaur,
                    AppColors.blue.light,  
                    AppColors.blue.dark,   
                    AppColors.blue.dark,   
                    AppColors.blue.normal, 
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildWasteBox(
                    "B3", data.b3,
                    AppColors.red.light,  
                    AppColors.red.normal, 
                    AppColors.red.dark,  
                    AppColors.red.normal, 
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildWasteBox(
                    "Residu", data.residu,
                    AppColors.black.light, 
                    AppColors.black.normal.withOpacity(0.7),
                    AppColors.black.normal, 
                    AppColors.black.lightActive,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.blue.light,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.blue.normal)
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.scale, color: AppColors.blue.dark, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Total Berat",
                    style: TextStyle(
                      fontFamily: 'InstrumentSans', 
                      fontSize: 14, 
                      fontWeight: FontWeight.w500, 
                      color: AppColors.blue.dark,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        data.total.toStringAsFixed(2), 
                        style: TextStyle(
                          fontFamily: 'InstrumentSans', 
                          fontSize: 20, 
                          fontWeight: FontWeight.bold, 
                          color: AppColors.blue.dark,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.0, left: 3.0),
                        child: Text(
                          "Kg",
                          style: TextStyle(
                            fontFamily: 'InstrumentSans', 
                            fontSize: 12,
                            color: AppColors.blue.dark, 
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRtTag(String rt) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.blue.light, 
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "RT $rt",
        style: TextStyle(
          fontFamily: 'InstrumentSans', 
          color: AppColors.blue.dark, 
          fontSize: 12, 
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildWasteBox(String title, double weight, Color bgColor, Color titleColor, Color valueColor, Color borderColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor) 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'InstrumentSans', 
              fontSize: 12, 
              color: titleColor, 
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                weight.toStringAsFixed(2), 
                style: TextStyle(
                  fontFamily: 'InstrumentSans', 
                  fontSize: 20,
                  fontWeight: FontWeight.bold, 
                  color: valueColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0, left: 3.0),
                child: Text(
                  "Kg",
                  style: TextStyle(
                    fontFamily: 'InstrumentSans', 
                    fontSize: 12,
                    color: titleColor, 
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          )
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