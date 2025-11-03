import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart'; 
import '../../../../core/presentation/utils/app_colors.dart';

class ChecklistCardWidget extends StatefulWidget {
  final Map<String, dynamic> dataRumah;
  final Function(String jenisSampah, bool newValue) onSampahChanged;
  final Function(bool isUploaded) onFotoUploadChanged;
  const ChecklistCardWidget({
    super.key,
    required this.dataRumah,
    required this.onSampahChanged,
    required this.onFotoUploadChanged,
  });
  @override
  State<ChecklistCardWidget> createState() => _ChecklistCardWidgetState();
}

class _ChecklistCardWidgetState extends State<ChecklistCardWidget>
    with TickerProviderStateMixin {
  late Map<String, bool> _sampahStatus;
  late bool _isFotoUploaded;
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  bool _showUploadButton = false;
  AnimationController? _lottieSuccessController;

  final List<Map<String, dynamic>> _sampahConfigs = const [
    {
      'label': "Mudah Terurai",
      'initial': "MT",
      'key': 'mudah_terurai',
      'color': AppColors.green,
    },
    {
      'label': "B3",
      'initial': "B3",
      'key': 'b3',
      'color': AppColors.red,
    },
    {
      'label': "Material Daur",
      'initial': "MD",
      'key': 'material_daur',
      'color': AppColors.blue,
    },
    {
      'label': "Residu",
      'initial': "R",
      'key': 'residu',
      'color': AppColors.black,
    },
  ];
  bool get _isAnySampahChecked {
    return _sampahStatus.values.any((isChecked) => isChecked == true);
  }

  @override
  void initState() {
    super.initState();
    final sampahData = widget.dataRumah['sampah'];
    if (sampahData is Map) {
      _sampahStatus =
          sampahData.map((key, value) => MapEntry(key, value is bool ? value : false));
    } else {
      _sampahStatus = {};
    }
    for (var config in _sampahConfigs) {
      _sampahStatus.putIfAbsent(config['key'], () => false);
    }
    _sampahStatus.putIfAbsent('r', () => false);
    _showUploadButton = _isAnySampahChecked;
    final fotoUploadedData = widget.dataRumah['foto_uploaded'];
    _isFotoUploaded = fotoUploadedData is bool ? fotoUploadedData : false;
  }

  void _showViewOnlyPreviewDialog(BuildContext context) {
    if (_imageFile == null) return; 
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.all(12),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.file(
                  File(_imageFile!.path), 
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                child: Text(
                  'Tutup',
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    color: AppColors.blue.normal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSavePreviewDialog(BuildContext context, XFile pickedFile) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Upload Kegiatan',
            style: TextStyle(
                fontFamily: 'InstrumentSans',
                fontWeight: FontWeight.w600,
                fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.file(
                  File(pickedFile.path), 
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                pickedFile.name, 
                style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.red.normal),
                foregroundColor: AppColors.red.normal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'BATAL',
                style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green.normal,
                foregroundColor: AppColors.white.normal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'SIMPAN',
                style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                setState(() {
                  _imageFile = pickedFile;
                  _isFotoUploaded = true;
                });
                widget.onFotoUploadChanged(true);
                _showConfirmationDialog(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Lottie.asset('assets/lottie/alert.json', repeat: false),
              ),
              Text(
                'Anda yakin?',
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pastikan data sudah benar!',
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontSize: 14,
                  color: AppColors.black.normal.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton( 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue.normal,
                    foregroundColor: AppColors.white.normal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'SUBMIT',
                    style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    // TODO: Taruh logika submit data ke API/Database di sini
                    // Contoh:
                    // await submitData(_sampahStatus, _imageFile);
                    _showSuccessDialog(context);
                  },
                ),
                const SizedBox(width: 8),
                OutlinedButton( 
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.red.normal),
                    foregroundColor: AppColors.red.normal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    setState(() {
                      _imageFile = null;
                      _isFotoUploaded = false;
                    });
                    widget.onFotoUploadChanged(false);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }
  
  void _showSuccessDialog(BuildContext context) {
    _lottieSuccessController?.dispose(); 

    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Lottie.asset(
                  'assets/lottie/success.json',
                  repeat: false,
                  onLoaded: (composition) {
                    _lottieSuccessController = AnimationController(
                      vsync: this, 
                      duration: composition.duration,
                    );
                    _lottieSuccessController!
                      ..forward().whenComplete(() {
                        Future.delayed(Duration(milliseconds: 300), () { 
                          Navigator.of(dialogContext).pop();
                          if (Navigator.of(this.context).canPop()) {
                            Navigator.of(this.context).pop(); 
                          }
                        });
                      });
                  },
                ),
              ),
              Text(
                'Berhasil!',
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Data telah berhasil disubmit.',
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontSize: 14,
                  color: AppColors.black.normal.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [],
        );
      },
    );
  }


  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white.normal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Upload Foto',
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: AppColors.black.normal,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(LucideIcons.camera, color: AppColors.blue.normal),
                title: const Text(
                  'Ambil Foto (Kamera)',
                  style: TextStyle(fontFamily: 'InstrumentSans'),
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(LucideIcons.image, color: AppColors.blue.normal),
                title: const Text(
                  'Pilih dari Galeri',
                  style: TextStyle(fontFamily: 'InstrumentSans'),
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop(); 
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_isFotoUploaded && _imageFile != null) ...[ 
                ListTile(
                  leading: Icon(LucideIcons.eye, color: AppColors.blue.normal),
                  title: Text(
                    'Lihat Foto',
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      color: AppColors.blue.normal,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop(); 
                    _showViewOnlyPreviewDialog(context);
                  },
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Kompresi gambar
        maxWidth: 1000, // Resize gambar
      );

      if (pickedFile != null && mounted) {
        _showSavePreviewDialog(context, pickedFile);
      } else {
        print("User cancelled image picking.");
      }
    } catch (e) {
      print("Error picking image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error mengambil gambar: $e')),
        );
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
                bool isCurrentlyChecked = _sampahStatus[key] ?? false;
                bool newCheckedState = !isCurrentlyChecked;
                _sampahStatus[key] = newCheckedState;
                if (!_showUploadButton && newCheckedState == true) {
                  _showUploadButton = true;
                }
              });
              widget.onSampahChanged(key, _sampahStatus[key]!);
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
    bool isUploaded = _isFotoUploaded;
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
        onTap: () {
          _showImageSourceActionSheet(context);
        },
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
                        widget.dataRumah['nama'] ?? 'Nama Tidak Ada',
                        style: const TextStyle(
                          fontFamily: 'InstrumentSans',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.dataRumah['alamat'] ?? 'Alamat Tidak Ada',
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
                    "RT ${widget.dataRumah['rt'] ?? '??'}",
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
                  'r', 
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

  @override
  void dispose() {
    _lottieSuccessController?.dispose();
    super.dispose();
  }
}

