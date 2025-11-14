import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; 
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import '../../../../core/presentation/utils/app_colors.dart';
import '../blocs/tambah/tambah_laporan_cubit.dart'; 
import '../../domain/entities/dokumentasi_laporan.dart'; 

class TambahLaporanPage extends StatefulWidget {
  const TambahLaporanPage({super.key});

  @override
  State<TambahLaporanPage> createState() => _TambahLaporanPageState();
}

class _TambahLaporanPageState extends State<TambahLaporanPage>
    with TickerProviderStateMixin { 
      
  AnimationController? _lottieSuccessController; 

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id', null); 
  }

  @override
  void dispose() {
    _lottieSuccessController?.dispose();
    super.dispose();
  }

  void _showSuccessModal(BuildContext context) {
    _lottieSuccessController?.dispose();
    _lottieSuccessController = AnimationController(vsync: this);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                  controller: _lottieSuccessController,
                  onLoaded: (composition) {
                    _lottieSuccessController!
                      ..duration = composition.duration
                      ..forward().whenComplete(() {
                        Future.delayed(const Duration(seconds: 1), () {
                          Navigator.of(dialogContext).pop(); 
                          Navigator.of(context).pop(); 
                        });
                      });
                  },
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TambahLaporanCubit()..init(), 
      child: BlocListener<TambahLaporanCubit, TambahLaporanState>(
        listenWhen: (prev, current) => prev.status != current.status,
        listener: (context, state) {
          if (state.status == TambahLaporanStatus.success) {
            _showSuccessModal(context); 
          } else if (state.status == TambahLaporanStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Gagal menyimpan data'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state.status == TambahLaporanStatus.imagePickFailed) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Gagal memilih gambar'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state.status == TambahLaporanStatus.imagePreviewReady) {
            if (state.tempPickedImage != null && state.tempImageDocId != null) {
              final data = state.listDokumentasi.firstWhere(
                (d) => d.id == state.tempImageDocId,
                orElse: () => state.listDokumentasi.first,
              );
              _showSavePreviewDialog(
                context, 
                data, 
                state.tempPickedImage!, 
                state.tempImageSizeKB ?? 0.0
              ).then((result) {
                if (result == 'simpan') {
                  context.read<TambahLaporanCubit>().saveTempImage();
                } else if (result == 'ganti') {
                  _TambahLaporanBody()._showImageSourceModal(context, data);
                } else {
                  context.read<TambahLaporanCubit>().clearTempImage();
                }
              });
            }
          }
        },
        child: Scaffold(
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
          body: _TambahLaporanBody(),
        ),
      ),
    );
  }
  
  Future<String?> _showSavePreviewDialog(BuildContext context, DokumentasiLaporan data, XFile compressedFile, double fileSizeInKB) {
    return showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Upload Dokumentasi',
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
                  _TambahLaporanBody()._showFullscreenImageDialog(context, compressedFile);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.file(
                    File(compressedFile.path), 
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
                    Navigator.of(dialogContext).pop('batal'); 
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
                    Navigator.of(dialogContext).pop('ganti'); 
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
                    Navigator.of(dialogContext).pop('simpan'); 
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

class _TambahLaporanBody extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final DateFormat _dateFormat = DateFormat('dd MMMM yyyy', 'id');

  _TambahLaporanBody({super.key});

  Future<void> _selectDate(BuildContext context, DokumentasiLaporan data) async {
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
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            textTheme: Theme.of(context).textTheme.copyWith(
                  headlineSmall: Theme.of(context).textTheme.headlineSmall?.copyWith(fontFamily: 'InstrumentSans'),
                  titleLarge: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: 'InstrumentSans'),
                  bodyLarge: Theme.of(context).textTheme.bodyLarge?.copyWith(fontFamily: 'InstrumentSans'),
                  labelLarge: Theme.of(context).textTheme.labelLarge?.copyWith(fontFamily: 'InstrumentSans'),
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != data.tanggalPelaksanaan) {
      context.read<TambahLaporanCubit>().selectDate(data.id, picked);
    }
  }

  void _showFullscreenImageDialog(BuildContext context, XFile imageFile) {
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
                child: Image.file(File(imageFile.path)),
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

  void _showPreviewImage(BuildContext context, XFile imageFile) {
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

  void _showImageSourceModal(BuildContext context, DokumentasiLaporan data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white.normal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (sheetContext) { 
        final cubit = context.read<TambahLaporanCubit>();
        if (data.pickedImage == null) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text( 'Pilih Sumber Gambar', style: TextStyle( fontFamily: 'InstrumentSans', fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.black.normal, ),),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Icon(LucideIcons.camera, color: AppColors.blue.normal),
                    title: Text('Kamera', style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 16, color: AppColors.black.normal,),),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      cubit.pickImage(data.id, ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: Icon(LucideIcons.image, color: AppColors.blue.normal),
                    title: Text('Galeri', style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 16, color: AppColors.black.normal,),),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      cubit.pickImage(data.id, ImageSource.gallery);
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        } else {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Opsi Gambar', style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.black.normal,),),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Icon(LucideIcons.eye, color: AppColors.blue.normal),
                    title: Text('Lihat Gambar', style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 16, color: AppColors.black.normal,),),
                    onTap: () => _showPreviewImage(sheetContext, data.pickedImage!),
                  ),
                  ListTile(
                    leading: Icon(LucideIcons.camera, color: AppColors.black.lightActive),
                    title: Text('Ganti via Kamera', style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 16, color: AppColors.black.normal,),),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      cubit.pickImage(data.id, ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: Icon(LucideIcons.image, color: AppColors.black.lightActive),
                    title: Text('Ganti via Galeri', style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 16, color: AppColors.black.normal,),),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      cubit.pickImage(data.id, ImageSource.gallery);
                    },
                  ),
                  ListTile(
                    leading: Icon(LucideIcons.trash2, color: AppColors.red.normal),
                    title: Text('Hapus Gambar', style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 16, color: AppColors.red.normal, fontWeight: FontWeight.w600,),),
                    onTap: () {
                      cubit.deleteImage(data.id); 
                      Navigator.pop(sheetContext);
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
    return BlocBuilder<TambahLaporanCubit, TambahLaporanState>(
      builder: (context, state) {
        final bool isLoading = state.status == TambahLaporanStatus.loading ||
                                state.status == TambahLaporanStatus.pickingImage;
        return Stack(
          children: [
            Form(
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
                            value: state.selectedBulan, 
                            onTap: () => _showFilterOptions(
                              context,
                              title: "Pilih Bulan",
                              options: state.listBulan, 
                              currentValue: state.selectedBulan,
                              onSelect: (newValue) => context.read<TambahLaporanCubit>().bulanChanged(newValue),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildFilterButton(
                            title: 'Tahun',
                            value: state.selectedTahun, 
                            onTap: () => _showFilterOptions(
                              context,
                              title: "Pilih Tahun",
                              options: state.listTahun, 
                              currentValue: state.selectedTahun,
                              onSelect: (newValue) => context.read<TambahLaporanCubit>().tahunChanged(newValue),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      key: Key('jumlah_rumah_${state.jumlahRumah}'),
                      initialValue: state.jumlahRumah, 
                      labelText: 'Jumlah Rumah yang Memilah',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        context.read<TambahLaporanCubit>().jumlahRumahChanged(value);
                      },
                    ),
                    const SizedBox(height: 32),
                    ...state.listDokumentasi.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 32.0),
                        child: _buildDokumentasiSection(context, index + 1, data),
                      );
                    }).toList(),

                    _buildReminderBox(),
                    const SizedBox(height: 32),
                    _buildActionButtons(context, isLoading), 
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            if (isLoading)
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
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            state.status == TambahLaporanStatus.pickingImage 
                              ? "Memproses gambar..." 
                              : "Menyimpan...",
                            style: const TextStyle(fontFamily: 'InstrumentSans', fontSize: 16),
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

  Widget _buildSectionTitle(String title, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle,),),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 14, fontWeight: FontWeight.bold, color: color,),),
      ],
    );
  }

  Widget _buildInputField({
    String? initialValue,
    TextEditingController? controller, 
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    String? hintText,
    bool readOnly = false,
    VoidCallback? onTap,
    Function(String)? onChanged,
    Key? key,
  }) {
    return TextFormField(
      key: key, 
      initialValue: initialValue, 
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      style: TextStyle(fontFamily: 'InstrumentSans', color: AppColors.black.normal, fontSize: 14,),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: onTap != null ? Icon(LucideIcons.calendar, color: AppColors.black.lightActive) : null,
        labelStyle: TextStyle(fontFamily: 'InstrumentSans', color: AppColors.black.lightActive,),
        hintStyle: TextStyle(fontFamily: 'InstrumentSans', color: AppColors.black.lightActive.withOpacity(0.5),),
        filled: true,
        fillColor: AppColors.white.normal,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: AppColors.black.light, width: 1.0),),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: AppColors.black.light, width: 1.0),),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: AppColors.blue.normal, width: 2.0),),
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
        Text(title, style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 12, color: AppColors.black.lightActive, fontWeight: FontWeight.w500,),),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: AppColors.white.normal, borderRadius: BorderRadius.circular(15), border: Border.all(color: AppColors.black.light, width: 1),),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value ?? title,
                    style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black.normal,),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(LucideIcons.chevronDown, color: AppColors.black.lightActive, size: 20),
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
                  child: Text(title, style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black.normal,),),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: options.length,
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
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontFamily: 'InstrumentSans',
                                    fontSize: 15,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                    color: isSelected ? AppColors.blue.dark : AppColors.black.normal,
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
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDokumentasiSection(BuildContext context, int number, DokumentasiLaporan data) {
    final TextEditingController dateController = TextEditingController(
      text: data.tanggalPelaksanaan != null
          ? _dateFormat.format(data.tanggalPelaksanaan!)
          : '',
    );

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
        _buildSectionTitle('Dokumentasi Kegiatan $number', AppColors.black.normal),
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
                  Text('Upload Foto Dokumentasi', style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black.normal,),),
                  Text('(Max. 200KB)', style: TextStyle(fontFamily: 'InstrumentSans', fontSize: 12, color: AppColors.red.normal, fontWeight: FontWeight.w500,),),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: Icon(LucideIcons.image, size: 18, color: AppColors.white.normal),
                label: Text(
                  buttonText, 
                  style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.bold, color: AppColors.white.normal,),
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: () {
                  _showImageSourceModal(context, data); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: data.isPhotoUploaded ? AppColors.green.normal : AppColors.blue.dark,
                  foregroundColor: AppColors.white.normal,
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildInputField(
          key: Key('ket_${data.id}'), 
          initialValue: data.keterangan,
          labelText: 'Keterangan Kegiatan',
          hintText: 'Masukkan keterangan kegiatan...',
          maxLines: 4,
          onChanged: (value) => context.read<TambahLaporanCubit>().keteranganChanged(data.id, value),
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
          key: Key('pelaksana_${data.id}'), 
          initialValue: data.pelaksanaKegiatan,
          labelText: 'Pelaksana Kegiatan',
          onChanged: (value) => context.read<TambahLaporanCubit>().pelaksanaChanged(data.id, value),
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

  Widget _buildActionButtons(BuildContext context, bool isLoading) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: isLoading ? null : () => Navigator.pop(context), 
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red.normal,
              foregroundColor: AppColors.white.normal,
              minimumSize: const Size(0, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
              elevation: 0,
            ),
            child: Text('BATAL', style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.bold, color: AppColors.white.normal,),),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: isLoading ? null : () { 
              if (_formKey.currentState!.validate()) {
                context.read<TambahLaporanCubit>().submitLaporan();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green.normal,
              foregroundColor: AppColors.white.normal,
              minimumSize: const Size(0, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
              elevation: 0,
            ),
            child: isLoading 
              ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,))
              : Text('TAMBAH', style: TextStyle(fontFamily: 'InstrumentSans', fontWeight: FontWeight.bold, color: AppColors.white.normal,),),
          ),
        ),
      ],
    );
  }
}