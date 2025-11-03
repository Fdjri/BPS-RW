import 'data_remote_data_source.dart';

class DataRemoteDataSourceImpl implements DataRemoteDataSource {
  const DataRemoteDataSourceImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw e;
    }
  }
}
