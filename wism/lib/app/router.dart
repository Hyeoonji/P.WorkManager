import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/app_keys.dart';
import '../features/auth/application/auth_controller.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/onboarding/application/onboarding_providers.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/memo/presentation/home_screen.dart';
import '../features/memo/presentation/memo_detail_page.dart';
import '../features/memo/presentation/all_memos_screen.dart';
import '../features/memo/presentation/my_memos_screen.dart';
import '../features/memo/presentation/bookmarks_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import 'main_shell.dart';

/// 인증 상태에 따라 가드되는 앱 라우터.
final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      // 푸시 딥링크 진입점. 루트 네비게이터에 push되어 탭바 위로 덮인다.
      GoRoute(
        path: '/memo/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, state) =>
            MemoDetailPage(memoId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/home', builder: (_, _) => const HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/all', builder: (_, _) => const AllMemosScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/my', builder: (_, _) => const MyMemosScreen())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/bookmarks', builder: (_, _) => const BookmarksScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen())],
          ),
        ],
      ),
    ],
  );
});

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen(authControllerProvider, (_, _) => notifyListeners());
    _ref.listen(onboardingSeenProvider, (_, _) => notifyListeners());
  }
  final Ref _ref;

  String? redirect(BuildContext context, GoRouterState state) {
    final seen = _ref.read(onboardingSeenProvider);
    final status = _ref.read(authControllerProvider).status;
    final loc = state.matchedLocation;

    // 1) 첫 실행 온보딩 미완료 → 무조건 온보딩
    if (!seen) return loc == '/onboarding' ? null : '/onboarding';

    // 2) 온보딩 완료 후 — 인증 상태로 분기 (게이트 화면엔 머무르지 않음)
    final atGate =
        loc == '/onboarding' || loc == '/splash' || loc == '/login';
    switch (status) {
      case AuthStatus.unknown:
        return loc == '/splash' ? null : '/splash';
      case AuthStatus.unauthenticated:
        return loc == '/login' ? null : '/login';
      case AuthStatus.authenticated:
        return atGate ? '/home' : null;
    }
  }
}
