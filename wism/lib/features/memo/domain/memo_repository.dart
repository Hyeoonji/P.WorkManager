import '../data/models/attachment.dart';
import '../data/models/comment.dart';
import '../data/models/department.dart';
import '../data/models/memo.dart';
import '../data/models/memo_project.dart';
import '../data/models/user_ref.dart';
import 'memo_draft.dart';

/// 메모가 이미 삭제되었거나 존재하지 않을 때(서버 404). 상세 화면이 "삭제된
/// 메모입니다" 안내 후 홈으로 복귀하는 데 쓴다.
class MemoNotFoundException implements Exception {
  const MemoNotFoundException();
}

/// 메모 목록 조회 범위.
enum MemoScope { all, my, bookmarks }

/// 정렬.
enum MemoSort { latest, oldest, urgentFirst }

abstract class MemoRepository {
  Future<List<Memo>> list({
    required MemoScope scope,
    String? category,
    String? priority,
    String? query,
    MemoSort sort = MemoSort.latest,
  });

  Future<Memo> detail(String id);
  Future<Memo> create(MemoDraft draft);
  Future<Memo> update(String id, MemoDraft draft);
  Future<void> delete(String id);
  Future<Memo> setBookmark(String id, {required bool bookmarked});
  Future<Memo> markRead(String id);
  Future<Comment> addComment(String memoId, String content);
  Future<void> updateComment(String memoId, String commentId, String content);
  Future<void> deleteComment(String memoId, String commentId);

  /// 첨부 업로드 (멀티파트). 성공 시 생성된 첨부.
  Future<Attachment> uploadAttachment(
      String memoId, String filePath, String fileName);

  /// 첨부 삭제 (메모 작성자만).
  Future<void> deleteAttachment(String attachmentId);

  /// 첨부 다운로드 → 바이트.
  Future<List<int>> downloadAttachment(String attachmentId);

  /// 확인자 태그 자동완성.
  Future<List<UserRef>> searchUsers(String query);

  /// 부서 목록 + 멤버 ('부서 단위 추가'용).
  Future<List<Department>> listDepartments();

  /// 사업(프로젝트) 자동완성.
  Future<List<MemoProject>> searchProjects(String query);
}
