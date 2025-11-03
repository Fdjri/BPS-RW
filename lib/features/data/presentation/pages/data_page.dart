import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/data_menu_drawer_widget.dart';
import '../../../../core/presentation/utils/app_colors.dart';
import '../../../../core/presentation/widgets/custom_bottom_navbar.dart';
import 'edit_rumah_page.dart';
import 'tambah_nik_page.dart';
import 'package:bps_rw/features/checklist/presentation/pages/checklist_page.dart';
import 'package:bps_rw/features/laporan/presentation/pages/laporan_page.dart';
import 'package:bps_rw/features/profile/presentation/pages/profile_page.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});
  static const String routeName = '/data';

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _selectedStatus = 'Semua Status';
  String? _selectedRT = 'Semua RT';
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _dataRumah = [
    {
      "rt": "099", "rw": "007", "is_synced": true, "is_edited": true,
      "alamat_dinas": "dinas lh",
      "alamat_full": "KOTA ADM. JAKARTA BARAT, GROGOL PETAMBURAN, GROGOL",
      "nama": "adam",
      "status_aktif": true,
      "status_checklist": true,
    },
    {
      "rt": "099", "rw": "007", "is_synced": true, "is_edited": true,
      "alamat_dinas": "jl. MAndala v no 67",
      "alamat_full": "KOTA ADM. JAKARTA BARAT, GROGOL PETAMBURAN, GROGOL",
      "nama": "JL. MAndala v no 67",
      "status_aktif": false,
      "status_checklist": false,
    },
    {
      "rt": "099", "rw": "007", "is_synced": false, "is_edited": true,
      "alamat_dinas": "jl.muaran buara No.3",
      "alamat_full": "KOTA ADM. JAKARTA BARAT, GROGOL PETAMBURAN, GROGOL",
      "nama": "jl.muaran buara No.3",
      "status_aktif": false,
      "status_checklist": false,
    },
     {
      "rt": "099", "rw": "007", "is_synced": false, "is_edited": true,
      "alamat_dinas": "jl.muaran buara No.5",
      "alamat_full": "KOTA ADM. JAKARTA BARAT, GROGOL PETAMBURAN, GROGOL",
      "nama": "jl.muaran buara No.5",
      "status_aktif": false,
      "status_checklist": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white.normal,
      drawer: const DataMenuDrawer(activeRoute: DataPage.routeName),
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

      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderAndFilters(),

            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _dataRumah.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildDataCard(_dataRumah[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderAndFilters() {
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
                  _buildFilterButton('Filter Status:', _selectedStatus ?? 'Semua Status'),
                  const SizedBox(width: 16),
                  _buildFilterButton('Filter RT:', _selectedRT ?? 'Semua RT'),
                ],
              ),
              // const SizedBox(height: 16),
              // TextField(
              //   controller: _searchController,
              //   style: const TextStyle( 
              //     fontFamily: 'InstrumentSans',
              //     fontSize: 14,
              //   ),
              //   decoration: InputDecoration(
              //     hintText: 'Cari alamat atau nama pemilik...',
              //     hintStyle: TextStyle( 
              //       fontFamily: 'InstrumentSans',
              //       color: AppColors.black.normal.withOpacity(0.54), 
              //     ),
              //     prefixIcon: Icon(LucideIcons.search, color: AppColors.black.normal.withOpacity(0.54)), 
              //     filled: true,
              //     fillColor: AppColors.white.normal, 
              //     contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //       borderSide: BorderSide.none,
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //       borderSide: BorderSide.none,
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //       borderSide: BorderSide(color: AppColors.blue.normal),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String title, String value) {
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
                _showFilterSheet(context, title, (title == 'Filter Status:') ? ['Semua Status', 'Aktif', 'Tidak Aktif'] : ['Semua RT', '099', '100']);
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

  void _showFilterSheet(BuildContext context, String title, List<String> items) {
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
              ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      items[index],
                      style: const TextStyle(fontFamily: 'InstrumentSans'), 
                    ),
                    onTap: () {
                      setState(() {
                        if (title == 'Filter Status:') {
                          _selectedStatus = items[index];
                        } else {
                          _selectedRT = items[index];
                        }
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDataCard(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ClipRRect( 
        borderRadius: BorderRadius.circular(15.0),
        child: Slidable(
          key: ValueKey(data["alamat_dinas"]), 
          groupTag: 'data-rumah-list',
          endActionPane: ActionPane(
            motion: const StretchMotion(), 
            extentRatio: 0.5, 
            children: [
            SlidableAction(
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditRumahPage(dataRumah: data),
                  ),
                );
              },
              backgroundColor: AppColors.yellow.normal,
                foregroundColor: AppColors.white.normal,
                icon: LucideIcons.edit,
                label: 'Edit',
              ),
            SlidableAction(
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TambahNikPage(dataRumah: data),
                  ),
                );
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
                            'RT ${data["rt"]}', 
                            AppColors.blue.light,
                            icon: LucideIcons.home
                          ),
                          const SizedBox(width: 8),
                          _buildTag('RW ${data["rw"]}', AppColors.blue.light),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  _buildInfoRow(LucideIcons.mapPin, data["alamat_dinas"], AppColors.blue.normal),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Text(
                      data["alamat_full"],
                      style: TextStyle(
                        fontFamily: 'InstrumentSans', 
                        fontSize: 12, 
                        color: AppColors.black.normal.withOpacity(0.54) 
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  _buildInfoRow(LucideIcons.user, data["nama"], AppColors.blue.normal),
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
                        data["status_aktif"] ? LucideIcons.checkCircle2 : LucideIcons.xCircle, 
                        data["status_aktif"] ? AppColors.green.dark : AppColors.red.normal, 
                        data["status_aktif"] ? AppColors.green.light : AppColors.red.light
                      ),
                      const SizedBox(width: 12),
                      _buildStatusChip( 
                        "Checklist", 
                        data["status_checklist"] ? LucideIcons.checkCircle2 : LucideIcons.xCircle, 
                        data["status_checklist"] ? AppColors.green.dark : AppColors.red.normal, 
                        data["status_checklist"] ? AppColors.green.light : AppColors.red.light
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
}



