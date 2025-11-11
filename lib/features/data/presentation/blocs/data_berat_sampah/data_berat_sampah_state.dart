import 'package:equatable/equatable.dart';
import '../../../domain/entities/data_berat_sampah.dart'; 

enum BeratSampahStatus { initial, loading, success, failure }

class BeratSampahState extends Equatable {
  const BeratSampahState({
    required this.status,
    required this.allDataBerat,
    required this.filteredDataBerat,
    this.errorMessage,
    required this.selectedBulan,
    required this.selectedTahun,
    required this.selectedRT,
    required this.bulanOptions,
    required this.tahunOptions,
    required this.rtOptions,
  });

  final BeratSampahStatus status;
  final List<BeratSampah> allDataBerat;
  final List<BeratSampah> filteredDataBerat;
  final String? errorMessage;
  final String selectedBulan;
  final String selectedTahun;
  final String selectedRT;
  final List<String> bulanOptions;
  final List<String> tahunOptions;
  final List<String> rtOptions;

  factory BeratSampahState.initial() {
    const listBulan = [
      'Semua Bulan', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 
      'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    const listTahun = ['2025', '2024', '2023']; 

    return const BeratSampahState(
      status: BeratSampahStatus.initial,
      allDataBerat: [],
      filteredDataBerat: [],
      errorMessage: null,
      selectedBulan: 'Semua Bulan',
      selectedTahun: '2025', 
      selectedRT: 'Semua RT',
      bulanOptions: listBulan,
      tahunOptions: listTahun,
      rtOptions: ['Semua RT'],
    );
  }

  BeratSampahState copyWith({
    BeratSampahStatus? status,
    List<BeratSampah>? allDataBerat,
    List<BeratSampah>? filteredDataBerat,
    String? errorMessage,
    String? selectedBulan,
    String? selectedTahun,
    String? selectedRT,
    List<String>? rtOptions,
  }) {
    return BeratSampahState(
      status: status ?? this.status,
      allDataBerat: allDataBerat ?? this.allDataBerat,
      filteredDataBerat: filteredDataBerat ?? this.filteredDataBerat,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedBulan: selectedBulan ?? this.selectedBulan,
      selectedTahun: selectedTahun ?? this.selectedTahun,
      selectedRT: selectedRT ?? this.selectedRT,
      bulanOptions: this.bulanOptions,
      tahunOptions: this.tahunOptions, 
      rtOptions: rtOptions ?? this.rtOptions, 
    );
  }

  @override
  List<Object?> get props => [
        status,
        allDataBerat,
        filteredDataBerat,
        errorMessage,
        selectedBulan,
        selectedTahun,
        selectedRT,
        rtOptions
      ];
}