import 'package:app_route/app_route.dart';
import 'package:dependency/dependency.dart';

import '../presentation/page/login_page.dart';

class AuthMicroApp extends MicroApp<void> {
  static const String authChannel = 'auth_channel';

  @override
  String get name => 'auth';

  @override
  String get description => 'Handles authentication: login, logout, token management';

  @override
  List<MicroAppPage> get pages => [
        MicroAppPage(
          route: AppRoutes.login,
          name: 'Login',
          description: 'Login screen',
          pageBuilder: PageBuilder(
            widgetBuilder: (context, settings) => const LoginPage(),
          ),
        ),
      ];
}
