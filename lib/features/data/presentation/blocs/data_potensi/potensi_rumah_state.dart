import 'package:equatable/equatable.dart';
import '../../../domain/entities/potensi_rumah.dart';

enum PotensiRumahStatus { initial, loading, success, failure }

class PotensiRumahState extends Equatable {
  const PotensiRumahState({
    required this.status,
    required this.allDataPotensi,
    required this.filteredDataPotensi,
    required this.selectedStatus,
    required this.selectedRT,
    required this.statusOptions,
    required this.rtOptions,
    this.errorMessage,
  });

  final PotensiRumahStatus status;
  final List<PotensiRumah> allDataPotensi; 
  final List<PotensiRumah> filteredDataPotensi;
  final String? errorMessage;
  final String selectedStatus;
  final String selectedRT;
  final List<String> statusOptions;
  final List<String> rtOptions;

  factory PotensiRumahState.initial() {
    return const PotensiRumahState(
      status: PotensiRumahStatus.initial,
      allDataPotensi: [],
      filteredDataPotensi: [],
      errorMessage: null,
      selectedStatus: 'Semua Status',
      selectedRT: 'Semua RT',
      statusOptions: ['Semua Status', 'Potensi', 'Bukan Potensi'],
      rtOptions: ['Semua RT'], 
    );
  }

  PotensiRumahState copyWith({
    PotensiRumahStatus? status,
    List<PotensiRumah>? allDataPotensi,
    List<PotensiRumah>? filteredDataPotensi,
    String? errorMessage,
    String? selectedStatus,
    String? selectedRT,
    List<String>? rtOptions,
  }) {
    return PotensiRumahState(
      status: status ?? this.status,
      allDataPotensi: allDataPotensi ?? this.allDataPotensi,
      filteredDataPotensi: filteredDataPotensi ?? this.filteredDataPotensi,
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
        allDataPotensi,
        filteredDataPotensi,
        errorMessage,
        selectedStatus,
        selectedRT,
        rtOptions
      ];
}