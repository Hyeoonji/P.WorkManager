/// 메모 작성/수정 입력값.
class MemoDraft {
  MemoDraft({
    required this.title,
    required this.content,
    required this.priority,
    required this.category,
    this.projectId,
    this.scheduledDate,
    this.assigneeIds = const [],
  });

  final String title;
  final String content;
  final String priority;
  final String category;
  final String? projectId;
  final DateTime? scheduledDate;
  final List<String> assigneeIds;

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'priority': priority,
        'category': category,
        'projectId': projectId,
        'scheduledDate': scheduledDate?.toIso8601String(),
        'assigneeIds': assigneeIds,
      };
}
