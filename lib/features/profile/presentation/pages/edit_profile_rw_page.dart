import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:lottie/lottie.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/presentation/utils/app_colors.dart';
import '../widgets/profile_shared_widgets.dart';
import '../../domain/entities/profile_rw.dart';
import '../blocs/profile_rw/edit_profile_rw_cubit.dart'; 

class EditRWProfilePage extends StatelessWidget {
  final ProfileRw profileRw;

  const EditRWProfilePage({
    super.key,
    required this.profileRw,
  });

  @override
  Widget build(BuildContext context) {
    // Kita sediain EditProfileRwCubit di sini
    return BlocProvider(
      // Ganti sl<EditProfileRwCubit>() pake Service Locator (GetIt) lo
      create: (context) => EditProfileRwCubit(),
      child: Scaffold(
        backgroundColor: AppColors.white.normal,
        body: CustomScrollView(
          slivers: [
            _buildHeader(context),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  // Kirim data profile ke Form Body
                  _EditRWProfileForm(profileRw: profileRw),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    // ... (Kode _buildHeader lo tetep sama, cuma perlu 'context' buat pop)
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
}

class _EditRWProfileForm extends StatefulWidget {
  final ProfileRw profileRw;
  const _EditRWProfileForm({required this.profileRw});

  @override
  State<_EditRWProfileForm> createState() => _EditRWProfileFormState();
}

class _EditRWProfileFormState extends State<_EditRWProfileForm> {
  final _formKey = GlobalKey<FormState>();
  PlatformFile? _pickedFile;
  String? _selectedFileName;

  late final TextEditingController _namaKetuaRWController;
  late final TextEditingController _noHPKetuaRWController;
  late final TextEditingController _jumlahKKController;
  late final TextEditingController _jumlahRumahController;
  late final TextEditingController _jumlahRTController;
  late final TextEditingController _luasRWController;
  late final TextEditingController _jumlahJiwaController;
  late final TextEditingController _timbulanSampahController;
  late final TextEditingController _kotaKabupatenController;
  late final TextEditingController _kecamatanController;
  late final TextEditingController _kelurahanController;
  late final TextEditingController _rwController;
  late final TextEditingController _noSKRWController;

  @override
  void initState() {
    super.initState();
    final data = widget.profileRw;
    _namaKetuaRWController = TextEditingController(text: data.namaKetuaRW);
    _noHPKetuaRWController = TextEditingController(text: data.noHPKetuaRW);
    _jumlahKKController = TextEditingController(text: data.jumlahKK.toString());
    _jumlahRumahController = TextEditingController(text: data.jumlahRumah.toString());
    _jumlahRTController = TextEditingController(text: data.jumlahRT.toString());
    _luasRWController = TextEditingController(text: data.luasRW.toString().replaceAll('.', ','));
    _jumlahJiwaController = TextEditingController(text: data.jumlahJiwa.toString());
    _timbulanSampahController = TextEditingController(text: data.timbulanSampah.toString().replaceAll('.', ','));
    _kotaKabupatenController = TextEditingController(text: data.kotaKabupaten);
    _kecamatanController = TextEditingController(text: data.kecamatan);
    _kelurahanController = TextEditingController(text: data.kelurahan);
    _rwController = TextEditingController(text: data.rw.toString());
    _noSKRWController = TextEditingController(text: data.noSKRW);
    _selectedFileName = data.skFileUrl?.split('/').last; 
  }

  @override
  void dispose() {
    _namaKetuaRWController.dispose();
    _noHPKetuaRWController.dispose();
    _jumlahKKController.dispose();
    _jumlahRumahController.dispose();
    _jumlahRTController.dispose();
    _luasRWController.dispose();
    _jumlahJiwaController.dispose();
    _timbulanSampahController.dispose();
    _kotaKabupatenController.dispose();
    _kecamatanController.dispose();
    _kelurahanController.dispose();
    _rwController.dispose();
    _noSKRWController.dispose();
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
          _selectedFileName = _pickedFile?.name; 
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
            const SizedBox(height: 80.0),
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
          controller: _namaKetuaRWController, 
          validator: (value) =>
              value!.isEmpty ? 'Nama Ketua RW tidak boleh kosong' : null,
        ),
        _buildEditableTextField(
          label: 'Nomor Handphone Ketua RW',
          controller: _noHPKetuaRWController, 
          keyboardType: TextInputType.phone,
          validator: (value) =>
              value!.isEmpty ? 'Nomor HP tidak boleh kosong' : null,
        ),
        const SizedBox(height: 24.0),
        buildSectionTitle('Data Wilayah'),
        _buildTwoColumnEditableData(
          label1: 'Jumlah KK',
          controller1: _jumlahKKController, 
          label2: 'Jumlah Rumah',
          controller2: _jumlahRumahController, 
          keyboardType: TextInputType.number,
        ),
        _buildTwoColumnEditableData(
          label1: 'Jumlah RT',
          controller1: _jumlahRTController, 
          label2: 'Luas RW (m²)',
          controller2: _luasRWController, 
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
        _buildTwoColumnEditableData(
          label1: 'Jumlah Jiwa',
          controller1: _jumlahJiwaController, 
          label2: 'Timbulan Sampah per Hari (Kg)',
          controller2: _timbulanSampahController, 
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 24.0),
        buildSectionTitle('Alamat Administratif'),
        _buildEditableTextField(
          label: 'Kota/Kabupaten',
          controller: _kotaKabupatenController, 
        ),
        _buildEditableTextField(
          label: 'Kecamatan',
          controller: _kecamatanController, 
        ),
        _buildTwoColumnEditableData(
          label1: 'Kelurahan',
          controller1: _kelurahanController, 
          label2: 'RW',
          controller2: _rwController, 
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24.0),
        buildSectionTitle('Dokumen SK RW'),
        _buildEditableTextField(
          label: 'NO SK RW',
          controller: _noSKRWController, 
        ),
        _buildFileUploadField(),
      ],
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

  Widget _buildTwoColumnEditableData({
    required String label1,
    required TextEditingController controller1, 
    required String label2,
    required TextEditingController controller2, 
    TextInputType keyboardType = TextInputType.text,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildEditableTextField(
              label: label1,
              controller: controller1,
              keyboardType: keyboardType,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildEditableTextField(
              label: label2,
              controller: controller2,
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
              _selectedFileName ?? 'No File Chosen', 
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: _selectedFileName != null
                    ? AppColors.black.darker
                    : AppColors.black.darker.withOpacity(0.6),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildActionButtons() {
    return BlocConsumer<EditProfileRwCubit, EditProfileRwState>(
      listener: (context, state) {
        if (state is EditProfileRwSuccess) {
          _showSuccessAnimation();
        }
        if (state is EditProfileRwError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal Menyimpan: ${state.message}'),
              backgroundColor: AppColors.red.normal,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is EditProfileRwLoading;

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
                    final updatedProfile = widget.profileRw.copyWith(
                      namaKetuaRW: _namaKetuaRWController.text,
                      noHPKetuaRW: _noHPKetuaRWController.text,
                      jumlahKK: int.tryParse(_jumlahKKController.text) ?? 0,
                      jumlahRumah: int.tryParse(_jumlahRumahController.text) ?? 0,
                      jumlahRT: int.tryParse(_jumlahRTController.text) ?? 0,
                      luasRW: double.tryParse(_luasRWController.text.replaceAll(',', '.')) ?? 0.0,
                      jumlahJiwa: int.tryParse(_jumlahJiwaController.text) ?? 0,
                      timbulanSampah: double.tryParse(_timbulanSampahController.text.replaceAll('.', '').replaceAll(',', '.')) ?? 0.0,
                      kotaKabupaten: _kotaKabupatenController.text,
                      kecamatan: _kecamatanController.text,
                      kelurahan: _kelurahanController.text,
                      rw: int.tryParse(_rwController.text) ?? 0,
                      noSKRW: _noSKRWController.text,
                    );
                    context.read<EditProfileRwCubit>().submitProfile(
                          updatedProfile: updatedProfile,
                          newSkFile: _pickedFile,
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
