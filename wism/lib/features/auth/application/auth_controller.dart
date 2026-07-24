import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/push/push_service.dart';
import '../data/auth_providers.dart';
import '../data/models/app_user.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState._(this.status, this.user);
  const AuthState.unknown() : this._(AuthStatus.unknown, null);
  const AuthState.unauthenticated() : this._(AuthStatus.unauthenticated, null);
  const AuthState.authenticated(AppUser user)
      : this._(AuthStatus.authenticated, user);

  final AuthStatus status;
  final AppUser? user;

  bool get isLoggedIn => status == AuthStatus.authenticated;
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    _restore();
    return const AuthState.unknown();
  }

  /// 앱 시작 시 저장된 토큰으로 자동 로그인 시도. (스플래시 최소 노출 ~1.3s)
  Future<void> _restore() async {
    try {
      final pending = ref.read(authRepositoryProvider).currentUser();
      await Future.delayed(const Duration(milliseconds: 1300));
      final user = await pending;
      if (user != null) {
        state = AuthState.authenticated(user);
        // 자동로그인 성공 시에도 토큰 갱신 등록 (fire-and-forget)
        ref.read(pushServiceProvider).registerToken();
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (_) {
      state = const AuthState.unauthenticated();
    }
  }

  /// 로그인. 실패 시 [AuthException] 전파(화면에서 처리).
  Future<void> login(String employeeNo, String password) async {
    final user =
        await ref.read(authRepositoryProvider).login(employeeNo, password);
    state = AuthState.authenticated(user);
    // FCM 토큰 등록 (권한 요청 포함). 실패해도 로그인엔 영향 없음.
    ref.read(pushServiceProvider).registerToken();
  }

  Future<void> logout() async {
    // 서버에서 이 기기 토큰 해제 (로그아웃 API 전에)
    await ref.read(pushServiceProvider).unregister();
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState.unauthenticated();
  }

}
