import 'package:dependency/dependency.dart';
import 'package:flutter/foundation.dart';

import '../client/api_client.dart';
import '../config/network_config.dart';
import '../interceptor/auth_interceptor.dart';
import '../interceptor/curl_interceptor.dart';
import '../interceptor/session_interceptor.dart';
import '../token/session_callback.dart';
import '../token/token_provider.dart';

@module
abstract class NetworkingDiModule {
  @singleton
  TokenProvider tokenProvider(SharedPreferences prefs) => TokenProvider(prefs);

  @Named('logging_interceptor')
  @singleton
  Interceptor get loggingInterceptor => PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    error: true,
    compact: false,
    responseBody: true,
    logPrint: (o) => debugPrint('API ${o.toString()}'),
  );

  @Named('requests_inspector_interceptor')
  @singleton
  Interceptor requestsInspectorInterceptor() => RequestsInspectorInterceptor();

  @Named('auth_interceptor')
  @singleton
  Interceptor authInterceptor(TokenProvider tokenProvider) => AuthInterceptor(tokenProvider);

  @Named('session_interceptor')
  @singleton
  Interceptor sessionInterceptor(
    TokenProvider tokenProvider,
    @Named('session_expired_callback') SessionExpiredCallback sessionExpiredCallback,
  ) => SessionInterceptor(
    baseUrl: NetworkConfig.baseUrl,
    onSessionExpired: sessionExpiredCallback.call,
    tokenProvider: tokenProvider,
  );

  @singleton
  Dio provideDio(
    @Named('logging_interceptor') Interceptor loggingInterceptor,
    @Named('requests_inspector_interceptor') Interceptor requestsInspectorInterceptor,
    @Named('auth_interceptor') Interceptor authInterceptor,
    @Named('session_interceptor') Interceptor sessionInterceptor,
  ) {
    final dio = Dio()
      ..options = BaseOptions(
        baseUrl: NetworkConfig.baseUrl,
        connectTimeout: NetworkConfig.connectTimeout,
        receiveTimeout: NetworkConfig.receiveTimeout,
        sendTimeout: NetworkConfig.sendTimeout,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      )
      ..interceptors.addAll([authInterceptor, sessionInterceptor]);

    if (kDebugMode) {
      dio.interceptors.add(loggingInterceptor);
      dio.interceptors.add(requestsInspectorInterceptor);
    }
    return dio;
  }

  @Singleton(as: ApiHandler)
  ApiClient apiClient(Dio dio) => ApiClient(dio: dio, baseUrl: NetworkConfig.baseUrl);
}
