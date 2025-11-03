import 'package:flutter/material.dart';
import '../../../../core/presentation/utils/app_colors.dart';
import '../pages/profile_page.dart';

class ProfileSwitchWidget extends StatelessWidget {
  final ProfileType currentType;
  final Function(ProfileType) onChanged;

  const ProfileSwitchWidget({
    super.key,
    required this.currentType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.white.normal,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.normal.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSwitchButton(
            label: 'Profile RW',
            type: ProfileType.rw,
          ),
          _buildSwitchButton(
            label: 'Profile BPS-RW',
            type: ProfileType.bpsRw,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchButton({
    required String label,
    required ProfileType type,
  }) {
    final bool isSelected = currentType == type;

    return Expanded(
      child: InkWell(
        onTap: () => onChanged(type),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), 
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blue.normal : AppColors.white.normal,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_outline,
                size: 18,
                color: isSelected ? AppColors.white.normal : AppColors.blue.normal,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                  color: isSelected ? AppColors.white.normal : AppColors.blue.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

