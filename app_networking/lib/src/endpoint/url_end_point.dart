/// Central endpoint registry.
///
/// Usage:
/// ```dart
/// UrlEndPoint.auth.login        // '/api/auth/login'
/// UrlEndPoint.user.profile      // '/api/users/profile'
/// ```
///
/// Add new module endpoints by extending [_BaseEndPoint]
/// and registering them here.
abstract final class UrlEndPoint {
  static final AuthEndPoint auth = AuthEndPoint();
  static final UserEndPoint user = UserEndPoint();
}

// ─── Base ────────────────────────────────────────────────────────────────────

abstract class _BaseEndPoint {
  const _BaseEndPoint();
}

// ─── Auth ────────────────────────────────────────────────────────────────────

class AuthEndPoint extends _BaseEndPoint {
  const AuthEndPoint();

  String get login => '/api/auth/login';
  String get signUp => '/api/auth/register';
  String get refreshToken => '/api/auth/refresh';
  String get logout => '/api/auth/logout';
}

// ─── User ────────────────────────────────────────────────────────────────────

class UserEndPoint extends _BaseEndPoint {
  const UserEndPoint();

  String get profile => '/api/users/profile';
  String profile$(String userId) => '/api/users/$userId';
}
