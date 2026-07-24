import '../../../core/storage/token_storage.dart';
import '../domain/auth_repository.dart';
import 'models/app_user.dart';
import 'mock_users.dart';

/// 서버 미구축 단계용 Mock 인증.
/// 시드 사번(00000~00020) + 비밀번호('0000' 또는 사번과 동일)로 로그인.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository(this._storage);
  final TokenStorage _storage;

  static const _devPassword = '0000';

  @override
  Future<AppUser> login(String employeeNo, String password) async {
    await Future.delayed(const Duration(milliseconds: 400)); // 네트워크 흉내
    final user = findMockUser(employeeNo);
    if (user == null) {
      throw AuthException('존재하지 않는 사번입니다.');
    }
    if (password != _devPassword && password != employeeNo) {
      throw AuthException('비밀번호가 올바르지 않습니다. (개발용: 0000)');
    }
    await _storage.save(access: 'mock:$employeeNo', refresh: 'mock-refresh');
    return user;
  }

  @override
  Future<void> logout() => _storage.clear();

  @override
  Future<AppUser?> currentUser() async {
    final token = await _storage.readAccess();
    if (token == null || !token.startsWith('mock:')) return null;
    return findMockUser(token.substring(5));
  }

}
