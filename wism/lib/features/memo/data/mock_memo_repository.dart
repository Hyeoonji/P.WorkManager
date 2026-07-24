import '../../auth/data/models/app_user.dart';
import '../../auth/data/mock_users.dart';
import '../domain/memo_draft.dart';
import '../domain/memo_repository.dart';
import 'models/assignee.dart';
import 'models/attachment.dart';
import 'models/comment.dart';
import 'models/department.dart';
import 'models/memo.dart';
import 'models/memo_project.dart';
import 'models/user_ref.dart';
import 'mock_memo_data.dart';

/// 인메모리 메모 저장소 (앱 실행 중 유지).
class _MemoStore {
  _MemoStore._() {
    _memos = buildSeedMemos();
  }
  static final instance = _MemoStore._();

  late List<Memo> _memos;
  int _nextMemoId = 1000;
  int _nextCommentId = 6000;
  final Set<String> _readByMe = {};

  String newMemoId() => 'M${_nextMemoId++}';
  String newCommentId() => 'C${_nextCommentId++}';
}

/// 서버 미구축 단계용 Mock 메모 리포지토리.
class MockMemoRepository implements MemoRepository {
  MockMemoRepository(this._currentUser);
  final AppUser? _currentUser;
  final _store = _MemoStore.instance;

  UserRef get _me => UserRef(
        id: _currentUser?.id ?? '0',
        name: _currentUser?.name ?? '나',
        dept: _currentUser?.dept,
        position: _currentUser?.position,
      );

  @override
  Future<List<Memo>> list({
    required MemoScope scope,
    String? category,
    String? priority,
    String? query,
    MemoSort sort = MemoSort.latest,
  }) async {
    var items = _store._memos.where((m) {
      switch (scope) {
        case MemoScope.my:
          if (m.author.id != _me.id) return false;
        case MemoScope.bookmarks:
          if (!m.bookmarked) return false;
        case MemoScope.all:
          break;
      }
      if (category != null && category != '전체' && m.category != category) {
        return false;
      }
      if (priority != null && m.priority != priority) return false;
      if (query != null && query.trim().isNotEmpty) {
        final q = query.trim();
        final hay = '${m.title} ${m.content ?? ''} ${m.project?.name ?? ''}';
        if (!hay.contains(q)) return false;
      }
      return true;
    }).toList();

    items.sort((a, b) {
      if (sort == MemoSort.urgentFirst && a.isUrgent != b.isUrgent) {
        return a.isUrgent ? -1 : 1;
      }
      return sort == MemoSort.oldest
          ? a.createdAt.compareTo(b.createdAt)
          : b.createdAt.compareTo(a.createdAt);
    });
    return items;
  }

  @override
  Future<Memo> detail(String id) async {
    return _store._memos.firstWhere((m) => m.id == id);
  }

  @override
  Future<Memo> create(MemoDraft draft) async {
    final memo = Memo(
      id: _store.newMemoId(),
      title: draft.title,
      content: draft.content,
      priority: draft.priority,
      category: draft.category,
      project: _projectOf(draft.projectId),
      scheduledDate: draft.category == '일정' ? draft.scheduledDate : null,
      author: _me,
      assignees: _assigneesOf(draft.assigneeIds),
      createdAt: DateTime.now(),
      readBy: 1,
      totalReaders: mockUsers.length,
      isRead: true,
    );
    _store._memos.insert(0, memo);
    _store._readByMe.add(memo.id);
    return memo;
  }

  @override
  Future<Memo> update(String id, MemoDraft draft) async {
    final i = _store._memos.indexWhere((m) => m.id == id);
    final updated = _store._memos[i].copyWith(
      title: draft.title,
      content: draft.content,
      priority: draft.priority,
      category: draft.category,
      project: _projectOf(draft.projectId),
      scheduledDate: draft.category == '일정' ? draft.scheduledDate : null,
      assignees: _assigneesOf(draft.assigneeIds),
    );
    _store._memos[i] = updated;
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    _store._memos.removeWhere((m) => m.id == id);
  }

  @override
  Future<Memo> setBookmark(String id, {required bool bookmarked}) async {
    final i = _store._memos.indexWhere((m) => m.id == id);
    _store._memos[i] = _store._memos[i].copyWith(bookmarked: bookmarked);
    return _store._memos[i];
  }

