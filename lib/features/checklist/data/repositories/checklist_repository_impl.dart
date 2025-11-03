import '../../domain/repositories/checklist_repository.dart';

class ChecklistRepositoryImpl implements ChecklistRepository {
  const ChecklistRepositoryImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw e;
    }
  }
}
