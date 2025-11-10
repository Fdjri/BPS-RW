import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart'; 
import 'package:flutter/material.dart'; 
import '../../../../core/presentation/utils/app_colors.dart';

class DashboardData extends Equatable {
  const DashboardData({
    required this.kelurahan,
    required this.rw,
    required this.pendamping,
    required this.jmlRT,
    required this.jmlRumah,
    required this.jmlJiwa,
    required this.estimasiTimbulan,
    required this.persenRumahMemilah,
    required this.jmlRumahMemilah,
    required this.progressRumahMemilah,
    required this.persenRumahNasabah,
    required this.jmlRumahNasabah,
    required this.progressRumahNasabah,
    required this.volumeOrganik,
    required this.volumeAnorganik,
    required this.volumeB3,
    required this.statusBankSampah,
    required this.accumulationData,
    required this.checkPerMonthData,
    required this.neracaSampah,
  });

  // Data Header
  final String kelurahan;
  final String rw;
  final String pendamping;

  // Data Grid Stats
  final String jmlRT;
  final String jmlRumah;
  final String jmlJiwa;
  final String estimasiTimbulan;

  // Data Sorting Stats
  final String persenRumahMemilah;
  final String jmlRumahMemilah;
  final double progressRumahMemilah;
  final String persenRumahNasabah;
  final String jmlRumahNasabah;
  final double progressRumahNasabah;

  // Data Volume Sampah (buat circular chart)
  final double volumeOrganik;
  final double volumeAnorganik;
  final double volumeB3;
  
  // Data Bank Sampah
  final String statusBankSampah;

  // Data Grafik
  final List<FlSpot> accumulationData;
  final List<FlSpot> checkPerMonthData;

  // Data Neraca Sampah
  final String neracaSampah;

  @override
  List<Object?> get props => [
        kelurahan, rw, pendamping, jmlRT, jmlRumah, jmlJiwa, estimasiTimbulan,
        persenRumahMemilah, jmlRumahMemilah, progressRumahMemilah,
        persenRumahNasabah, jmlRumahNasabah, progressRumahNasabah,
        volumeOrganik, volumeAnorganik, volumeB3, statusBankSampah,
        accumulationData, checkPerMonthData, neracaSampah,
      ];

  factory DashboardData.getStaticData() {
    return DashboardData(
      // Header
      kelurahan: 'Kelurahan Grogol',
      rw: 'RW 7',
      pendamping: 'Rhafael Pahala',
      
      // Grid Stats
      jmlRT: '15',
      jmlRumah: '428',
      jmlJiwa: '2383',
      estimasiTimbulan: '1,611.08',
      
      // Sorting Stats
      persenRumahMemilah: '0.23%',
      jmlRumahMemilah: '1',
      progressRumahMemilah: 0.0023,
      persenRumahNasabah: '0%',
      jmlRumahNasabah: '0',
      progressRumahNasabah: 0.0,
      
      // Volume (masih 0 semua)
      volumeOrganik: 0.0,
      volumeAnorganik: 0.0,
      volumeB3: 0.0,
      
      // Bank Sampah
      statusBankSampah: 'Belum ada bank sampah',
      
      // Chart Data
      accumulationData: const [
        FlSpot(0, 8000), FlSpot(1, 9000), FlSpot(2, 9000),
        FlSpot(3, 9200), FlSpot(4, 18000), FlSpot(5, 19000),
        FlSpot(6, 19000), FlSpot(7, 19000),
      ],
      checkPerMonthData: const [
        FlSpot(0, 8000), FlSpot(1, 6000), FlSpot(2, 7000),
        FlSpot(3, 5000), FlSpot(4, 4000), FlSpot(5, 3000),
        FlSpot(6, 2500), FlSpot(7, 2000),
      ],

      // Neraca
      neracaSampah: '1,611.08 kg',
    );
  }

  List<double> get wastePercentages => [volumeOrganik, volumeAnorganik, volumeB3];
  List<String> get wasteKgs => [
    '${(volumeOrganik * 100).toStringAsFixed(0)}', 
    '${(volumeAnorganik * 100).toStringAsFixed(0)}', 
    '${(volumeB3 * 100).toStringAsFixed(0)}' 
  ];
  List<Color> get lineColors => [AppColors.red.normal, AppColors.blue.normal];
  List<String> get bottomChartTitles => const [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep'
  ];
}