part of 'sudah_verif_cubit.dart';

enum VerifiedChecklistStatus { initial, loading, success, failure }

class VerifiedChecklistState extends Equatable {
  final VerifiedChecklistStatus status;
  final List<VerifiedChecklist> listData;
  final List<VerifiedChecklist> filteredListData;
  final String selectedBulan;
  final String selectedTahun;
  final List<String> listBulan;
  final List<String> listTahun;
  final String? errorMessage;

  const VerifiedChecklistState({
    this.status = VerifiedChecklistStatus.initial,
    this.listData = const [],
    this.filteredListData = const [],
    this.selectedBulan = 'Semua Bulan',
    this.selectedTahun = '2025',
    this.listBulan = const ['Semua Bulan', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'],
    this.listTahun = const ['2025', '2024', '2023'],
    this.errorMessage,
  });

  VerifiedChecklistState copyWith({
    VerifiedChecklistStatus? status,
    List<VerifiedChecklist>? listData,
    List<VerifiedChecklist>? filteredListData,
    String? selectedBulan,
    String? selectedTahun,
    List<String>? listBulan,
    List<String>? listTahun,
    String? errorMessage,
  }) {
    return VerifiedChecklistState(
      status: status ?? this.status,
      listData: listData ?? this.listData,
      filteredListData: filteredListData ?? this.filteredListData,
      selectedBulan: selectedBulan ?? this.selectedBulan,
      selectedTahun: selectedTahun ?? this.selectedTahun,
      listBulan: listBulan ?? this.listBulan,
      listTahun: listTahun ?? this.listTahun,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        listData,
        filteredListData,
        selectedBulan,
        selectedTahun,
        listBulan,
        listTahun,
        errorMessage,
      ];
}