import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/presentation/utils/app_colors.dart'; 

class SeksiData {
  String nama;
  String noWa;

  SeksiData({required this.nama, required this.noWa});
  SeksiData copyWith({String? nama, String? noWa}) {
    return SeksiData(
      nama: nama ?? this.nama,
      noWa: noWa ?? this.noWa,
    );
  }
}

class EditableBPSRWProfileData {
  SeksiData ketuaBidang;
  List<SeksiData> seksiOperasional;
  List<SeksiData> seksiSosialisasiPengawasan;
  SeksiData pjlpPendamping;
  SeksiData supervisorPendamping;

  EditableBPSRWProfileData({
    required this.ketuaBidang,
    required this.seksiOperasional,
    required this.seksiSosialisasiPengawasan,
    required this.pjlpPendamping,
    required this.supervisorPendamping,
  });

  factory EditableBPSRWProfileData.dummy() {
    return EditableBPSRWProfileData(
      ketuaBidang: SeksiData(nama: 'Adnan Silempat', noWa: '81311308969'),
      seksiOperasional: [
        SeksiData(nama: 'Jamaludin', noWa: 'Nomor WA Seksi Operasional 1'),
        SeksiData(nama: 'Triyono', noWa: 'Nomor WA Seksi Operasional 2'),
      ],
      seksiSosialisasiPengawasan: [
        SeksiData(nama: 'Juwansyah', noWa: 'No WA Seksi Sosialisasi & Pengawasan 1'),
        SeksiData(nama: 'Robi dahlan', noWa: 'No WA Seksi Sosialisasi & Pengawasan 2'),
      ],
      pjlpPendamping: SeksiData(nama: 'Rhafael Pahala', noWa: 'No WA PJLP Pendamping'),
      supervisorPendamping: SeksiData(nama: 'Muhamat Sofian', noWa: '87837822399'),
    );
  }
}

class EditBPSRWProfilePage extends StatefulWidget {
  const EditBPSRWProfilePage({super.key});

  @override
  State<EditBPSRWProfilePage> createState() => _EditBPSRWProfilePageState();
}

class _EditBPSRWProfilePageState extends State<EditBPSRWProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late EditableBPSRWProfileData _formData; 

  @override
  void initState() {
    super.initState();
    _formData = EditableBPSRWProfileData.dummy(); 
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
    return Scaffold(
      backgroundColor: AppColors.white.normal,
      body: CustomScrollView(
        slivers: [
          _buildHeader(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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

  Widget _buildProfileForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle('Ketua Bidang'),
        _buildSeksiFields(
          namaLabel: 'Nama Ketua Bidang',
          noWaLabel: 'Nomor WA Ketua Bidang',
          seksiData: _formData.ketuaBidang,
          onNamaChanged: (value) => _formData.ketuaBidang.nama = value,
          onNoWaChanged: (value) => _formData.ketuaBidang.noWa = value,
          validator: (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
        ),
        const SizedBox(height: 24.0),
        buildSectionTitle('Seksi Operasional'),
        for (int i = 0; i < _formData.seksiOperasional.length; i++) 
          _buildSeksiFields(
            namaLabel: 'Nama Seksi Operasional ${i + 1}',
            noWaLabel: 'Nomor WA Seksi Operasional ${i + 1}',
            seksiData: _formData.seksiOperasional[i],
            onNamaChanged: (value) => _formData.seksiOperasional[i].nama = value,
            onNoWaChanged: (value) => _formData.seksiOperasional[i].noWa = value,
          ),
        const SizedBox(height: 24.0),
        buildSectionTitle('Seksi Sosialisasi & Pengawasan'),
        for (int i = 0; i < _formData.seksiSosialisasiPengawasan.length; i++) 
          _buildSeksiFields(
            namaLabel: 'Nama Seksi Sosialisasi & Pengawasan ${i + 1}',
            noWaLabel: 'Nomor WA Seksi Sosialisasi & Pengawasan ${i + 1}',
            seksiData: _formData.seksiSosialisasiPengawasan[i],
            onNamaChanged: (value) => _formData.seksiSosialisasiPengawasan[i].nama = value,
            onNoWaChanged: (value) => _formData.seksiSosialisasiPengawasan[i].noWa = value,
          ),
        const SizedBox(height: 24.0),
        buildSectionTitle('Pendamping'),
        _buildSeksiFields(
          namaLabel: 'Nama PJLP Pendamping',
          noWaLabel: 'No WA PJLP Pendamping',
          seksiData: _formData.pjlpPendamping,
          onNamaChanged: (value) => _formData.pjlpPendamping.nama = value,
          onNoWaChanged: (value) => _formData.pjlpPendamping.noWa = value,
        ),
        const SizedBox(height: 24.0),
        buildSectionTitle('Supervisor Pendamping'),
        _buildSeksiFields(
          namaLabel: 'Nama Supervisor Pendamping',
          noWaLabel: 'No WA Supervisor Pendamping',
          seksiData: _formData.supervisorPendamping,
          onNamaChanged: (value) => _formData.supervisorPendamping.nama = value,
          onNoWaChanged: (value) => _formData.supervisorPendamping.noWa = value,
        ),
      ],
    );
  }

  Widget _buildSeksiFields({
    required String namaLabel,
    required String noWaLabel,
    required SeksiData seksiData,
    required Function(String) onNamaChanged,
    required Function(String) onNoWaChanged,
    String? Function(String?)? validator,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20.0),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.black.light)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEditableTextField(
              label: namaLabel,
              initialValue: seksiData.nama,
              onChanged: onNamaChanged,
              validator: validator,
            ),
            _buildEditableTextField(
              label: noWaLabel,
              initialValue: seksiData.noWa,
              onChanged: onNoWaChanged,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableTextField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
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
          initialValue: initialValue,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: TextStyle(
            fontFamily: 'InstrumentSans',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: AppColors.black.darker,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
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
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // TODO: Implement actual save logic (send data to BLoC/Use Case)
                _showSuccessAnimation();
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
            child: Text(
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
  }
}

Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        '• $title',
        style: TextStyle(
          fontFamily: 'InstrumentSans',
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: AppColors.black.normal,
        ),
      ),
    );
}
