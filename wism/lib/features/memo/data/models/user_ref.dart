import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_ref.freezed.dart';
part 'user_ref.g.dart';

/// 사용자 요약 참조 (작성자 / 유저 검색 결과).
@freezed
abstract class UserRef with _$UserRef {
  const factory UserRef({
    required String id,
    required String name,
    String? dept,
    String? position,
    String? photoUrl,
  }) = _UserRef;

  factory UserRef.fromJson(Map<String, dynamic> json) =>
      _$UserRefFromJson(json);
}
