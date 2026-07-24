import 'models/assignee.dart';
import 'models/comment.dart';
import 'models/memo.dart';
import 'models/memo_project.dart';
import 'models/user_ref.dart';

/// 개발용 사업(프로젝트) 시드 (사업명 ↔ 주관업체).
const mockProjects = <MemoProject>[
  MemoProject(id: '1', name: 'XR 헤드셋 납품', clientName: 'EQUIP'),
  MemoProject(id: '2', name: 'XR 콘텐츠 개발', clientName: 'XR-EDU'),
  MemoProject(id: '3', name: '방산 시뮬레이터', clientName: 'DEF-SIM'),
  MemoProject(id: '4', name: '스마트팩토리 구축', clientName: 'IT-OPS'),
];

// 작성자/담당자용 UserRef (mock 사용자 일부)
const _hwangDonggi = UserRef(id: '12', name: '황동기', dept: '사업 1실 2팀', position: '팀장');
const _leeSanghwa = UserRef(id: '9', name: '이상화', dept: '사업 5실', position: '실장');
const _kimGinam = UserRef(id: '21', name: '김기남', dept: '사업 5실 3팀', position: '팀장');
const _parkJunggyu = UserRef(id: '11', name: '박정규', dept: '사업 1실 1팀', position: '팀장');
const _baeJaehyun = UserRef(id: '16', name: '배재현', dept: '사업 3실 2팀', position: '팀장');
const _leeJuun = UserRef(id: '19', name: '이주운', dept: '사업 5실 1팀', position: '팀장');

List<Memo> buildSeedMemos() => [
      Memo(
        id: '1',
        title: '긴급 서버 장애 대응 완료',
        content: '오전 10시경 발생한 서버 장애가 11시 30분에 복구 완료되었습니다. 원인 분석 중이며 재발 방지 대책 수립 예정입니다.',
        priority: '긴급',
        category: '이슈',
        project: mockProjects[3],
        author: _hwangDonggi,
        createdAt: DateTime(2026, 6, 5, 11, 45),
        readBy: 8,
        totalReaders: 21,
        viewCount: 7,
        commentCount: 1,
        comments: [
          Comment(
            id: '5001',
            author: _leeSanghwa,
            content: '확인했습니다. 원인 분석 결과 공유 부탁드립니다.',
            createdAt: DateTime(2026, 6, 5, 12, 10),
          ),
        ],
      ),
      Memo(
        id: '2',
        title: 'Q3 사업 계획 확정 요청',
        content: '3분기 사업 계획 최종안입니다. 검토 후 승인 부탁드립니다.',
        priority: '일반',
        category: '결정사항',
        project: mockProjects[1],
        author: _leeSanghwa,
        assignees: const [Assignee(userId: '21', name: '김기남')],
        createdAt: DateTime(2026, 6, 5, 9, 0),
        readBy: 15,
        totalReaders: 21,
        viewCount: 14,
      ),
      Memo(
        id: '3',
        title: '6월 월간회의 회의록',
        content: '6월 월간 경영회의 회의록입니다. 각 팀 진행현황 및 결정사항 정리.',
        priority: '일반',
        category: '회의록',
        author: _kimGinam,
        createdAt: DateTime(2026, 6, 4, 16, 0),
        readBy: 21,
        totalReaders: 21,
        viewCount: 20,
      ),
      Memo(
        id: '4',
        title: 'XR 헤드셋 납품 일정 확인 요청',
        content: '6월 25일 XR 헤드셋 50대 납품 일정입니다. 검수 담당자 지정 및 수령 장소 확정이 필요합니다.',
        priority: '긴급',
        category: '일정',
        project: mockProjects[0],
        author: _parkJunggyu,
        assignees: const [Assignee(userId: '13', name: '한성덕')],
        createdAt: DateTime(2026, 6, 4, 11, 0),
        scheduledDate: DateTime(2026, 6, 25),
        readBy: 5,
        totalReaders: 21,
        viewCount: 4,
      ),
      Memo(
        id: '5',
        title: '방산 시뮬레이터 렌더링 오류',
        content: '방산 시뮬레이터 v2.3에서 렌더링 오류가 발생했습니다. 즉각적인 조치가 필요합니다.',
        priority: '긴급',
        category: '이슈',
        project: mockProjects[2],
        author: _baeJaehyun,
        createdAt: DateTime(2026, 6, 3, 8, 15),
        readBy: 10,
        totalReaders: 21,
        viewCount: 9,
      ),
      Memo(
        id: '6',
        title: '신규 프로젝트 킥오프 미팅',
        content: '신규 프로젝트 킥오프 미팅을 진행합니다. 상세 일정은 추후 공유 예정입니다.',
        priority: '일반',
        category: '일정',
        author: _leeJuun,
        createdAt: DateTime(2026, 6, 3, 10, 0),
        scheduledDate: DateTime(2026, 6, 18),
        readBy: 12,
        totalReaders: 21,
        bookmarked: true,
        viewCount: 11,
      ),
    ];
