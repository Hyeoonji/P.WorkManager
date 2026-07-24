import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_ref.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

/// 댓글. type: comment(일반) | status(확인완료)
@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    required String id,
    required UserRef author,
    required String content,
    @Default('comment') String type,
    required DateTime createdAt,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
}
