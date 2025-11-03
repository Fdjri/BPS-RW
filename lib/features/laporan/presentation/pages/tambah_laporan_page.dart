import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart'; 
import 'dart:io';
import '../../../../core/presentation/utils/app_colors.dart';
import 'package:lottie/lottie.dart';

class DokumentasiData {
  String? keterangan;
  DateTime? tanggalPelaksanaan;
  String? pelaksanaKegiatan;
  bool isPhotoUploaded;
  XFile? pickedImage; 

  DokumentasiData({
    this.keterangan,
    this.tanggalPelaksanaan,
    this.pelaksanaKegiatan,
    this.isPhotoUploaded = false,
    this.pickedImage, 
  });
}

class TambahLaporanPage extends StatefulWidget {
  const TambahLaporanPage({super.key});

  @override
  State<TambahLaporanPage> createState() => _TambahLaporanPageState();
}

class _TambahLaporanPageState extends State<TambahLaporanPage> {
  final _formKey = GlobalKey<FormState>();
  final DateFormat _dateFormat = DateFormat('dd MMMM yyyy', 'id');
  String? _selectedBulan = 'September';
  String? _selectedTahun = '2025';
  final TextEditingController _jumlahRumahController =
      TextEditingController(text: '0');
  final List<String> _bulanOptions = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];
  final List<String> _tahunOptions = ['2025', '2024', '2023'];
  final List<DokumentasiData> _dokumentasiList = [
    DokumentasiData(tanggalPelaksanaan: DateTime.now()),
    DokumentasiData(),
  ];

  final ImagePicker _picker = ImagePicker(); 

  @override
  void dispose() {
    _jumlahRumahController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, DokumentasiData data) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: data.tanggalPelaksanaan ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.blue.normal,
            colorScheme: ColorScheme.light(primary: AppColors.blue.normal),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            textTheme: Theme.of(context).textTheme.copyWith(
                  headlineSmall: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontFamily: 'InstrumentSans'),
                  titleLarge: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontFamily: 'InstrumentSans'),
                  bodyLarge: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontFamily: 'InstrumentSans'),
                  labelLarge: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontFamily: 'InstrumentSans'),
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != data.tanggalPelaksanaan) {
      setState(() {
        data.tanggalPelaksanaan = picked;
      });
    }
  }

  Future<void> _pickImage(DokumentasiData data, ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800, // Atur max width agar file tidak terlalu besar
        maxHeight: 800, // Atur max height
        imageQuality: 70, // Kompresi kualitas gambar
      );

      if (image != null) {
        // Cek ukuran file (contoh: maks 600KB)
        final int fileSize = await image.length();
        if (fileSize > 600 * 1024) { // 600KB
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ukuran file terlalu besar! Maksimal 600KB.'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return; 
        }

        setState(() {
          data.pickedImage = image;
          data.isPhotoUploaded = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gambar dipilih: ${image.name}')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pemilihan gambar dibatalkan.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saat memilih gambar: $e')),
        );
      }
    }
  }

  void _showPreviewImage(XFile imageFile) {
    Navigator.pop(context); 
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: const EdgeInsets.all(10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(imageFile.path),
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Tutup',
                style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    color: AppColors.blue.normal),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showImageSourceModal(DokumentasiData data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white.normal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        // Jika belum ada gambar
        if (data.pickedImage == null) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pilih Sumber Gambar',
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.black.normal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading:
                        Icon(LucideIcons.camera, color: AppColors.blue.normal),
                    title: Text(
                      'Kamera',
                      style: TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontSize: 16,
                        color: AppColors.black.normal,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(data, ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading:
                        Icon(LucideIcons.image, color: AppColors.blue.normal),
                    title: Text(
                      'Galeri',
                      style: TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontSize: 16,
                        color: AppColors.black.normal,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(data, ImageSource.gallery);
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        }
        else {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Opsi Gambar',
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.black.normal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Icon(LucideIcons.eye, color: AppColors.blue.normal),
                    title: Text(
                      'Lihat Gambar',
                      style: TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontSize: 16,
                        color: AppColors.black.normal,
                      ),
                    ),
                    onTap: () => _showPreviewImage(data.pickedImage!),
                  ),
                  ListTile(
                    leading:
                        Icon(LucideIcons.camera, color: AppColors.black.lightActive),
                    title: Text(
                      'Ganti via Kamera',
                      style: TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontSize: 16,
                        color: AppColors.black.normal,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(data, ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading:
                        Icon(LucideIcons.image, color: AppColors.black.lightActive),
                    title: Text(
                      'Ganti via Galeri',
                      style: TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontSize: 16,
                        color: AppColors.black.normal,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(data, ImageSource.gallery);
                    },
                  ),
                  ListTile(
                    leading:
                        Icon(LucideIcons.trash2, color: AppColors.red.normal),
                    title: Text(
                      'Hapus Gambar',
                      style: TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontSize: 16,
                        color: AppColors.red.normal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        data.pickedImage = null;
                        data.isPhotoUploaded = false;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Gambar berhasil dihapus.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white.normal,
      appBar: AppBar(
        backgroundColor: AppColors.white.normal,
        elevation: 0,
        title: Text(
          'Tambah Laporan RW',
          style: TextStyle(
            fontFamily: 'InstrumentSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.black.normal,
          ),
        ),
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: AppColors.black.normal),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Informasi Laporan', AppColors.black.normal),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildFilterButton(
                      title: 'Bulan',
                      value: _selectedBulan,
                      onTap: () => _showFilterOptions(
                        context,
                        title: "Pilih Bulan",
                        options: _bulanOptions,
                        currentValue: _selectedBulan,
                        onSelect: (newValue) =>
                            setState(() => _selectedBulan = newValue),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildFilterButton(
                      title: 'Tahun',
                      value: _selectedTahun,
                      onTap: () => _showFilterOptions(
                        context,
                        title: "Pilih Tahun",
                        options: _tahunOptions,
                        currentValue: _selectedTahun,
                        onSelect: (newValue) =>
                            setState(() => _selectedTahun = newValue),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _jumlahRumahController,
                labelText: 'Jumlah Rumah yang Memilah',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 32),
              ..._dokumentasiList.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: _buildDokumentasiSection(index + 1, data),
                );
              }).toList(),
              _buildReminderBox(),
              const SizedBox(height: 32),
              _buildActionButtons(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'InstrumentSans',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    String? hintText,
    bool readOnly = false,
    VoidCallback? onTap,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      style: TextStyle(
        fontFamily: 'InstrumentSans',
        color: AppColors.black.normal,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: onTap != null
            ? Icon(LucideIcons.calendar, color: AppColors.black.lightActive)
            : null,
        labelStyle: TextStyle(
          fontFamily: 'InstrumentSans',
          color: AppColors.black.lightActive,
        ),
        hintStyle: TextStyle(
          fontFamily: 'InstrumentSans',
          color: AppColors.black.lightActive.withOpacity(0.5),
        ),
        filled: true,
        fillColor: AppColors.white.normal,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.black.light, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.black.light, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.blue.normal, width: 2.0),
        ),
      ),
    );
  }

  Widget _buildFilterButton({
    required String title,
    required String? value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'InstrumentSans',
            fontSize: 12,
            color: AppColors.black.lightActive,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white.normal,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.black.light, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value ?? title,
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(LucideIcons.chevronDown,
                    color: AppColors.black.lightActive, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showFilterOptions(
    BuildContext context, {
    required String title,
    required List<String> options,
    required String? currentValue,
    required Function(String) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white.normal,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black.normal,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length > 8 ? 8 : options.length,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = options[index];
                    final isSelected = item == currentValue;
                    return InkWell(
                      onTap: () {
                        onSelect(item);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontFamily: 'InstrumentSans',
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? AppColors.blue.dark
                                      : AppColors.black.normal,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                LucideIcons.check,
                                color: AppColors.blue.dark,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDokumentasiSection(int number, DokumentasiData data) {
    final TextEditingController dateController = TextEditingController(
      text: data.tanggalPelaksanaan != null
          ? _dateFormat.format(data.tanggalPelaksanaan!)
          : '',
    );

    // Tentukan teks untuk tombol
    String buttonText = 'Pilih Foto';
    if (data.pickedImage != null) {
      String name = data.pickedImage!.name;
      buttonText = name.length > 25 ? '${name.substring(0, 22)}...' : name;
    } else if (data.isPhotoUploaded) {
      buttonText = 'Foto Terupload';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
            'Dokumentasi Kegiatan $number', AppColors.black.normal),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.blue.light.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.blue.normal.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upload Foto Dokumentasi',
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black.normal,
                    ),
                  ),
                  Text(
                    '(Max. 600KB)',
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontSize: 12,
                      color: AppColors.red.normal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: Icon(LucideIcons.image,
                    size: 18, color: AppColors.white.normal),
                label: Text(
                  buttonText, 
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    fontWeight: FontWeight.bold,
                    color: AppColors.white.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: () {
                  _showImageSourceModal(data); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: data.isPhotoUploaded
                      ? AppColors.green.normal
                      : AppColors.blue.dark,
                  foregroundColor: AppColors.white.normal,
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildInputField(
          controller: TextEditingController(text: data.keterangan),
          labelText: 'Keterangan Kegiatan',
          hintText: 'Masukkan keterangan kegiatan...',
          maxLines: 4,
          onChanged: (value) => data.keterangan = value,
        ),
        const SizedBox(height: 16),
        _buildInputField(
          controller: dateController,
          labelText: 'Tanggal Pelaksanaan Kegiatan',
          hintText: 'Contoh: 15 Oktober 2025',
          readOnly: true,
          onTap: () => _selectDate(context, data),
        ),
        const SizedBox(height: 16),
        _buildInputField(
          controller: TextEditingController(text: data.pelaksanaKegiatan),
          labelText: 'Pelaksana Kegiatan',
          onChanged: (value) =>
              data.pelaksanaKegiatan = value,
        ),
      ],
    );
  }

  Widget _buildReminderBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.blue.light.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.blue.lightActive),
      ),
      child: Text(
        'Lengkapi keterangan foto dalam kolom keterangan, tanggal, dan pelaksana kegiatan diatas.',
        style: TextStyle(
          fontFamily: 'InstrumentSans',
          fontSize: 13,
          color: AppColors.black.normal.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red.normal,
              foregroundColor: AppColors.white.normal,
              minimumSize: const Size(0, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 0,
            ),
            child: Text(
              'BATAL',
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                fontWeight: FontWeight.bold,
                color: AppColors.white.normal,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // TODO: Nanti di sini, kirim _dokumentasiList
              // yang berisi data.pickedImage ke BLoC/Use Case
              _showSuccessModal(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green.normal,
              foregroundColor: AppColors.white.normal,
              minimumSize: const Size(0, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 0,
            ),
            child: Text(
              'TAMBAH',
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                fontWeight: FontWeight.bold,
                color: AppColors.white.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Lottie.asset(
                  'assets/lottie/success.json',
                  width: 120,
                  height: 120,
                  repeat: false,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Berhasil Disimpan!',
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black.normal,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Data berhasil terkirim.',
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
}

