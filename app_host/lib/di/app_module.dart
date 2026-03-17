import 'package:app_networking/app_networking.dart';
import 'package:app_route/app_route.dart';
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

  /// Called by [SessionInterceptor] when the refresh token is expired.
  /// Clears the token cache and redirects to the login screen.
  @Named('session_expired_callback')
  @lazySingleton
  SessionExpiredCallback sessionExpiredCallback(TokenProvider tokenProvider) =>
      SessionExpiredCallback(() {
        tokenProvider.clearToken();
        AppNavigator.toLogin();
      });
}
