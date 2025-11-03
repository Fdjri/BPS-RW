import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:file_picker/file_picker.dart'; 
import '../../../../core/presentation/utils/app_colors.dart';
import '../pages/profile_page.dart';

class EditableProfileData {
  String namaKetuaRW;
  String noHPKetuaRW;
  String jumlahKK;
  String jumlahRumah;
  String jumlahRT;
  String luasRW;
  String jumlahJiwa;
  String timbulanSampah;
  String kotaKabupaten;
  String kecamatan;
  String kelurahan;
  String rw;
  String noSKRW;
  String? selectedFileName;

  EditableProfileData({
    required this.namaKetuaRW,
    required this.noHPKetuaRW,
    required this.jumlahKK,
    required this.jumlahRumah,
    required this.jumlahRT,
    required this.luasRW,
    required this.jumlahJiwa,
    required this.timbulanSampah,
    required this.kotaKabupaten,
    required this.kecamatan,
    required this.kelurahan,
    required this.rw,
    required this.noSKRW,
    this.selectedFileName,
  });

  factory EditableProfileData.dummy() {
    return EditableProfileData(
      namaKetuaRW: 'Sumarkum',
      noHPKetuaRW: '81280903773',
      jumlahKK: '812',
      jumlahRumah: '428',
      jumlahRT: '15',
      luasRW: '20,1',
      jumlahJiwa: '2383',
      timbulanSampah: '1.811,08',
      kotaKabupaten: 'KOTA ADM. JAKARTA BARAT',
      kecamatan: 'Grogol Petamburan',
      kelurahan: 'Grogol',
      rw: '7',
      noSKRW: '123',
      selectedFileName: null,
    );
  }
}

class EditRWProfilePage extends StatefulWidget {
  const EditRWProfilePage({super.key});

  @override
  State<EditRWProfilePage> createState() => _EditRWProfilePageState();
}

class _EditRWProfilePageState extends State<EditRWProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late EditableProfileData _formData;
  PlatformFile? _pickedFile; 

  @override
  void initState() {
    super.initState();
    _formData = EditableProfileData.dummy();
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

  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'], 
        allowMultiple: false, 
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _pickedFile = result.files.first; 
          _formData.selectedFileName =
              _pickedFile?.name; 
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File dipilih: ${_pickedFile?.name}')),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pemilihan file dibatalkan.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saat memilih file: $e')),
        );
      }
    }
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
                        const SizedBox(height: 80.0),
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
                  'Ubah Informasi Profile RW',
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
        buildSectionTitle('Informasi Ketua RW'),
        _buildEditableTextField(
          label: 'Nama Ketua RW',
          initialValue: _formData.namaKetuaRW,
          onChanged: (value) => _formData.namaKetuaRW = value,
          validator: (value) =>
              value!.isEmpty ? 'Nama Ketua RW tidak boleh kosong' : null,
        ),
        _buildEditableTextField(
          label: 'Nomor Handphone Ketua RW',
          initialValue: _formData.noHPKetuaRW,
          onChanged: (value) => _formData.noHPKetuaRW = value,
          keyboardType: TextInputType.phone,
          validator: (value) =>
              value!.isEmpty ? 'Nomor HP tidak boleh kosong' : null,
        ),
        const SizedBox(height: 24.0),
        buildSectionTitle('Data Wilayah'),
        _buildTwoColumnEditableData(
          label1: 'Jumlah KK',
          initialValue1: _formData.jumlahKK,
          onChanged1: (value) => _formData.jumlahKK = value,
          label2: 'Jumlah Rumah',
          initialValue2: _formData.jumlahRumah,
          onChanged2: (value) => _formData.jumlahRumah = value,
          keyboardType: TextInputType.number,
        ),
        _buildTwoColumnEditableData(
          label1: 'Jumlah RT',
          initialValue1: _formData.jumlahRT,
          onChanged1: (value) => _formData.jumlahRT = value,
          label2: 'Luas RW (m²)',
          initialValue2: _formData.luasRW,
          onChanged2: (value) => _formData.luasRW = value,
          keyboardType: TextInputType.number,
        ),
        _buildTwoColumnEditableData(
          label1: 'Jumlah Jiwa',
          initialValue1: _formData.jumlahJiwa,
          onChanged1: (value) => _formData.jumlahJiwa = value,
          label2: 'Timbulan Sampah per Hari (Kg)',
          initialValue2: _formData.timbulanSampah,
          onChanged2: (value) => _formData.timbulanSampah = value,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24.0),
        buildSectionTitle('Alamat Administratif'),
        _buildEditableTextField(
          label: 'Kota/Kabupaten',
          initialValue: _formData.kotaKabupaten,
          onChanged: (value) => _formData.kotaKabupaten = value,
        ),
        _buildEditableTextField(
          label: 'Kecamatan',
          initialValue: _formData.kecamatan,
          onChanged: (value) => _formData.kecamatan = value,
        ),
        _buildTwoColumnEditableData(
          label1: 'Kelurahan',
          initialValue1: _formData.kelurahan,
          onChanged1: (value) => _formData.kelurahan = value,
          label2: 'RW',
          initialValue2: _formData.rw,
          onChanged2: (value) => _formData.rw = value,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24.0),
        buildSectionTitle('Dokumen SK RW'),
        _buildEditableTextField(
          label: 'NO SK RW',
          initialValue: _formData.noSKRW,
          onChanged: (value) => _formData.noSKRW = value,
        ),
        _buildFileUploadField(),
      ],
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

  Widget _buildTwoColumnEditableData({
    required String label1,
    required String initialValue1,
    required Function(String) onChanged1,
    required String label2,
    required String initialValue2,
    required Function(String) onChanged2,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildEditableTextField(
              label: label1,
              initialValue: initialValue1,
              onChanged: onChanged1,
              keyboardType: keyboardType,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildEditableTextField(
              label: label2,
              initialValue: initialValue2,
              onChanged: onChanged2,
              keyboardType: keyboardType,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileUploadField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Upload File SK (hanya PDF)',
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColors.black.darker.withOpacity(0.6),
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white.normal,
              border: Border.all(color: AppColors.black.light),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _formData.selectedFileName ?? 'No File Chosen', 
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: _formData.selectedFileName != null
                    ? AppColors.black.darker
                    : AppColors.black.darker.withOpacity(0.6),
              ),
            ),
          ),
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
                // Nanti di sini, kita bisa kirim _formData dan _pickedFile
                // Contoh:
                // context.read<ProfileBloc>().add(
                //   UpdateProfileEvent(
                //     profileData: _formData,
                //     file: _pickedFile, // <-- Kirim filenya!
                //   ),
                // );
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
