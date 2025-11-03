import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/presentation/utils/app_colors.dart';
import '../pages/checklist_page.dart'; 
import '../pages/belum_verif_page.dart'; 
import '../pages/sudah_verif_page.dart'; 

class ChecklistMenuDrawerWidget extends StatelessWidget {
  const ChecklistMenuDrawerWidget({
    super.key,
    this.activeRoute,
  });
  final String? activeRoute;

  static const String inputHarianRoute = ChecklistPage.routeName;
  static const String belumVerifikasiRoute = BelumVerifikasiPage.routeName;
  static const String sudahVerifikasiRoute = SudahVerifikasiPage.routeName; 

  @override
  Widget build(BuildContext context) {
    final String? currentRoute = activeRoute ?? ModalRoute.of(context)?.settings.name;

    return Drawer(
      backgroundColor: AppColors.white.light,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            child: Text(
              'Menu Checklist',
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.black.normal,
              ),
            ),
          ),

          _buildMenuItem(
            context,
            icon: LucideIcons.clipboardEdit,
            text: 'Input Harian',
            subtitle: 'Masukkan data checklist harian',
            isSelected: currentRoute == inputHarianRoute,
            onTap: () {
              Navigator.pop(context); 
              if (currentRoute != inputHarianRoute) {
                Navigator.pushReplacementNamed(context, inputHarianRoute);
              }
            },
          ),

          _buildMenuItem(
            context,
            icon: LucideIcons.clock,
            text: 'Belum di Verifikasi',
            subtitle: 'Data menunggu verifikasi',
            isSelected: currentRoute == belumVerifikasiRoute,
            onTap: () {
              Navigator.pop(context);
              if (currentRoute != belumVerifikasiRoute) {
                 Navigator.pushReplacementNamed(context, belumVerifikasiRoute);
              }
            },
          ),

           _buildMenuItem(
            context,
            icon: LucideIcons.checkCircle2, 
            text: 'Sudah Diverifikasi',
            subtitle: 'Data telah terverifikasi',
            isSelected: currentRoute == sudahVerifikasiRoute,
            onTap: () {
              Navigator.pop(context);
              if (currentRoute != sudahVerifikasiRoute) {
                Navigator.pushReplacementNamed(context, sudahVerifikasiRoute);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final Color bgColor = isSelected ? AppColors.blue.normal : Colors.transparent;
    final Color contentColor = isSelected ? AppColors.white.light : AppColors.blue.dark;
    final Color subtitleColor = isSelected ? AppColors.white.normal.withOpacity(0.7) : AppColors.black.normal.withOpacity(0.6);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(12), 
        clipBehavior: Clip.antiAlias, 
        child: ListTile(
          leading: Icon(icon, color: contentColor, size: 22), 
          title: Text(
            text,
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              color: contentColor,
              fontWeight: FontWeight.bold 
            )
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              color: subtitleColor, 
              fontSize: 12
            )
          ),
          onTap: onTap,
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}

