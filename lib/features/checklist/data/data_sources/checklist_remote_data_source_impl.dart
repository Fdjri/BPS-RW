import 'checklist_remote_data_source.dart';

class ChecklistRemoteDataSourceImpl implements ChecklistRemoteDataSource {
  const ChecklistRemoteDataSourceImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw e;
    }
  }
}
