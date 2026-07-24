import 'models/app_notification.dart';

List<AppNotification> buildSeedNotifications() => [
      AppNotification(
        id: 1,
        type: 'urgent',
        title: '긴급 이슈 등록',
        content: '방산 시뮬레이터 렌더링 오류',
        memoId: '5',
        createdAt: DateTime(2026, 6, 5, 8, 16),
      ),
      AppNotification(
        id: 2,
        type: 'comment',
        title: '새 댓글',
        content: '이상화님이 댓글을 남겼습니다',
        memoId: '1',
        createdAt: DateTime(2026, 6, 5, 12, 10),
      ),
      AppNotification(
        id: 3,
        type: 'mention',
        title: '멘션됨',
        content: '@담당자 확인 부탁드립니다',
        memoId: '4',
        createdAt: DateTime(2026, 6, 4, 11, 5),
      ),
      AppNotification(
        id: 4,
        type: 'status',
        title: '확인 완료',
        content: '김기남님이 메모를 확인했습니다',
        memoId: '3',
        isRead: true,
        createdAt: DateTime(2026, 6, 4, 9, 15),
      ),
    ];
