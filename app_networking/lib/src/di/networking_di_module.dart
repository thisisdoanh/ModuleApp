import 'package:dependency/dependency.dart';

import '../client/api_client.dart';
import '../config/network_config.dart';
import '../interceptor/error_interceptor.dart';
import '../interceptor/logging_interceptor.dart';

@module
abstract class NetworkingDiModule {
  @singleton
  Dio get dio => Dio(
        BaseOptions(
          baseUrl: NetworkConfig.baseUrl,
          connectTimeout: NetworkConfig.connectTimeout,
          receiveTimeout: NetworkConfig.receiveTimeout,
          sendTimeout: NetworkConfig.sendTimeout,
          headers: {'Content-Type': 'application/json'},
        ),
      )..interceptors.addAll([
          LoggingInterceptor(),
          ErrorInterceptor(),
        ]);

  @singleton
  ApiClient apiClient(Dio dio) => ApiClient(dio);
}
