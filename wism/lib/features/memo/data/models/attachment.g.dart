// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Attachment _$AttachmentFromJson(Map<String, dynamic> json) => _Attachment(
  id: json['id'] as String,
  memoId: json['memoId'] as String,
  fileName: json['fileName'] as String,
  mimeType: json['mimeType'] as String?,
  size: (json['size'] as num?)?.toInt() ?? 0,
  url: json['url'] as String,
);

Map<String, dynamic> _$AttachmentToJson(_Attachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memoId': instance.memoId,
      'fileName': instance.fileName,
      'mimeType': instance.mimeType,
      'size': instance.size,
      'url': instance.url,
    };
