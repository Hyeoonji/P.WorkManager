import 'package:freezed_annotation/freezed_annotation.dart';

part 'assignee.freezed.dart';
part 'assignee.g.dart';

/// 담당자 태그 (userData에서 선택).
@freezed
abstract class Assignee with _$Assignee {
  const factory Assignee({
    required String userId,
    required String name,
    @Default(false) bool confirmed, // 확인(읽음) 완료 여부 — 상세조회에서만 채워짐
  }) = _Assignee;

  factory Assignee.fromJson(Map<String, dynamic> json) =>
      _$AssigneeFromJson(json);
}
