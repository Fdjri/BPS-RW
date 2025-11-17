import 'package:flutter/material.dart';
import '../../../../core/presentation/utils/app_colors.dart'; 

Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Text(
      '• $title',
      style: TextStyle(
        fontFamily: 'InstrumentSans',
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: AppColors.black.normal,
      ),
    ),
  );
}

Widget buildReadOnlyTextField(String label, String value,
    {bool isHalfWidth = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'InstrumentSans',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: AppColors.black.darker.withOpacity(0.6),
          ),
        ),
      ),
      const SizedBox(height: 4.0),
      Container(
        width: isHalfWidth ? null : double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white.normal,
          border: Border.all(color: AppColors.black.light),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          value,
          style: TextStyle(
            fontFamily: 'InstrumentSans',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: AppColors.black.darker,
          ),
        ),
      ),
      const SizedBox(height: 16.0),
    ],
  );
}