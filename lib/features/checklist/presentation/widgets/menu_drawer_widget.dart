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
    // Safe access route name
    String currentRoute = activeRoute ?? '';
    if (currentRoute.isEmpty) {
      try {
        currentRoute = ModalRoute.of(context)?.settings.name ?? '';
      } catch (_) {}
    }

    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24), 
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER ---
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.blue.light.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(LucideIcons.clipboardCheck, color: AppColors.blue.normal, size: 24),
                ),
                const SizedBox(height: 16),
                Text(
                  'Menu Checklist',
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black.normal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kelola checklist harian & verifikasi',
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 16),

          // --- LIST MENU ITEMS ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildMenuItem(
                  context,
                  icon: LucideIcons.clipboardEdit,
                  title: 'Input Harian',
                  subtitle: 'Isi data checklist harian',
                  isActive: currentRoute == inputHarianRoute,
                  onTap: () => _navigate(context, inputHarianRoute, currentRoute),
                ),
                const SizedBox(height: 4),
                
                _buildMenuItem(
                  context,
                  icon: LucideIcons.clock,
                  title: 'Belum Diverifikasi',
                  subtitle: 'Menunggu verifikasi',
                  isActive: currentRoute == belumVerifikasiRoute,
                  onTap: () => _navigate(context, belumVerifikasiRoute, currentRoute),
                ),
                const SizedBox(height: 4),
                
                _buildMenuItem(
                  context,
                  icon: LucideIcons.checkCircle2,
                  title: 'Sudah Diverifikasi',
                  subtitle: 'Data yang telah disetujui',
                  isActive: currentRoute == sudahVerifikasiRoute,
                  onTap: () => _navigate(context, sudahVerifikasiRoute, currentRoute),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- FUNGSI NAVIGASI  ---
  void _navigate(BuildContext context, String targetRoute, String currentRoute) {
    // 1. Tutup Drawer
    Navigator.of(context).pop(); 

    if (targetRoute == currentRoute) {
      return; 
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      if (context.mounted) {
        // FIX: Gunakan pushNamed (bukan pushReplacementNamed) biar bisa di-back
        Navigator.of(context, rootNavigator: true).pushNamed(targetRoute);
      }
    });
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final Color titleColor = isActive ? AppColors.white.light : AppColors.black.normal.withOpacity(0.8);
    final Color subtitleColor = isActive ? AppColors.white.light.withOpacity(0.8) : Colors.grey[500]!;
    final Color iconColor = isActive ? AppColors.white.light : Colors.grey[400]!;
    final Color bgColor = isActive ? AppColors.blue.normal : Colors.transparent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: iconColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontSize: 15,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontSize: 11,
                        color: subtitleColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}