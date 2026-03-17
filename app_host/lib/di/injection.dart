import 'package:dependency/dependency.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies.
///
/// Uses injectable's generated code to register:
/// - AppModule: SharedPreferences (async), Dio
/// - AuthDiModule: FlutterSecureStorage, TokenService, AuthRepository, AuthCubit
///
/// Run `flutter pub run build_runner build` to regenerate [injection.config.dart].
@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
