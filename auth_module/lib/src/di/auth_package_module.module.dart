//@GeneratedMicroModule;AuthModulePackageModule;package:auth_module/src/di/auth_package_module.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:auth_module/src/data/datasource/auth_remote_datasource.dart'
    as _i270;
import 'package:auth_module/src/data/repository/auth_repository.dart' as _i895;
import 'package:auth_module/src/di/auth_di_module.dart' as _i598;
import 'package:auth_module/src/presentation/cubit/auth_cubit.dart' as _i945;
import 'package:auth_module/src/service/token_service.dart' as _i402;
import 'package:dependency/dependency.dart' as _i90;
import 'package:injectable/injectable.dart' as _i526;

class AuthModulePackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    final authDiModule = _$AuthDiModule();
    gh.lazySingleton<_i402.TokenService>(
        () => authDiModule.tokenService(gh<_i90.FlutterSecureStorage>()));
    gh.lazySingleton<_i270.AuthRemoteDataSource>(
        () => authDiModule.authRemoteDataSource(gh<_i90.Dio>()));
    gh.lazySingleton<_i895.AuthRepository>(() => authDiModule.authRepository(
          gh<_i270.AuthRemoteDataSource>(),
          gh<_i402.TokenService>(),
        ));
    gh.factory<_i945.AuthCubit>(
        () => authDiModule.authCubit(gh<_i895.AuthRepository>()));
  }
}

class _$AuthDiModule extends _i598.AuthDiModule {}
