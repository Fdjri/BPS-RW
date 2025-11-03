import 'laporan_remote_data_source.dart';

class LaporanRemoteDataSourceImpl implements LaporanRemoteDataSource {
  const LaporanRemoteDataSourceImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw e;
    }
  }
}
