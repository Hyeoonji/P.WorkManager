import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

/// 앱 공용 Dio 인스턴스.
///
/// baseUrl은 .env의 고정 서버 주소([Env.apiBaseUrl])를 사용한다.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json; charset=utf-8',
    ),
  );
  dio.interceptors.add(
    AuthInterceptor(ref.read(tokenStorageProvider), Env.apiBaseUrl),
  );
  // 서버 연결 진단이 필요하면 wism_log_interceptor.dart 를 import 하고
  // 아래 한 줄의 주석을 풀어 재빌드한다.
  // ⚠️ 요청·응답 본문(메모 내용·개인정보·FCM 토큰)이 logcat에 남으므로 배포본에는 넣지 않는다.
  // dio.interceptors.add(const WismLogInterceptor());
  return dio;
});
