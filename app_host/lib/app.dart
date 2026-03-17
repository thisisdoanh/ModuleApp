import 'package:app_localizations/app_localizations.dart';
import 'package:app_route/app_route.dart';
import 'package:auth_module/auth_module.dart';
import 'package:common_ui/common_ui.dart';
import 'package:dependency/dependency.dart';
import 'package:home_module/home_module.dart';

import 'cubit/app_cubit.dart';
import 'cubit/app_state.dart';
import 'flavors.dart';

class App extends MicroHostStatelessWidget {
  App({super.key});

  @override
  List<MicroAppPage> get pages => [];

  @override
  List<MicroApp> get initialMicroApps => [
        AuthMicroApp(),
        HomeMicroApp(),
      ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<AppCubit>(),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (_, appState) {
          return ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) => MaterialApp(
              title: F.title,
              debugShowCheckedModeBanner: F.appFlavor == Flavor.dev,
              navigatorKey: NavigatorInstance.navigatorKey,
              onGenerateRoute: onGenerateRoute,
              initialRoute: AppRoutes.login,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: appState.themeMode,
              locale: appState.locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          );
        },
      ),
    );
  }
}
