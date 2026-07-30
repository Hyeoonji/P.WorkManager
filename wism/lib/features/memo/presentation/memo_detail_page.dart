import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/utils/formats.dart';
import '../../../shared/widgets/app_dialog.dart';
import '../../../shared/widgets/memo_badges.dart';
import '../../auth/application/auth_controller.dart';
import '../application/memo_providers.dart';
import '../domain/memo_repository.dart';
import '../data/models/attachment.dart';
import '../data/models/comment.dart';
import '../data/models/memo.dart';
import 'widgets/attachment_widgets.dart';
import 'write_memo_sheet.dart';

class MemoDetailPage extends ConsumerStatefulWidget {
  const MemoDetailPage({super.key, required this.memoId});
  final String memoId;

  @override
  ConsumerState<MemoDetailPage> createState() => _MemoDetailPageState();
}

class _MemoDetailPageState extends ConsumerState<MemoDetailPage> {
  final _commentController = TextEditingController();
  bool _sending = false;
  bool _gone = false; // 삭제된 메모 안내·홈복귀를 한 번만 실행하기 위한 가드

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _refresh() {
    ref.invalidate(memoDetailProvider(widget.memoId));
    ref.invalidate(memoListProvider);
    ref.invalidate(allMemosProvider);
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() => _sending = true);
    try {
      await ref.read(memoRepositoryProvider).addComment(widget.memoId, text);
      _commentController.clear();
      _refresh();
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _saveCommentEdit(Comment c, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || trimmed == c.content) return;
    await ref
        .read(memoRepositoryProvider)
        .updateComment(widget.memoId, c.id, trimmed);
    _refresh();
  }

  Future<void> _deleteComment(Comment c) async {
    final ok = await showConfirmDialog(
      context,
      title: '댓글을 삭제할까요?',
      message: '삭제된 댓글은 복구할 수 없습니다.',
      confirmText: '삭제',
      confirmColor: AppColors.danger,
    );
    if (ok != true) return;
    await ref
        .read(memoRepositoryProvider)
        .deleteComment(widget.memoId, c.id);
    _refresh();
  }

  Future<void> _delete() async {
    final ok = await showConfirmDialog(
      context,
      title: '메모를 삭제할까요?',
      message: '삭제된 메모는 복구할 수 없습니다.',
      confirmText: '삭제',
      confirmColor: AppColors.danger,
    );
    if (ok != true) return;
    await ref.read(memoRepositoryProvider).delete(widget.memoId);
    ref.invalidate(memoListProvider);
    ref.invalidate(allMemosProvider);
    if (mounted) Navigator.pop(context);
  }

  /// 확인자가 '확인 완료'(읽음 기록 생성). 홈 미확인 긴급에서 사라짐.
  Future<void> _confirm() async {
    await ref.read(memoRepositoryProvider).markRead(widget.memoId);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(memoDetailProvider(widget.memoId));
    final currentUserId = ref.watch(authControllerProvider).user?.id;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('메모 상세'),
        centerTitle: true,
        actions: [
          async.maybeWhen(
            data: (m) {
              if (m.author.id != currentUserId) return const SizedBox.shrink();
              return PopupMenuButton<String>(
                icon: const Icon(LucideIcons.moreVertical),
                color: AppColors.surface,
                elevation: 8,
                clipBehavior: Clip.antiAlias,
                position: PopupMenuPosition.under,
                constraints: const BoxConstraints(minWidth: 120),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.cardBorder),
                ),
                onSelected: (v) async {
                  if (v == 'edit') {
                    final saved = await showWriteMemoSheet(context, edit: m);
                    if (saved == true) _refresh();
                  } else if (v == 'delete') {
                    _delete();
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'edit',
                    height: 44,
                    padding: EdgeInsets.zero,
                    child: _MenuRow(text: '수정', borderBottom: true),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    height: 44,
                    padding: EdgeInsets.zero,
                    child: _MenuRow(text: '삭제', color: AppColors.danger),
                  ),
                ],
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _errorView(e),
        data: (memo) => Column(
          children: [
            Expanded(child: _body(memo)),
            _commentInput(),
          ],
        ),
      ),
    );
  }

