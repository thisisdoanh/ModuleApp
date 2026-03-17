import 'package:dependency/dependency.dart';
import 'package:flutter/foundation.dart';

import '../endpoint/url_end_point.dart';
import '../extension/string_extension.dart';
import '../interceptor/curl_interceptor.dart';
import '../model/base_response_model.dart';
import '../model/token_response_model.dart';
import '../token/token_provider.dart';

final List<String> _skipAuthPaths = [
  UrlEndPoint.auth.login,
  UrlEndPoint.auth.signUp,
];

class SessionInterceptor extends QueuedInterceptor {
  SessionInterceptor({
    required this.baseUrl,
    required this.onSessionExpired,
    required this.tokenProvider,
  });

  final TokenProvider tokenProvider;
  final VoidCallback onSessionExpired;
  final String baseUrl;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final token = tokenProvider.token;
    final errorCode = err.response?.statusCode;
    final authorization = 'Bearer ${token.accessToken}';

    if (_shouldRefreshToken(err.requestOptions.path, token, errorCode)) {
      final originalOptions = err.requestOptions;

      if (authorization != originalOptions.headers['Authorization']) {
        originalOptions.headers['Authorization'] = authorization;
        try {
          final res = await _retryDio().fetch(originalOptions);
          handler.resolve(res);
          return;
        } on DioException catch (e) {
          handler.reject(e);
          return;
        }
      }

      try {
        final response = await _refreshDio().post<dynamic>(
          UrlEndPoint.auth.refreshToken,
          data: {'refreshToken': token.refreshToken ?? ''},
        );
        final base = BaseResponseModel<TokenResponseModel>.fromJson(
          response.data as Map<String, dynamic>,
          (json) => TokenResponseModel.fromJson(json as Map<String, dynamic>),
        );
        tokenProvider.setToken(base.data);
        originalOptions.headers['Authorization'] =
            'Bearer ${base.data?.accessToken ?? ''}';

        try {
          final res = await _retryDio().fetch(originalOptions);
          handler.resolve(res);
          return;
        } on DioException catch (e) {
          handler.reject(e);
          return;
        }
      } on DioException catch (e) {
        onSessionExpired();
        return handler.next(e);
      }
    }
    return handler.next(err);
  }

  bool _shouldRefreshToken(String path, TokenResponseModel token, int? errorCode) =>
      token.accessToken.isNotNullOrEmpty &&
      !_skipAuthPaths.contains(path) &&
      (errorCode == 401 || errorCode == 403);

  Dio _retryDio() => Dio()
    ..interceptors.addAll([
      CurlInterceptor(),
      if (kDebugMode)
        LogInterceptor(requestBody: kDebugMode, responseBody: kDebugMode),
    ]);

  Dio _refreshDio() => Dio()
    ..options = BaseOptions(baseUrl: baseUrl, headers: {'Content-Type': 'application/json'})
    ..interceptors.addAll([
      CurlInterceptor(),
      if (kDebugMode)
        LogInterceptor(request: true, requestBody: true, responseBody: true),
    ]);
}
