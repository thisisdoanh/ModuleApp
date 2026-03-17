import 'package:app_networking/app_networking.dart';
import 'package:auth_module/auth_module.dart';
import 'package:dependency/dependency.dart';
import 'package:home_module/home_module.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  externalPackageModulesAfter: [
    ExternalModule(AppNetworkingPackageModule),
    ExternalModule(AuthModulePackageModule),
    ExternalModule(HomeModulePackageModule),
  ],
)
Future<void> configureDependencies() async => getIt.init();
