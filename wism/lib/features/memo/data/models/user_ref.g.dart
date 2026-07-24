// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_ref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserRef _$UserRefFromJson(Map<String, dynamic> json) => _UserRef(
  id: json['id'] as String,
  name: json['name'] as String,
  dept: json['dept'] as String?,
  position: json['position'] as String?,
  photoUrl: json['photoUrl'] as String?,
);

Map<String, dynamic> _$UserRefToJson(_UserRef instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'dept': instance.dept,
  'position': instance.position,
  'photoUrl': instance.photoUrl,
};
