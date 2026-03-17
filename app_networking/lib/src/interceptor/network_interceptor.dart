// import 'package:dio/dio.dart';
// import 'package:eib_agent_app/core/app/app_controller.dart';
// import 'package:eib_agent_app/core/extension/build_context_extension.dart';
// import 'package:eib_agent_app/core/helper/network/network_checker.dart';
// import 'package:eib_agent_app/core/routing/sli_page_route.dart';
// import 'package:eib_agent_app/di/injection.dart';
// import 'package:eib_agent_app/widget/no_internet_screen.dart';
//
// class NetworkInterceptor extends QueuedInterceptor {
//   NetworkInterceptor();
//
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     if (Injector.getIt.get<NetworkChecker>().isConnected == true) {
//       super.onRequest(options, handler);
//     } else {
//       AppController appController = Injector.getIt.get<AppController>();
//       appController.context?.navigator.push(SLIPageRoute(
//           page: () => NoInternetScreen(onRetry: () {
//                 appController.context?.navigator.pop();
//                 super.onRequest(options, handler);
//               })));
//     }
//   }
// }
