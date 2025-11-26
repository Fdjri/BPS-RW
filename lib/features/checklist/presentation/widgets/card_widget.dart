import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/presentation/utils/app_colors.dart';

class CardWidget extends StatelessWidget {
  final String nama;
  final String alamat;
  final String rt;
  final Map<String, bool> sampahData;
  final bool isPhotoUploaded;
  final Function(String jenisSampah, bool value) onCheckChanged;
  final VoidCallback onCameraTap;

  const CardWidget({
    super.key,
    required this.nama,
    required this.alamat,
    required this.rt,
    required this.sampahData,
    required this.isPhotoUploaded,
    required this.onCheckChanged,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    // Cek apakah ada sampah yang dicentang buat nentuin tombol kamera muncul/nggak
    final isAnyChecked = sampahData.containsValue(true);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.black.light),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Nama & RT
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.blue.light,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.home,
                  color: AppColors.blue.normal,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alamat,
                      style: TextStyle(
                        fontFamily: 'InstrumentSans',
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.green.light,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "RT $rt",
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    color: AppColors.green.dark,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),

          // Checkbox Sampah (Grid 2x2 biar rapi)
          Row(
            children: [
              Expanded(
                child: _buildCheckboxItem(
                  label: "Mudah Terurai",
                  code: "MT", 
                  value: sampahData['MT'] ?? false,
                  activeColor: AppColors.green.normal,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCheckboxItem(
                  label: "Daur Ulang",
                  code: "MD",
                  value: sampahData['MD'] ?? false,
                  activeColor: AppColors.blue.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildCheckboxItem(
                  label: "B3",
                  code: "B3",
                  value: sampahData['B3'] ?? false,
                  activeColor: AppColors.red.normal,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCheckboxItem(
                  label: "Residu",
                  code: "Residu",
                  value: sampahData['Residu'] ?? false,
                  activeColor: AppColors.black.normal,
                ),
              ),
            ],
          ),

          // Tombol Upload Foto (Muncul kalau ada yg dicentang ATAU udah upload)
          if (isAnyChecked || isPhotoUploaded) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onCameraTap,
                icon: Icon(
                  isPhotoUploaded ? LucideIcons.checkCircle : LucideIcons.camera,
                  size: 18,
                ),
                label: Text(
                  isPhotoUploaded ? "Foto Terupload" : "Ambil Bukti Foto",
                  style: const TextStyle(fontFamily: 'InstrumentSans'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPhotoUploaded 
                      ? AppColors.green.light 
                      : AppColors.blue.normal,
                  foregroundColor: isPhotoUploaded 
                      ? AppColors.green.dark 
                      : AppColors.white.normal,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCheckboxItem({
    required String label,
    required String code,
    required bool value,
    required Color activeColor,
  }) {
    return InkWell(
      onTap: () => onCheckChanged(code, !value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: value ? activeColor : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
          color: value ? activeColor.withOpacity(0.1) : Colors.transparent,
        ),
        child: Row(
          children: [
            // Custom Checkbox visual
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: value ? activeColor : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: value ? activeColor : Colors.grey.shade400,
                ),
              ),
              child: value
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                fontSize: 12,
                fontWeight: value ? FontWeight.w600 : FontWeight.normal,
                color: value ? activeColor : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}