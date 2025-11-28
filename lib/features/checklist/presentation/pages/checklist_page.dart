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

// Import Dependency Injection
import '../../../../injection_container.dart' as di;

// Core Imports
import '../../../../core/presentation/utils/app_colors.dart';

// Widget Imports
import '../widgets/menu_drawer_widget.dart';
import '../widgets/card_widget.dart';

// Bloc Import
import '../blocs/checklist/checklist_input_cubit.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});
  static const String routeName = '/checklist';

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> with TickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  
  // Animation Controllers
  AnimationController? _lottieSuccessController;
  AnimationController? _lottieSuccessTotalController;
  
  // Local State untuk file gambar sementara
  final Map<String, File> _uploadedImageFiles = {};

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id', null);
  }
  
  @override
  void dispose() {
    _lottieSuccessController?.dispose();
    _lottieSuccessTotalController?.dispose();
    super.dispose();
  }

  // ==========================================================================
  // 1. LOGIC FILTER SHEET (MODERN STYLE)
  // ==========================================================================
  void _showFilterSheet(BuildContext context, ChecklistInputCubit cubit, List<String> listRT, String currentRT) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6, 
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 4),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Header Sheet
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pilih Wilayah RT',
                      style: TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(LucideIcons.x, color: Colors.black, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              
              const Divider(height: 1, color: Color(0xFFEEEEEE)),

              // List RT Options
              Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shrinkWrap: true,
                  itemCount: listRT.length,
                  itemBuilder: (context, index) {
                    // FIX: Handle potential null values safely
                    final String? rawRT = listRT[index];
                    final String rt = rawRT ?? "Unknown"; 
                    
                    final bool isSelected = rt == currentRT;
                    
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        // Update Cubit State
                        cubit.filterRtChanged(rt);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        color: isSelected ? AppColors.blue.light.withOpacity(0.1) : Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              rt == 'Semua RT' ? 'Tampilkan Semua RT' : 'RT $rt',
                              style: TextStyle(
                                fontFamily: 'InstrumentSans',
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? AppColors.blue.normal : Colors.black87,
                              ),
                            ),
                            if (isSelected)
                              Icon(LucideIcons.check, color: AppColors.blue.normal, size: 20),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================================
  // 2. LOGIC IMAGE PICKER & COMPRESS
  // ==========================================================================
  Future<void> _pickAndCompressImage(ImageSource source, BuildContext context, String rumahId, ChecklistInputCubit cubit) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70, 
        maxWidth: 1000, 
      );
      if (pickedFile == null) return;
      
      final fileBytes = await pickedFile.readAsBytes();
      var result = await FlutterImageCompress.compressWithList(
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
        result = await FlutterImageCompress.compressWithList(
          result,
          minHeight: 600,
          minWidth: 600,
          quality: 50, 
        );
        compressedFile = await File(targetPath).writeAsBytes(result);
        fileSizeInKB = await compressedFile.length() / 1024;
      }
      
      if (mounted) {
        final bool? isSaved = await _showSavePreviewDialog(context, compressedFile, fileSizeInKB);
        
        if (isSaved == true) { 
          if (!context.mounted) return;
          final bool? isConfirmed = await _showConfirmationDialog(context);
          
          if (isConfirmed == true && context.mounted) {
            setState(() {
              _uploadedImageFiles[rumahId] = compressedFile; 
            });
            cubit.submitFoto(rumahId, compressedFile);
          }
        } else if (isSaved == null && context.mounted) {
          _showImageSourceActionSheet(context, rumahId);
        }
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error mengambil gambar: $e')),
        );
      }
    }
  }

  void _showImageSourceActionSheet(BuildContext context, String rumahId) {
    final cubit = context.read<ChecklistInputCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white.normal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Upload Foto', style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.w600, fontSize: 18, color: AppColors.black.normal)),
              ),
              ListTile(
                leading: Icon(LucideIcons.camera, color: AppColors.blue.normal),
                title: const Text('Ambil Foto (Kamera)', style: TextStyle(fontFamily: 'InstrumentSans')),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickAndCompressImage(ImageSource.camera, context, rumahId, cubit);
                },
              ),
              ListTile(
                leading: Icon(LucideIcons.image, color: AppColors.blue.normal),
                title: const Text('Pilih dari Galeri', style: TextStyle(fontFamily: 'InstrumentSans')),
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

  // ==========================================================================
  // 3. DIALOGS (Preview, Confirm, Success, Input Weight)
  // ==========================================================================

  Future<void> _showViewOnlyPreviewDialog(BuildContext context, String rumahId) {
    final File? imageFile = _uploadedImageFiles[rumahId];
    if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: File foto tidak ditemukan.')));
      return Future.value();
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Lihat Gambar', style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.w600, fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  _showFullscreenImageDialog(context, imageFile);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.file(imageFile, fit: BoxFit.contain, height: 250),
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.red.normal.withOpacity(0.5)),
                foregroundColor: AppColors.red.normal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('BATAL', style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.w700)),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue.normal,
                foregroundColor: AppColors.white.normal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('UBAH', style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.w700)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); 
                _showImageSourceActionSheet(context, rumahId);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showSavePreviewDialog(BuildContext context, File compressedFile, double fileSizeInKB) {
    return showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Upload Kegiatan', style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.w600, fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => _showFullscreenImageDialog(context, compressedFile),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.file(compressedFile, fit: BoxFit.contain, height: 250),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${fileSizeInKB.toStringAsFixed(1)} KB",
                style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 12, fontWeight: FontWeight.bold, color: fileSizeInKB > 200 ? AppColors.red.normal : AppColors.green.dark),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('BATAL', style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.w700)),
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.blue.normal),
                    foregroundColor: AppColors.blue.normal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('GANTI', style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.w700)),
                  onPressed: () => Navigator.of(dialogContext).pop(null),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green.normal,
                    foregroundColor: AppColors.white.normal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('SIMPAN', style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.w700)),
                  onPressed: () => Navigator.of(dialogContext).pop(true),
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
          insetPadding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: InteractiveViewer(child: Image.file(imageFile)),
              ),
              const SizedBox(height: 12),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.8)),
                child: Text('Tutup', style: TextStyle(fontFamily: 'InstrumentSans', color: AppColors.blue.normal, fontWeight: FontWeight.w600)),
                onPressed: () => Navigator.of(dialogContext).pop(),
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
              SizedBox(width: 120, height: 120, child: Lottie.asset('assets/lottie/alert.json', repeat: false)),
              const Text('Anda yakin?', style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 8),
              Text('Pastikan data sudah benar!', style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 14, color: AppColors.black.normal.withOpacity(0.6)), textAlign: TextAlign.center),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton( 
                  style: OutlinedButton.styleFrom(side: BorderSide(color: AppColors.red.normal), foregroundColor: AppColors.red.normal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('BATAL', style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.w700)),
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                ),
                const SizedBox(width: 8),
                ElevatedButton( 
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue.normal, foregroundColor: AppColors.white.normal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('KIRIM', style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                  onPressed: () => Navigator.of(dialogContext).pop(true),
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
                width: 120, height: 120,
                child: Lottie.asset('assets/lottie/success.json', repeat: false, controller: _lottieSuccessController, onLoaded: (composition) {
                  _lottieSuccessController!
                    ..duration = composition.duration
                    ..forward().whenComplete(() {
                      Future.delayed(const Duration(milliseconds: 300), () { 
                        Navigator.of(dialogContext).pop();
                      });
                    });
                }),
              ),
              const Text('Berhasil!', style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 8),
              Text('Foto telah berhasil dikirim.', style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 14, color: AppColors.black.normal.withOpacity(0.6)), textAlign: TextAlign.center),
            ],
          ),
        );
      },
    );
  }

  Future<Map<String, String>?> _showWeightInputDialog(BuildContext context) {
    final String todayDate = DateFormat('EEEE, d MMMM yyyy', 'id').format(DateTime.now());
    final mtController = TextEditingController(text: '0');
    final mdController = TextEditingController(text: '0');
    final residuController = TextEditingController(text: '0');
    final b3Controller = TextEditingController(text: '0');
    
    return showDialog<Map<String, String>?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          actionsPadding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          title: Text(
            'Data Sampah RW 7 : $todayDate',
            style: const TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.w600, fontSize: 16),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(children: [Expanded(child: _buildWeightTextField('Mudah Terurai (kg)', mtController)), const SizedBox(width: 16), Expanded(child: _buildWeightTextField('Material Daur (kg)', mdController))]),
                const SizedBox(height: 16),
                Row(children: [Expanded(child: _buildWeightTextField('Residu (kg)', residuController)), const SizedBox(width: 16), Expanded(child: _buildWeightTextField('E-waste/B3 (kg)', b3Controller))]),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(backgroundColor: AppColors.red.normal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: Text('BATAL', style: TextStyle(fontFamily: 'InstrumentSans', color: AppColors.white.normal, fontWeight: FontWeight.w600)),
              onPressed: () => Navigator.of(dialogContext).pop(null),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: AppColors.green.normal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: Text('SIMPAN', style: TextStyle(fontFamily: 'InstrumentSans', color: AppColors.white.normal, fontWeight: FontWeight.w600)),
              onPressed: () {
                final dataBerat = {
                  'mudah_terurai': mtController.text,
                  'material_daur': mdController.text,
                  'residu': residuController.text,
                  'b3': b3Controller.text,
                };
                Navigator.of(dialogContext).pop(dataBerat);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeightTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 12, color: AppColors.black.normal.withOpacity(0.7))),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          style: const TextStyle(fontFamily: 'InstrumentSans', fontSize: 14),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: true,
            fillColor: AppColors.white.normal,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.black.lightActive)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.black.lightActive)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.blue.normal, width: 1.5)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/lottie/success.json', repeat: false, width: 150, height: 150, controller: _lottieSuccessTotalController, onLoaded: (composition) {
                _lottieSuccessTotalController!
                  ..duration = composition.duration
                  ..forward().whenComplete(() {
                    Future.delayed(composition.duration, () {
                      if(context.mounted) Navigator.of(context).pop();
                    });
                  });
              }),
              const SizedBox(height: 16),
              Text('Data Berhasil Dikirim!', style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.w600, fontSize: 18, color: AppColors.blue.normal)),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================================
  // BUILD METHOD (MAIN UI)
  // ==========================================================================
  @override
  Widget build(BuildContext context) {
    final String todayDate = DateFormat('EEEE, d MMMM yyyy', 'id').format(DateTime.now());
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    
    return BlocProvider(
      create: (context) => di.sl<ChecklistInputCubit>()..fetchListRumah(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF8F9FD),
        drawer: const ChecklistMenuDrawerWidget(activeRoute: ChecklistPage.routeName),
        extendBody: true, 
        body: _ChecklistBody(
          scaffoldKey: scaffoldKey,
          todayDate: todayDate,
          
          // Callback Filter
          onShowFilter: (cubit, listRT, currentRT) {
            _showFilterSheet(context, cubit, listRT, currentRT);
          },
          
          // Callback Image Picker
          onShowImagePicker: (sheetContext, rumahId, isUploaded) {
             if (isUploaded) {
                _showViewOnlyPreviewDialog(sheetContext, rumahId);
             } else {
                _showImageSourceActionSheet(sheetContext, rumahId);
             }
          }, 
          onShowPhotoSubmitSuccess: () => _showPhotoSubmitSuccessDialog(context),
          onShowWeightDialog: () => _showWeightInputDialog(context),
          onShowSuccessAnimation: () => _showSuccessAnimation(context),
        ),
      ),
    );
  }
}

