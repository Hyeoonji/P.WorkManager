import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wism/core/storage/token_storage.dart';
import 'package:wism/features/auth/data/mock_auth_repository.dart';
import 'package:wism/features/auth/domain/auth_repository.dart';

/// 메모리 기반 가짜 토큰 저장소 (secure storage 플랫폼 채널 없이 테스트).
class FakeTokenStorage extends TokenStorage {
  FakeTokenStorage() : super(const FlutterSecureStorage());
  final _m = <String, String>{};

  @override
  Future<void> save({required String access, String? refresh}) async {
    _m['a'] = access;
    if (refresh != null) _m['r'] = refresh;
  }

  @override
  Future<String?> readAccess() async => _m['a'];
  @override
  Future<String?> readRefresh() async => _m['r'];
  @override
  Future<void> clear() async => _m.clear();
}

void main() {
  late MockAuthRepository repo;

  setUp(() => repo = MockAuthRepository(FakeTokenStorage()));

  test('유효 사번 + 비밀번호(0000) 로그인 성공', () async {
    final user = await repo.login('00000', '0000');
    expect(user.name, '이태경');
    expect(user.position, '대표이사');
  });

  test('로그인 후 currentUser 복원', () async {
    await repo.login('00020', '0000');
    final user = await repo.currentUser();
    expect(user?.name, '김기남');
    expect(user?.dept, '사업 5실 3팀');
  });

  test('존재하지 않는 사번 → AuthException', () async {
    expect(() => repo.login('99999', '0000'), throwsA(isA<AuthException>()));
  });

  test('잘못된 비밀번호 → AuthException', () async {
    expect(() => repo.login('00000', 'wrong'), throwsA(isA<AuthException>()));
  });

  test('로그아웃 후 currentUser null', () async {
    await repo.login('00000', '0000');
    await repo.logout();
    expect(await repo.currentUser(), isNull);
  });
  // 프로필 수정 테스트 제거 — 프로필은 회사 인사시스템 소유(읽기전용)
}
