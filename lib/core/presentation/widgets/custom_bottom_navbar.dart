import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../utils/app_colors.dart';

import '../../../features/home/presentation/pages/main_page.dart'; 
import '../../../features/data/presentation/pages/data_page.dart'; 
import '../../../features/checklist/presentation/pages/checklist_page.dart'; 
import '../../../features/laporan/presentation/pages/laporan_page.dart'; 
import '../../../features/profile/presentation/pages/profile_page.dart'; 

class CustomBottomNavbar extends StatelessWidget {
  final int initialIndex;

  const CustomBottomNavbar({
    super.key,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final PersistentTabController controller = PersistentTabController(initialIndex: initialIndex);

    final double bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return PersistentTabView(
      context,
      controller: controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineToSafeArea: true, 
      backgroundColor: AppColors.white.normal, 
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true, 
      stateManagement: true, 
      padding: EdgeInsets.only(bottom: bottomPadding > 0 ? bottomPadding : 20, top: 10),
      margin: const EdgeInsets.all(0),
      decoration: NavBarDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        colorBehindNavBar: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings( 
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings( 
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
      ),

      navBarStyle: NavBarStyle.style1, 
    );
  }

  List<Widget> _buildScreens() {
    return [
      const MainPage(),      
      const DataPage(),      
      const ChecklistPage(), 
      const LaporanPage(),   
      const ProfilePage(),   
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      _buildItem(LucideIcons.home, "Home"),
      _buildItem(LucideIcons.database, "Data"),
      _buildItem(LucideIcons.clipboardCheck, "Checklist"), 
      _buildItem(LucideIcons.fileText, "Laporan"),
      _buildItem(LucideIcons.user, "Profile"),
    ];
  }

  PersistentBottomNavBarItem _buildItem(IconData icon, String title) {
    return PersistentBottomNavBarItem(
      icon: Icon(
        icon,
        size: 22,
        ),
      title: title,
      activeColorPrimary: AppColors.blue.normal, 
      inactiveColorPrimary: Colors.grey, 
      textStyle: const TextStyle(
        fontFamily: 'InstrumentSans',
        fontWeight: FontWeight.w700,
        fontSize: 12, 
      ),
    );
  }
}