part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.dashboardData,
    this.errorMessage,
  });

  final HomeStatus status;
  final DashboardData? dashboardData;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    DashboardData? dashboardData,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      dashboardData: dashboardData ?? this.dashboardData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, dashboardData, errorMessage];
}