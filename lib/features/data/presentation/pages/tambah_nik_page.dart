import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/presentation/utils/app_colors.dart';
import 'dart:async';
import '../blocs/tambah_nik/tambah_nik_cubit.dart';
import '../blocs/tambah_nik/tambah_nik_state.dart';
import '../../domain/entities/data_rumah.dart';

class TambahNikPage extends StatefulWidget {
  const TambahNikPage({super.key, required this.dataRumah});
  final DataRumah dataRumah;
  @override
  State<TambahNikPage> createState() => _TambahNikPageState();
}

class _TambahNikPageState extends State<TambahNikPage> {
  final _ktpController = TextEditingController();
  final _namaKepalaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _namaPemilikController = TextEditingController();
  final _rtController = TextEditingController();
  final _rwController = TextEditingController();
  final _kelurahanController = TextEditingController();
  final _kecamatanController = TextEditingController();
  final _kotaController = TextEditingController();
  final _bangunanIdController = TextEditingController();
  final _nasabahStatusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _alamatController.text = widget.dataRumah.alamatDinas;
    _rtController.text = widget.dataRumah.rt;
    _rwController.text = widget.dataRumah.rw;
    _kelurahanController.text = "GROGOL"; 
    _kecamatanController.text = "GROGOL PETAMBURAN";
    _kotaController.text = "KOTA ADM. JAKARTA BARAT";
  }

  @override
  void dispose() {
    _ktpController.dispose();
    _namaKepalaController.dispose();
    _alamatController.dispose();
    _namaPemilikController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    _kelurahanController.dispose();
    _kecamatanController.dispose();
    _kotaController.dispose();
    _bangunanIdController.dispose();
    _nasabahStatusController.dispose();
    super.dispose();
  }

  void _onCekDataPressed(BuildContext context) {
    context.read<TambahNikCubit>().cekData(_ktpController.text);
  }

  Future<void> _onSavePressed(BuildContext context) async {
    final formData = {
      "ktp": _ktpController.text,
      "namaKepala": _namaKepalaController.text,
      "alamat": _alamatController.text,
      "namaPemilik": _namaPemilikController.text,
      "rt": _rtController.text,
      "rw": _rwController.text,
      "kelurahan": _kelurahanController.text,
      "kecamatan": _kecamatanController.text,
      "kota": _kotaController.text,
      "bangunanId": _bangunanIdController.text,
      "nasabahStatus": _nasabahStatusController.text,
      "alamatDinas_id": widget.dataRumah.alamatDinas,
    };
    context.read<TambahNikCubit>().saveData(formData);
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
      create: (context) => TambahNikCubit(),
      child: Scaffold(
        backgroundColor: AppColors.white.normal, 
        appBar: AppBar(
          title: const Text(
            'Input NIK Rumah',
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
        body: BlocConsumer<TambahNikCubit, TambahNikState>(
          listener: (context, state) {
            if (state.checkStatus == TambahNikCheckStatus.success) {
              final data = state.checkedData;
              if (data != null) {
                _namaKepalaController.text = data["namaKepala"];
                _namaPemilikController.text = data["namaPemilik"];
                _bangunanIdController.text = data["bangunanId"];
                _nasabahStatusController.text = data["nasabahStatus"];
              }
            }
            if (state.checkStatus == TambahNikCheckStatus.failure) {
              _showAnimatedDialog(
                "Gagal Mencari NIK", 
                state.errorMessage ?? "Terjadi kesalahan.",
                isSuccess: false,
              );
            }
            if (state.submitStatus == TambahNikSubmitStatus.success) {
              _showAnimatedDialog(
                "Berhasil Disimpan!", 
                "Data NIK baru telah berhasil ditambahkan."
              ).then((_) {
                if (mounted) {
                  Navigator.pop(context, true); 
                }
              });
            }
            if (state.submitStatus == TambahNikSubmitStatus.failure) {
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
                    _buildLabel("No KTP"),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildTextField(
                            controller: _ktpController,
                            hint: '16 digit NIK...',
                            isEnabled: true,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: state.checkStatus == TambahNikCheckStatus.loading
                              ? null 
                              : () => _onCekDataPressed(context), 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yellow.normal,
                              foregroundColor: AppColors.black.normal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: state.checkStatus == TambahNikCheckStatus.loading
                              ? const SizedBox(
                                  height: 16, 
                                  width: 16, 
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                                )
                              : Text(
                                  "CEK DATA",
                                  style: TextStyle(
                                    color: AppColors.white.normal,
                                    fontFamily: 'InstrumentSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildLabel("Nama Kepala Rumah Tangga"),
                    const SizedBox(height: 8),
                    _buildTextField(controller: _namaKepalaController, isEnabled: true),
                    const SizedBox(height: 16),
                    _buildLabel("Alamat"),
                    const SizedBox(height: 8),
                    _buildTextField(controller: _alamatController, isEnabled: true),
                    const SizedBox(height: 16),
                    _buildLabel("Nama Pemilik KTP"),
                    const SizedBox(height: 8),
                    _buildTextField(controller: _namaPemilikController, isEnabled: true), 
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("RT"),
                              const SizedBox(height: 8),
                              _buildTextField(controller: _rtController, isEnabled: true), 
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("RW"),
                              const SizedBox(height: 8),
                              _buildTextField(controller: _rwController, isEnabled: true), 
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildLabel("Kelurahan"),
                    const SizedBox(height: 8),
                    _buildTextField(controller: _kelurahanController, isEnabled: true), 
                    const SizedBox(height: 16),
                    _buildLabel("Kecamatan"),
                    const SizedBox(height: 8),
                    _buildTextField(controller: _kecamatanController, isEnabled: true), 
                    const SizedBox(height: 16),
                    _buildLabel("Kota"),
                    const SizedBox(height: 8),
                    _buildTextField(controller: _kotaController, isEnabled: true), 
                    const SizedBox(height: 16),
                    _buildLabel("Bangunan ID"),
                    const SizedBox(height: 8),
                    _buildTextField(controller: _bangunanIdController, isEnabled: true), 
                    const SizedBox(height: 16),
                    _buildLabel("Nasabah Status"),
                    const SizedBox(height: 8),
                    _buildTextField(controller: _nasabahStatusController, isEnabled: true), 
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
                            onPressed: state.submitStatus == TambahNikSubmitStatus.loading
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
                            child: state.submitStatus == TambahNikSubmitStatus.loading
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      enabled: isEnabled,
      keyboardType: keyboardType,
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
        fillColor: isEnabled ? AppColors.white.normal : AppColors.black.light, 
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
            color: AppColors.black.lightActive.withOpacity(0.5), 
            width: 1.0,
          ),
        ),
      ),
    );
  }
}