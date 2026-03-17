//@GeneratedMicroModule;HomeModulePackageModule;package:home_module/src/di/home_package_module.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:dependency/dependency.dart' as _i90;
import 'package:home_module/src/data/repository/home_repository.dart' as _i419;
import 'package:home_module/src/di/home_di_module.dart' as _i1013;
import 'package:home_module/src/presentation/cubit/home_cubit.dart' as _i983;
import 'package:injectable/injectable.dart' as _i526;

class HomeModulePackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    final homeDiModule = _$HomeDiModule();
    gh.lazySingleton<_i419.HomeRepository>(
        () => homeDiModule.homeRepository(gh<_i90.Dio>()));
    gh.factory<_i983.HomeCubit>(
        () => homeDiModule.homeCubit(gh<_i419.HomeRepository>()));
  }
}

class _$HomeDiModule extends _i1013.HomeDiModule {}
