// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo_project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemoProject _$MemoProjectFromJson(Map<String, dynamic> json) => _MemoProject(
  id: json['id'] as String,
  name: json['name'] as String,
  clientName: json['clientName'] as String?,
);

Map<String, dynamic> _$MemoProjectToJson(_MemoProject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'clientName': instance.clientName,
    };
