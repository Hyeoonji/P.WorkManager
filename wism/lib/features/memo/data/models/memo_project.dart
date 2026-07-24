import 'package:freezed_annotation/freezed_annotation.dart';

part 'memo_project.freezed.dart';
part 'memo_project.g.dart';

/// 사업(프로젝트) — 사업명 ↔ 주관업체.
@freezed
abstract class MemoProject with _$MemoProject {
  const factory MemoProject({
    required String id,
    required String name,
    String? clientName,
  }) = _MemoProject;

  factory MemoProject.fromJson(Map<String, dynamic> json) =>
      _$MemoProjectFromJson(json);
}
