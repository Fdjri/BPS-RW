part of 'checklist_input_cubit.dart';

enum ChecklistInputStatus {
  initial,
  loading,
  success,
  failure,
  
  uploadingFoto,
  uploadFotoSuccess,
  uploadFotoFailure,
  
  submittingTotal,
  submitTotalSuccess,
  submitTotalFailure
}

class ChecklistInputState extends Equatable {
  final ChecklistInputStatus status;
  final List<RumahChecklist> listRumah;       
  final List<RumahChecklist> filteredListRumah;
  final String selectedRT;
  final String searchQuery;                  
  final List<String> listRT;
  final String? errorMessage;

  const ChecklistInputState({
    this.status = ChecklistInputStatus.initial,
    this.listRumah = const [],
    this.filteredListRumah = const [],
    this.selectedRT = 'Semua RT',
    this.searchQuery = '',                    
    this.listRT = const ['Semua RT'], 
    this.errorMessage,
  });

  ChecklistInputState copyWith({
    ChecklistInputStatus? status,
    List<RumahChecklist>? listRumah,
    List<RumahChecklist>? filteredListRumah,
    String? selectedRT,
    String? searchQuery,
    List<String>? listRT,
    String? errorMessage,
  }) {
    return ChecklistInputState(
      status: status ?? this.status,
      listRumah: listRumah ?? this.listRumah,
      filteredListRumah: filteredListRumah ?? this.filteredListRumah,
      selectedRT: selectedRT ?? this.selectedRT,
      searchQuery: searchQuery ?? this.searchQuery,
      listRT: listRT ?? this.listRT,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status, 
    listRumah, 
    filteredListRumah, 
    selectedRT, 
    searchQuery, 
    listRT, 
    errorMessage
  ];
}