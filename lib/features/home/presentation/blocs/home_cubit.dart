import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/presentation/utils/app_colors.dart';
import '../../domain/entities/dashboard_data.dart'; 

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  Future<void> fetchDashboardData() async {
    emit(state.copyWith(status: HomeStatus.loading));
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      final data = DashboardData.getStaticData();
      emit(state.copyWith(
        status: HomeStatus.success,
        dashboardData: data,
      ));
      
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: 'Gagal memuat data dashboard.',
      ));
    }
  }
}