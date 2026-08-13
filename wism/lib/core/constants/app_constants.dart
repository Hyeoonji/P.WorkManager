/// 앱 버전 표시 — 화면에 보여줄 때는 항상 이 값을 쓴다.
/// ⚠️ pubspec.yaml 의 `version:` 과 반드시 같이 올릴 것.
abstract class AppInfo {
  static const version = '1.4.0';
  static const versionLabel = 'v$version';
}

/// 메모 카테고리 (계획서 1.3 / DB ENUM)
abstract class MemoCategory {
  static const schedule = '일정';
  static const issue = '이슈';
  static const decision = '결정사항';
  static const meeting = '회의록';
  static const etc = '기타';

  static const all = [schedule, issue, decision, meeting, etc];
}

/// 메모 중요도
abstract class MemoPriority {
  static const urgent = '긴급';
  static const normal = '일반';

  static const all = [normal, urgent];
}

/// 사업(프로젝트) 태그 제약.
///
/// 회사 공식 사업명을 아직 받을 수 없어, 사용자가 직접 적는 자유 태그로 운영한다.
/// 저장 위치는 오라클 `WEP_WISM_MEMO.PJTCODE VARCHAR2(30 BYTE)` 이고
/// 캐릭터셋이 AL32UTF8(한글 1자 = 3바이트)이라 **한글 10자가 정확히 30바이트**다.
/// 그래서 화면에는 "10자"로만 안내하고, 이모지처럼 3바이트를 넘는 문자가 섞여도
/// 넘치지 않도록 [maxBytes] 로 한 번 더 막는다.
abstract class ProjectTag {
  static const maxChars = 10;
  static const maxBytes = 30;
}

/// 첨부 제약 (9-5 확정)
abstract class AttachmentLimit {
  static const maxBytes = 10 * 1024 * 1024; // 10MB
  static const maxPerMemo = 3;
  static const allowedExtensions = [
    'jpg', 'jpeg', 'png', 'gif',
    'pdf',
    'hwp', 'hwpx',
    'doc', 'docx',
    'ppt', 'pptx',
    'xls', 'xlsx',
  ];
}