  /// 상세 로드 실패 화면. 삭제된 메모(404)면 안내 후 홈으로 자동 복귀하고
  /// 목록을 갱신해 무한 재조회를 끊는다. 그 외 오류는 재시도 버튼을 준다.
  Widget _errorView(Object error) {
    final gone = error is MemoNotFoundException;
    if (gone && !_gone) {
      _gone = true;
      // build 중 네비게이션 금지 → 프레임 종료 후 실행.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.invalidate(memoListProvider);
        ref.invalidate(allMemosProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('삭제된 메모입니다.')),
        );
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/home');
        }
      });
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            gone ? LucideIcons.trash2 : LucideIcons.wifiOff,
            size: 40,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 12),
          Text(
            gone ? '삭제된 메모입니다.' : '메모를 불러오지 못했습니다.',
            style: const TextStyle(color: AppColors.textMuted),
          ),
          if (!gone) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => ref.invalidate(memoDetailProvider(widget.memoId)),
              child: const Text('다시 시도'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _body(Memo memo) {
    final currentUserId = ref.read(authControllerProvider).user?.id;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.primary.withValues(alpha: 0.08)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (memo.isUrgent) const UrgentBadge(),
                    CategoryBadge(memo.category),
                    if (memo.project != null) ProjectBadge(memo.project!.name),
                  ],
                ),
                const SizedBox(height: 12),
                Text(memo.title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: AppColors.textTitle)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                          color: Color(0xFFEBF3FB), shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: Text(
                        memo.author.name.characters.first,
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                        '${memo.author.name} 작성 · ${fmtDate(memo.createdAt)} ${fmtTime(memo.createdAt)}',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF8A94A6))),
                  ],
                ),
                if (memo.scheduledDate != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F1FB),
                      borderRadius: BorderRadius.circular(8), // 일정 칩 = rBadge 8
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.calendarDays,
                            size: 14, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text('일정: ${fmtScheduled(memo.scheduledDate!)}',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary)),
                      ],
                    ),
                  ),
                ],
                if (memo.assignees.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: memo.assignees
                        .map((a) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBF3FB),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text('@${a.name}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primary)),
                            ))
                        .toList(),
                  ),
                ],
                Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    color: AppColors.divider),
                Text(
                  (memo.content ?? '').isEmpty ? '내용이 없습니다.' : memo.content!,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textBody, height: 1.6),
                ),
              ],
            ),
          ),
        ),
        // 첨부파일
        if (memo.attachments.isNotEmpty) ...[
          const SizedBox(height: 16),
          _attachmentsCard(memo),
        ],
        // 확인 현황 — 긴급 메모 + 확인자 있을 때, 그리고 내가 확인자이거나 작성자일 때만 (#4·#5)
        if (memo.isUrgent &&
            memo.assignees.isNotEmpty &&
            (memo.isConfirmer || memo.author.id == currentUserId)) ...[
          const SizedBox(height: 16),
          _confirmSection(memo, currentUserId),
        ],
        const SizedBox(height: 16),
        Text('댓글${memo.comments.isNotEmpty ? ' (${memo.comments.length})' : ''}',
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textTitle)),
        const SizedBox(height: 8),
        if (memo.comments.isEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
            ),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.messageSquare,
                      size: 32, color: Color(0xFFD1D9E6)),
                  SizedBox(height: 8),
                  Text('첫 번째 댓글을 남겨보세요',
                      style: TextStyle(color: AppColors.textMuted)),
                ],
              ),
            ),
          )
        else
          ...memo.comments.map((c) => _CommentTile(
                comment: c,
                isOwn: c.author.id == currentUserId,
                onSave: (text) => _saveCommentEdit(c, text),
                onDelete: () => _deleteComment(c),
              )),
      ],
    );
  }

  // ── 첨부파일 ──
  Future<void> _openAttachment(Attachment a) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(content: Text('${a.fileName} 여는 중...'), duration: const Duration(seconds: 1)),
    );
    try {
      final bytes = await ref
          .read(memoRepositoryProvider)
          .downloadAttachment(a.id);
      // 1) 임시 파일로 저장(열기용)
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${a.fileName}');
      await file.writeAsBytes(bytes);

      // 2) 공용 저장소(Download/WISM)에 저장 — '내 파일'에서 보이게
      String? savedMsg;
      try {
        final saveInfo = await MediaStore().saveFile(
          tempFilePath: file.path,
          dirType: DirType.download,
          dirName: DirName.download,
        );
        if (saveInfo != null) {
          savedMsg = saveInfo.isDuplicated
              ? '이미 다운로드 폴더에 있습니다'
              : '다운로드 폴더(WISM)에 저장됨';
        }
      } catch (e) {
        savedMsg = '저장 실패(열기는 시도)';
        debugPrint('[attach] MediaStore 저장 실패: $e');
      }

      // 3) 뷰어로 열기
      final result = await OpenFilex.open(file.path);
      if (!mounted) return;
      if (result.type != ResultType.done) {
        messenger.showSnackBar(
          SnackBar(content: Text('파일을 열 수 없습니다: ${result.message}')),
        );
      } else if (savedMsg != null) {
        messenger.showSnackBar(SnackBar(content: Text(savedMsg)));
      }
    } catch (_) {
      if (mounted) {
        messenger.showSnackBar(
            const SnackBar(content: Text('다운로드에 실패했습니다.')));
      }
    }
  }

  Widget _attachmentsCard(Memo memo) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.paperclip, size: 14, color: AppColors.textSub),
              const SizedBox(width: 8),
              Text('첨부파일 (${memo.attachments.length})',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSub)),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < memo.attachments.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            _attachmentRow(memo.attachments[i]),
          ],
        ],
      ),
    );
  }

  Widget _attachmentRow(Attachment a) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _openAttachment(a),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              AttachmentTypeIcon(a.kind),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textTitle)),
                    const SizedBox(height: 2),
                    Text(a.sizeLabel,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              ),
              const Icon(LucideIcons.download,
                  size: 16, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  // ── 확인 현황 (긴급 메모) ──
  Widget _confirmSection(Memo memo, String? currentUserId) {
    final isAuthor = memo.author.id == currentUserId;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: memo.isConfirmer
                    ? _confirmButton(memo.confirmedByMe)
                    : _notTargetBox(),
              ),
              // 확인 인원 카운트(N/M)는 작성자에게만 노출.
              if (isAuthor) ...[
                const SizedBox(width: 12),
                _countBox(memo.confirmedCount, memo.confirmerCount),
              ],
            ],
          ),
        ),
        if (isAuthor) ...[
          const SizedBox(height: 12),
          _confirmNames(memo),
        ],
      ],
    );
  }

  Widget _confirmButton(bool confirmed) {
    final bg = confirmed ? const Color(0xFFE6F4EA) : AppColors.primary;
    final fg = confirmed ? AppColors.catDecision : Colors.white;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: confirmed ? null : _confirm,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.checkCircle, size: 16, color: fg),
              const SizedBox(width: 8),
              Text(confirmed ? '확인함' : '확인 완료',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, color: fg)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notTargetBox() {
    return Container(
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: const Text('확인 대상이 아닙니다',
          style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
    );
  }

  Widget _countBox(int n, int m) {
    return Container(
      constraints: const BoxConstraints(minWidth: 62),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text.rich(
            TextSpan(children: [
              TextSpan(
                  text: '$n',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary)),
              TextSpan(
                  text: '/$m',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textMuted)),
            ]),
          ),
          const SizedBox(height: 2),
          const Text('확인',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _confirmNames(Memo memo) {
    final done = memo.assignees.where((a) => a.confirmed).toList();
    final pending = memo.assignees.where((a) => !a.confirmed).toList();
    Widget chip(String name, {required bool ok}) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: ok ? const Color(0xFFE6F4EA) : AppColors.background,
            borderRadius: BorderRadius.circular(6),
            border: ok ? null : Border.all(color: AppColors.border),
          ),
          child: Text(name,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: ok ? AppColors.catDecision : AppColors.textSub)),
        );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (done.isNotEmpty) ...[
            Text('확인 완료 (${done.length})',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.catDecision)),
            const SizedBox(height: 8),
            Wrap(
                spacing: 6,
                runSpacing: 6,
                children: done.map((a) => chip(a.name, ok: true)).toList()),
          ],
          if (done.isNotEmpty && pending.isNotEmpty)
            const SizedBox(height: 12),
          if (pending.isNotEmpty) ...[
            Text('미확인 (${pending.length})',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted)),
            const SizedBox(height: 8),
            Wrap(
                spacing: 6,
                runSpacing: 6,
                children: pending.map((a) => chip(a.name, ok: false)).toList()),
          ],
        ],
      ),
    );
  }

  Widget _commentInput() {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: Color(0x1A14387F))),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFEBF3FB),
              child: Text(
                (ref.read(authControllerProvider).user?.name ?? '나')
                    .characters
                    .first,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _commentController,
                minLines: 1,
                maxLines: 4,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(fontSize: 14, color: AppColors.textTitle),
                decoration: InputDecoration(
                  hintText: '댓글을 입력하세요...',
                  hintStyle:
                      const TextStyle(fontSize: 14, color: AppColors.textMuted),
                  isDense: true,
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0x1A14387F)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.skyBlue),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0x1A14387F)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _SendButton(
                enabled: !_sending && _commentController.text.trim().isNotEmpty,
                onTap: _addComment),
          ],
        ),
      ),
    );
  }
}

