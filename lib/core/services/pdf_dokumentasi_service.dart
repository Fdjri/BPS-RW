import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../features/laporan/domain/entities/dokumentasi_laporan.dart';
import '../../features/laporan/domain/entities/laporan_entities.dart';

class PdfDokumentasiService {
  static Future<Uint8List> generateLaporanDokumentasi({
    required Laporan laporan,
    required List<DokumentasiLaporan> listKegiatan,
  }) async {
    final pdf = pw.Document();
    List<pw.ImageProvider> loadedImages = [];
    for (var kegiatan in listKegiatan) {
      try {
        if (kegiatan.fotoUrl != null && kegiatan.fotoUrl!.isNotEmpty) {
          final image = await networkImage(kegiatan.fotoUrl!);
          loadedImages.add(image);
        } else if (kegiatan.pickedImage != null) {
          final bytes = await kegiatan.pickedImage!.readAsBytes();
          loadedImages.add(pw.MemoryImage(bytes));
        } else {
          loadedImages.add(pw.MemoryImage(Uint8List(0)));
        }
      } catch (e) {
        loadedImages.add(pw.MemoryImage(Uint8List(0)));
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'LAPORAN DOKUMENTASI BPS RW',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Periode: ${laporan.bulan} ${laporan.tahun}',
                    style: const pw.TextStyle(fontSize: 14),
                  ),
                  pw.Text(
                    'Jumlah Rumah Memilah: ${laporan.jumlahRumah} Rumah',
                    style: const pw.TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            ...List.generate(listKegiatan.length, (index) {
              final kegiatan = listKegiatan[index];
              final image = loadedImages[index];
              final tgl = kegiatan.tanggalPelaksanaan;
              final tanggalStr = tgl != null
                  ? "${tgl.day}/${tgl.month}/${tgl.year}"
                  : '-';

              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 24),
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400, width: 1),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(8),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Kegiatan ${index + 1}',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 12),
                    pw.Center(
                      child: pw.Container(
                        height: 200,
                        child: pw.Image(image, fit: pw.BoxFit.contain),
                      ),
                    ),
                    pw.SizedBox(height: 12),
                    _buildInfoRow('Keterangan', kegiatan.keterangan ?? '-'),
                    _buildInfoRow('Tanggal', tanggalStr),
                    _buildInfoRow(
                      'Pelaksana',
                      kegiatan.pelaksanaKegiatan ?? '-',
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

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              '$label',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Text(': '),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }
}
