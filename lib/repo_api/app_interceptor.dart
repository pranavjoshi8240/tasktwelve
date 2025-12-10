import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/app_utils.dart';
import '../resources/strings.dart';

class AppInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    debugPrint("onRequest headers");
    if (options.extra.containsKey('header')) {
      // Add auth token if needed
    }
    if (options.extra.containsKey('language')) {
      final lang = options.extra['Accept-Language'] as String? ?? 'en';
      options.headers.addAll({'Accept-Language': lang});
    }
    return handler.next(options);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.unknown || err.type == DioExceptionType.badResponse) {
      if (err.response?.statusCode == 401) {
        // Handle unauthorized
        debugPrint(strUnauthorizedRequest);
      } else if (err.response?.statusCode == 500) {
        showError(message: err.response?.statusMessage ?? strInternalServerError);
      }
    }
    if (err.type == DioExceptionType.sendTimeout || 
        err.type == DioExceptionType.connectionTimeout || 
        err.type == DioExceptionType.receiveTimeout) {
      debugPrint(strRequestTimeout);
    }

    return handler.next(err);
  }
}
