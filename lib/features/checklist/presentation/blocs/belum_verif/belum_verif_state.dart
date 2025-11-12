part of 'belum_verif_cubit.dart';

enum UnverifiedChecklistStatus { initial, loading, success, failure }

class UnverifiedChecklistState extends Equatable {
  final UnverifiedChecklistStatus status;
  final List<UnverifiedChecklist> listData;
  final List<UnverifiedChecklist> filteredListData;
  final String selectedBulan;
  final String selectedTahun;
  final List<String> listBulan;
  final List<String> listTahun;
  final String? errorMessage;

  const UnverifiedChecklistState({
    this.status = UnverifiedChecklistStatus.initial,
    this.listData = const [],
    this.filteredListData = const [],
    this.selectedBulan = 'Semua Bulan',
    this.selectedTahun = '2025',
    this.listBulan = const ['Semua Bulan', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'],
    this.listTahun = const ['2025', '2024', '2023'],
    this.errorMessage,
  });

  UnverifiedChecklistState copyWith({
    UnverifiedChecklistStatus? status,
    List<UnverifiedChecklist>? listData,
    List<UnverifiedChecklist>? filteredListData,
    String? selectedBulan,
    String? selectedTahun,
    List<String>? listBulan,
    List<String>? listTahun,
    String? errorMessage,
  }) {
    return UnverifiedChecklistState(
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