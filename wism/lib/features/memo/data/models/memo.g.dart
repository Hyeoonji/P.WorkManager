// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Memo _$MemoFromJson(Map<String, dynamic> json) => _Memo(
  id: json['id'] as String,
  title: json['title'] as String,
  content: json['content'] as String?,
  priority: json['priority'] as String? ?? '일반',
  category: json['category'] as String? ?? '기타',
  project: json['project'] == null
      ? null
      : MemoProject.fromJson(json['project'] as Map<String, dynamic>),
  scheduledDate: json['scheduledDate'] == null
      ? null
      : DateTime.parse(json['scheduledDate'] as String),
  author: UserRef.fromJson(json['author'] as Map<String, dynamic>),
  assignees:
      (json['assignees'] as List<dynamic>?)
          ?.map((e) => Assignee.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Assignee>[],
  createdAt: DateTime.parse(json['createdAt'] as String),
  readBy: (json['readBy'] as num?)?.toInt() ?? 0,
  totalReaders: (json['totalReaders'] as num?)?.toInt() ?? 0,
  viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
  commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
  bookmarked: json['bookmarked'] as bool? ?? false,
  isRead: json['isRead'] as bool? ?? false,
  isConfirmer: json['isConfirmer'] as bool? ?? false,
  confirmedByMe: json['confirmedByMe'] as bool? ?? false,
  comments:
      (json['comments'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Comment>[],
  attachments:
      (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Attachment>[],
);

Map<String, dynamic> _$MemoToJson(_Memo instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'content': instance.content,
  'priority': instance.priority,
  'category': instance.category,
  'project': instance.project,
  'scheduledDate': instance.scheduledDate?.toIso8601String(),
  'author': instance.author,
  'assignees': instance.assignees,
  'createdAt': instance.createdAt.toIso8601String(),
  'readBy': instance.readBy,
  'totalReaders': instance.totalReaders,
  'viewCount': instance.viewCount,
  'commentCount': instance.commentCount,
  'bookmarked': instance.bookmarked,
  'isRead': instance.isRead,
  'isConfirmer': instance.isConfirmer,
  'confirmedByMe': instance.confirmedByMe,
  'comments': instance.comments,
  'attachments': instance.attachments,
};
