import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:bps_rw/core/presentation/utils/app_colors.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: AppColors.white.normal,
      clipBehavior: Clip.none,
      child: Container(
        clipBehavior: Clip.none,
        height: 70 + MediaQuery.of(context).viewPadding.bottom,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          8,
          8,
          8,
          8 + MediaQuery.of(context).viewPadding.bottom,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              icon: LucideIcons.home,
              label: 'Home',
              index: 0,
            ),
            _buildNavItem(
              context: context,
              icon: LucideIcons.database,
              label: 'Data',
              index: 1,
            ),
            _buildNavItem(
              context: context,
              icon: LucideIcons.checkCircle2,
              label: 'Checklist',
              index: 2,
            ),
            _buildNavItem(
              context: context,
              icon: LucideIcons.clipboardList,
              label: 'Laporan',
              index: 3,
            ),
            _buildNavItem(
              context: context,
              icon: LucideIcons.userCircle2,
              label: 'Profile',
              index: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isCentral = index == 2;
    final bool isSelected = selectedIndex == index;
    final Color bgColor;
    if (isCentral) {
      bgColor = isSelected ? AppColors.blue.dark : AppColors.blue.normal;
    } else {
      bgColor = isSelected ? AppColors.blue.dark : Colors.transparent;
    }
    final bool isHighlighted = bgColor != Colors.transparent;
    final Color contentColor = isHighlighted
        ? AppColors.white.light
        : AppColors.black.lightActive;
    final EdgeInsets padding = isHighlighted
        ? (isCentral
            ? const EdgeInsets.all(8)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 8))
        : const EdgeInsets.all(8);

    final Widget navItem = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: contentColor,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'InstrumentSans',
              color: contentColor,
              fontSize: 10,
              fontWeight: FontWeight.w500, 
              height: 1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    final Widget tappableItem = GestureDetector(
      onTap: () => onItemTapped(index),
      behavior: HitTestBehavior.translucent,
      child: navItem,
    );

    if (isCentral) {
      return Expanded(
        child: Transform.translate(
          offset: const Offset(0, -20),
          child: tappableItem,
        ),
      );
    }

    return Expanded(
      child: tappableItem,
    );
  }
}
