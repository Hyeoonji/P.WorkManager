import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachment.freezed.dart';
part 'attachment.g.dart';

/// 메모 첨부파일 (백엔드 6장 — { id, memoId, fileName, mimeType, size, url }).
@freezed
abstract class Attachment with _$Attachment {
  const factory Attachment({
    required String id,
    required String memoId,
    required String fileName,
    String? mimeType,
    @Default(0) int size,
    required String url, // 다운로드 경로 (/attachments/{id}/download)
  }) = _Attachment;

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);
}

extension AttachmentX on Attachment {
  /// 파일 종류 (확장자 기반) — 아이콘/색상 매핑용.
  String get kind {
    final ext = fileName.contains('.')
        ? fileName.split('.').last.toLowerCase()
        : '';
    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'].contains(ext)) {
      return 'image';
    }
    if (ext == 'pdf') return 'pdf';
    if (['xls', 'xlsx', 'csv'].contains(ext)) return 'excel';
    if (['doc', 'docx', 'hwp', 'hwpx', 'txt', 'ppt', 'pptx'].contains(ext)) {
      return 'doc';
    }
    return 'other';
  }

  /// 사람이 읽는 용량 (KB/MB).
  String get sizeLabel {
    final kb = size / 1024;
    if (kb >= 1024) return '${(kb / 1024).toStringAsFixed(1)} MB';
    return '${kb.round()} KB';
  }
}
