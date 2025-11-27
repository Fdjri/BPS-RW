import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/presentation/utils/app_colors.dart';
// Import pages untuk akses routeName static agar konsisten
import '../pages/data_page.dart';
import '../pages/potensi_rumah_page.dart';
import '../pages/data_berat_sampah_page.dart';

class DataMenuDrawer extends StatelessWidget {
  const DataMenuDrawer({
    super.key,
    this.activeRoute,
  });
  final String? activeRoute;

  // Gunakan routeName dari masing-masing Page
  static const String dataRoute = DataPage.routeName;
  static const String potensiRoute = DataPotensiRumahPage.routeName;
  static const String sampahRoute = DataBeratSampahPage.routeName;

  @override
  Widget build(BuildContext context) {
    // Ambil current route dengan aman
    String currentRoute = activeRoute ?? '';
    if (currentRoute.isEmpty) {
      try {
        currentRoute = ModalRoute.of(context)?.settings.name ?? '';
      } catch (_) {}
    }

    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      // Border radius di ujung kanan agar tidak kaku
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
                // Logo Kecil
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.blue.light.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(LucideIcons.database, color: AppColors.blue.normal, size: 24),
                ),
                const SizedBox(height: 16),
                
                // Judul Menu
                Text(
                  'Menu Data',
                  style: TextStyle(
                    fontFamily: 'InstrumentSans', 
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black.normal,
                  ),
                ),
                const SizedBox(height: 4),
                
                // Subtitle
                Text(
                  'Kelola database RW',
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
                  icon: LucideIcons.database,  
                  text: 'Data Rumah Lama',
                  subtitle: 'Daftar rumah terdaftar',
                  isSelected: currentRoute == dataRoute,
                  // Navigasi ke Tab Utama (DataPage) -> Pakai pushReplacementNamed
                  onTap: () => _navigate(context, dataRoute, currentRoute, isTabMainPage: true),
                ),
                const SizedBox(height: 4),

                _buildMenuItem(
                  context,
                  icon: LucideIcons.trendingUp,
                  text: 'Potensi Rumah',
                  subtitle: 'Rumah berpotensi bergabung',
                  isSelected: currentRoute == potensiRoute,
                  // Navigasi ke Sub-Page (Fullscreen) -> Pakai pushNamed
                  onTap: () => _navigate(context, potensiRoute, currentRoute, isTabMainPage: false),
                ),
                const SizedBox(height: 4),

                _buildMenuItem(
                  context,
                  icon: LucideIcons.trash2,
                  text: 'Data Berat Sampah',
                  subtitle: 'Riwayat berat sampah',
                  isSelected: currentRoute == sampahRoute,
                  // Navigasi ke Sub-Page (Fullscreen) -> Pakai pushNamed
                  onTap: () => _navigate(context, sampahRoute, currentRoute, isTabMainPage: false),
                ),
              ],
            ),
          ),
          
          // --- FOOTER ---
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              "Versi 1.0.0",
              style: TextStyle(
                fontFamily: 'InstrumentSans',
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- FUNGSI NAVIGASI AMAN (ANTI-FREEZE) ---
  void _navigate(BuildContext context, String targetRoute, String currentRoute, {required bool isTabMainPage}) {
    // 1. Tutup Drawer DULU
    Navigator.of(context).pop(); 

    // 2. Cek apakah route tujuan SAMA dengan route sekarang?
    if (targetRoute == currentRoute) {
      return; // Stop, gak perlu ngapa-ngapain
    }

    // 3. Delay sedikit biar animasi drawer selesai & state aman
    Future.delayed(const Duration(milliseconds: 300), () {
      if (context.mounted) {
        if (isTabMainPage) {
          // Kalau balik ke Menu Utama Tab (Data Page), pake pushReplacementNamed
          // Ini akan me-reset stack dan kembali ke Navbar
          Navigator.of(context).pushReplacementNamed(targetRoute);
        } else {
          // Kalau ke Sub-Page (Potensi/Sampah), pake pushNamed biasa dengan rootNavigator
          // Biar halaman baru menumpuk di atas (fullscreen) dan punya tombol BACK
          Navigator.of(context, rootNavigator: true).pushNamed(targetRoute);
        }
      }
    });
  }

  // --- ITEM MENU STYLE BARU (Sama dengan ChecklistDrawer) ---
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    // Warna Text & Icon (Putih kalau aktif, Hitam/Abu kalau nggak)
    final Color titleColor = isSelected ? AppColors.white.light : AppColors.black.normal.withOpacity(0.8);
    final Color subtitleColor = isSelected ? AppColors.white.light.withOpacity(0.8) : Colors.grey[500]!;
    final Color iconColor = isSelected ? AppColors.white.light : Colors.grey[400]!;
    
    // Warna Background Block (Biru solid kalau aktif, transparan kalau nggak)
    final Color bgColor = isSelected ? AppColors.blue.normal : Colors.transparent;

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
                      text,
                      style: TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
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