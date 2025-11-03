import '../../domain/repositories/data_repository.dart';

class DataRepositoryImpl implements DataRepository {
  const DataRepositoryImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw e;
    }
  }
}
