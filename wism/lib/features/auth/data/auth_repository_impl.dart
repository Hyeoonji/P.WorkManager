import 'package:dio/dio.dart';

import '../../../core/storage/token_storage.dart';
import '../domain/auth_repository.dart';
import 'models/app_user.dart';
import 'models/login_response.dart';

/// 실서버 인증 (Dio). USE_MOCK_AUTH=false 일 때 사용.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio, this._storage);
  final Dio _dio;
  final TokenStorage _storage;

  @override
  Future<AppUser> login(String employeeNo, String password) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'employeeNo': employeeNo, 'password': password},
      );
      final login = LoginResponse.fromJson(res.data!);
      await _storage.save(
        access: login.accessToken,
        refresh: login.refreshToken,
      );
      return login.user;
    } on DioException catch (e) {
      throw AuthException(_message(e));
    }
  }

  @override
  Future<void> logout() async {
    try {
      final refresh = await _storage.readRefresh();
      if (refresh != null) {
        await _dio.post('/auth/logout', data: {'refreshToken': refresh});
      }
    } catch (_) {
      // 로그아웃 API 실패해도 로컬 토큰은 삭제
    }
    await _storage.clear();
  }

  @override
  Future<AppUser?> currentUser() async {
    final token = await _storage.readAccess();
    if (token == null) return null;
    try {
      final res = await _dio.get<Map<String, dynamic>>('/me');
      return AppUser.fromJson(res.data!);
    } on DioException {
      return null;
    }
  }

  String _message(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) return data['message'] as String;
    if (e.response?.statusCode == 401) {
      return '사번 또는 비밀번호가 올바르지 않습니다.';
    }
    return '로그인에 실패했습니다. 네트워크를 확인해주세요.';
  }
}
