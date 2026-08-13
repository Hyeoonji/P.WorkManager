import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 서버 연결 진단용 로그. 모든 줄 앞에 `[WISM]` 태그가 붙는다.
///
/// 보는 법(PC에 폰 USB 연결 후):
///   adb logcat -s flutter:V | findstr "[WISM]"
///
/// 릴리즈 빌드에서도 찍힌다(서버실 이전 후 실기기 진단용).
/// 진단이 끝나면 [dioProvider]에서 이 인터셉터만 빼면 된다.
class WismLogInterceptor extends Interceptor {
  const WismLogInterceptor();

  static void log(String message) => debugPrint('[WISM] $message');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('→ 요청 ${options.method} ${options.uri}');
    log('   connectTimeout=${options.connectTimeout} '
        'receiveTimeout=${options.receiveTimeout}');
    final body = options.data;
    if (body != null) log('   body=${_mask(body)}');
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    log('← 응답 ${response.statusCode} ${response.requestOptions.uri}');
    log('   data=${_clip(response.data)}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('✖ 실패 ${err.requestOptions.method} ${err.requestOptions.uri}');
    log('   type=${err.type}  message=${err.message}');
    if (err.response != null) {
      // 서버까지는 닿았고 서버가 에러를 돌려준 경우 → 네트워크는 정상.
      log('   status=${err.response!.statusCode}');
      log('   서버응답=${_clip(err.response!.data)}');
    } else {
      // 서버에 닿지도 못한 경우 → 포워딩/방화벽/DNS 쪽 문제.
      log('   서버 응답 없음(연결 자체 실패)');
    }
    final cause = err.error;
    if (cause is SocketException) {
      log('   SocketException: ${cause.message}');
      log('   osError=${cause.osError}  address=${cause.address}  port=${cause.port}');
    } else if (cause != null) {
      log('   원인=$cause (${cause.runtimeType})');
    }
    handler.next(err);
  }

  /// 비밀번호는 로그에 남기지 않는다.
  static Object? _mask(Object? body) {
    if (body is! Map) return _clip(body);
    final copy = Map<String, dynamic>.from(body.cast<String, dynamic>());
    for (final key in ['password', 'passwd', 'pw']) {
      if (copy.containsKey(key)) copy[key] = '***';
    }
    return _clip(copy);
  }

  static String _clip(Object? value) {
    final text = '$value';
    return text.length <= 500 ? text : '${text.substring(0, 500)}…(생략)';
  }
}
