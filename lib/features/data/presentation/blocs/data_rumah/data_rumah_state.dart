import 'package:equatable/equatable.dart';
import '../../../domain/entities/data_rumah.dart'; 

enum DataRumahStatus { initial, loading, success, failure }
class DataRumahState extends Equatable {
  const DataRumahState({
    required this.status,
    required this.allDataRumah,
    required this.filteredDataRumah,
    required this.selectedStatus,
    required this.selectedRT,
    required this.statusOptions,
    required this.rtOptions,
    this.errorMessage,
  });

  final DataRumahStatus status;
  final List<DataRumah> allDataRumah; 
  final List<DataRumah> filteredDataRumah;
  final String? errorMessage;
  final String selectedStatus;
  final String selectedRT;
  final List<String> statusOptions;
  final List<String> rtOptions;
  factory DataRumahState.initial() {
    return const DataRumahState(
      status: DataRumahStatus.initial,
      allDataRumah: [],
      filteredDataRumah: [],
      errorMessage: null,
      selectedStatus: 'Semua Status',
      selectedRT: 'Semua RT',
      statusOptions: ['Semua Status', 'Aktif', 'Tidak Aktif', 'Sudah Checklist', 'Belum Checklist'],
      rtOptions: ['Semua RT'],
    );
  }

  DataRumahState copyWith({
    DataRumahStatus? status,
    List<DataRumah>? allDataRumah,
    List<DataRumah>? filteredDataRumah,
    String? errorMessage,
    String? selectedStatus,
    String? selectedRT,
    List<String>? rtOptions,
  }) {
    return DataRumahState(
      status: status ?? this.status,
      allDataRumah: allDataRumah ?? this.allDataRumah,
      filteredDataRumah: filteredDataRumah ?? this.filteredDataRumah,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedRT: selectedRT ?? this.selectedRT,
      statusOptions: this.statusOptions, 
      rtOptions: rtOptions ?? this.rtOptions,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allDataRumah,
        filteredDataRumah,
        errorMessage,
        selectedStatus,
        selectedRT,
        rtOptions
      ];
}