/// 팝업 메뉴 항목 — 흰 카드 메뉴 안의 한 줄(높이 44, 14px w500).
class _MenuRow extends StatelessWidget {
  const _MenuRow(
      {required this.text,
      this.color = AppColors.textTitle,
      this.borderBottom = false});
  final String text;
  final Color color;
  final bool borderBottom;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: 44,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: borderBottom
            ? const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.divider)))
            : null,
        child: Text(text,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: color)),
      );
}

/// 댓글 한 줄 — 본인 댓글은 ⋮ 메뉴(수정/삭제), 수정은 인라인 편집(#8).
class _CommentTile extends StatefulWidget {
  const _CommentTile({
    required this.comment,
    required this.isOwn,
    required this.onSave,
    required this.onDelete,
  });
  final Comment comment;
  final bool isOwn;
  final Future<void> Function(String text) onSave;
  final VoidCallback onDelete;

  @override
  State<_CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<_CommentTile> {
  late final TextEditingController _ctrl =
      TextEditingController(text: widget.comment.content);
  bool _editing = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _startEdit() {
    _ctrl.text = widget.comment.content;
    setState(() => _editing = true);
  }

  void _cancel() {
    _ctrl.text = widget.comment.content;
    setState(() => _editing = false);
  }

  Future<void> _save() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _editing = false);
    await widget.onSave(text);
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.comment;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xFFEBF3FB),
            child: Text(c.author.name.characters.first,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(c.author.name,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Text(fmtTime(c.createdAt),
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
                    if (c.type == 'status') ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: const Color(0xFFE6F4EA),
                            borderRadius: BorderRadius.circular(6)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.checkCircle,
                                size: 11, color: AppColors.catDecision),
                            SizedBox(width: 3),
                            Text('확인 완료',
                                style: TextStyle(
                                    fontSize: 11, color: AppColors.catDecision)),
                          ],
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (widget.isOwn && !_editing)
                      SizedBox(
                        height: 22,
                        width: 28,
                        child: PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          iconSize: 18,
                          color: AppColors.surface,
                          elevation: 8,
                          clipBehavior: Clip.antiAlias,
                          position: PopupMenuPosition.under,
                          constraints: const BoxConstraints(minWidth: 120),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: AppColors.cardBorder),
                          ),
                          icon: const Icon(LucideIcons.moreVertical,
                              color: AppColors.textMuted),
                          onSelected: (v) =>
                              v == 'edit' ? _startEdit() : widget.onDelete(),
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                                value: 'edit',
                                height: 44,
                                padding: EdgeInsets.zero,
                                child: _MenuRow(text: '수정', borderBottom: true)),
                            PopupMenuItem(
                                value: 'delete',
                                height: 44,
                                padding: EdgeInsets.zero,
                                child:
                                    _MenuRow(text: '삭제', color: AppColors.danger)),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                if (_editing)
                  _editor()
                else
                  Text(c.content,
                      style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textBody,
                          height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 인라인 편집 영역 — textarea + 취소/저장 (디자인 CommentItem).
  Widget _editor() {
    OutlineInputBorder border(Color c, double w) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c, width: w),
        );
    return Padding(
      padding: const EdgeInsets.only(top: 4, right: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _ctrl,
            autofocus: true,
            minLines: 2,
            maxLines: 5,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(fontSize: 14, color: AppColors.textTitle),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: AppColors.background,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              enabledBorder: border(AppColors.border, 1),
              focusedBorder: border(AppColors.primary, 1),
              border: border(AppColors.border, 1),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 32,
                child: OutlinedButton(
                  onPressed: _cancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSub,
                    backgroundColor: AppColors.background,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    textStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  child: const Text('취소'),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 32,
                child: FilledButton(
                  onPressed: _ctrl.text.trim().isEmpty ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.buttonDisabled,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    textStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('저장'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 댓글 전송 버튼 — 36 원형, 활성 네이비 / 비활성 #D1D9E6.
class _SendButton extends StatelessWidget {
  const _SendButton({required this.enabled, required this.onTap});
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled ? AppColors.primary : const Color(0xFFD1D9E6),
          shape: BoxShape.circle,
        ),
        child: const Icon(LucideIcons.send, size: 16, color: Colors.white),
      ),
    );
  }
}
