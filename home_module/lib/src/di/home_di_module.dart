import 'package:dependency/dependency.dart';

import '../data/repository/home_repository.dart';
import '../data/repository/home_repository_impl.dart';
import '../presentation/cubit/home_cubit.dart';

@module
abstract class HomeDiModule {
  @lazySingleton
  HomeRepository homeRepository(Dio dio) => HomeRepositoryImpl(dio);

  @factory
  HomeCubit homeCubit(HomeRepository repository) => HomeCubit(repository);
}
