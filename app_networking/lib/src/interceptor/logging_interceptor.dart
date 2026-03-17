
import 'package:dependency/src/networking.dart';

/// Wraps PrettyDioLogger with app-specific settings.
class LoggingInterceptor extends PrettyDioLogger {
  LoggingInterceptor()
    : super(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      );
}
