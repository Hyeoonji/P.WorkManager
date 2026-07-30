import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

/// 요청에 Access 토큰 첨부 + 401 시 Refresh 토큰으로 1회 재발급/재시도.
/// (Mock 인증 모드에서는 네트워크를 타지 않으므로 호출되지 않음)
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._storage, this._baseUrl);
  final TokenStorage _storage;
  final String _baseUrl;

  // 재발급·재시도용 별도 Dio에도 타임아웃을 건다. (없으면 QueuedInterceptor라
  // 응답 없는 재발급 하나가 뒤의 모든 요청을 멈춰 앱 전체가 무한로딩됨)
  static const _timeout = Duration(seconds: 15);
  BaseOptions _rawOptions() => BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: _timeout,
        receiveTimeout: _timeout,
        sendTimeout: _timeout,
      );

  bool _isAuthPath(String path) =>
      path.contains('/auth/login') || path.contains('/auth/refresh');

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isAuthPath(options.path)) {
      final token = await _storage.readAccess();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;
    final path = err.requestOptions.path;

    if (status != 401 || _isAuthPath(path) || err.requestOptions.extra['retried'] == true) {
      return handler.next(err);
    }

    final refresh = await _storage.readRefresh();
    if (refresh == null) {
      await _storage.clear();
      return handler.next(err);
    }

    // 1) 토큰 재발급. 이것 자체가 실패하면 진짜 세션 만료 → 로그아웃.
    final String newAccess;
    try {
      // 재발급은 인터셉터가 없는 별도 Dio로 (무한루프 방지) + 타임아웃.
      final raw = Dio(_rawOptions());
      final res = await raw.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refresh},
      );
      newAccess = res.data!['accessToken'] as String;
      await _storage.save(access: newAccess);
    } catch (_) {
      await _storage.clear();
      return handler.next(err);
    }

    // 2) 원 요청 재시도. 여기서의 실패는 인증이 아니라 업무 오류(404·500·네트워크
    //    등)일 수 있으므로 로그아웃하지 않고 그 오류를 그대로 전달한다.
    try {
      final req = err.requestOptions;
      req.headers['Authorization'] = 'Bearer $newAccess';
      req.extra['retried'] = true;
      final retry = await Dio(_rawOptions()).fetch(req);
      return handler.resolve(retry);
    } on DioException catch (retryErr) {
      return handler.reject(retryErr);
    }
  }
}
