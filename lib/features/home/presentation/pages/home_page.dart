import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../../core/presentation/utils/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedWasteTypeIndex = 0;
  final List<Color> _lineColors = [
    AppColors.red.normal,
    AppColors.blue.normal,
  ];

  final List<FlSpot> _accumulationData = const [
    FlSpot(0, 8000),
    FlSpot(1, 9000),
    FlSpot(2, 9000),
    FlSpot(3, 9200),
    FlSpot(4, 18000),
    FlSpot(5, 19000),
    FlSpot(6, 19000),
    FlSpot(7, 19000),
  ];

  final List<FlSpot> _checkPerMonthData = const [
    FlSpot(0, 8000),
    FlSpot(1, 6000),
    FlSpot(2, 7000),
    FlSpot(3, 5000),
    FlSpot(4, 4000),
    FlSpot(5, 3000),
    FlSpot(6, 2500),
    FlSpot(7, 2000),
  ];

  final List<String> _bottomTitles = const [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep'
  ];


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          
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
                    _buildStatCard('Jumlah RT', '15'),
                    _buildStatCard('Jumlah Rumah (unit)', '428'),
                    _buildStatCard('Jumlah Jiwa (Orang)', '2383'),
                    _buildStatCard(
                      'Estimasi Timbulan',
                      '1,611.08',
                      subtitle: '(kg/hari)',
                    ),
                    _buildSortingStatCard(
                      percentage: '0.23%',
                      title: 'Rumah Memilah',
                      count: '1',
                      progress: 0.0023,
                      color: AppColors.green.normal,
                      backgroundColor: AppColors.green.light,
                    ),
                    _buildSortingStatCard(
                      percentage: '0%',
                      title: 'Jumlah Rumah Nasabah',
                      count: '0',
                      progress: 0.0,
                      color: AppColors.blue.normal,
                      backgroundColor: AppColors.blue.light,
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),

                _buildSectionTitle('Volume Jenis Sampah'),
                const SizedBox(height: 10),
                _buildWasteVolumeCard(),
                const SizedBox(height: 12),
                
                _buildSectionTitle('Bank Sampah'),
                const SizedBox(height: 10),
                _buildWasteBankCard(),
                const SizedBox(height: 12),
                
                _buildSectionTitle('Grafik Jumlah Rumah Memilah Per Bulan'),
                const SizedBox(height: 10),
                _buildMonthlyStatsGraphCard(),
                const SizedBox(height: 12),

                _buildWasteBalanceCard(),
                const SizedBox(height: 100), 
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
                          'Kelurahan Grogol',
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
                        'RW 7',
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
                              'Rhafael Pahala',
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

  Widget _buildWasteVolumeCard() {
    final List<String> wasteTypes = ['Organik', 'Anorganik', 'B3'];
    final List<double> percentages = [0.0, 0.0, 0.0];
    final List<String> kgs = ['0', '0', '0'];

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

  Widget _buildWasteBankCard() {
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
                    const Text(
                      'Belum ada bank sampah',
                      style: TextStyle(
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

  Widget _buildMonthlyStatsGraphCard() {
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
                          if (index >= 0 && index < _bottomTitles.length) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                _bottomTitles[index], 
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
                      spots: _accumulationData,
                      isCurved: true,
                      color: _lineColors[0],
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                    LineChartBarData(
                      spots: _checkPerMonthData,
                      isCurved: true,
                      color: _lineColors[1],
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
                _buildLegendItem(_lineColors[0], 'Akumulasi'),
                const SizedBox(width: 20),
                _buildLegendItem(_lineColors[1], 'Check Perbulan'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWasteBalanceCard() {
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
            const Text(
              '1,611.08 kg',
              style: TextStyle(
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

