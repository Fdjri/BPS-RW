import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/presentation/utils/app_colors.dart';
import '../widgets/data_menu_drawer_widget.dart';
import '../../../../core/presentation/widgets/custom_bottom_navbar.dart';
import 'package:bps_rw/features/checklist/presentation/pages/checklist_page.dart';
import 'package:bps_rw/features/laporan/presentation/pages/laporan_page.dart';
import 'package:bps_rw/features/profile/presentation/pages/profile_page.dart';


class DataBeratSampahPage extends StatefulWidget {
  const DataBeratSampahPage({super.key});

  static const String routeName = DataMenuDrawer.sampahRoute;

  @override
  State<DataBeratSampahPage> createState() => _DataBeratSampahPageState();
}

class _DataBeratSampahPageState extends State<DataBeratSampahPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _selectedBulan = 'Semua Bulan';
  String? _selectedTahun = '2025';
  String? _selectedRT = 'Semua RT';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _dataBeratList = [
    {
      "tanggal": "Rabu, 15 Januari 2025",
      "rt": "001",
      "mudah_terurai": "12.50",
      "material_daur": "8.30",
      "b3": "1.20",
      "residu": "5.80",
      "total": "27.80"
    },
    {
      "tanggal": "Selasa, 14 Januari 2025",
      "rt": "002",
      "mudah_terurai": "10.00",
      "material_daur": "5.10",
      "b3": "0.50",
      "residu": "3.20",
      "total": "18.80"
    },
    {
      "tanggal": "Senin, 13 Januari 2025",
      "rt": "001",
      "mudah_terurai": "11.20",
      "material_daur": "7.00",
      "b3": "0.80",
      "residu": "4.50",
      "total": "23.50"
    },
  ];
  final List<String> _listBulan = ['Semua Bulan', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
  final List<String> _listTahun = ['2025', '2024', '2023'];
  final List<String> _listRT = ['Semua RT', '001', '002', '003', '004', '005'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderAndFilters(),
            _buildDataList(),
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
                  _buildFilterButton('Bulan:', _selectedBulan ?? 'Semua Bulan'),
                  const SizedBox(width: 12),
                  _buildFilterButton('Tahun:', _selectedTahun ?? '2025'),
                  const SizedBox(width: 12),
                  _buildFilterButton('RT:', _selectedRT ?? 'Semua RT'),
                ],
              ),
              // const SizedBox(height: 16),
              // TextField(
              //   controller: _searchController,
              //   style: const TextStyle(
              //     fontFamily: 'InstrumentSans', 
              //     fontSize: 14
              //   ),
              //   decoration: InputDecoration(
              //     hintText: 'Cari RT atau tanggal...',
              //     hintStyle: TextStyle(
              //       fontFamily: 'InstrumentSans', 
              //       color: AppColors.black.normal.withOpacity(0.54) 
              //     ),
              //     prefixIcon: Icon(LucideIcons.search, color: AppColors.black.normal.withOpacity(0.54)), 
              //     filled: true,
              //     fillColor: AppColors.white.normal, 
              //     contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //       borderSide: BorderSide.none,
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
                List<String> items;
                if (title == 'Bulan:') {
                  items = _listBulan;
                } else if (title == 'Tahun:') {
                  items = _listTahun;
                } else {
                  items = _listRT;
                }
                _showFilterSheet(context, title, items);
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
                    return ListTile(
                      title: Text(
                        items[index], 
                        style: const TextStyle(fontFamily: 'InstrumentSans'), 
                      ),
                      onTap: () {
                        setState(() {
                          if (title == 'Bulan:') {
                            _selectedBulan = items[index];
                          } else if (title == 'Tahun:') {
                            _selectedTahun = items[index];
                          } else {
                            _selectedRT = items[index];
                          }
                        });
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

  Widget _buildDataList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: _dataBeratList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _buildDataCard(_dataBeratList[index]);
      },
    );
  }

  Widget _buildDataCard(Map<String, dynamic> data) {
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
                  data["tanggal"],
                  style: const TextStyle(
                    fontFamily: 'InstrumentSans', 
                    fontSize: 14, 
                    fontWeight: FontWeight.bold, 
                  ),
                ),
                const Spacer(),
                _buildRtTag(data["rt"]),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildWasteBox(
                    "Mudah Terurai", data["mudah_terurai"], 
                    AppColors.green.light, 
                    AppColors.green.dark,  
                    AppColors.green.dark, 
                    AppColors.green.normal, 
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildWasteBox(
                    "Material Daur", data["material_daur"], 
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
                    "B3", data["b3"], 
                    AppColors.red.light,  
                    AppColors.red.normal, 
                    AppColors.red.dark,  
                    AppColors.red.normal, 
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildWasteBox(
                    "Residu", data["residu"], 
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
                        data["total"],
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

  
  Widget _buildWasteBox(String title, String weight, Color bgColor, Color titleColor, Color valueColor, Color borderColor) {
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
                weight,
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
}
