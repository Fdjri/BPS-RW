import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/presentation/utils/app_colors.dart';
import '../../../../core/presentation/widgets/custom_bottom_navbar.dart';
import '../widgets/menu_drawer_widget.dart';
import '../widgets/card_widget.dart';
import 'package:bps_rw/features/laporan/presentation/pages/laporan_page.dart';
import 'package:bps_rw/features/profile/presentation/pages/profile_page.dart';
import 'package:bps_rw/features/data/presentation/pages/data_page.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});
  static const String routeName = '/checklist';

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _selectedRT = 'Semua RT';
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _mtController = TextEditingController(text: '0');
  final TextEditingController _mdController = TextEditingController(text: '0');
  final TextEditingController _residuController = TextEditingController(text: '0');
  final TextEditingController _b3Controller = TextEditingController(text: '0');
  final List<Map<String, dynamic>> _dataRumah = List.generate(10, (index) => {
        "nama": "Budi Santoso ${index + 1}",
        "alamat": "Jl. Mawar No. ${10 + index}",
        "rt": "00${(index % 3) + 1}",
        "sampah": <String, bool>{ 
          "mudah_terurai": index == 0,
          "material_daur": index == 0,
          "b3": index == 0,
          "r": index == 0, 
        },
        "foto_uploaded": index == 0,
      });
  final List<String> _listRT = ['Semua RT', '001', '002', '003'];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id', null);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mtController.dispose();
    _mdController.dispose();
    _residuController.dispose();
    _b3Controller.dispose();
    super.dispose();
  }

  void _showSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/success.json',
                repeat: false,
                width: 150,
                height: 150,
                onLoaded: (composition) {
                  Future.delayed(composition.duration, () {
                    Navigator.of(context).pop();
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Data Berhasil Dikirim!',
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: AppColors.blue.normal,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool?> _showWeightInputDialog() {
    final String todayDate =
        DateFormat('EEEE, d MMMM yyyy', 'id').format(DateTime.now());
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          actionsPadding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          title: Text(
            'Data Sampah RW 7 : $todayDate',
            style: const TextStyle(
              fontFamily: 'InstrumentSans',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                        child: _buildWeightTextField(
                            'Mudah Terurai (kg)', _mtController)),
                    const SizedBox(width: 16),
                    Expanded(
                        child: _buildWeightTextField(
                            'Material Daur (kg)', _mdController)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: _buildWeightTextField(
                            'Residu (kg)', _residuController)),
                    const SizedBox(width: 16),
                    Expanded(
                        child: _buildWeightTextField(
                            'E-waste/B3 (kg)', _b3Controller)),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.red.normal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'BATAL',
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  color: AppColors.white.normal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(false); 
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.green.normal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'SIMPAN',
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  color: AppColors.white.normal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                // TODO: Tambahin logic validasi atau simpan data di sini
                print('MT: ${_mtController.text}');
                print('MD: ${_mdController.text}');
                print('Residu: ${_residuController.text}');
                print('B3: ${_b3Controller.text}');
                Navigator.of(dialogContext)
                    .pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeightTextField(
      String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'InstrumentSans',
            fontSize: 12,
            color: AppColors.black.normal.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          style: const TextStyle(fontFamily: 'InstrumentSans', fontSize: 14),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: true,
            fillColor: AppColors.white.normal,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.black.lightActive),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.black.lightActive),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.blue.normal, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String todayDate =
        DateFormat('EEEE, d MMMM yyyy', 'id').format(DateTime.now());
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white.normal,
      drawer: const ChecklistMenuDrawerWidget(
          activeRoute: ChecklistPage.routeName),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderAndFilters(todayDate),
            _buildLegend(),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _dataRumah.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ChecklistCardWidget(
                  dataRumah: _dataRumah[index],
                  onSampahChanged: (String jenisSampah, bool isChecked) {
                    print(
                        'Rumah ${index + 1} - Sampah "$jenisSampah" diubah menjadi: $isChecked');
                  },
                  onFotoUploadChanged: (bool isUploaded) {
                    print(
                        'Rumah ${index + 1} - Status Foto Upload diubah menjadi: $isUploaded');
                  },
                );
              },
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderAndFilters(String date) {
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
                  Icon(LucideIcons.clipboardEdit,
                      color: AppColors.white.normal, size: 22),
                  const SizedBox(width: 12),
                  Text(
                    'Input Harian',
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      color: AppColors.white.normal,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  date,
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    color: AppColors.white.normal,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildFilterSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Column(
        children: [
          Row(
            children: [
              _buildLegendItem('MT', 'Mudah Terurai',
                  abvColor: AppColors.green.normal),
              _buildLegendItem('R', 'Residu',
                  abvColor: AppColors.blue.darkActive),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _buildLegendItem('MD', 'Material Daur',
                  abvColor: AppColors.blue.normal),
              _buildLegendItem('B3', '', abvColor: AppColors.red.normal),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String abbreviation, String text, {Color? abvColor}) {
    abvColor ??= AppColors.black.darker;
    return Expanded(
      child: Row(
        children: [
          Text(
            abbreviation,
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: abvColor,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              fontSize: 14,
              color: AppColors.black.normal.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
          child: Text(
            'Filter RT:',
            style: TextStyle(
                fontFamily: 'InstrumentSans',
                color: AppColors.white.normal.withOpacity(0.8),
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
        ),
        _buildFilterDropdown(_selectedRT, _listRT, () {
          _showFilterSheet(context, 'Pilih RT', _listRT, _selectedRT, (value) {
            setState(() => _selectedRT = value);
            // TODO: Implementasi logic filter data berdasarkan RT
            print("RT Filter changed to: $value");
          });
        }),
      ],
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
              Text(
                currentValue ?? 'Pilih...',
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontSize: 14,
                  color: AppColors.black.normal.withOpacity(0.87),
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

  void _showFilterSheet(
      BuildContext context,
      String title,
      List<String> items,
      String? currentSelection,
      ValueChanged<String?> onSelect) {
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

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, 16 + MediaQuery.of(context).viewPadding.bottom + 70),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async { 
            print("Submit Data tapped");
            final bool? isSaved = await _showWeightInputDialog();
            if (isSaved == true) {
              _showSuccessAnimation();
            } else {
              print("Input weight cancelled");
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue.normal,
            foregroundColor: AppColors.white.normal,
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: const Text(
            'Submit Data',
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

