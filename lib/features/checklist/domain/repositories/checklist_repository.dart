import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/rumah_checklist.dart';

abstract class ChecklistRepository {
  Future<Either<Failure, List<RumahChecklist>>> getInputChecklist();
}