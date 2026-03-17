import 'package:dependency/dependency.dart';

import '../routes/app_routes.dart';

/// Navigation utility wrapping flutter_micro_app's [NavigatorInstance].
/// Use typed methods for common navigations, or generic methods for custom routes.
abstract final class AppNavigator {
  // ─── Generic ────────────────────────────────────────────────────────────────

  /// Push a named route onto the stack.
  static Future<T?> push<T>(String route, {Object? arguments}) =>
      NavigatorInstance.pushNamed<T>(route, arguments: arguments);

  /// Replace the current route with a new one.
  static Future<T?> replace<T extends Object?>(String route,
          {Object? arguments}) =>
      NavigatorInstance.pushReplacementNamed<T, Object?>(route,
          arguments: arguments);

  /// Replace the entire stack with a single route.
  static Future<T?> replaceAll<T>(String route, {Object? arguments}) =>
      NavigatorInstance.pushNamedAndRemoveUntil<T>(
        route,
        (r) => false,
        arguments: arguments,
      );

  /// Pop the current route off the stack.
  static void pop<T extends Object?>([T? result]) =>
      NavigatorInstance.pop<T>(result);

  // ─── Typed navigation ───────────────────────────────────────────────────────

  /// Navigate to login and clear all previous routes.
  static Future<void> toLogin() => replaceAll(AppRoutes.login);

  /// Navigate to dashboard and clear all previous routes.
  static Future<void> toDashboard() => replaceAll(AppRoutes.dashboard);
}
