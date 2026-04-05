import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../../../../core/presentation/utils/app_colors.dart';
import '../../../../core/services/pdf_checklist_service.dart';

class ExportPdfDialog extends StatefulWidget {
  final List<dynamic> fullData;
  final String statusTitle;
  
  const ExportPdfDialog({
    super.key, 
    required this.fullData,
    required this.statusTitle,
  });

  @override
  State<ExportPdfDialog> createState() => _ExportPdfDialogState();
}

class _ExportPdfDialogState extends State<ExportPdfDialog> {
  String? selectedBulan;
  String? selectedTahun;

  final List<String> listBulan = [
    'Semua Bulan', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];
  final List<String> listTahun = ['Semua Tahun', '2023', '2024', '2025', '2026', '2027'];

  @override
  void initState() {
    super.initState();
    selectedBulan = 'Semua Bulan';
    selectedTahun = 'Semua Tahun';
  }

  void _printData() async {
    // Filter data based on selected month and year
    List<Map<String, dynamic>> filtered = [];
    
    for (var rawData in widget.fullData) {
      final data = rawData.toMap();
      final DateTime tgl = data['tanggal'];
      final String bulanData = DateFormat('MMMM', 'id').format(tgl);
      final String tahunData = DateFormat('yyyy', 'id').format(tgl);

      bool matchBulan = (selectedBulan == 'Semua Bulan' || bulanData == selectedBulan);
      bool matchTahun = (selectedTahun == 'Semua Tahun' || tahunData == selectedTahun);

      if (matchBulan && matchTahun) {
        filtered.add(data);
      }
    }

    if (filtered.isEmpty) {
      // Show nodata lottie
      Navigator.pop(context); // Close the export dialog first
      _showNoDataPopup();
    } else {
      Navigator.pop(context); // Close the export dialog
      try {
        final String periode = '${selectedBulan == 'Semua Bulan' ? 'Semua' : selectedBulan} ${selectedTahun == 'Semua Tahun' ? '' : selectedTahun}';
        final pdfBytes = await PdfChecklistService.generateRekapChecklistPdf(filtered, periode, widget.statusTitle);
        await Printing.layoutPdf(
          onLayout: (format) async => pdfBytes,
          name: 'Rekapitulasi_Checklist_$periode.pdf',
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal membuat PDF: $e')),
          );
        }
      }
    }
  }

  void _showNoDataPopup() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/lottie/nodata.json', width: 200, height: 200, repeat: true),
              const SizedBox(height: 16),
              const Text('Data Tidak Ditemukan', style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                'Tidak ada data untuk bulan $selectedBulan dan tahun $selectedTahun.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 14, color: AppColors.black.normal.withOpacity(0.6)),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue.normal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Tutup', style: TextStyle(fontFamily: 'InstrumentSans', color: AppColors.white.normal, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(LucideIcons.printer, color: AppColors.blue.normal),
          const SizedBox(width: 8),
          const Text('Cetak PDF', style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pilih rentang waktu untuk diekspor:', style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 14)),
          const SizedBox(height: 16),
          _buildDropdown('Bulan', selectedBulan, listBulan, (val) {
            setState(() {
              selectedBulan = val;
            });
          }),
          const SizedBox(height: 12),
          _buildDropdown('Tahun', selectedTahun, listTahun, (val) {
            setState(() {
              selectedTahun = val;
            });
          }),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Batal', style: TextStyle(fontFamily: 'InstrumentSans', color: AppColors.red.normal, fontWeight: FontWeight.bold)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue.normal,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: _printData,
          child: Text('Cetak', style: TextStyle(fontFamily: 'InstrumentSans', color: AppColors.white.normal, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 12, color: AppColors.black.normal.withOpacity(0.6))),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.black.lightActive),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontFamily: 'InstrumentSans', fontSize: 14)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
