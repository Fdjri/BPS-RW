import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:lottie/lottie.dart'; 
import 'dart:async'; 
import '../../../../core/presentation/utils/app_colors.dart';
import '../blocs/edit_rumah/edit_rumah_cubit.dart';
import '../blocs/edit_rumah/edit_rumah_state.dart';
import '../../domain/entities/data_rumah.dart'; 

class EditRumahPage extends StatefulWidget {
  const EditRumahPage({
    super.key, 
    required this.dataRumah, 
    required this.allRtOptions, 
  });

  final DataRumah dataRumah;
  final List<String> allRtOptions;

  @override
  State<EditRumahPage> createState() => _EditRumahPageState();
}

class _EditRumahPageState extends State<EditRumahPage> {
  late TextEditingController _namaController;
  late TextEditingController _alamatController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.dataRumah.nama);
    _alamatController = TextEditingController(text: widget.dataRumah.alamatDinas);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  String get _rw => widget.dataRumah.rw;
  String get _kelurahan => "GROGOL"; 
  String get _kecamatan => "GROGOL PETAMBURAN"; 
  String get _kota => "KOTA ADM. JAKARTA BARAT"; 
  bool get _statusAktif => widget.dataRumah.statusAktif;
  bool get _statusChecklist => widget.dataRumah.statusChecklist;

  Future<void> _onSavePressed(BuildContext context) async {
    context.read<EditRumahCubit>().saveChanges();
  }

  Future<void> _showAnimatedDialog(String title, String message, {bool isSuccess = true}) async {
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
                isSuccess ? 'assets/lottie/success.json' : 'assets/lottie/error.json', 
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
    return BlocProvider(
      create: (context) => EditRumahCubit(
        initialData: widget.dataRumah,
        allRtOptions: widget.allRtOptions,
      ),
      child: Scaffold(
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
        body: BlocConsumer<EditRumahCubit, EditRumahState>(
          listener: (context, state) {
            if (state.status == EditRumahStatus.success) {
              _showAnimatedDialog(
                "Berhasil Disimpan!", 
                "Perubahan detail rumah telah berhasil disimpan."
              ).then((_) {
                if (mounted) {
                  Navigator.pop(context, true); 
                }
              });
            }
            if (state.status == EditRumahStatus.failure) {
              _showAnimatedDialog(
                "Gagal Menyimpan", 
                state.errorMessage ?? "Terjadi kesalahan.",
                isSuccess: false,
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
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
                              _buildDropdownRT(
                                context,
                                state.selectedRT, 
                                state.rtOptions
                              ),
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
                    _buildTextField(
                      controller: _namaController, 
                      hint: 'Masukkan nama pemilik...',
                      onChanged: (value) {
                        context.read<EditRumahCubit>().namaChanged(value);
                      }
                    ),
                    const SizedBox(height: 16),

                    _buildLabel("Alamat *"),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _alamatController, 
                      hint: 'Masukkan alamat...',
                      onChanged: (value) {
                        context.read<EditRumahCubit>().alamatChanged(value);
                      }
                    ),
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
                            onPressed: state.status == EditRumahStatus.submitting 
                              ? null 
                              : () => _onSavePressed(context), 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.green.normal,
                              foregroundColor: AppColors.white.normal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 7),
                            ),
                            child: state.status == EditRumahStatus.submitting
                              ? const SizedBox(
                                  height: 16, 
                                  width: 16, 
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                                )
                              : const Text(
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
            );
          },
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
    void Function(String)? onChanged, 
  }) {
    return TextField(
      controller: controller,
      enabled: isEnabled,
      onChanged: onChanged, 
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

  Widget _buildDropdownRT(BuildContext context, String selectedRT, List<String> rtOptions) {
    return DropdownButtonFormField<String>(
      value: selectedRT,
      items: rtOptions.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(fontFamily: 'InstrumentSans', fontSize: 14)),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          context.read<EditRumahCubit>().rtChanged(newValue);
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