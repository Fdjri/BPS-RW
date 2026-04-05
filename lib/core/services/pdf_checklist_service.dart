import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class PdfChecklistService {
  static Future<Uint8List> generateChecklistPdf(Map<String, dynamic> checklistData) async {
    final pdf = pw.Document();

    final DateTime tanggal = checklistData['tanggal'] ?? DateTime.now();
    final double totalMudahTerurai = (checklistData['mudah_terurai'] ?? 0.0).toDouble();
    final double totalMaterialDaur = (checklistData['material_daur'] ?? 0.0).toDouble();
    final double totalB3 = (checklistData['b3'] ?? 0.0).toDouble();
    final double totalResidu = (checklistData['residu'] ?? 0.0).toDouble();
    final List<Map<String, dynamic>> detailRumah = List<Map<String, dynamic>>.from(checklistData['detail_rumah'] ?? []);

    final DateFormat dateFormatter = DateFormat('EEEE, d MMMM yyyy', 'id');
    final NumberFormat numberFormatter = NumberFormat('#,##0.00', 'id');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'LAPORAN CHECKLIST BPS RW',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Tanggal: ${dateFormatter.format(tanggal)}',
                    style: const pw.TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Summary Totals
            pw.Text(
              'Total Berat Sampah (Kg)',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Table.fromTextArray(
              border: pw.TableBorder.all(color: PdfColors.grey400, width: 1),
              headers: ['Kategori', 'Berat (Kg)'],
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
              data: [
                ['Mudah Terurai', numberFormatter.format(totalMudahTerurai)],
                ['Material Daur', numberFormatter.format(totalMaterialDaur)],
                ['B3', numberFormatter.format(totalB3)],
                ['Residu', numberFormatter.format(totalResidu)],
              ],
            ),
            pw.SizedBox(height: 24),

            // Detail Rumah
            pw.Text(
              'Data Inputan Checklist Rumah',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),
            ...List.generate(detailRumah.length, (index) {
              final rumah = detailRumah[index];
              final Map<String, bool> sampahStatus = Map<String, bool>.from(rumah['sampah'] ?? {});
              
              final bool mudahTerurai = sampahStatus['mudah_terurai'] ?? false;
              final bool materialDaur = sampahStatus['material_daur'] ?? false;
              final bool b3 = sampahStatus['b3'] ?? false;
              final bool residu = sampahStatus['residu'] ?? false;
              
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 12),
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400, width: 1),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          rumah['nama'] ?? 'Nama Rumah Tidak Ada',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                        ),
                        pw.Text(
                          'RT ${rumah['rt'] ?? '???'}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.blue800, fontSize: 12),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      children: [
                        _buildCheckboxSpec('Mudah Terurai', mudahTerurai),
                        pw.SizedBox(width: 16),
                        _buildCheckboxSpec('Material Daur', materialDaur),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      children: [
                        _buildCheckboxSpec('B3', b3),
                        pw.SizedBox(width: 16),
                        _buildCheckboxSpec('Residu', residu),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildCheckboxSpec(String label, bool isChecked) {
    return pw.Row(
      children: [
        pw.Container(
          width: 12,
          height: 12,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 1),
            color: isChecked ? PdfColors.black : PdfColors.white,
          ),
          child: isChecked 
            ? pw.Center(
                child: pw.Text('✓', style: pw.TextStyle(color: PdfColors.white, fontSize: 10)),
              )
            : null,
        ),
        pw.SizedBox(width: 6),
        pw.Text(label, style: const pw.TextStyle(fontSize: 12)),
      ],
    );
  }

  static Future<Uint8List> generateRekapChecklistPdf(
    List<Map<String, dynamic>> listData,
    String periode,
    String statusTitle,
  ) async {
    final pdf = pw.Document();
    final DateFormat dateFormatter = DateFormat('EEEE, d MMMM yyyy', 'id');
    final NumberFormat numberFormatter = NumberFormat('#,##0.00', 'id');

    // Aggregate totals for the month
    double totalMudahTerurai = 0.0;
    double totalMaterialDaur = 0.0;
    double totalB3 = 0.0;
    double totalResidu = 0.0;

    for (var data in listData) {
      totalMudahTerurai += (data['mudah_terurai'] ?? 0.0).toDouble();
      totalMaterialDaur += (data['material_daur'] ?? 0.0).toDouble();
      totalB3 += (data['b3'] ?? 0.0).toDouble();
      totalResidu += (data['residu'] ?? 0.0).toDouble();
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          final List<pw.Widget> children = [
            // Header
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'REKAPITULASI CHECKLIST BPS RW',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Status: $statusTitle',
                    style: const pw.TextStyle(fontSize: 14),
                  ),
                  pw.Text(
                    'Periode: $periode',
                    style: const pw.TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Summary Totals
            pw.Text(
              'Total Akumulasi Berat Sampah (Kg)',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Table.fromTextArray(
              border: pw.TableBorder.all(color: PdfColors.grey400, width: 1),
              headers: ['Kategori', 'Total Berat (Kg)'],
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
              data: [
                ['Mudah Terurai', numberFormatter.format(totalMudahTerurai)],
                ['Material Daur', numberFormatter.format(totalMaterialDaur)],
                ['B3', numberFormatter.format(totalB3)],
                ['Residu', numberFormatter.format(totalResidu)],
              ],
            ),
            pw.SizedBox(height: 24),

            pw.Text(
              'Daftar Harian Checklist',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),
          ];

          for (var data in listData) {
            final DateTime tanggal = data['tanggal'] ?? DateTime.now();
            final double mt = (data['mudah_terurai'] ?? 0.0).toDouble();
            final double md = (data['material_daur'] ?? 0.0).toDouble();
            final double b3 = (data['b3'] ?? 0.0).toDouble();
            final double rs = (data['residu'] ?? 0.0).toDouble();
            
            children.add(
              pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 12),
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400, width: 1),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      dateFormatter.format(tanggal),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      children: [
                        pw.Text('MT: ${numberFormatter.format(mt)} Kg,   ', style: const pw.TextStyle(fontSize: 12)),
                        pw.Text('MD: ${numberFormatter.format(md)} Kg,   ', style: const pw.TextStyle(fontSize: 12)),
                        pw.Text('B3: ${numberFormatter.format(b3)} Kg,   ', style: const pw.TextStyle(fontSize: 12)),
                        pw.Text('RS: ${numberFormatter.format(rs)} Kg', style: const pw.TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              )
            );
          }

          if (listData.isEmpty) {
            children.add(pw.Text('- Tidak ada data -', style: pw.TextStyle(fontStyle: pw.FontStyle.italic)));
          }

          return children;
        },
      ),
    );

    return pdf.save();
  }
}
