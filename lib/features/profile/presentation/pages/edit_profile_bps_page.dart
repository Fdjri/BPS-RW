import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:lottie/lottie.dart';
import '../../../../core/presentation/utils/app_colors.dart';
import '../widgets/profile_shared_widgets.dart'; 
import '../../domain/entities/profile_bps.dart';
import '../../domain/entities/seksi_data.dart';
import '../blocs/profile_bps/edit_profile_bps_cubit.dart';

class EditBPSRWProfilePage extends StatelessWidget {
  final ProfileBps profileBps;

  const EditBPSRWProfilePage({
    super.key,
    required this.profileBps,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileBpsCubit(),
      child: Scaffold(
        backgroundColor: AppColors.white.normal,
        body: CustomScrollView(
          slivers: [
            _buildHeader(context), 
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  _EditBPSProfileForm(profileBps: profileBps),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
        decoration: BoxDecoration(
          color: AppColors.blue.normal,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.normal.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, color: AppColors.white.normal),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: AppColors.white.normal,
                  ),
                ),
                Text(
                  'Ubah Informasi Profile BPS-RW',
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.white.normal.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EditBPSProfileForm extends StatefulWidget {
  final ProfileBps profileBps;
  const _EditBPSProfileForm({required this.profileBps});

  @override
  State<_EditBPSProfileForm> createState() => _EditBPSProfileFormState();
}

class _EditBPSProfileFormState extends State<_EditBPSProfileForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _ketuaBidangNamaC;
  late final TextEditingController _ketuaBidangNoWaC;
  late final TextEditingController _pjlpNamaC;
  late final TextEditingController _pjlpNoWaC;
  late final TextEditingController _supervisorNamaC;
  late final TextEditingController _supervisorNoWaC;

  final List<TextEditingController> _seksiOpsNamaC = [];
  final List<TextEditingController> _seksiOpsNoWaC = [];
  final List<TextEditingController> _seksiSosNamaC = [];
  final List<TextEditingController> _seksiSosNoWaC = [];

  @override
  void initState() {
    super.initState();
    final data = widget.profileBps;
    _ketuaBidangNamaC = TextEditingController(text: data.ketuaBidang.nama);
    _ketuaBidangNoWaC = TextEditingController(text: data.ketuaBidang.noWA);
    _pjlpNamaC = TextEditingController(text: data.pjlpPendamping.nama);
    _pjlpNoWaC = TextEditingController(text: data.pjlpPendamping.noWA);
    _supervisorNamaC = TextEditingController(text: data.supervisorPendamping.nama);
    _supervisorNoWaC = TextEditingController(text: data.supervisorPendamping.noWA);
    for (var seksi in data.seksiOperasional) {
      _seksiOpsNamaC.add(TextEditingController(text: seksi.nama));
      _seksiOpsNoWaC.add(TextEditingController(text: seksi.noWA));
    }
    for (var seksi in data.seksiSosialisasiPengawasan) {
      _seksiSosNamaC.add(TextEditingController(text: seksi.nama));
      _seksiSosNoWaC.add(TextEditingController(text: seksi.noWA));
    }
  }

  @override
  void dispose() {
    _ketuaBidangNamaC.dispose();
    _ketuaBidangNoWaC.dispose();
    _pjlpNamaC.dispose();
    _pjlpNoWaC.dispose();
    _supervisorNamaC.dispose();
    _supervisorNoWaC.dispose();
    for (var controller in _seksiOpsNamaC) {
      controller.dispose();
    }
    for (var controller in _seksiOpsNoWaC) {
      controller.dispose();
    }
    for (var controller in _seksiSosNamaC) {
      controller.dispose();
    }
    for (var controller in _seksiSosNoWaC) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/success.json',
                repeat: false,
                width: 150,
                height: 150,
                onLoaded: (composition) {
                  Future.delayed(composition.duration, () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Profil Berhasil Disimpan!',
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: AppColors.blue.normal,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24.0),
            _buildProfileForm(),
            const SizedBox(height: 32.0),
            _buildActionButtons(),
            const SizedBox(height: 120.0),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle('Ketua Bidang'),
        _buildSeksiFields(
          namaLabel: 'Nama Ketua Bidang',
          noWaLabel: 'Nomor WA Ketua Bidang',
          namaController: _ketuaBidangNamaC,
          noWaController: _ketuaBidangNoWaC,
          validator: (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
        ),
        const SizedBox(height: 24.0),
        buildSectionTitle('Seksi Operasional'),
        for (int i = 0; i < _seksiOpsNamaC.length; i++)
          _buildSeksiFields(
            namaLabel: 'Nama Seksi Operasional ${i + 1}',
            noWaLabel: 'Nomor WA Seksi Operasional ${i + 1}',
            namaController: _seksiOpsNamaC[i],
            noWaController: _seksiOpsNoWaC[i],
          ),
        const SizedBox(height: 24.0),
        buildSectionTitle('Seksi Sosialisasi & Pengawasan'),
        for (int i = 0; i < _seksiSosNamaC.length; i++)
          _buildSeksiFields(
            namaLabel: 'Nama Seksi Sosialisasi & Pengawasan ${i + 1}',
            noWaLabel: 'Nomor WA Seksi Sosialisasi & Pengawasan ${i + 1}',
            namaController: _seksiSosNamaC[i],
            noWaController: _seksiSosNoWaC[i],
          ),
        const SizedBox(height: 24.0),
        buildSectionTitle('Pendamping'),
        _buildSeksiFields(
          namaLabel: 'Nama PJLP Pendamping',
          noWaLabel: 'No WA PJLP Pendamping',
          namaController: _pjlpNamaC,
          noWaController: _pjlpNoWaC,
        ),
        const SizedBox(height: 24.0),
        buildSectionTitle('Supervisor Pendamping'),
        _buildSeksiFields(
          namaLabel: 'Nama Supervisor Pendamping',
          noWaLabel: 'No WA Supervisor Pendamping',
          namaController: _supervisorNamaC,
          noWaController: _supervisorNoWaC,
        ),
      ],
    );
  }

  Widget _buildSeksiFields({
    required String namaLabel,
    required String noWaLabel,
    required TextEditingController namaController, 
    required TextEditingController noWaController, 
    String? Function(String?)? validator,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20.0),
      elevation: 1,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.black.light)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEditableTextField(
              label: namaLabel,
              controller: namaController,
              validator: validator,
            ),
            _buildEditableTextField(
              label: noWaLabel,
              controller: noWaController,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColors.black.darker.withOpacity(0.6),
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            fontFamily: 'InstrumentSans',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: AppColors.black.darker,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.black.light),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.black.light),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.blue.normal, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.red.normal, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.red.normal, width: 2),
            ),
          ),
          validator: validator,
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildActionButtons() {
    return BlocConsumer<EditProfileBpsCubit, EditProfileBpsState>(
      listener: (context, state) {
        if (state is EditProfileBpsSuccess) {
          _showSuccessAnimation();
        }
        if (state is EditProfileBpsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal Menyimpan: ${state.message}'),
              backgroundColor: AppColors.red.normal,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is EditProfileBpsLoading;

        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isLoading ? null : () {
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.blue.normal),
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'BATAL',
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.blue.normal,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: isLoading ? null : () {
                  if (_formKey.currentState!.validate()) {
                    final List<SeksiData> updatedOps = [];
                    for(int i=0; i < _seksiOpsNamaC.length; i++) {
                      updatedOps.add(SeksiData(
                        nama: _seksiOpsNamaC[i].text,
                        noWA: _seksiOpsNoWaC[i].text,
                      ));
                    }
                    final List<SeksiData> updatedSos = [];
                    for(int i=0; i < _seksiSosNamaC.length; i++) {
                      updatedSos.add(SeksiData(
                        nama: _seksiSosNamaC[i].text,
                        noWA: _seksiSosNoWaC[i].text,
                      ));
                    }
                    final updatedProfile = widget.profileBps.copyWith(
                      ketuaBidang: SeksiData(
                        nama: _ketuaBidangNamaC.text,
                        noWA: _ketuaBidangNoWaC.text,
                      ),
                      pjlpPendamping: SeksiData(
                        nama: _pjlpNamaC.text,
                        noWA: _pjlpNoWaC.text,
                      ),
                      supervisorPendamping: SeksiData(
                        nama: _supervisorNamaC.text,
                        noWA: _supervisorNoWaC.text,
                      ),
                      seksiOperasional: updatedOps,
                      seksiSosialisasiPengawasan: updatedSos,
                    );
                    context.read<EditProfileBpsCubit>().submitProfileBps(
                          updatedProfile: updatedProfile,
                        );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue.normal,
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? Container(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.white.normal,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'SIMPAN',
                        style: TextStyle(
                          fontFamily: 'InstrumentSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.white.normal,
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
