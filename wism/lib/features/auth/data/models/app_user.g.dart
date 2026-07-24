// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  employeeNo: json['employeeNo'] as String,
  name: json['name'] as String,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  position: json['position'] as String?,
  dept: json['dept'] as String?,
  photoUrl: json['photoUrl'] as String?,
  role: json['role'] as String? ?? 'manager',
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'employeeNo': instance.employeeNo,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'position': instance.position,
  'dept': instance.dept,
  'photoUrl': instance.photoUrl,
  'role': instance.role,
};
