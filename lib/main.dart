import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'core/presentation/utils/app_colors.dart';
import 'core/presentation/widgets/custom_bottom_navbar.dart';
import 'features/login/presentation/pages/login_page.dart';
import 'features/checklist/presentation/blocs/checklist/checklist_input_cubit.dart';
import 'features/checklist/presentation/pages/checklist_page.dart';
import 'features/checklist/presentation/pages/belum_verif_page.dart';
import 'features/checklist/presentation/pages/sudah_verif_page.dart';
import 'features/data/presentation/pages/data_page.dart';
import 'features/data/presentation/pages/potensi_rumah_page.dart';
import 'features/data/presentation/pages/data_berat_sampah_page.dart';
import 'features/laporan/presentation/pages/laporan_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => di.sl<ChecklistInputCubit>())],
      child: MaterialApp(
        title: 'Aplikasi BPS',
        theme: ThemeData(
          primaryColor: AppColors.blue.normal,
          colorScheme: ColorScheme.light(
            primary: AppColors.blue.normal,
            secondary: AppColors.blue.normal,
          ),
          fontFamily: 'InstrumentSans',
          textTheme: ThemeData().textTheme.apply(fontFamily: 'InstrumentSans'),
          scaffoldBackgroundColor: AppColors.white.light,
        ),
        debugShowCheckedModeBanner: false,

        initialRoute: '/',

        routes: {
          '/': (context) => const LoginPage(),
          '/home': (context) => const CustomBottomNavbar(initialIndex: 0),
          DataPage.routeName: (context) =>
              const CustomBottomNavbar(initialIndex: 1),
          ChecklistPage.routeName: (context) =>
              const CustomBottomNavbar(initialIndex: 2),
          LaporanPage.routeName: (context) =>
              const CustomBottomNavbar(initialIndex: 3),
          ProfilePage.routeName: (context) =>
              const CustomBottomNavbar(initialIndex: 4),
          BelumVerifikasiPage.routeName: (context) =>
              const BelumVerifikasiPage(),
          SudahVerifikasiPage.routeName: (context) =>
              const SudahVerifikasiPage(),
          DataPotensiRumahPage.routeName: (context) =>
              const DataPotensiRumahPage(),
          DataBeratSampahPage.routeName: (context) =>
              const DataBeratSampahPage(),
        },
      ),
    );
  }
}
