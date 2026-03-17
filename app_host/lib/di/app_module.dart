import 'package:dependency/dependency.dart';

import '../cubit/app_cubit.dart';

@module
abstract class AppModule {
  /// SharedPreferences - resolved async before app starts
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  /// Dio HTTP client - configured with timeouts and logging
  @singleton
  Dio get dio => Dio()
    ..options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    )
    ..interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    ]);

  @factory
  AppCubit appCubit(SharedPreferences prefs) => AppCubit(prefs);
}
