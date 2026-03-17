import 'package:app_networking/app_networking.dart';
import 'package:dependency/dependency.dart';

import '../data/datasource/local/auth_local_datasource.dart';
import '../data/datasource/local/auth_local_datasource_impl.dart';
import '../data/datasource/network/auth_network_datasource.dart';
import '../data/datasource/network/auth_network_datasource_impl.dart';
import '../data/repository/auth_repository.dart';
import '../data/repository/auth_repository_impl.dart';
import '../presentation/cubit/auth_cubit.dart';

@module
abstract class AuthDiModule {
  @Singleton(as: AuthLocalDataSource)
  AuthLocalDataSourceImpl authLocalDataSource(FlutterSecureStorage storage) =>
      AuthLocalDataSourceImpl(storage);

  @lazySingleton
  AuthNetworkDataSource authNetworkDataSource(ApiHandler apiClient) =>
      AuthNetworkDataSourceImpl(apiClient);

  @lazySingleton
  AuthRepository authRepository(
    AuthNetworkDataSource network,
    AuthLocalDataSource local,
    TokenProvider tokenProvider,
  ) =>
      AuthRepositoryImpl(network, local, tokenProvider);

  @factory
  AuthCubit authCubit(AuthRepository repository) => AuthCubit(repository);
}
