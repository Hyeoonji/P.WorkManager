import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // StateProvider (Riverpod 3.x)

import '../../../core/config/env.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/application/auth_controller.dart';
import '../data/memo_repository_impl.dart';
import '../data/mock_memo_repository.dart';
import '../data/models/department.dart';
import '../data/models/memo.dart';
import '../data/models/memo_project.dart';
import '../data/models/user_ref.dart';
import '../domain/memo_repository.dart';

final memoRepositoryProvider = Provider<MemoRepository>((ref) {
  if (Env.useMockAuth) {
    final user = ref.watch(authControllerProvider).user;
    return MockMemoRepository(user);
  }
  return MemoRepositoryImpl(ref.read(dioProvider));
});

/// 탭(전체/내메모)을 누를 때마다 +1 → 해당 목록의 필터/정렬을 초기화하는 신호 (#6).
final memoListResetProvider =
    StateProvider.family<int, MemoScope>((ref, scope) => 0);

/// 목록 조회 쿼리 (record → 구조적 동등성으로 family 키).
typedef MemoQuery = ({
  MemoScope scope,
  String category,
  String? priority,
  String query,
  MemoSort sort,
});

final memoListProvider =
    FutureProvider.autoDispose.family<List<Memo>, MemoQuery>((ref, q) async {
  final repo = ref.watch(memoRepositoryProvider);
  return repo.list(
    scope: q.scope,
    category: q.category == '전체' ? null : q.category,
    priority: q.priority,
    query: q.query,
    sort: q.sort,
  );
});

final memoDetailProvider =
    FutureProvider.autoDispose.family<Memo, String>((ref, id) async {
  return ref.watch(memoRepositoryProvider).detail(id);
});

/// 전체 메모 (대시보드·캘린더 파생용).
final allMemosProvider = FutureProvider.autoDispose<List<Memo>>((ref) async {
  return ref.watch(memoRepositoryProvider).list(scope: MemoScope.all);
});

final userSearchProvider =
    FutureProvider.autoDispose.family<List<UserRef>, String>((ref, q) async {
  // 빈 입력이면 전체 목록(미리보기)을 반환하도록 그대로 위임한다.
  return ref.watch(memoRepositoryProvider).searchUsers(q);
});

/// 부서 목록 (작성 시 '부서 단위 추가'). 한 번 로드 후 캐시.
final departmentsProvider = FutureProvider<List<Department>>((ref) async {
  return ref.watch(memoRepositoryProvider).listDepartments();
});

final projectSearchProvider =
    FutureProvider.autoDispose.family<List<MemoProject>, String>((ref, q) async {
  return ref.watch(memoRepositoryProvider).searchProjects(q);
});
