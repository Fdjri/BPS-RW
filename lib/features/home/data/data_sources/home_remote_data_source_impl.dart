import 'home_remote_data_source.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw e;
    }
  }
}
