import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tasktwelve/utils/app_constants.dart';
import 'package:tasktwelve/utils/shared_preference_util.dart';
import '../repo_api/rest_constants.dart';
import 'app_interceptor.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: RestConstants.baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      PrettyDioLogger(requestHeader: true, requestBody: true, responseBody: true, responseHeader: false, error: true, compact: true, maxWidth: 100),
      AppInterceptor(),
    ]);
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    bool isHeader = false,
    bool isLanguage = true,
    String lang = 'en',
  }) async {
    // lang = SharedPreferenceUtil.getString(languageKey);
    lang = SharedPreferenceUtil.getString(languageCodeKey);
    return await dio.get(
      url,
      queryParameters: query,
      options: Options(
        extra: {
          'Accept-Language': lang == '' ? 'en' : lang,
          'header': isHeader,
          'language': isLanguage,
        },
      ),
    );
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
    bool isHeader = false,
  }) async {
    return await dio.delete(
      url,
      queryParameters: query,
      options: Options(
        extra: {
          'header': isHeader,
        },
      ),
    );
  }

  static Future<Response> postData({
    required String url,
    Map<dynamic, dynamic>? data,
    FormData? formData,
    bool isHeader = false,
    bool isAllow412 = false,
    bool isLanguage = true,
    String lang = 'en',
  }) async {
    // lang = SharedPreferenceUtil.getString(languageKey);
    lang = SharedPreferenceUtil.getString(languageCodeKey);
    return await dio.post(
      url,
      data: formData ?? data,
      options: Options(
          extra: {
            'header': isHeader,
            'language': isLanguage,
            'Accept-Language': lang == '' ? 'en' : lang,
          },
          validateStatus: (status) {
            return isAllow412 && status == 412
                ? true
                : status == 200
                    ? true
                    : false;
          }),
    );
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    // lang = SharedPreferenceUtil.getString(languageKey);
    lang = SharedPreferenceUtil.getString(languageCodeKey);
    dio.options.headers = {
      'Accept-Language': lang == '' ? 'en' : lang,
      'VAuthorization': token ?? '',
      'Content-Type': 'application/json',
    };
    return await dio.put(
      url,
      queryParameters: query,
      data: data,
    );
  }
}
