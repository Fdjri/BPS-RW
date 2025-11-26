import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/rumah_checklist.dart'; 
import '../../domain/repositories/checklist_repository.dart';
import '../data_sources/checklist_remote_data_source.dart';

class ChecklistRepositoryImpl implements ChecklistRepository {
  final ChecklistRemoteDataSource remoteDataSource;

  ChecklistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<RumahChecklist>>> getInputChecklist() async {
    try {
      final remoteChecklist = await remoteDataSource.getInputChecklist();
      
      return Right(remoteChecklist);
      
    } on ServerException {
      return const Left(ServerFailure('Gagal terhubung ke server'));
    } on SocketException {
      return const Left(NetworkFailure('Tidak ada koneksi internet'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}