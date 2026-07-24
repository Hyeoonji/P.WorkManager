import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

/// 알림. type: urgent | comment | mention | status
/// (Flutter의 Notification 위젯과 충돌 방지를 위해 AppNotification)
@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required int id,
    required String type,
    required String title,
    String? content,
    String? memoId,
    @Default(false) bool isRead,
    required DateTime createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}
