import 'package:equatable/equatable.dart';

enum TambahNikCheckStatus {
  initial,
  loading, 
  success, 
  failure, 
}

enum TambahNikSubmitStatus {
  initial, 
  loading, 
  success, 
  failure, 
}

class TambahNikState extends Equatable {
  const TambahNikState({
    required this.checkStatus,
    required this.submitStatus,
    this.checkedData, 
    this.errorMessage,
  });

  final TambahNikCheckStatus checkStatus;
  final TambahNikSubmitStatus submitStatus;
  final Map<String, dynamic>? checkedData;
  final String? errorMessage;

  factory TambahNikState.initial() {
    return const TambahNikState(
      checkStatus: TambahNikCheckStatus.initial,
      submitStatus: TambahNikSubmitStatus.initial,
    );
  }

  TambahNikState copyWith({
    TambahNikCheckStatus? checkStatus,
    TambahNikSubmitStatus? submitStatus,
    Map<String, dynamic>? checkedData,
    String? errorMessage,
  }) {
    return TambahNikState(
      checkStatus: checkStatus ?? this.checkStatus,
      submitStatus: submitStatus ?? this.submitStatus,
      checkedData: checkedData ?? this.checkedData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        checkStatus,
        submitStatus,
        checkedData,
        errorMessage,
      ];
}