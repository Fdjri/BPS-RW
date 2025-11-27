import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/checklist/data/data_sources/checklist_remote_data_source.dart';
import 'features/checklist/data/data_sources/checklist_remote_data_source_impl.dart';
import 'features/checklist/data/repositories/checklist_repository_impl.dart';
import 'features/checklist/domain/repositories/checklist_repository.dart';
import 'features/checklist/domain/use_cases/get_input_checklist.dart';
import 'features/checklist/presentation/blocs/checklist/checklist_input_cubit.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // ! Features - Checklist
  // Bloc / Cubit
  sl.registerFactory(
    () => ChecklistInputCubit(getInputChecklist: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetInputChecklist(sl()));

  // Repository
  sl.registerLazySingleton<ChecklistRepository>(
    () => ChecklistRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ChecklistRemoteDataSource>(
    () => ChecklistRemoteDataSourceImpl(client: sl()),
  );

  // ! External
  sl.registerLazySingleton(() => http.Client());
}