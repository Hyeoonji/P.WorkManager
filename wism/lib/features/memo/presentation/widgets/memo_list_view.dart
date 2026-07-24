import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/memo_providers.dart';
import '../../domain/memo_repository.dart';
import '../memo_detail_page.dart';
import 'memo_card.dart';

/// 전체/내메모/북마크에서 재사용하는 목록 (검색·카테고리 칩·정렬).
class MemoListView extends ConsumerStatefulWidget {
  const MemoListView({super.key, required this.scope, this.showSearch = true});
  final MemoScope scope;
  final bool showSearch;

  @override
  ConsumerState<MemoListView> createState() => _MemoListViewState();
}

class _MemoListViewState extends ConsumerState<MemoListView> {
  final _searchController = TextEditingController();
  final _sortKey = GlobalKey();
  String _filter = '전체'; // 전체/긴급/일정/이슈/결정사항/회의록/기타
  String _query = '';
  MemoSort _sort = MemoSort.latest;

  // 디자인: 전체 + 긴급 + 카테고리들
  static const _filters = ['전체', '긴급', ...MemoCategory.all];
  static const _sortLabels = {
    MemoSort.latest: '최신순',
    MemoSort.oldest: '오래된순',
    MemoSort.urgentFirst: '긴급순',
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _toggleBookmark(String id, bool current) async {
    await ref.read(memoRepositoryProvider).setBookmark(id, bookmarked: !current);
    ref.invalidate(memoListProvider);
    ref.invalidate(allMemosProvider);
  }

  /// 정렬 메뉴 — 루트 네비게이터에 띄워 탭 전환 시 닫히게 한다.
  Future<void> _openSortMenu() async {
    final buttonCtx = _sortKey.currentContext;
    if (buttonCtx == null) return;
    final button = buttonCtx.findRenderObject() as RenderBox;
    final overlay = Navigator.of(context, rootNavigator: true)
        .overlay!
        .context
        .findRenderObject() as RenderBox;
    final topRight =
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay);
    final position = RelativeRect.fromRect(
      Rect.fromPoints(topRight, topRight),
      Offset.zero & overlay.size,
    );
    final selected = await showMenu<MemoSort>(
      context: context,
      useRootNavigator: true,
      position: position,
      color: AppColors.surface,
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      constraints: const BoxConstraints(minWidth: 110),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0x1F14387F)),
      ),
      items: _sortLabels.entries.map((e) {
        final sel = e.key == _sort;
        return PopupMenuItem<MemoSort>(
          value: e.key,
          height: 40,
          padding: EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            height: 40,
            alignment: Alignment.centerLeft,
            color: sel ? const Color(0xFFEBF3FB) : null,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(e.value,
                style: TextStyle(
                    fontSize: 13,
                    color: sel ? AppColors.primary : AppColors.textSub)),
          ),
        );
      }).toList(),
    );
    if (selected != null && mounted) setState(() => _sort = selected);
  }

  @override
  Widget build(BuildContext context) {
    // 탭 재탭 시 필터/정렬 초기화 (#6)
    ref.listen(memoListResetProvider(widget.scope), (_, _) {
      _searchController.clear();
      setState(() {
        _filter = '전체';
        _query = '';
        _sort = MemoSort.latest;
      });
    });

    final isUrgent = _filter == '긴급';
    final query = (
      scope: widget.scope,
      category: isUrgent ? '전체' : _filter,
      priority: isUrgent ? '긴급' : null,
      query: _query,
      sort: _sort,
    );
    final async = ref.watch(memoListProvider(query));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showSearch) _searchBar(),
        const SizedBox(height: 8),
        _chips(),
        _countAndSort(async.asData?.value.length),
        Expanded(
          child: async.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const Center(child: Text('목록을 불러오지 못했습니다.')),
            data: (list) {
              if (list.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Text('항목이 없습니다',
                        style: TextStyle(color: Color(0xFFAAB4C8))),
                  ),
                );
              }
              // 전체 메모 탭에서는 북마크한 메모를 정렬과 무관하게 항상 최상단에 고정.
              final items = widget.scope == MemoScope.all
                  ? [
                      ...list.where((m) => m.bookmarked),
                      ...list.where((m) => !m.bookmarked),
                    ]
                  : list;
              return RefreshIndicator(
                onRefresh: () async => ref.invalidate(memoListProvider),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final m = items[i];
                    return MemoCard(
                      memo: m,
                      onTap: () async {
                        await Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (_) => MemoDetailPage(memoId: m.id),
                          ),
                        );
                        ref.invalidate(memoListProvider);
                        ref.invalidate(allMemosProvider);
                      },
                      onBookmark: () => _toggleBookmark(m.id, m.bookmarked),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _searchBar() {
    OutlineInputBorder border(Color c, double w) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c, width: w),
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontSize: 14),
        onChanged: (v) => setState(() => _query = v),
        decoration: InputDecoration(
          hintText: '제목, 내용, 사업명 검색...',
          hintStyle: const TextStyle(color: Color(0xFFAAB4C8), fontSize: 14),
          prefixIcon: const Icon(LucideIcons.search, size: 16, color: AppColors.iconInactive),
          filled: true,
          fillColor: AppColors.surface,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          enabledBorder: border(AppColors.primary.withValues(alpha: 0.12), 1),
          focusedBorder: border(AppColors.catSchedule, 1.5),
          border: border(AppColors.primary.withValues(alpha: 0.12), 1),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear, size: 16, color: Color(0xFFAAB4C8)),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                ),
        ),
      ),
    );
  }

  Widget _chips() {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = _filters[i];
          final selected = _filter == f;
          return GestureDetector(
            onTap: () => setState(() => _filter = f),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(100),
                border: selected
                    ? null
                    : Border.all(color: AppColors.border),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                f,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? Colors.white : AppColors.textSub,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _countAndSort(int? count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 6),
      child: Row(
        children: [
          Text('총 ${count ?? 0}건',
              style: const TextStyle(fontSize: 13, color: AppColors.textSub)),
          const Spacer(),
          InkWell(
            key: _sortKey,
            onTap: _openSortMenu,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_sortLabels[_sort]!,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textSub)),
                  const Icon(LucideIcons.chevronDown,
                      size: 14, color: AppColors.textSub),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
