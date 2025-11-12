import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; 
import '../../../../core/presentation/utils/app_colors.dart';

class DetailChecklistPage extends StatefulWidget {
  final Map<String, dynamic> checklistData;
  const DetailChecklistPage({
    super.key,
    required this.checklistData,
  });

  @override
  State<DetailChecklistPage> createState() => _DetailChecklistPageState();
}

class _DetailChecklistPageState extends State<DetailChecklistPage> {
  late DateFormat _headerDateFormatter;
  late NumberFormat _weightNumberFormatter;
  late DateTime tanggal;
  late double totalMudahTerurai;
  late double totalMaterialDaur;
  late double totalB3;
  late double totalResidu;
  late List<Map<String, dynamic>> detailRumah;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id', null);
    _headerDateFormatter = DateFormat('EEEE, d MMMM yyyy', 'id');
    _weightNumberFormatter = NumberFormat('#,##0.00', 'id');
    tanggal = widget.checklistData['tanggal'] ?? DateTime.now();
    totalMudahTerurai = (widget.checklistData['mudah_terurai'] ?? 0.0).toDouble();
    totalMaterialDaur = (widget.checklistData['material_daur'] ?? 0.0).toDouble();
    totalB3 = (widget.checklistData['b3'] ?? 0.0).toDouble();
    totalResidu = (widget.checklistData['residu'] ?? 0.0).toDouble();
    detailRumah = List<Map<String, dynamic>>.from(widget.checklistData['detail_rumah'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white.normal,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, tanggal),
            _buildBody(totalMudahTerurai, totalMaterialDaur, totalB3, totalResidu, detailRumah),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DateTime tanggal) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24, top: 16), 
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
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(LucideIcons.arrowLeft, color: AppColors.white.normal),
                  onPressed: () => Navigator.pop(context),
                ),
                Icon(LucideIcons.clipboardCheck, color: AppColors.white.normal, size: 22), 
                const SizedBox(width: 12),
                Text(
                  'Detail Checklist', 
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    color: AppColors.white.normal,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Tanggal',
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                color: AppColors.white.normal.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _headerDateFormatter.format(tanggal), 
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                color: AppColors.white.normal,
                fontSize: 16, 
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(double mudahTerurai, double materialDaur, double b3, double residu, List<Map<String, dynamic>> detailRumah) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Inputan Checklist Rumah',
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.black.normal.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              Row( 
                children: [     
                  Expanded(child: _buildTotalWeightBox('Mudah Terurai', mudahTerurai, AppColors.green.normal)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTotalWeightBox('Material Daur', materialDaur, AppColors.blue.normal)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildTotalWeightBox('B3', b3, AppColors.red.normal)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTotalWeightBox('Residu', residu, AppColors.black.lightActive)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          ListView.builder(
            padding: EdgeInsets.zero, 
            itemCount: detailRumah.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildRumahChecklistCard(detailRumah[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalWeightBox(String title, double weight, Color bgColor) {
    Color textColor = AppColors.white.normal;
    Color titleColor = textColor; 
    if (bgColor == AppColors.black.lightActive) { 
      textColor = AppColors.black.normal;
      titleColor = AppColors.black.normal; 
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16), 
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15), 
      ),
      child: SizedBox( 
        height: 60, 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, 
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _weightNumberFormatter.format(weight), 
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontSize: 20, 
                        fontWeight: FontWeight.w600, 
                        color: textColor,
                      ),
                      maxLines: 1, 
                      overflow: TextOverflow.ellipsis, 
                    ),
                    Text(
                      "Kg",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontSize: 17, 
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                        maxLines: 1,
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title.split(' ').map((word) => '${word[0].toUpperCase()}${word.substring(1)}').join(' '),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontSize: 16, 
                      fontWeight: FontWeight.w500, 
                      color: textColor, 
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis, 
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRumahChecklistCard(Map<String, dynamic> dataRumah) {
    final Map<String, bool> sampahStatus = Map<String, bool>.from(dataRumah['sampah'] ?? {});

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded( 
                  child: Text(
                    dataRumah['nama'] ?? 'Nama Rumah Tidak Ada',
                    style: const TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.blue.light,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "RT ${dataRumah['rt'] ?? '???'}",
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
                Expanded(child: _buildReadOnlySampahCheckbox("Mudah Terurai", sampahStatus['mudah_terurai'] ?? false, AppColors.green.normal, AppColors.green.light)),
                const SizedBox(width: 8),
                Expanded(child: _buildReadOnlySampahCheckbox("Material Daur", sampahStatus['material_daur'] ?? false, AppColors.blue.normal, AppColors.blue.light)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildReadOnlySampahCheckbox("B3", sampahStatus['b3'] ?? false, AppColors.red.normal, AppColors.red.light)),
                const SizedBox(width: 8),
                Expanded(child: _buildReadOnlySampahCheckbox("Residu", sampahStatus['residu'] ?? false, AppColors.black.normal, AppColors.black.light, uncheckedBorderColor: AppColors.black.lightActive)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlySampahCheckbox(String title, bool isChecked, Color activeColor, Color activeBgColor, {Color? uncheckedBorderColor}) {
    final Color finalUncheckedBorderColor = uncheckedBorderColor ?? AppColors.black.lightActive.withOpacity(0.5);
    final Color textColor = isChecked ? activeColor : AppColors.black.normal.withOpacity(0.7);
    final Color bgColor = isChecked ? activeBgColor : AppColors.white.normal;
    final Color borderColor = isChecked ? activeColor : finalUncheckedBorderColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: isChecked ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isChecked ? activeColor : AppColors.black.lightActive.withOpacity(0.8), 
                width: 1.5
              ),
            ),
            child: isChecked
                ? Icon(LucideIcons.check, size: 12, color: AppColors.white.normal) 
                : null, 
          ),
          const SizedBox(width: 10),
          Expanded( 
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                fontSize: 13, 
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              overflow: TextOverflow.ellipsis, 
            ),
          ),
        ],
      ),
    );
  }
}