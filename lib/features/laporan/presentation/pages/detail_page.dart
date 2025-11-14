import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/presentation/utils/app_colors.dart';
import '../blocs/detail/detail_laporan_cubit.dart';
import '../../domain/entities/laporan_entities.dart';
import '../../domain/entities/dokumentasi_laporan.dart';

class DetailLaporanPage extends StatefulWidget {
  final String laporanId;
  const DetailLaporanPage({
    super.key,
    required this.laporanId,
  });

  @override
  State<DetailLaporanPage> createState() => _DetailLaporanPageState();
}

class _DetailLaporanPageState extends State<DetailLaporanPage> {
  final DateFormat _dateFormat = DateFormat('dd MMMM yyyy', 'id');

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id', null);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailLaporanCubit()..fetchDetail(widget.laporanId),
      child: Scaffold(
        backgroundColor: AppColors.white.normal,
        body: BlocBuilder<DetailLaporanCubit, DetailLaporanState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                _buildHeader(context, state),
                if (state.status == DetailLaporanStatus.loading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (state.status == DetailLaporanStatus.failure)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(state.errorMessage ?? 'Gagal memuat data'),
                    ),
                  ),
                if (state.status == DetailLaporanStatus.success)
                  _buildBody(context, state.laporan, state.listDokumentasi),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DetailLaporanState state) {
    String title = 'Detail Laporan';
    if (state.status == DetailLaporanStatus.success && state.laporan != null) {
      title = 'Detail Laporan ${state.laporan!.bulan} ${state.laporan!.tahun}';
    }
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.blue.normal,
      foregroundColor: AppColors.white.normal,
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'InstrumentSans',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.white.normal,
        ),
      ),
      leading: IconButton(
        icon: Icon(LucideIcons.arrowLeft, color: AppColors.white.normal),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Laporan? laporan, List<DokumentasiLaporan> listDokumentasi) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Informasi Laporan', AppColors.black.normal),
            const SizedBox(height: 16),
            _buildReadOnlyDropdown(
              title: 'Bulan',
              value: laporan?.bulan ?? '-',
            ),
            const SizedBox(height: 16),
            _buildReadOnlyDropdown(
              title: 'Tahun',
              value: laporan?.tahun ?? '-',
            ),
            const SizedBox(height: 16),
            _buildReadOnlyField(
              labelText: 'Jumlah Rumah yang Memilah',
              value: laporan?.jumlahRumah.toString() ?? '0',
            ),
            const SizedBox(height: 32),
            ...listDokumentasi.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: _buildDokumentasiSection(index + 1, data),
              );
            }).toList(),
            const SizedBox(height: 16),
          ],
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

  Widget _buildReadOnlyField({
    required String labelText,
    required String value,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      maxLines: maxLines,
      style: TextStyle(
        fontFamily: 'InstrumentSans',
        color: AppColors.black.normal,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontFamily: 'InstrumentSans',
          color: AppColors.black.lightActive,
        ),
        filled: true,
        fillColor: AppColors.black.light.withOpacity(0.5), 
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
          borderSide: BorderSide(color: AppColors.black.light, width: 1.0),
        ),
      ),
    );
  }

  Widget _buildReadOnlyDropdown({
    required String title,
    required String value,
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.black.light.withOpacity(0.5), 
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.black.light, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
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
      ],
    );
  }

  Widget _buildDokumentasiSection(int number, DokumentasiLaporan data) {
    final String tanggalText = data.tanggalPelaksanaan != null
        ? _dateFormat.format(data.tanggalPelaksanaan!)
        : '-';
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
              Text(
                'Dokumentasi:',
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black.normal,
                ),
              ),
              const SizedBox(height: 8),
              if (data.fotoUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    data.fotoUrl!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      color: AppColors.black.light,
                      child: Center(
                        child: Lottie.asset(
                          'assets/lottie/image.json',
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 150,
                        color: AppColors.black.light,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColors.black.light,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Lottie.asset(
                      'assets/lottie/image.json',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildReadOnlyField(
          labelText: 'Keterangan Kegiatan',
          value: data.keterangan ?? '-',
          maxLines: 4,
        ),
        const SizedBox(height: 16),
        _buildReadOnlyField(
          labelText: 'Tanggal Pelaksanaan Kegiatan',
          value: tanggalText,
        ),
        const SizedBox(height: 16),
        _buildReadOnlyField(
          labelText: 'Pelaksana Kegiatan',
          value: data.pelaksanaKegiatan ?? '-',
        ),
      ],
    );
  }
}
