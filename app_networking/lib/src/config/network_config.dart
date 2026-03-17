/// Network configuration loaded from environment variables.
/// Pass via --dart-define=BASE_URL=https://your-api.com
abstract final class NetworkConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: '',
  );

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
