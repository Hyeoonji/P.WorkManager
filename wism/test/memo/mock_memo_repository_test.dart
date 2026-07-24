import 'package:flutter_test/flutter_test.dart';
import 'package:wism/features/auth/data/models/app_user.dart';
import 'package:wism/features/memo/data/mock_memo_repository.dart';
import 'package:wism/features/memo/domain/memo_draft.dart';
import 'package:wism/features/memo/domain/memo_repository.dart';

void main() {
  const tester =
      AppUser(id: '100', employeeNo: '99999', name: '테스터', dept: 'QA', position: '팀장');
  late MockMemoRepository repo;

  setUp(() => repo = MockMemoRepository(tester));

  test('전체 목록에 시드 메모 포함', () async {
    final all = await repo.list(scope: MemoScope.all);
    expect(all.any((m) => m.title == '긴급 서버 장애 대응 완료'), isTrue);
  });

  test('카테고리 필터(이슈)', () async {
    final issues = await repo.list(scope: MemoScope.all, category: '이슈');
    expect(issues, isNotEmpty);
    expect(issues.every((m) => m.category == '이슈'), isTrue);
  });

  test('통합 검색(방산)', () async {
    final r = await repo.list(scope: MemoScope.all, query: '방산');
    expect(r.any((m) => m.title.contains('방산')), isTrue);
  });

  test('작성 → 작성자=현재 사용자, 내 메모에 포함', () async {
    final created = await repo.create(MemoDraft(
      title: '테스트 메모',
      content: '내용',
      priority: '일반',
      category: '기타',
    ));
    expect(created.author.name, '테스터');
    final mine = await repo.list(scope: MemoScope.my);
    expect(mine.any((m) => m.id == created.id), isTrue);
  });

  test('읽음 확인 시 readBy 증가 + isRead', () async {
    final before = await repo.detail('4');
    final after = await repo.markRead('4');
    expect(after.readBy, before.readBy + 1);
    expect(after.isRead, isTrue);
  });

  test('댓글 추가 시 commentCount 증가', () async {
    final before = await repo.detail('2');
    await repo.addComment('2', '확인했습니다');
    final after = await repo.detail('2');
    expect(after.commentCount, before.commentCount + 1);
  });

  test('북마크 설정', () async {
    final m = await repo.setBookmark('5', bookmarked: true);
    expect(m.bookmarked, isTrue);
  });

  test('댓글 수정/삭제', () async {
    final c = await repo.addComment('3', '임시 댓글');
    await repo.updateComment('3', c.id, '수정된 댓글');
    var m = await repo.detail('3');
    expect(m.comments.firstWhere((x) => x.id == c.id).content, '수정된 댓글');

    final before = m.commentCount;
    await repo.deleteComment('3', c.id);
    m = await repo.detail('3');
    expect(m.comments.any((x) => x.id == c.id), isFalse);
    expect(m.commentCount, before - 1);
  });
}
