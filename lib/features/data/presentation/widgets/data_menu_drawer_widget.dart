import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/presentation/utils/app_colors.dart';

class DataMenuDrawer extends StatelessWidget {
  const DataMenuDrawer({
    super.key,
    this.activeRoute,
  });
  final String? activeRoute;

  static const String dataRoute = '/data';
  static const String potensiRoute = '/data-potensi';
  static const String sampahRoute = '/data-sampah';


  @override
  Widget build(BuildContext context) {
    final String? currentRoute = activeRoute ?? ModalRoute.of(context)?.settings.name;

    return Drawer(
      backgroundColor: AppColors.white.normal, 
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            child: Text(
              'Menu Data',
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
            icon: LucideIcons.database,  
            text: 'Data Rumah Lama',
            subtitle: 'Daftar rumah terdaftar',
            isSelected: currentRoute == dataRoute,
            onTap: () {
              Navigator.pop(context);
              if (currentRoute != dataRoute) {
                Navigator.pushReplacementNamed(context, dataRoute);
              }
            },
          ),

          _buildMenuItem(
            context,
            icon: LucideIcons.trendingUp,
            text: 'Potensi Rumah',
            subtitle: 'Rumah berpotensi bergabung',
            isSelected: currentRoute == potensiRoute,
            onTap: () {
              Navigator.pop(context);
              if (currentRoute != potensiRoute) {
                Navigator.pushReplacementNamed(context, potensiRoute);
              }
            },
          ),

          _buildMenuItem(
            context,
            icon: LucideIcons.trash2,
            text: 'Data Berat Sampah',
            subtitle: 'Riwayat berat sampah',
            isSelected: currentRoute == sampahRoute,
            onTap: () {
              Navigator.pop(context);
              if (currentRoute != sampahRoute) {
                Navigator.pushReplacementNamed(context, sampahRoute);
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
    final Color contentColor = isSelected ? AppColors.white.normal : AppColors.black.lightActive; 
    final Color subtitleColor = isSelected ? AppColors.white.normal.withOpacity(0.7) : AppColors.black.normal.withOpacity(0.54); 

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: Icon(icon, color: contentColor),
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
