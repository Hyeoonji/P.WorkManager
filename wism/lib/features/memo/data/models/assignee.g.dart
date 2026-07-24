// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Assignee _$AssigneeFromJson(Map<String, dynamic> json) => _Assignee(
  userId: json['userId'] as String,
  name: json['name'] as String,
  confirmed: json['confirmed'] as bool? ?? false,
);

Map<String, dynamic> _$AssigneeToJson(_Assignee instance) => <String, dynamic>{
  'userId': instance.userId,
  'name': instance.name,
  'confirmed': instance.confirmed,
};
