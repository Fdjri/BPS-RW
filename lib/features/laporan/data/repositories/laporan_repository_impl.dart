import '../../domain/repositories/laporan_repository.dart';

class LaporanRepositoryImpl implements LaporanRepository {
  const LaporanRepositoryImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw e;
    }
  }
}
