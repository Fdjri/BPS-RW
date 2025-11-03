import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:lottie/lottie.dart'; 
import 'dart:async'; 
import '../../../../core/presentation/utils/app_colors.dart';

class EditRumahPage extends StatefulWidget {
  const EditRumahPage({super.key, required this.dataRumah});

  final Map<String, dynamic> dataRumah;

  @override
  State<EditRumahPage> createState() => _EditRumahPageState();
}

class _EditRumahPageState extends State<EditRumahPage> {
  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  
  late String _selectedRT;
  final List<String> _rtOptions = ['099', '100', '101']; 

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.dataRumah['nama'] ?? '');
    _alamatController = TextEditingController(text: widget.dataRumah['alamat_dinas'] ?? '');
    _selectedRT = widget.dataRumah['rt'] ?? _rtOptions[0]; 

    if (!_rtOptions.contains(_selectedRT)) {
      _rtOptions.insert(0, _selectedRT);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  String get _rw => widget.dataRumah['rw'] ?? 'N/A';
  String get _kelurahan => "GROGOL"; 
  String get _kecamatan => "GROGOL PETAMBURAN"; 
  String get _kota => "KOTA ADM. JAKARTA BARAT"; 
  bool get _statusAktif => widget.dataRumah['status_aktif'] ?? false;
  bool get _statusChecklist => widget.dataRumah['status_checklist'] ?? false;

  Future<void> _onSavePressed() async {
    print("Saving data...");
    print("RT: $_selectedRT");
    print("Nama: ${_namaController.text}");
    print("Alamat: ${_alamatController.text}");
    
    await _showAnimatedDialog(
      "Berhasil Disimpan!", 
      "Perubahan detail rumah telah berhasil disimpan (dummy)."
    );

    if (mounted) {
       Navigator.pop(context);
    }
  }

  Future<void> _showAnimatedDialog(String title, String message) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Timer(const Duration(milliseconds: 2500), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/success.json', 
                width: 120,
                height: 120,
                repeat: false,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontSize: 14,
                  color: AppColors.black.lightActive,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white.normal,
      appBar: AppBar(
        title: const Text(
          'Edit Detail Rumah',
          style: TextStyle(
            fontFamily: 'InstrumentSans',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.blue.normal,
        foregroundColor: AppColors.white.normal,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
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
                        _buildLabel("No RT *"),
                        const SizedBox(height: 8),
                        _buildDropdownRT(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("No RW"),
                        const SizedBox(height: 8),
                        _buildReadOnlyField(_rw),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildLabel("Nama Pemilik Rumah"),
              const SizedBox(height: 8),
              _buildTextField(controller: _namaController, hint: 'Masukkan nama pemilik...'),
              const SizedBox(height: 16),

              _buildLabel("Alamat *"),
              const SizedBox(height: 8),
              _buildTextField(controller: _alamatController, hint: 'Masukkan alamat...'),
              const SizedBox(height: 24),

              Divider(color: AppColors.black.light),
              const SizedBox(height: 16),

              _buildLabel("Detail Lokasi"),
              const SizedBox(height: 12),
              _buildReadOnlyField(_kelurahan, label: "Kelurahan"),
              const SizedBox(height: 12),
              _buildReadOnlyField(_kecamatan, label: "Kecamatan"),
              const SizedBox(height: 12),
              _buildReadOnlyField(_kota, label: "Kota/Kabupaten"),
              const SizedBox(height: 24),

              Divider(color: AppColors.black.light),
              const SizedBox(height: 16),


              _buildLabel("Status Saat Ini"),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStatusChip(
                    "Aktif",
                    _statusAktif ? LucideIcons.checkCircle2 : LucideIcons.xCircle,
                    _statusAktif ? AppColors.green.dark : AppColors.red.normal,
                    _statusAktif ? AppColors.green.light : AppColors.red.light,
                  ),
                  const SizedBox(width: 12),
                   _buildStatusChip(
                    "Checklist",
                    _statusChecklist ? LucideIcons.checkCircle2 : LucideIcons.xCircle,
                    _statusChecklist ? AppColors.green.dark : AppColors.red.normal,
                    _statusChecklist ? AppColors.green.light : AppColors.red.light,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red.normal,
                        foregroundColor: AppColors.white.normal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 7),
                      ),
                      child: const Text(
                        "BATAL",
                        style: TextStyle(
                          fontFamily: 'InstrumentSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _onSavePressed, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green.normal,
                        foregroundColor: AppColors.white.normal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 7),
                      ),
                      child: const Text(
                        "SIMPAN",
                        style: TextStyle(
                          fontFamily: 'InstrumentSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'InstrumentSans',
        fontWeight: FontWeight.w500,
        color: AppColors.black.lightActive,
        fontSize: 14,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hint,
    bool isEnabled = true, 
  }) {
    return TextField(
      controller: controller,
      enabled: isEnabled,
      style: const TextStyle(
        fontFamily: 'InstrumentSans',
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'InstrumentSans',
          color: AppColors.black.normal.withOpacity(0.3),
        ),
        filled: true,
        fillColor: isEnabled
            ? AppColors.white.normal
            : AppColors.black.light.withOpacity(0.5), 
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.black.lightActive.withOpacity(0.5),
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.black.lightActive.withOpacity(0.5),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.blue.normal,
            width: 2.0,
          ),
        ),
        disabledBorder: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.black.light.withOpacity(0.8),
            width: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String value, {String? label}) {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[ 
           Text(
             label,
             style: TextStyle(
               fontFamily: 'InstrumentSans',
               fontSize: 11,
               color: AppColors.black.lightActive,
             ),
           ),
           const SizedBox(height: 4),
        ],
         Container(
           width: double.infinity,
           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
           decoration: BoxDecoration(
             color: AppColors.black.light.withOpacity(0.5),
             borderRadius: BorderRadius.circular(12),
             border: Border.all(
               color: AppColors.black.light.withOpacity(0.8),
               width: 1.0,
             ),
           ),
           child: Text(
             value.isEmpty ? '-' : value,
             style: TextStyle(
               fontFamily: 'InstrumentSans',
               fontSize: 14,
               color: AppColors.black.normal.withOpacity(0.8),
             ),
           ),
         ),
      ],
    );
  }

  Widget _buildDropdownRT() {
    return DropdownButtonFormField<String>(
      value: _selectedRT,
      items: _rtOptions.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(fontFamily: 'InstrumentSans', fontSize: 14)),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedRT = newValue;
          });
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.white.normal,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
         border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.black.lightActive.withOpacity(0.5),
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.black.lightActive.withOpacity(0.5),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.blue.normal,
            width: 2.0,
          ),
        ),
      ),
      icon: Icon(LucideIcons.chevronDown, color: AppColors.black.normal.withOpacity(0.54)),
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
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}


