import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw e;
    }
  }
}
