import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/utils/app_colors.dart';
import '../blocs/home_cubit.dart'; 
import '../../domain/entities/dashboard_data.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedWasteTypeIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final username = ModalRoute.of(context)?.settings.arguments as String?;
      if (username != null && mounted) {
        _showWelcomePopup(context, username);
      }
    });
  }

  void _showWelcomePopup(BuildContext context, String username) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: AppColors.white.normal,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/lottie/handshake.json',
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                  onLoaded: (composition) {
                    Future.delayed(composition.duration, () {
                      if (Navigator.canPop(dialogContext)) {
                        Navigator.of(dialogContext).pop();
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Selamat Datang!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: AppColors.black.normal,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  username, 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: AppColors.blue.normal, 
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..fetchDashboardData(),
      child: Scaffold(
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading || 
                state.status == HomeStatus.initial) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.blue.normal,
                ),
              );
            }

            if (state.status == HomeStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errorMessage ?? 'Error!'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeCubit>().fetchDashboardData();
                      }, 
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            if (state.status == HomeStatus.success && state.dashboardData != null) {
              return _buildMainHomePage(state.dashboardData!);
            }
            return const Center(child: Text('State tidak dikenal'));
          },
        ),
      ),
    );
  }

  Widget _buildMainHomePage(DashboardData data) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(data),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.0,
                  children: [
                    _buildStatCard('Jumlah RT', data.jmlRT),
                    _buildStatCard('Jumlah Rumah (unit)', data.jmlRumah),
                    _buildStatCard('Jumlah Jiwa (Orang)', data.jmlJiwa),
                    _buildStatCard(
                      'Estimasi Timbulan',
                      data.estimasiTimbulan,
                      subtitle: '(kg/hari)',
                    ),
                    _buildSortingStatCard(
                      percentage: data.persenRumahMemilah,
                      title: 'Rumah Memilah',
                      count: data.jmlRumahMemilah,
                      progress: data.progressRumahMemilah,
                      color: AppColors.green.normal,
                      backgroundColor: AppColors.green.light,
                    ),
                    _buildSortingStatCard(
                      percentage: data.persenRumahNasabah,
                      title: 'Jumlah Rumah Nasabah',
                      count: data.jmlRumahNasabah,
                      progress: data.progressRumahNasabah,
                      color: AppColors.blue.normal,
                      backgroundColor: AppColors.blue.light,
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),

                _buildSectionTitle('Volume Jenis Sampah'),
                const SizedBox(height: 10),
                _buildWasteVolumeCard(data), 
                const SizedBox(height: 12),
                
                _buildSectionTitle('Bank Sampah'),
                const SizedBox(height: 10),
                _buildWasteBankCard(data), 
                const SizedBox(height: 12),
                
                _buildSectionTitle('Grafik Jumlah Rumah Memilah Per Bulan'),
                const SizedBox(height: 10),
                _buildMonthlyStatsGraphCard(data), 
                const SizedBox(height: 12),

                _buildWasteBalanceCard(data), 
                const SizedBox(height: 100), 
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(DashboardData data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 20),
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
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.white.normal.withOpacity(0.2), 
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.green.normal, 
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          data.kelurahan, 
                          style: TextStyle(
                            fontFamily: 'InstrumentSans', 
                            color: AppColors.white.normal,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    child: Image.asset(
                      'assets/images/logo_bps.png', 
                      width: 30,
                      height: 30,
                      color: AppColors.white.normal,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.business, color: AppColors.white.normal, size: 30);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wilayah',
                        style: TextStyle(
                          fontFamily: 'InstrumentSans', 
                          fontSize: 16,
                          color: AppColors.white.normal, 
                          fontWeight: FontWeight.w400, 
                        ),
                      ),
                      Text(
                        data.rw, 
                        style: TextStyle(
                          fontFamily: 'InstrumentSans', 
                          fontSize: 28,
                          fontWeight: FontWeight.w700, 
                          color: AppColors.white.normal,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.white.normal.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.house_rounded, color: AppColors.white.normal, size: 18),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pendamping',
                              style: TextStyle(
                                fontFamily: 'InstrumentSans', 
                                color: AppColors.white.normal,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              data.pendamping, 
                              style: TextStyle(
                                fontFamily: 'InstrumentSans', 
                                color: AppColors.white.normal,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, {String? subtitle}) {
    return Card(
      margin: EdgeInsets.zero, 
      elevation: 2,
      shadowColor: AppColors.black.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'InstrumentSans', 
                    fontSize: 14, 
                    color: AppColors.white.darker,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'InstrumentSans', 
                        fontSize: 12, 
                        color: AppColors.white.darker,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4), 
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value, 
                style: TextStyle(
                  fontFamily: 'InstrumentSans', 
                  fontSize: 30, 
                  fontWeight: FontWeight.w700,
                  color: AppColors.black.normal.withOpacity(0.85),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortingStatCard({
    required String percentage,
    required String title,
    required String count,
    required double progress,
    required Color color,
    required Color backgroundColor,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shadowColor: AppColors.black.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              percentage, 
              style: TextStyle(
                fontFamily: 'InstrumentSans', 
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title, 
              maxLines: 2, 
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'InstrumentSans', 
                fontSize: 14, 
                color: AppColors.black.normal.withOpacity(0.75),
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(), 
            LinearPercentIndicator(
              padding: EdgeInsets.zero,
              percent: progress, 
              progressColor: color,
              backgroundColor: AppColors.blue.lightActive,
              barRadius: const Radius.circular(10), 
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                count, 
                style: TextStyle(
                  fontFamily: 'InstrumentSans', 
                  fontSize: 16, 
                  color: AppColors.white.darker,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'InstrumentSans', 
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildWasteVolumeCard(DashboardData data) {
    final List<String> wasteTypes = ['Organik', 'Anorganik', 'B3'];
    final List<double> percentages = data.wastePercentages;
    final List<String> kgs = data.wasteKgs;

    return Card(
      elevation: 2,
      shadowColor: AppColors.black.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(wasteTypes.length, (index) {
                bool isSelected = _selectedWasteTypeIndex == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(wasteTypes[index]),
                    labelStyle: TextStyle(
                      fontFamily: 'InstrumentSans', 
                      color: isSelected ? AppColors.white.normal : AppColors.black.normal,
                      fontWeight: FontWeight.w500, 
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedWasteTypeIndex = index;
                        });
                      }
                    },
                    selectedColor: AppColors.green.normal,
                    backgroundColor: AppColors.black.light,
                    showCheckmark: false,
                    shape: StadiumBorder(
                      side: BorderSide(color: AppColors.black.light)
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            CircularPercentIndicator(
              radius: 50.0,
              lineWidth: 10.0,
              percent: percentages[_selectedWasteTypeIndex], 
              center: Text(
                "${kgs[_selectedWasteTypeIndex]} kg", 
                style: const TextStyle(
                  fontFamily: 'InstrumentSans', 
                  fontWeight: FontWeight.w700,
                  fontSize: 16
                ),
              ),
              progressColor: AppColors.green.normal,
              backgroundColor: AppColors.black.light,
            ),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontFamily: 'InstrumentSans', 
                    fontSize: 14, 
                    fontWeight: FontWeight.w700,
                  ),
                ),
                CircularPercentIndicator(
                  radius: 25.0,
                  lineWidth: 6.0,
                  percent: 0.0, 
                  center: const Text(
                    "0 kg",
                    style: TextStyle(
                      fontFamily: 'InstrumentSans', 
                      fontWeight: FontWeight.w700,
                      fontSize: 10
                    ),
                  ),
                  progressColor: AppColors.white.darker,
                  backgroundColor: AppColors.black.light,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWasteBankCard(DashboardData data) {
    return Card(
      elevation: 2,
      shadowColor: AppColors.black.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildLegendItem(AppColors.green.normal, 'Aktif'),
                const SizedBox(width: 20),
                _buildLegendItem(AppColors.red.normal, 'Non Aktif'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, color: AppColors.yellow.normal, size: 30),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: TextStyle(
                        fontFamily: 'InstrumentSans', 
                        fontSize: 12, 
                        color: AppColors.white.darker,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      data.statusBankSampah, 
                      style: const TextStyle(
                        fontFamily: 'InstrumentSans', 
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'InstrumentSans', 
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyStatsGraphCard(DashboardData data) {
    return Card(
      elevation: 2,
      shadowColor: AppColors.black.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jumlah Rumah Memilah Aktif Perbulan',
              style: TextStyle(
                fontFamily: 'InstrumentSans', 
                fontSize: 12,
                color: AppColors.white.darker,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppColors.black.lightActive,
                        strokeWidth: 0.5,
                        dashArray: [5, 5]
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          final titles = data.bottomChartTitles; 
                          if (index >= 0 && index < titles.length) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                titles[index], 
                                style: TextStyle(
                                  fontFamily: 'InstrumentSans', 
                                  color: AppColors.white.darker,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                )
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          if (value % 8000 == 0 && value <= 24000) {
                            return Text(
                              '${(value / 1000).toInt()}k', 
                              style: TextStyle(
                                fontFamily: 'InstrumentSans', 
                                color: AppColors.white.darker,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              )
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: AppColors.black.light),
                  ),
                  minX: 0,
                  maxX: 7,
                  minY: 0,
                  maxY: 24000,
                  lineBarsData: [
                    LineChartBarData(
                      spots: data.accumulationData, 
                      isCurved: true,
                      color: data.lineColors[0], 
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                    LineChartBarData(
                      spots: data.checkPerMonthData, 
                      isCurved: true,
                      color: data.lineColors[1], 
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: AppColors.blue.normal,
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((barSpot) {
                          String text;
                          if (barSpot.barIndex == 0) {
                            text = 'Akumulasi';
                          } else {
                            text = 'Check Perbulan';
                          }
                          return LineTooltipItem(
                            '$text: ${barSpot.y.toStringAsFixed(0)}',
                            TextStyle(
                              fontFamily: 'InstrumentSans', 
                              color: AppColors.white.normal,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(data.lineColors[0], 'Akumulasi'), 
                const SizedBox(width: 20),
                _buildLegendItem(data.lineColors[1], 'Check Perbulan'), 
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWasteBalanceCard(DashboardData data) {
    return Card(
      elevation: 2,
      shadowColor: AppColors.black.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Neraca Sampah (Estimasi Timbulan - Sampah Terkelola) (Harian)',
              style: TextStyle(
                fontFamily: 'InstrumentSans', 
                fontSize: 12,
                color: AppColors.white.darker,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              data.neracaSampah, 
              style: const TextStyle(
                fontFamily: 'InstrumentSans', 
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}