  @override
  Future<Memo> markRead(String id) async {
    final i = _store._memos.indexWhere((m) => m.id == id);
    final m = _store._memos[i];
    if (_store._readByMe.contains(id)) return m;
    _store._readByMe.add(id);
    final isAuthor = m.author.id == _me.id;
    final updated = m.copyWith(
      isRead: true,
      readBy: m.readBy + 1,
      viewCount: isAuthor ? m.viewCount : m.viewCount + 1,
    );
    _store._memos[i] = updated;
    return updated;
  }

  @override
  Future<Comment> addComment(String memoId, String content) async {
    final i = _store._memos.indexWhere((m) => m.id == memoId);
    final comment = Comment(
      id: _store.newCommentId(),
      author: _me,
      content: content,
      createdAt: DateTime.now(),
    );
    final m = _store._memos[i];
    _store._memos[i] = m.copyWith(
      comments: [...m.comments, comment],
      commentCount: m.commentCount + 1,
    );
    return comment;
  }

  @override
  Future<void> updateComment(String memoId, String commentId, String content) async {
    final i = _store._memos.indexWhere((m) => m.id == memoId);
    if (i < 0) return;
    final m = _store._memos[i];
    final comments = m.comments
        .map((c) => c.id == commentId ? c.copyWith(content: content) : c)
        .toList();
    _store._memos[i] = m.copyWith(comments: comments);
  }

  @override
  Future<void> deleteComment(String memoId, String commentId) async {
    final i = _store._memos.indexWhere((m) => m.id == memoId);
    if (i < 0) return;
    final m = _store._memos[i];
    final comments = m.comments.where((c) => c.id != commentId).toList();
    _store._memos[i] =
        m.copyWith(comments: comments, commentCount: comments.length);
  }

  @override
  Future<Attachment> uploadAttachment(
      String memoId, String filePath, String fileName) async {
    final i = _store._memos.indexWhere((m) => m.id == memoId);
    final m = _store._memos[i];
    final att = Attachment(
      id: _store.newCommentId(),
      memoId: memoId,
      fileName: fileName,
      size: 0,
      url: '/attachments/0/download',
    );
    _store._memos[i] = m.copyWith(attachments: [...m.attachments, att]);
    return att;
  }

  @override
  Future<void> deleteAttachment(String attachmentId) async {
    for (var i = 0; i < _store._memos.length; i++) {
      final m = _store._memos[i];
      if (m.attachments.any((a) => a.id == attachmentId)) {
        _store._memos[i] = m.copyWith(
          attachments:
              m.attachments.where((a) => a.id != attachmentId).toList(),
        );
        break;
      }
    }
  }

  @override
  Future<List<int>> downloadAttachment(String attachmentId) async {
    throw UnsupportedError('Mock 모드에서는 첨부 다운로드를 지원하지 않습니다.');
  }

  @override
  Future<List<UserRef>> searchUsers(String query) async {
    await Future.delayed(const Duration(milliseconds: 120));
    final q = query.trim();
    // 빈 입력이면 전체 사용자(미리보기), 아니면 이름/부서명 매칭.
    return mockUsers
        .where((u) =>
            q.isEmpty || u.name.contains(q) || (u.dept?.contains(q) ?? false))
        .take(20)
        .map((u) => UserRef(
              id: u.id,
              name: u.name,
              dept: u.dept,
              position: u.position,
            ))
        .toList();
  }

  @override
  Future<List<Department>> listDepartments() async {
    await Future.delayed(const Duration(milliseconds: 80));
    final map = <String, List<UserRef>>{};
    for (final u in mockUsers) {
      final d = u.dept;
      if (d == null || d.isEmpty) continue;
      (map[d] ??= []).add(UserRef(
          id: u.id, name: u.name, dept: u.dept, position: u.position));
    }
    return map.entries
        .map((e) => Department(name: e.key, members: e.value))
        .toList();
  }

  @override
  Future<List<MemoProject>> searchProjects(String query) async {
    await Future.delayed(const Duration(milliseconds: 120));
    final q = query.trim();
    if (q.isEmpty) return mockProjects;
    return mockProjects.where((p) => p.name.contains(q)).toList();
  }

  MemoProject? _projectOf(String? id) {
    if (id == null) return null;
    for (final p in mockProjects) {
      if (p.id == id) return p;
    }
    return null;
  }

  List<Assignee> _assigneesOf(List<String> ids) {
    final result = <Assignee>[];
    for (final id in ids) {
      final u = mockUsers.where((u) => u.id == id).firstOrNull;
      if (u != null) result.add(Assignee(userId: u.id, name: u.name));
    }
    return result;
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
