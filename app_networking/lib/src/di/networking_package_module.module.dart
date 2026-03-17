//@GeneratedMicroModule;AppNetworkingPackageModule;package:app_networking/src/di/networking_package_module.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:app_networking/src/client/api_client.dart' as _i281;
import 'package:app_networking/src/di/networking_di_module.dart' as _i991;
import 'package:dependency/dependency.dart' as _i90;
import 'package:injectable/injectable.dart' as _i526;

class AppNetworkingPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    final networkingDiModule = _$NetworkingDiModule();
    gh.singleton<_i90.Dio>(() => networkingDiModule.dio);
    gh.singleton<_i281.ApiClient>(
        () => networkingDiModule.apiClient(gh<_i90.Dio>()));
  }
}

class _$NetworkingDiModule extends _i991.NetworkingDiModule {}
