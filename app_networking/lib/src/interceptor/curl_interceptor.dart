import 'dart:convert';
import 'dart:developer';

import 'package:dependency/dependency.dart';
import 'package:flutter/foundation.dart';

class CurlInterceptor extends Interceptor {
  CurlInterceptor({this.convertFormData = true});
  final bool convertFormData;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      _renderCurlRepresentation(options);
    }
    handler.next(options);
  }

  void _renderCurlRepresentation(RequestOptions requestOptions) {
    // add a breakpoint here so all errors can break
    try {
      log(_cURLRepresentation(requestOptions), name: 'Agent App');
    } catch (err) {
      log('unable to create a CURL representation of the requestOptions', name: 'Agent App');
    }
  }

  String _cURLRepresentation(RequestOptions options) {
    final List<String> components = ['curl -i'];
    if (options.method.toUpperCase() != 'GET') {
      components.add('-X ${options.method}');
    }

    options.headers.forEach((k, v) {
      if (k != 'Cookie') {
        components.add('-H "$k: $v"');
      }
    });

    if (options.data != null) {
      final dynamic dataRequest = options.data;
      if (dataRequest is FormData) {
        final List<String> form = [];
        for (final MapEntry<String, String> item in dataRequest.fields) {
          final String request = '--form "${item.key}=${item.value}"';
          form.add(request);
        }
        for (final MapEntry<String, MultipartFile> file in dataRequest.files) {
          final String request = '--form "${file.key}=${file.value.filename}"';
          form.add(request);
        }
        components.addAll(form);
      } else {
        final data = json.encode(options.data).replaceAll('"', '\\"');
        components.add('-d "$data"');
      }
    }

    components.add('"${options.uri.toString()}"');

    return components.join(' \\\n\t');
  }
}
