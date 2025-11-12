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
  final List<String> listRT;
  final String? errorMessage;

  const ChecklistInputState({
    this.status = ChecklistInputStatus.initial,
    this.listRumah = const [],
    this.filteredListRumah = const [],
    this.selectedRT = 'Semua RT',
    this.listRT = const ['Semua RT', '001', '002', '003'], 
    this.errorMessage,
  });

  ChecklistInputState copyWith({
    ChecklistInputStatus? status,
    List<RumahChecklist>? listRumah,
    List<RumahChecklist>? filteredListRumah,
    String? selectedRT,
    List<String>? listRT,
    String? errorMessage,
  }) {
    return ChecklistInputState(
      status: status ?? this.status,
      listRumah: listRumah ?? this.listRumah,
      filteredListRumah: filteredListRumah ?? this.filteredListRumah,
      selectedRT: selectedRT ?? this.selectedRT,
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
        listRT,
        errorMessage,
      ];
}