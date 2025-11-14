import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import '../../../domain/entities/dokumentasi_laporan.dart';

part 'tambah_laporan_state.dart';

class TambahLaporanCubit extends Cubit<TambahLaporanState> {
  TambahLaporanCubit() : super(const TambahLaporanState());
  final ImagePicker _picker = ImagePicker();
  void init() {
    emit(state.copyWith(
      listDokumentasi: [
        DokumentasiLaporan(
            id: 'doc_1', tanggalPelaksanaan: DateTime.now()),
        DokumentasiLaporan(id: 'doc_2'),
      ],
    ));
  }

  void bulanChanged(String bulan) {
    emit(state.copyWith(selectedBulan: bulan));
  }

  void tahunChanged(String tahun) {
    emit(state.copyWith(selectedTahun: tahun));
  }

  void jumlahRumahChanged(String jumlah) {
    emit(state.copyWith(jumlahRumah: jumlah));
  }

  void keteranganChanged(String id, String keterangan) {
    final newList = state.listDokumentasi.map((doc) {
      if (doc.id == id) {
        return doc.copyWith(keterangan: keterangan);
      }
      return doc;
    }).toList();
    emit(state.copyWith(listDokumentasi: newList));
  }

  void pelaksanaChanged(String id, String pelaksana) {
    final newList = state.listDokumentasi.map((doc) {
      if (doc.id == id) {
        return doc.copyWith(pelaksanaKegiatan: pelaksana);
      }
      return doc;
    }).toList();
    emit(state.copyWith(listDokumentasi: newList));
  }

  void selectDate(String id, DateTime tanggal) {
    final newList = state.listDokumentasi.map((doc) {
      if (doc.id == id) {
        return doc.copyWith(tanggalPelaksanaan: tanggal);
      }
      return doc;
    }).toList();
    emit(state.copyWith(listDokumentasi: newList));
  }

  Future<void> pickImage(String id, ImageSource source) async {
    emit(state.copyWith(status: TambahLaporanStatus.pickingImage));
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1000,
      );
      if (pickedFile == null) {
        emit(state.copyWith(status: TambahLaporanStatus.initial));
        return;
      }
      final fileBytes = await pickedFile.readAsBytes();
      final result = await FlutterImageCompress.compressWithList(
        fileBytes,
        minHeight: 800,
        minWidth: 800,
        quality: 70,
      );
      final tempDir = Directory.systemTemp;
      final targetPath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      File compressedFile = await File(targetPath).writeAsBytes(result);
      double fileSizeInKB = await compressedFile.length() / 1024;
      if (fileSizeInKB > 200) {
        final resultLagi = await FlutterImageCompress.compressWithList(
          result,
          minHeight: 600,
          minWidth: 600,
          quality: 50,
        );
        compressedFile = await File(targetPath).writeAsBytes(resultLagi);
        fileSizeInKB = await compressedFile.length() / 1024; 
      }
      final compressedXFile = XFile(compressedFile.path);
      emit(state.copyWith(
        status: TambahLaporanStatus.imagePreviewReady,
        tempPickedImage: compressedXFile,
        tempImageSizeKB: fileSizeInKB,
        tempImageDocId: id, 
      ));

    } catch (e) {
      emit(state.copyWith(
        status: TambahLaporanStatus.imagePickFailed,
        errorMessage: e.toString(),
      ));
    }
  }

  void saveTempImage() {
    final tempImage = state.tempPickedImage;
    final docId = state.tempImageDocId;
    if (tempImage == null || docId == null) return; 
    final newList = state.listDokumentasi.map((doc) {
      if (doc.id == docId) {
        return doc.copyWith(
          pickedImage: tempImage,
          isPhotoUploaded: true,
        );
      }
      return doc;
    }).toList();
    emit(state.copyWith(
      status: TambahLaporanStatus.imagePickSuccess,
      listDokumentasi: newList,
      clearTempImage: true, 
    ));
  }

  void clearTempImage() {
    emit(state.copyWith(
      status: TambahLaporanStatus.initial,
      clearTempImage: true,
    ));
  }

  void deleteImage(String id) {
    final newList = state.listDokumentasi.map((doc) {
      if (doc.id == id) {
        return doc.copyWith(
          pickedImage: null,
          isPhotoUploaded: false,
          clearPickedImage: true, 
        );
      }
      return doc;
    }).toList();
    emit(state.copyWith(listDokumentasi: newList));
  }

  Future<void> submitLaporan() async {
    emit(state.copyWith(status: TambahLaporanStatus.loading));
    try {
      await Future.delayed(const Duration(seconds: 2));
      print("--- SIMULASI SUBMIT LAPORAN ---");
      print("Bulan: ${state.selectedBulan}");
      print("Tahun: ${state.selectedTahun}");
      print("Jumlah Rumah: ${state.jumlahRumah}");
      for (var doc in state.listDokumentasi) {
        print("  Dok ${doc.id}:");
        print("    Ket: ${doc.keterangan}");
        print("    Tgl: ${doc.tanggalPelaksanaan}");
        print("    Pelaksana: ${doc.pelaksanaKegiatan}");
        print("    Foto: ${doc.pickedImage?.path}");
      }
      print("---------------------------------");
      
      emit(state.copyWith(status: TambahLaporanStatus.success));

    } catch (e) {
      emit(state.copyWith(
        status: TambahLaporanStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}