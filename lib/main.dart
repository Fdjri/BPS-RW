import 'package:flutter/material.dart';
import 'features/login/presentation/pages/login_page.dart';
import 'core/presentation/utils/app_colors.dart';
import 'features/home/presentation/pages/main_page.dart';
import 'package:bps_rw/features/data/presentation/pages/data_page.dart';
import 'package:bps_rw/features/data/presentation/pages/potensi_rumah_page.dart';
import 'package:bps_rw/features/data/presentation/pages/data_berat_sampah_page.dart';
import 'features/checklist/presentation/pages/checklist_page.dart';
import 'features/checklist/presentation/pages/belum_verif_page.dart';
import 'features/checklist/presentation/pages/sudah_verif_page.dart';
import 'features/laporan/presentation/pages/laporan_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi BPS',
      theme: ThemeData(
        primaryColor: AppColors.blue.normal,
        colorScheme: ColorScheme.light(
          primary: AppColors.blue.normal,
          secondary: AppColors.blue.normal,
        ),
        fontFamily: 'InstrumentSans', 
        textTheme: ThemeData().textTheme.apply(
          fontFamily: 'InstrumentSans',
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const MainPage(),

        // --- Checklist Routes ---
        ChecklistPage.routeName: (context) => const ChecklistPage(),
        BelumVerifikasiPage.routeName: (context) => const BelumVerifikasiPage(), 
        SudahVerifikasiPage.routeName: (context) => const SudahVerifikasiPage(),

        // --- Data Routes ---
        DataPage.routeName: (context) => const DataPage(), 
        DataPotensiRumahPage.routeName: (context) => const DataPotensiRumahPage(), 
        DataBeratSampahPage.routeName: (context) => const DataBeratSampahPage(), 

        // --- Laporan Route ---
        LaporanPage.routeName: (context) => const LaporanPage(),

        // --- Profile Route ---
        ProfilePage.routeName: (context) => const ProfilePage(),
      },
    );
  }
}
