import 'package:get_it/get_it.dart';
import 'package:simple_to_do/data/database_service.dart';
import 'package:simple_to_do/data/to_do_service.dart';
import 'package:simple_to_do/view/cubit/to_dos_cubit.dart';

final getIt = GetIt.instance;

void init() {
  getIt.registerSingleton(() => ToDosCubit(toDoService: getIt()));

  getIt.registerLazySingleton(() => ToDoService(getIt()));

  getIt.registerLazySingleton<DatabaseService>(() => DatabaseService());
}
