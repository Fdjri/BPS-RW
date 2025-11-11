import 'package:equatable/equatable.dart';
import '../../../domain/entities/data_rumah.dart';

enum EditRumahStatus {
  initial, 
  submitting, 
  success, 
  failure, 
}

class EditRumahState extends Equatable {
  const EditRumahState({
    required this.status,
    required this.initialDataRumah,
    required this.nama,
    required this.alamat,
    required this.selectedRT,
    required this.rtOptions,
    this.errorMessage,
  });

  final EditRumahStatus status;
  final DataRumah initialDataRumah; 
  final String nama;
  final String alamat;
  final String selectedRT;
  final List<String> rtOptions;
  final String? errorMessage;

  EditRumahState copyWith({
    EditRumahStatus? status,
    String? nama,
    String? alamat,
    String? selectedRT,
    String? errorMessage,
  }) {
    return EditRumahState(
      status: status ?? this.status,
      initialDataRumah: this.initialDataRumah,
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      selectedRT: selectedRT ?? this.selectedRT,
      rtOptions: this.rtOptions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        initialDataRumah,
        nama,
        alamat,
        selectedRT,
        rtOptions,
        errorMessage
      ];
}