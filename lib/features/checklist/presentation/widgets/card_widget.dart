import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/entities/rumah_checklist.dart';
import '../../../../core/presentation/utils/app_colors.dart';

class ChecklistCardWidget extends StatefulWidget {
  final RumahChecklist dataRumah;
  final Function(String jenisSampah, bool newValue) onSampahChanged;
  final Function(bool isUploaded) onFotoUploadTapped;

  const ChecklistCardWidget({
    super.key,
    required this.dataRumah,
    required this.onSampahChanged,
    required this.onFotoUploadTapped,
  });
  @override
  State<ChecklistCardWidget> createState() => _ChecklistCardWidgetState();
}

class _ChecklistCardWidgetState extends State<ChecklistCardWidget> {
  bool _hasUserInteracted = false;

  @override
  void initState() {
    super.initState();
    if (_isAnySampahChecked || widget.dataRumah.fotoUploaded) {
      _hasUserInteracted = true;
    }
  }

  // Helper mapping key dari UI ke Model
  bool _getStatus(String key) {
    switch(key) {
      case 'mudah_terurai': return widget.dataRumah.sampah['MT'] ?? false; 
      case 'material_daur': return widget.dataRumah.sampah['MD'] ?? false;
      case 'b3': return widget.dataRumah.sampah['B3'] ?? false;
      case 'residu': return widget.dataRumah.sampah['Residu'] ?? false;
      default: return false;
    }
  }
  bool get _isAnySampahChecked {
    return widget.dataRumah.sampah.containsValue(true);
  }
  void _handleSampahChange(String modelKey, bool newValue) {
    widget.onSampahChanged(modelKey, newValue);
    if (newValue == true) {
      setState(() {
        _hasUserInteracted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Logic Tombol Muncul: 
    // 1. Kalau udah pernah interaksi (_hasUserInteracted)
    // 2. ATAU kalau foto udah terupload (widget.dataRumah.fotoUploaded)
    // 3. ATAU (sebagai fallback) kalau ada sampah yang checked saat ini (_isAnySampahChecked)
    final bool showUploadButton = _hasUserInteracted || widget.dataRumah.fotoUploaded || _isAnySampahChecked;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200), 
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER CARD ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Rumah dalam Kotak
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.blue.light.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(LucideIcons.home, color: AppColors.blue.normal, size: 20),
                ),
                const SizedBox(width: 12),
                
                // Nama & Alamat
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.dataRumah.nama,
                        style: const TextStyle(
                          fontFamily: 'InstrumentSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1A1A1A), 
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.dataRumah.alamat,
                        style: TextStyle(
                          fontFamily: 'InstrumentSans',
                          color: Colors.grey[500],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                // Badge RT
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF), 
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.blue.light.withOpacity(0.5)),
                  ),
                  child: Text(
                    "RT ${widget.dataRumah.rt}",
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      color: AppColors.blue.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFF0F0F0)), 
            const SizedBox(height: 16),

            // --- CHECKLIST CHIPS (Single Row) ---
            Row(
              children: [
                Expanded(
                  child: _buildChipButton(
                    label: "MT",
                    code: "MT",
                    uiKey: 'mudah_terurai',
                    modelKey: 'MT',
                    color: AppColors.green.normal,
                  ),
                ),
                const SizedBox(width: 8), 
                Expanded(
                  child: _buildChipButton(
                    label: "MD",
                    code: "MD",
                    uiKey: 'material_daur',
                    modelKey: 'MD',
                    color: AppColors.blue.normal,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildChipButton(
                    label: "B3",
                    code: "B3",
                    uiKey: 'b3',
                    modelKey: 'B3',
                    color: AppColors.red.normal,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildChipButton(
                    label: "R",
                    code: "R",
                    uiKey: 'residu',
                    modelKey: 'Residu',
                    color: AppColors.black.normal,
                  ),
                ),
              ],
            ),

            // --- TOMBOL UPLOAD (Logic Persistent) ---
            if (showUploadButton) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => widget.onFotoUploadTapped(widget.dataRumah.fotoUploaded),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.dataRumah.fotoUploaded 
                        ? const Color(0xFFE8F5E9) 
                        : AppColors.blue.normal,
                    foregroundColor: widget.dataRumah.fotoUploaded 
                        ? AppColors.green.dark 
                        : Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: widget.dataRumah.fotoUploaded 
                          ? BorderSide(color: AppColors.green.normal) 
                          : BorderSide.none,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.dataRumah.fotoUploaded ? LucideIcons.checkCircle2 : LucideIcons.camera,
                        size: 18,
                        color: widget.dataRumah.fotoUploaded ? AppColors.green.dark : Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.dataRumah.fotoUploaded ? "Foto Terupload" : "Ambil Foto Bukti",
                        style: const TextStyle(
                          fontFamily: 'InstrumentSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Widget Tombol Chip (Checklist)
  Widget _buildChipButton({
    required String label,
    required String code,
    required String uiKey,
    required String modelKey,
    required Color color,
  }) {
    final bool isChecked = _getStatus(uiKey);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleSampahChange(modelKey, !isChecked), 
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: isChecked ? color.withOpacity(0.08) : Colors.white, 
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isChecked ? color : Colors.grey.shade300, 
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: isChecked ? color : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isChecked ? color : Colors.grey.shade400,
                    width: 1.5,
                  ),
                ),
                child: isChecked
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 6), 
              
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontSize: 13,
                  fontWeight: isChecked ? FontWeight.bold : FontWeight.w500,
                  color: isChecked ? color : const Color(0xFF4A4A4A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}