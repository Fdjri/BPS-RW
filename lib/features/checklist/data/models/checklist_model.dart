import '../../domain/entities/rumah_checklist.dart';

class ChecklistModel extends RumahChecklist {
  const ChecklistModel({
    required super.id,
    required super.checkDetailId,
    required super.nama,
    required super.alamat,
    required super.rt,
    super.rw,
    required super.sampah,
    required super.fotoUploaded,
  });

  factory ChecklistModel.fromJson(Map<String, dynamic> json) {
    // 1. LOGIC MEMECAH NAMA & ALAMAT
    String rawAlamat = json['alamatNew'] ?? '';
    String parsedNama = 'Warga'; 
    String parsedAlamat = rawAlamat;

    if (rawAlamat.contains(' - (')) {
      final parts = rawAlamat.split(' - (');
      if (parts.length > 1) {
        parsedAlamat = parts[0].trim();
        parsedNama = parts[1].replaceAll(')', '').trim();
      }
    }

    return ChecklistModel(
      id: json['id']?.toString() ?? '',
      checkDetailId: json['checkDetailID']?.toString() ?? '', 
      
      nama: parsedNama,
      alamat: parsedAlamat,
      
      rt: json['rt'] ?? '',
      rw: json['rw'], 
      
      // 2. MAPPING 0/1 KE BOOLEAN MAP
      sampah: {
        'B3': (json['checkB3'] ?? 0) == 1,
        'Residu': (json['checkResidu'] ?? 0) == 1,
        'MT': (json['checkMT'] ?? 0) == 1,
        'MD': (json['checkMD'] ?? 0) == 1,
      },
      
      // 3. CEK FOTO NULL ATAU NGGAK
      fotoUploaded: json['fileUpload'] != null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'checkDetailID': checkDetailId,
      'alamatNew': '$alamat - ($nama)', 
      'rt': rt,
      'rw': rw,
      'checkB3': sampah['B3'] == true ? 1 : 0,
      'checkResidu': sampah['Residu'] == true ? 1 : 0,
      'checkMT': sampah['MT'] == true ? 1 : 0,
      'checkMD': sampah['MD'] == true ? 1 : 0,
    };
  }
}