import 'package:dependency/dependency.dart';

/// Converts common HTTP error codes into typed exceptions.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;

    switch (response?.statusCode) {
      case 401:
        handler.next(
          err.copyWith(
            error: UnauthorizedException(
                response?.data?['message']?.toString() ?? 'Unauthorized'),
          ),
        );
      case 403:
        handler.next(
          err.copyWith(
            error: ForbiddenException(
                response?.data?['message']?.toString() ?? 'Forbidden'),
          ),
        );
      case 404:
        handler.next(
          err.copyWith(
            error: NotFoundException(
                response?.data?['message']?.toString() ?? 'Not found'),
          ),
        );
      case 500:
      case 502:
      case 503:
        handler.next(
          err.copyWith(
            error: ServerException(
                response?.data?['message']?.toString() ?? 'Server error'),
          ),
        );
      default:
        handler.next(err);
    }
  }
}

class UnauthorizedException implements Exception {
  const UnauthorizedException(this.message);
  final String message;
  @override
  String toString() => 'UnauthorizedException: $message';
}

class ForbiddenException implements Exception {
  const ForbiddenException(this.message);
  final String message;
  @override
  String toString() => 'ForbiddenException: $message';
}

class NotFoundException implements Exception {
  const NotFoundException(this.message);
  final String message;
  @override
  String toString() => 'NotFoundException: $message';
}

class ServerException implements Exception {
  const ServerException(this.message);
  final String message;
  @override
  String toString() => 'ServerException: $message';
}
