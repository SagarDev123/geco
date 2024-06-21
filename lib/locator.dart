import 'package:geco/repository/remotedatarepository.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;
void setUp() {
  locator.registerLazySingleton<RemoteDataRepository>(
      () => RemoteDataRepository());
}
