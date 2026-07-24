import '../data/models/app_user.dart';

abstract class AuthRepository {
  /// 로그인. 실패 시 [AuthException].
  Future<AppUser> login(String employeeNo, String password);

  Future<void> logout();

  /// 저장된 토큰으로 현재 사용자 복원. 없거나 무효면 null.
  Future<AppUser?> currentUser();
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}
