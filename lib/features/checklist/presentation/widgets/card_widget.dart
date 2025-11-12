import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/entities/rumah_checklist.dart';
import '../../../../core/presentation/utils/app_colors.dart';

class ChecklistCardWidget extends StatefulWidget {
  final RumahChecklist dataRumah;
  final Function(String jenisSampah, bool newValue) onSampahChanged;
  final Function() onFotoUploadTapped; 

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
  late Map<String, bool> _sampahStatus;
  bool _showUploadButton = false;
  bool get _isAnySampahChecked {
    return _sampahStatus.values.any((isChecked) => isChecked == true);
  }

  @override
  void initState() {
    super.initState();
    _sampahStatus = {
      'mudah_terurai': widget.dataRumah.sampah['mudah_terurai'] ?? false,
      'b3': widget.dataRumah.sampah['b3'] ?? false,
      'material_daur': widget.dataRumah.sampah['material_daur'] ?? false,
      'residu': widget.dataRumah.sampah['residu'] ?? false,
    };

    if (_isAnySampahChecked || widget.dataRumah.fotoUploaded) {
      _showUploadButton = true;
    }
  }

  @override
  void didUpdateWidget(ChecklistCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dataRumah != oldWidget.dataRumah) {
      _sampahStatus = {
        'mudah_terurai': widget.dataRumah.sampah['mudah_terurai'] ?? false,
        'b3': widget.dataRumah.sampah['b3'] ?? false,
        'material_daur': widget.dataRumah.sampah['material_daur'] ?? false,
        'residu': widget.dataRumah.sampah['residu'] ?? false,
      };
      if (_isAnySampahChecked || widget.dataRumah.fotoUploaded) {
        setState(() {
          _showUploadButton = true;
        });
      }
    }
  }

  Widget _buildSampahCheckbox(
    String initial,
    String key, 
    Color normalColor,
    Color lightColor,
  ) {
    bool isChecked = _sampahStatus[key] ?? false;
    Color boxColor = isChecked ? lightColor : const Color(0xFFF3F4F6);
    Color borderColor = isChecked ? normalColor : const Color(0xFFD1D5DB);
    Color contentColor =
        isChecked ? normalColor : AppColors.black.normal.withOpacity(0.8);
    final String cubitKey = key;
    return Flexible(
      child: AspectRatio(
        aspectRatio: 2.2,
        child: Material(
          color: boxColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: borderColor, width: 1.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              setState(() {
                bool newCheckedState = !isChecked;
                _sampahStatus[key] = newCheckedState;

                if (newCheckedState == true && _showUploadButton == false) {
                  _showUploadButton = true;
                }
              });
              widget.onSampahChanged(cubitKey, _sampahStatus[key]!);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isChecked ? normalColor : AppColors.white.normal,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: isChecked ? normalColor : const Color(0xFF9CA3AF),
                        width: 1.5,
                      ),
                    ),
                    child: isChecked
                        ? Icon(
                            LucideIcons.check,
                            size: 14,
                            color: AppColors.white.normal,
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      initial,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: contentColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    bool isUploaded = widget.dataRumah.fotoUploaded;
    Color bgColor = isUploaded ? AppColors.green.light : AppColors.white.normal;
    Color contentColor =
        isUploaded ? AppColors.green.dark : AppColors.blue.normal;
    IconData icon = isUploaded ? LucideIcons.checkCircle : LucideIcons.upload;
    String label = isUploaded ? "Foto Terupload" : "Upload Foto";
    
    return Material(
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: contentColor, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onFotoUploadTapped,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: contentColor, size: 12),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: contentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: AppColors.black.normal.withOpacity(0.08),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppColors.black.light.withOpacity(0.8), width: 1.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.dataRumah.nama, 
                        style: const TextStyle(
                          fontFamily: 'InstrumentSans',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.dataRumah.alamat, 
                        style: TextStyle(
                          fontFamily: 'InstrumentSans',
                          fontSize: 13,
                          color: AppColors.black.normal.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.blue.light,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "RT ${widget.dataRumah.rt}", 
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      color: AppColors.blue.dark,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSampahCheckbox(
                  "MT",
                  'mudah_terurai',
                  AppColors.green.normal,
                  AppColors.green.light,
                ),
                const SizedBox(width: 8),
                _buildSampahCheckbox(
                  "B3",
                  'b3',
                  AppColors.red.normal,
                  AppColors.red.light,
                ),
                const SizedBox(width: 8),
                _buildSampahCheckbox(
                  "MD",
                  'material_daur',
                  AppColors.blue.normal,
                  AppColors.blue.light,
                ),
                const SizedBox(width: 8),
                _buildSampahCheckbox(
                  "R",
                  'residu', 
                  AppColors.black.normal,
                  AppColors.black.light,
                ),
              ],
            ),
            if (_showUploadButton) ...[
              const SizedBox(height: 10),
              _buildUploadButton(),
            ]
          ],
        ),
      ),
    );
  }
}