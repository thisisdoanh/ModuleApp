import 'package:app_route/app_route.dart';
import 'package:dependency/dependency.dart';

import '../presentation/page/dashboard_page.dart';

class HomeMicroApp extends MicroApp<void> {
  static const String homeChannel = 'home_channel';

  @override
  String get name => 'home';

  @override
  String get description => 'Dashboard with home and profile tabs';

  @override
  List<MicroAppPage> get pages => [
        MicroAppPage(
          route: AppRoutes.dashboard,
          name: 'Dashboard',
          description: 'Main dashboard with bottom navigation',
          pageBuilder: PageBuilder(
            widgetBuilder: (context, settings) => const DashboardPage(),
          ),
        ),
      ];
}
