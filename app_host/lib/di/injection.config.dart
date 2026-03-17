// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app_host/cubit/app_cubit.dart' as _i292;
import 'package:app_host/di/app_module.dart' as _i811;
import 'package:app_networking/app_networking.dart' as _i355;
import 'package:auth_module/auth_module.dart' as _i353;
import 'package:dependency/dependency.dart' as _i90;
import 'package:get_it/get_it.dart' as _i174;
import 'package:home_module/home_module.dart' as _i974;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.factoryAsync<_i90.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.singleton<_i90.FlutterSecureStorage>(() => appModule.secureStorage);
    gh.factory<_i292.AppCubit>(
      () => appModule.appCubit(gh<_i90.SharedPreferences>()),
    );
    await _i355.AppNetworkingPackageModule().init(gh);
    await _i353.AuthModulePackageModule().init(gh);
    await _i974.HomeModulePackageModule().init(gh);
    return this;
  }
}

class _$AppModule extends _i811.AppModule {}
