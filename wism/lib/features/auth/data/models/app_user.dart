import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

/// 사용자(직원). 운영 시 /me·/users 응답과 매핑.
@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String employeeNo,
    required String name,
    String? email,
    String? phone,
    String? position,
    String? dept,
    String? photoUrl,
    @Default('manager') String role,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
