import 'package:dependency/dependency.dart';

/// Wrapper for the session-expired callback.
/// Register a concrete instance in [AppModule]:
/// ```dart
/// @singleton
/// SessionExpiredCallback get sessionExpiredCallback =>
///     SessionExpiredCallback(AppNavigator.toLogin);
/// ```
class SessionExpiredCallback {
  const SessionExpiredCallback(this.call);
  final VoidCallback call;
}
