import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/rumah_checklist.dart';
import '../repositories/checklist_repository.dart';

class GetInputChecklist {
  final ChecklistRepository repository;

  GetInputChecklist(this.repository);

  Future<Either<Failure, List<RumahChecklist>>> call() async {
    // Panggil method yang didefinisikan di interface tadi
    return await repository.getInputChecklist();
  }
}