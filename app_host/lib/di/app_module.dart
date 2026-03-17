import 'package:dependency/dependency.dart';

import '../cubit/app_cubit.dart';

@module
abstract class AppModule {
  /// SharedPreferences - resolved async before app starts
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @singleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @factory
  AppCubit appCubit(SharedPreferences prefs) => AppCubit(prefs);
}
