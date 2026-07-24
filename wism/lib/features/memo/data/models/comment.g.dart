// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Comment _$CommentFromJson(Map<String, dynamic> json) => _Comment(
  id: json['id'] as String,
  author: UserRef.fromJson(json['author'] as Map<String, dynamic>),
  content: json['content'] as String,
  type: json['type'] as String? ?? 'comment',
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$CommentToJson(_Comment instance) => <String, dynamic>{
  'id': instance.id,
  'author': instance.author,
  'content': instance.content,
  'type': instance.type,
  'createdAt': instance.createdAt.toIso8601String(),
};
