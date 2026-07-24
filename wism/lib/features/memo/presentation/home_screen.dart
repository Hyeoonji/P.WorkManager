import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/utils/formats.dart';
import '../../../shared/widgets/memo_badges.dart';
import '../../auth/application/auth_controller.dart';
import '../../calendar/presentation/calendar_page.dart';
import '../../notification/presentation/widgets/notification_bell.dart';
import '../application/memo_providers.dart';
import '../data/models/memo.dart';
import 'memo_detail_page.dart';
import 'write_memo_sheet.dart';

const _red = AppColors.danger; // 디자인 danger(#D92D20)와 통일
const _cardShadow = BoxShadow(
  color: Color(0x0F14387F), // rgba(20,56,127,0.06)
  blurRadius: 4,
  offset: Offset(0, 1),
);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late DateTime _selectedDay = _dateOnly(DateTime.now());

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
  bool _sameDay(DateTime? a, DateTime b) =>
      a != null && _dateOnly(a) == _dateOnly(b);

  void _openCalendar() => Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(builder: (_) => const CalendarPage()),
      );

  void _openMemo(String id) => Navigator.of(context, rootNavigator: true)
      .push(MaterialPageRoute(builder: (_) => MemoDetailPage(memoId: id)))
      .then((_) => ref.invalidate(allMemosProvider));

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(allMemosProvider);
    final myId = ref.watch(authControllerProvider).user?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
        actions: const [NotificationBell()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final ok = await showWriteMemoSheet(context);
          if (ok == true) {
            ref.invalidate(allMemosProvider);
            ref.invalidate(memoListProvider);
          }
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(LucideIcons.plus, size: 24),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('불러오지 못했습니다.')),
        data: (memos) {
          final today = _dateOnly(DateTime.now());
          // 미확인 긴급 = 내가 확인자인데 아직 확인 안 한 긴급 메모 (#4)
          final unreadUrgent = memos
              .where((m) => m.isUrgent && m.isConfirmer && !m.confirmedByMe)
              .toList();
          final todayCount =
              memos.where((m) => _sameDay(m.scheduledDate, today)).length;
          final myCount = memos.where((m) => m.author.id == myId).length;
          final recent = [...memos]
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(allMemosProvider),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _statRow(unreadUrgent.length, todayCount, myCount),
                const SizedBox(height: 16),
                if (unreadUrgent.isNotEmpty) ...[
                  _urgentSection(unreadUrgent.take(3).toList()),
                  const SizedBox(height: 16),
                ],
                _weekSection(memos),
                const SizedBox(height: 16),
                _recentSection(recent.take(3).toList()),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── 통계 카드 ──
  Widget _statRow(int urgent, int today, int mine) {
    return Row(
      children: [
        _statCard('미확인 긴급', urgent,
            iconColor: AppColors.danger,
            countColor: AppColors.danger,
            bg: const Color(0xFFFEE4E2),
            icon: LucideIcons.bell,
            onTap: () => context.go('/all')),
        const SizedBox(width: 12),
        _statCard('오늘', today,
            iconColor: AppColors.skyBlue,
            countColor: AppColors.primary,
            bg: const Color(0xFFEBF3FB),
            icon: LucideIcons.calendar,
            onTap: _openCalendar),
        const SizedBox(width: 12),
        _statCard('내 메모', mine,
            iconColor: const Color(0xFF22A85A),
            countColor: AppColors.primary,
            bg: const Color(0xFFEBF5EE),
            icon: LucideIcons.fileText,
            onTap: () => context.go('/my')),
      ],
    );
  }

  Widget _statCard(String label, int count,
      {required Color iconColor,
      required Color countColor,
      required Color bg,
      required IconData icon,
      required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: const [_cardShadow],
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(height: 6),
              Text('$count',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: countColor,
                      height: 1)),
              const SizedBox(height: 2),
              Text(label,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted)),
            ],
          ),
        ),
      ),
    );
  }

  // ── 미확인 긴급 이슈 ──
  Widget _urgentSection(List<Memo> memos) {
    return _card(
      children: [
        _sectionHeader(
          icon: LucideIcons.bell,
          iconColor: _red,
          title: '미확인 긴급 이슈',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(20)),
            child: Text('${memos.length}',
                style: const TextStyle(color: _red, fontSize: 12)),
          ),
          borderBottom: true,
        ),
        for (int i = 0; i < memos.length; i++) ...[
          if (i > 0) const _RowDivider(),
          _urgentTile(memos[i]),
        ],
      ],
    );
  }

  Widget _urgentTile(Memo m) {
    return InkWell(
      onTap: () => _openMemo(m.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: _Dot(_red),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(spacing: 6, children: [
                    const UrgentBadge(),
                    CategoryBadge(m.category),
                  ]),
                  const SizedBox(height: 4),
                  Text(m.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textTitle)),
                  const SizedBox(height: 2),
                  Text(m.author.name,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 이번 주 일정 ──
  Widget _weekSection(List<Memo> memos) {
    final today = _dateOnly(DateTime.now());
    final weekStart = today.subtract(Duration(days: today.weekday % 7));
    final days = List.generate(7, (i) => weekStart.add(Duration(days: i)));
    const labels = ['일', '월', '화', '수', '목', '금', '토'];
    final selectedMemos =
        memos.where((m) => _sameDay(m.scheduledDate, _selectedDay)).toList();

    return _card(
      children: [
        // 헤더 (구분선 없음)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            children: [
              const Icon(LucideIcons.calendar, size: 14, color: AppColors.skyBlue),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('이번 주 일정',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTitle)),
              ),
              InkWell(
                onTap: _openCalendar,
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('캘린더 전체보기',
                      style: TextStyle(fontSize: 13, color: AppColors.skyBlue)),
                  Icon(LucideIcons.chevronRight, size: 14, color: AppColors.skyBlue),
                ]),
              ),
            ],
          ),
        ),
        // 주간 스트립
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Row(
            children: List.generate(7, (i) {
              final d = days[i];
              final isSel = _dateOnly(d) == _selectedDay;
              final isToday = _dateOnly(d) == today;
              final dayMemos =
                  memos.where((m) => _sameDay(m.scheduledDate, d)).toList();
              final cats = <String>{
                for (final m in dayMemos) m.isUrgent ? '이슈' : m.category
              }.take(2).toList();

              final labelColor = i == 0
                  ? AppColors.danger
                  : i == 6
                      ? AppColors.skyBlue
                      : AppColors.textMuted;
              final numColor = isToday
                  ? Colors.white
                  : isSel
                      ? AppColors.primary
                      : i == 0
                          ? AppColors.danger
                          : i == 6
                              ? AppColors.skyBlue
                              : AppColors.textTitle;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _selectedDay = _dateOnly(d)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      children: [
                        Text(labels[i],
                            style: TextStyle(fontSize: 12, color: labelColor)),
                        const SizedBox(height: 2),
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isToday ? AppColors.primary : null,
                                  border: isSel && !isToday
                                      ? Border.all(
                                          color: AppColors.primary, width: 2)
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text('${d.day}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: numColor,
                                        height: 1)),
                              ),
                              if (cats.isNotEmpty)
                                Positioned(
                                  bottom: 3,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (final c in cats)
                                        Padding(
                                          padding:
                                              const EdgeInsets.symmetric(horizontal: 1),
                                          child: _Dot(
                                            (isSel || isToday)
                                                ? Colors.white
                                                : AppColors.category(c),
                                            size: 4,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: AppColors.divider),
        // 선택일 일정 리스트
        if (selectedMemos.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 28),
            child: Center(
              child: Text('이 날짜에 등록된 일정이 없습니다',
                  style: TextStyle(fontSize: 14, color: AppColors.textMuted)),
            ),
          )
        else
          for (final m in selectedMemos) _scheduleTile(m),
      ],
    );
  }

  Widget _scheduleTile(Memo m) {
    final barColor =
        m.isUrgent ? AppColors.danger : AppColors.category(m.category);
    final meta = [fmtTime(m.scheduledDate ?? m.createdAt), m.author.name].join(' · '); // 일정 시각
    return InkWell(
      onTap: () => _openMemo(m.id),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: barColor),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Color(0x0A14387F))), // rgba(20,56,127,0.04)
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(m.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textTitle)),
                        ),
                        if (m.isUrgent)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                                color: AppColors.urgentBg,
                                borderRadius: BorderRadius.circular(6)),
                            child: const Text('긴급',
                                style: TextStyle(
                                    fontSize: 11, color: AppColors.urgentFg)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(meta,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 최근 업데이트 ──
  Widget _recentSection(List<Memo> recent) {
    return _card(
      children: [
        _sectionHeader(
          icon: LucideIcons.fileText,
          iconColor: AppColors.primary,
          title: '최근 업데이트',
          borderBottom: true,
        ),
        for (int i = 0; i < recent.length; i++) ...[
          if (i > 0) const _RowDivider(),
          _recentTile(recent[i]),
        ],
      ],
    );
  }

  Widget _recentTile(Memo m) {
    return InkWell(
      onTap: () => _openMemo(m.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _Dot(m.isUrgent ? _red : AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textTitle)),
                  const SizedBox(height: 2),
                  Text('${m.author.name} · ${fmtDateTimeShort(m.createdAt)}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
            ),
            if (m.isUrgent) ...[
              const SizedBox(width: 8),
              const UrgentBadge(),
            ],
          ],
        ),
      ),
    );
  }

  // ── 공통 카드/헤더 ──
  Widget _card({required List<Widget> children}) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _sectionHeader({
    required IconData icon,
    required Color iconColor,
    required String title,
    Widget? trailing,
    bool borderBottom = false,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: borderBottom
          ? const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0x0F14387F))))
          : null,
      child: Row(
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTitle)),
          if (trailing != null) ...[const Spacer(), trailing],
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot(this.color, {this.size = 6});
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();
  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: const Color(0x0F14387F)); // rgba(20,56,127,0.06)
}
