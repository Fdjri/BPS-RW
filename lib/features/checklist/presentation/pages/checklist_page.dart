import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:flutter_image_compress/flutter_image_compress.dart'; 
import '../../../../core/presentation/utils/app_colors.dart';
import '../../../../core/presentation/widgets/custom_bottom_navbar.dart';
import '../widgets/menu_drawer_widget.dart';
import '../widgets/card_widget.dart'; 
import 'package:bps_rw/features/laporan/presentation/pages/laporan_page.dart';
import 'package:bps_rw/features/profile/presentation/pages/profile_page.dart';
import 'package:bps_rw/features/data/presentation/pages/data_page.dart';
import '../blocs/checklist/checklist_input_cubit.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});
  static const String routeName = '/checklist';

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> with TickerProviderStateMixin { 
  
  final ImagePicker _picker = ImagePicker();
  AnimationController? _lottieSuccessController;
  AnimationController? _lottieSuccessTotalController;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id', null);
  }

  void _showImageSourceActionSheet(BuildContext context, String rumahId) {
    final cubit = context.read<ChecklistInputCubit>();

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
                  _pickAndCompressImage(ImageSource.camera, context, rumahId, cubit);
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
                  _pickAndCompressImage(ImageSource.gallery, context, rumahId, cubit);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickAndCompressImage(ImageSource source, BuildContext context, String rumahId, ChecklistInputCubit cubit) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70, 
        maxWidth: 1000, 
      );
      if (pickedFile == null) return;
      final fileBytes = await pickedFile.readAsBytes();
      final result = await FlutterImageCompress.compressWithList(
        fileBytes,
        minHeight: 800,
        minWidth: 800,
        quality: 70,
      );
      final tempDir = Directory.systemTemp;
      final targetPath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      File compressedFile = await File(targetPath).writeAsBytes(result);
      double fileSizeInKB = await compressedFile.length() / 1024;
      if (fileSizeInKB > 200) {
        final resultLagi = await FlutterImageCompress.compressWithList(
          result,
          minHeight: 600,
          minWidth: 600,
          quality: 50, 
        );
        compressedFile = await File(targetPath).writeAsBytes(resultLagi);
        fileSizeInKB = await compressedFile.length() / 1024;
      }

      if (mounted) {
        final bool? isSaved = await _showSavePreviewDialog(context, compressedFile, fileSizeInKB);
        if (isSaved == true) {
          final bool? isConfirmed = await _showConfirmationDialog(context);
          if (isConfirmed == true && context.mounted) {
            cubit.submitFoto(rumahId, compressedFile);
          }
        } else if (isSaved == null) {
          _pickAndCompressImage(source, context, rumahId, context.read<ChecklistInputCubit>()); 
        }
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
  
  Future<bool?> _showSavePreviewDialog(BuildContext context, File compressedFile, double fileSizeInKB) {
    return showDialog<bool?>(
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
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              InkWell(
                onTap: () {
                  _showFullscreenImageDialog(context, compressedFile);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.file(
                    compressedFile, 
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${fileSizeInKB.toStringAsFixed(1)} KB",
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: fileSizeInKB > 200 ? AppColors.red.normal : AppColors.green.dark,
                ),
                textAlign: TextAlign.center, 
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            Wrap(
              alignment: WrapAlignment.center, 
              spacing: 8.0, 
              runSpacing: 8.0,
              children: [
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
                    Navigator.of(dialogContext).pop(false); 
                  },
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.blue.normal),
                    foregroundColor: AppColors.blue.normal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'GANTI',
                    style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(null); 
                  },
                ),
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
                    Navigator.of(dialogContext).pop(true); 
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _showFullscreenImageDialog(BuildContext context, File imageFile) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InteractiveViewer(
                child: Image.file(imageFile),
              ),
              const SizedBox(height: 12),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.8)
                ),
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

  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
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
                    Navigator.of(dialogContext).pop(false); 
                  },
                ),
                const SizedBox(width: 8),
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
                    Navigator.of(dialogContext).pop(true); 
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }
  
  void _showPhotoSubmitSuccessDialog(BuildContext context) {
    _lottieSuccessController?.dispose(); 
    _lottieSuccessController = AnimationController(vsync: this);
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
                  controller: _lottieSuccessController,
                  onLoaded: (composition) {
                    _lottieSuccessController!
                      ..duration = composition.duration
                      ..forward().whenComplete(() {
                        Future.delayed(Duration(milliseconds: 300), () { 
                          Navigator.of(dialogContext).pop();
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
                'Foto telah berhasil disubmit.',
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
  
  @override
  void dispose() {
    _lottieSuccessController?.dispose(); 
    _lottieSuccessTotalController?.dispose();
    super.dispose();
  }

  Future<Map<String, String>?> _showWeightInputDialog(BuildContext context) {
    final String todayDate =
        DateFormat('EEEE, d MMMM yyyy', 'id').format(DateTime.now());
    final _mtController = TextEditingController(text: '0');
    final _mdController = TextEditingController(text: '0');
    final _residuController = TextEditingController(text: '0');
    final _b3Controller = TextEditingController(text: '0');
    return showDialog<Map<String, String>?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          actionsPadding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          title: Text(
            'Data Sampah RW 7 : $todayDate',
            style: const TextStyle(
              fontFamily: 'InstrumentSans',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                        child: _buildWeightTextField(
                            'Mudah Terurai (kg)', _mtController)),
                    const SizedBox(width: 16),
                    Expanded(
                        child: _buildWeightTextField(
                            'Material Daur (kg)', _mdController)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: _buildWeightTextField(
                            'Residu (kg)', _residuController)),
                    const SizedBox(width: 16),
                    Expanded(
                        child: _buildWeightTextField(
                            'E-waste/B3 (kg)', _b3Controller)),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.red.normal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'BATAL',
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  color: AppColors.white.normal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(null);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.green.normal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'SIMPAN',
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  color: AppColors.white.normal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                // Kirim data Map-nya
                final dataBerat = {
                  'mudah_terurai': _mtController.text,
                  'material_daur': _mdController.text,
                  'residu': _residuController.text,
                  'b3': _b3Controller.text,
                };
                Navigator.of(dialogContext).pop(dataBerat);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeightTextField(
      String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'InstrumentSans',
            fontSize: 12,
            color: AppColors.black.normal.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          style: const TextStyle(fontFamily: 'InstrumentSans', fontSize: 14),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: true,
            fillColor: AppColors.white.normal,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.black.lightActive),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.black.lightActive),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.blue.normal, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
  
  void _showSuccessAnimation(BuildContext context) {
    _lottieSuccessTotalController?.dispose();
    _lottieSuccessTotalController = AnimationController(vsync: this);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/success.json',
                repeat: false,
                width: 150,
                height: 150,
                controller: _lottieSuccessTotalController,
                onLoaded: (composition) {
                  _lottieSuccessTotalController!
                    ..duration = composition.duration
                    ..forward().whenComplete(() {
                      Future.delayed(composition.duration, () {
                        Navigator.of(context).pop();
                      });
                    });
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Data Berhasil Dikirim!',
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
    final String todayDate =
        DateFormat('EEEE, d MMMM yyyy', 'id').format(DateTime.now());
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return BlocProvider(
      create: (context) => ChecklistInputCubit()..fetchListRumah(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.white.normal,
        drawer: const ChecklistMenuDrawerWidget(
            activeRoute: ChecklistPage.routeName),
        bottomNavigationBar: CustomBottomNavbar(
          selectedIndex: 2,
          onItemTapped: (index) {
            if (index == 0) Navigator.pushReplacementNamed(context, '/home');
            if (index == 1)
              Navigator.pushReplacementNamed(context, DataPage.routeName);
            if (index == 2) {}
            if (index == 3)
              Navigator.pushReplacementNamed(context, LaporanPage.routeName);
            if (index == 4)
              Navigator.pushReplacementNamed(context, ProfilePage.routeName);
          },
        ),
        body: _ChecklistBody(
          scaffoldKey: _scaffoldKey,
          todayDate: todayDate,
          onShowImagePicker: (sheetContext, rumahId) {
            _showImageSourceActionSheet(sheetContext, rumahId);
          },
          onShowPhotoSubmitSuccess: () {
            _showPhotoSubmitSuccessDialog(context);
          },
          onShowWeightDialog: () {
            return _showWeightInputDialog(context);
          },
          onShowSuccessAnimation: () {
            _showSuccessAnimation(context);
          }
        ),
      ),
    );
  }
}

class _ChecklistBody extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String todayDate;
  final Function(BuildContext context, String rumahId) onShowImagePicker;
  final Function() onShowPhotoSubmitSuccess;
  final Future<Map<String, String>?> Function() onShowWeightDialog;
  final Function() onShowSuccessAnimation;

  const _ChecklistBody({
    required this.scaffoldKey,
    required this.todayDate,
    required this.onShowImagePicker,
    required this.onShowPhotoSubmitSuccess,
    required this.onShowWeightDialog, 
    required this.onShowSuccessAnimation, 
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChecklistInputCubit, ChecklistInputState>(
      listenWhen: (prev, current) => prev.status != current.status,
      listener: (context, state) {
        if (state.status == ChecklistInputStatus.uploadFotoSuccess) {
          onShowPhotoSubmitSuccess(); 
        } else if (state.status == ChecklistInputStatus.uploadFotoFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Gagal Upload Foto: ${state.errorMessage ?? 'Unknown error'}')),
          );
        }
        if (state.status == ChecklistInputStatus.submitTotalSuccess) {
          onShowSuccessAnimation(); 
        } else if (state.status == ChecklistInputStatus.submitTotalFailure) {
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Gagal Kirim Data: ${state.errorMessage ?? 'Unknown error'}')),
          );
        }
      },
      buildWhen: (prev, current) => 
          prev.status != current.status || 
          prev.filteredListRumah != current.filteredListRumah,
      builder: (context, state) {
        final bool isUploading = state.status == ChecklistInputStatus.uploadingFoto;
        final bool isSubmitting = state.status == ChecklistInputStatus.submittingTotal;
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeaderAndFilters(context, todayDate),
                  _buildLegend(),
                  _buildListContent(context, state),
                  _buildSubmitButton(context),
                ],
              ),
            ),
            if (isUploading || isSubmitting)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            isUploading ? "Mengupload foto..." : "Mengirim data...",
                             style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildListContent(BuildContext context, ChecklistInputState state) {
    if (state.status == ChecklistInputStatus.loading && state.listRumah.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.status == ChecklistInputStatus.failure && state.listRumah.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: Text('Gagal load data: ${state.errorMessage ?? 'Error'}')),
      );
    }
    if (state.filteredListRumah.isEmpty) {
       return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: Text('Tidak ada data rumah')),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: state.filteredListRumah.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final dataRumah = state.filteredListRumah[index];
        return ChecklistCardWidget(
          key: ValueKey(dataRumah.id), 
          dataRumah: dataRumah,
          onSampahChanged: (String jenisSampah, bool isChecked) {
            context.read<ChecklistInputCubit>().updateSampahChecklist(
                  dataRumah.id,
                  jenisSampah,
                  isChecked,
                );
          },
          onFotoUploadTapped: () {
            onShowImagePicker(context, dataRumah.id);
          },
        );
      },
    );
  }

  Widget _buildHeaderAndFilters(BuildContext context, String date) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppColors.blue.normal,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(LucideIcons.menu, color: AppColors.white.normal),
                    onPressed: () => scaffoldKey.currentState?.openDrawer(),
                  ),
                  const SizedBox(width: 8),
                  Icon(LucideIcons.clipboardEdit,
                      color: AppColors.white.normal, size: 22),
                  const SizedBox(width: 12),
                  Text(
                    'Input Harian',
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      color: AppColors.white.normal,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  date,
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    color: AppColors.white.normal,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildFilterSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Column(
        children: [
          Row(
            children: [
              _buildLegendItem('MT', 'Mudah Terurai',
                  abvColor: AppColors.green.normal),
              _buildLegendItem('R', 'Residu',
                  abvColor: AppColors.blue.darkActive),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _buildLegendItem('MD', 'Material Daur',
                  abvColor: AppColors.blue.normal),
              _buildLegendItem('B3', '', abvColor: AppColors.red.normal),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String abbreviation, String text, {Color? abvColor}) {
    abvColor ??= AppColors.black.darker;
    return Expanded(
      child: Row(
        children: [
          Text(
            abbreviation,
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: abvColor,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              fontSize: 14,
              color: AppColors.black.normal.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
          child: Text(
            'Filter RT:',
            style: TextStyle(
                fontFamily: 'InstrumentSans',
                color: AppColors.white.normal.withOpacity(0.8),
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
        ),
        BlocBuilder<ChecklistInputCubit, ChecklistInputState>(
          buildWhen: (prev, current) => prev.selectedRT != current.selectedRT || prev.listRT != current.listRT,
          builder: (context, state) {
            return _buildFilterDropdown(state.selectedRT, state.listRT, () {
              _showFilterSheet(context, 'Pilih RT', state.listRT, state.selectedRT,
                  (value) {
                if (value != null) {
                  context.read<ChecklistInputCubit>().filterRtChanged(value);
                }
              });
            });
          },
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(
      String? currentValue, List<String> items, VoidCallback onTap) {
    return Material(
      color: AppColors.white.normal,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentValue ?? 'Pilih...',
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontSize: 14,
                  color: AppColors.black.normal.withOpacity(0.87),
                ),
              ),
              Icon(LucideIcons.chevronDown,
                  size: 20, color: AppColors.black.normal.withOpacity(0.6)),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(
      BuildContext context,
      String title,
      List<String> items,
      String? currentSelection,
      ValueChanged<String?> onSelect) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
          padding: EdgeInsets.only(
              top: 20,
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewPadding.bottom + 16),
          decoration: BoxDecoration(
            color: AppColors.white.normal,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final bool isSelected = items[index] == currentSelection;
                    return ListTile(
                      title: Text(items[index],
                          style: TextStyle(
                            fontFamily: 'InstrumentSans',
                            color: isSelected
                                ? AppColors.blue.normal
                                : AppColors.black.normal,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          )),
                      trailing: isSelected
                          ? Icon(LucideIcons.check,
                              color: AppColors.blue.normal, size: 20)
                          : null,
                      onTap: () {
                        onSelect(items[index]);
                        Navigator.pop(context);
                      },
                      dense: true,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocBuilder<ChecklistInputCubit, ChecklistInputState>(
      buildWhen: (prev, current) => prev.status != current.status,
      builder: (context, state) {
        final bool isSubmitting = state.status == ChecklistInputStatus.submittingTotal;
        final bool isUploading = state.status == ChecklistInputStatus.uploadingFoto;
        final bool isLoading = isSubmitting || isUploading;
        return Padding(
          padding: EdgeInsets.fromLTRB(
              16, 16, 16, 16 + MediaQuery.of(context).viewPadding.bottom + 70),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : () async { 
                print("Submit Data Total tapped");
                final Map<String, String>? dataBerat = await onShowWeightDialog();
                if (dataBerat != null && context.mounted) {
                  context.read<ChecklistInputCubit>().submitTotalWeight(dataBerat);
                } else {
                  print("Input weight cancelled");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue.normal,
                foregroundColor: AppColors.white.normal,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: isSubmitting 
                ? const SizedBox(
                    height: 20, 
                    width: 20, 
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                  )
                : const Text(
                    'Submit Data',
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
            ),
          ),
        );
      },
    );
  }
}