class _ChecklistBody extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String todayDate;
  final Function(ChecklistInputCubit, List<String>, String) onShowFilter; 
  final Function(BuildContext, String, bool) onShowImagePicker;
  final Function() onShowPhotoSubmitSuccess;
  final Future<Map<String, String>?> Function() onShowWeightDialog;
  final Function() onShowSuccessAnimation;

  const _ChecklistBody({
    required this.scaffoldKey,
    required this.todayDate,
    required this.onShowFilter,
    required this.onShowImagePicker,
    required this.onShowPhotoSubmitSuccess,
    required this.onShowWeightDialog,
    required this.onShowSuccessAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = 80 + MediaQuery.of(context).viewPadding.bottom;

    return BlocConsumer<ChecklistInputCubit, ChecklistInputState>(
      listener: (context, state) {
        if (state.status == ChecklistInputStatus.uploadFotoSuccess) {
          onShowPhotoSubmitSuccess();
        }
        if (state.status == ChecklistInputStatus.submitTotalSuccess) {
          onShowSuccessAnimation();
        }
      },
      builder: (context, state) {
        final bool isLoading = state.status == ChecklistInputStatus.loading;
        final bool isUploading = state.status == ChecklistInputStatus.uploadingFoto;
        final bool isSubmitting = state.status == ChecklistInputStatus.submittingTotal;

        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeaderAndFilters(context, todayDate, state),
                ),
                SliverToBoxAdapter(
                  child: _buildLegend(),
                ),
                if (isLoading)
                  const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
                else if (state.filteredListRumah.isEmpty)
                  SliverFillRemaining(child: _buildEmptyState())
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final data = state.filteredListRumah[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ChecklistCardWidget(
                            key: ValueKey(data.id),
                            dataRumah: data,
                            onSampahChanged: (key, val) {
                              context.read<ChecklistInputCubit>().updateSampahChecklist(data.id, key, val);
                            },
                            onFotoUploadTapped: (isUp) {
                              onShowImagePicker(context, data.id, isUp);
                            },
                          ),
                        );
                      },
                      childCount: state.filteredListRumah.length,
                    ),
                  ),
                SliverToBoxAdapter(child: SizedBox(height: bottomPadding)),
              ],
            ),
            
            Positioned(
              left: 20, 
              right: 20, 
              bottom: 35, 
              child: _buildSubmitButton(context, state),
            ),

            if (isUploading || isSubmitting)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }

  Widget _buildHeaderAndFilters(BuildContext context, String date, ChecklistInputState state) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppColors.blue.normal,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.normal.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(LucideIcons.menu, color: AppColors.white.normal),
                    onPressed: () => scaffoldKey.currentState?.openDrawer(),
                  ),
                  const Spacer(),
                  Icon(LucideIcons.clipboardEdit, color: AppColors.white.normal, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Input Harian',
                    style: TextStyle(
                      fontFamily: 'InstrumentSans',
                      color: AppColors.white.normal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48), 
                ],
              ),
              
              const SizedBox(height: 16),
              
              Text(
                date,
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  color: AppColors.white.normal,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 20),
              
              Text(
                'Filter RT:',
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  color: AppColors.white.normal.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              
              GestureDetector(
                onTap: () {
                  final cubit = context.read<ChecklistInputCubit>();
                  onShowFilter(cubit, state.listRT, state.selectedRT);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white.normal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.selectedRT == 'Semua RT' ? 'Semua RT' : 'RT ${state.selectedRT}',
                        style: TextStyle(
                          fontFamily: 'InstrumentSans',
                          color: AppColors.black.normal,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Icon(LucideIcons.chevronDown, color: AppColors.black.normal, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              _legendItem("MT", "Mudah Terurai", AppColors.green.normal),
              const SizedBox(width: 16),
              _legendItem("R", "Residu", AppColors.black.normal),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _legendItem("MD", "Material Daur", AppColors.blue.normal),
              const SizedBox(width: 16),
              _legendItem("B3", "B3", AppColors.red.normal),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String code, String label, Color color) {
    return Expanded(
      child: Row(
        children: [
          Text(
            code,
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              color: AppColors.black.normal.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/nodata.json', width: 200, height: 200),
          const SizedBox(height: 16),
          Text(
            'Belum ada data rumah',
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, ChecklistInputState state) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.normal.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () async {
          final Map<String, String>? dataBerat = await onShowWeightDialog();
          if (dataBerat != null && context.mounted) {
            context.read<ChecklistInputCubit>().submitTotalWeight(dataBerat);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green.normal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), 
          ),
          elevation: 5, 
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.uploadCloud, size: 18), 
            SizedBox(width: 8),
            Text(
              'Simpan Data Harian',
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                fontWeight: FontWeight.bold,
                fontSize: 14, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}