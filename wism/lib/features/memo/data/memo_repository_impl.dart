import 'package:dio/dio.dart';

import '../domain/memo_draft.dart';
import '../domain/memo_repository.dart';
import 'models/attachment.dart';
import 'models/comment.dart';
import 'models/department.dart';
import 'models/memo.dart';
import 'models/memo_project.dart';
import 'models/user_ref.dart';

/// 실서버 메모 리포지토리 (Dio). USE_MOCK_AUTH=false 일 때 사용.
class MemoRepositoryImpl implements MemoRepository {
  MemoRepositoryImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<Memo>> list({
    required MemoScope scope,
    String? category,
    String? priority,
    String? query,
    MemoSort sort = MemoSort.latest,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>('/memos', queryParameters: {
      'scope': scope.name,
      if (category != null && category != '전체') 'category': category,
      'priority': ?priority,
      if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
      'sort': sort.name,
    });
    final items = (res.data!['items'] as List)
        .map((e) => Memo.fromJson(e as Map<String, dynamic>))
        .toList();
    return items;
  }

  @override
  Future<Memo> detail(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/memos/$id');
      return Memo.fromJson(res.data!);
    } on DioException catch (e) {
      // 삭제됐거나 없는 메모 → 상세 화면이 '삭제됨'으로 처리하도록 구분된 예외로.
      if (e.response?.statusCode == 404) {
        throw const MemoNotFoundException();
      }
      rethrow;
    }
  }

  @override
  Future<Memo> create(MemoDraft draft) async {
    final res = await _dio.post<Map<String, dynamic>>('/memos', data: draft.toJson());
    return Memo.fromJson(res.data!);
  }

  @override
  Future<Memo> update(String id, MemoDraft draft) async {
    final res = await _dio.put<Map<String, dynamic>>('/memos/$id', data: draft.toJson());
    return Memo.fromJson(res.data!);
  }

  @override
  Future<void> delete(String id) async {
    await _dio.delete('/memos/$id');
  }

  @override
  Future<Memo> setBookmark(String id, {required bool bookmarked}) async {
    if (bookmarked) {
      await _dio.put('/memos/$id/bookmark');
    } else {
      await _dio.delete('/memos/$id/bookmark');
    }
    return detail(id);
  }

  @override
  Future<Memo> markRead(String id) async {
    await _dio.post('/memos/$id/read');
    return detail(id);
  }

  @override
  Future<Comment> addComment(String memoId, String content) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/memos/$memoId/comments',
      data: {'content': content, 'type': 'comment'},
    );
    return Comment.fromJson(res.data!);
  }

  @override
  Future<void> updateComment(String memoId, String commentId, String content) async {
    await _dio.put('/comments/$commentId', data: {'content': content});
  }

  @override
  Future<void> deleteComment(String memoId, String commentId) async {
    await _dio.delete('/comments/$commentId');
  }

  @override
  Future<Attachment> uploadAttachment(
      String memoId, String filePath, String fileName) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    });
    final res = await _dio.post<Map<String, dynamic>>(
      '/memos/$memoId/attachments',
      data: form,
    );
    return Attachment.fromJson(res.data!);
  }

  @override
  Future<void> deleteAttachment(String attachmentId) async {
    await _dio.delete('/attachments/$attachmentId');
  }

  @override
  Future<List<int>> downloadAttachment(String attachmentId) async {
    final res = await _dio.get<List<int>>(
      '/attachments/$attachmentId/download',
      options: Options(responseType: ResponseType.bytes),
    );
    return res.data!;
  }

  @override
  Future<List<UserRef>> searchUsers(String query) async {
    final res = await _dio.get<List<dynamic>>('/users', queryParameters: {'q': query});
    return res.data!.map((e) => UserRef.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Department>> listDepartments() async {
    final res = await _dio.get<List<dynamic>>('/departments');
    return res.data!
        .map((e) => Department.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<MemoProject>> searchProjects(String query) async {
    final res = await _dio.get<List<dynamic>>('/projects', queryParameters: {'q': query});
    return res.data!.map((e) => MemoProject.fromJson(e as Map<String, dynamic>)).toList();
  }
}
