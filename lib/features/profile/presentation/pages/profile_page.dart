import 'package:flutter/material.dart';
import '../../../../core/presentation/utils/app_colors.dart';
import '../widgets/profile_switch_widget.dart';
import '../widgets/profile_rw_view.dart';
import '../widgets/profile_bps_rw_view.dart';
import 'edit_profile_rw_page.dart';
import 'edit_profile_bps_page.dart';
import '../../../../core/presentation/widgets/custom_bottom_navbar.dart';
import 'package:bps_rw/features/checklist/presentation/pages/checklist_page.dart';
import 'package:bps_rw/features/data/presentation/pages/data_page.dart';
import 'package:bps_rw/features/laporan/presentation/pages/laporan_page.dart';

enum ProfileType { rw, bpsRw }
class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileType _currentProfileType = ProfileType.rw;
  void _changeProfileType(ProfileType newType) {
    setState(() {
      _currentProfileType = newType;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.white.normal,
      bottomNavigationBar: CustomBottomNavbar(
        selectedIndex: 4,
        onItemTapped: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 1) Navigator.pushReplacementNamed(context, DataPage.routeName);
          if (index == 2) Navigator.pushReplacementNamed(context, ChecklistPage.routeName);
          if (index == 3) Navigator.pushReplacementNamed(context, LaporanPage.routeName);
          if (index == 4) {} 
        },
      ),
      
      body: CustomScrollView(
        slivers: [
          _buildHeader(size),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24.0),
                      ProfileSwitchWidget(
                        currentType: _currentProfileType,
                        onChanged: _changeProfileType,
                      ),
                      const SizedBox(height: 24.0),
                      _buildEditProfileButton(),
                      const SizedBox(height: 32.0),
                      _currentProfileType == ProfileType.rw
                          ? const ProfileRWView()
                          : const ProfileBPSRWView(),
                      const SizedBox(height: 120.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return SliverToBoxAdapter(
      child: Container(
        width: size.width,
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
        decoration: BoxDecoration(
          color: AppColors.blue.normal,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.normal.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white.normal.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline,
                color: AppColors.white.normal,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile',
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: AppColors.white.normal,
                  ),
                ),
                Text(
                  'Informasi Profile RW & BPS',
                  style: TextStyle(
                    fontFamily: 'InstrumentSans',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.white.normal.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditProfileButton() {
    final targetPage = _currentProfileType == ProfileType.rw
        ? const EditRWProfilePage()
        : const EditBPSRWProfilePage();

    return Align(
      alignment: Alignment.centerRight,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => targetPage),
          );
        },
        icon: Icon(
          Icons.edit_outlined,
          color: AppColors.blue.normal,
          size: 18,
        ),
        label: Text(
          'EDIT PROFILE',
          style: TextStyle(
            fontFamily: 'InstrumentSans',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.blue.normal,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.blue.normal),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

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

Widget buildReadOnlyTextField(String label, String value, {bool isHalfWidth = false}) {
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
