import 'package:dependency/dependency.dart';
import '../data/datasource/auth_remote_datasource.dart';
import '../data/repository/auth_repository.dart';
import '../data/repository/auth_repository_impl.dart';
import '../presentation/cubit/auth_cubit.dart';
import '../service/token_service.dart';
import '../service/token_service_impl.dart';

@module
abstract class AuthDiModule {
  @singleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );

  @lazySingleton
  TokenService tokenService(FlutterSecureStorage storage) =>
      TokenServiceImpl(storage);

  @lazySingleton
  AuthRemoteDataSource authRemoteDataSource(Dio dio) =>
      AuthRemoteDataSourceImpl(dio);

  @lazySingleton
  AuthRepository authRepository(
    AuthRemoteDataSource remoteDataSource,
    TokenService tokenService,
  ) =>
      AuthRepositoryImpl(remoteDataSource, tokenService);

  @factory
  AuthCubit authCubit(AuthRepository repository) => AuthCubit(repository);
}
