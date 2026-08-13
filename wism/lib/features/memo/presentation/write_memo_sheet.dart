import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../application/memo_providers.dart';
import '../data/models/attachment.dart';
import '../data/models/memo.dart';
import '../data/models/user_ref.dart';
import '../domain/memo_draft.dart';
import 'widgets/attachment_widgets.dart';
import 'widgets/wism_date_picker.dart';

/// 직급 정렬 우선순위 (낮을수록 높은 직급 → 먼저 노출). 미등록 직급은 맨 뒤.
/// 현재 DB 실제 값: 대표이사·본부장·실장·팀장. 부사장~이사는 향후 대비 포함.
const _positionOrder = <String>[
  '대표이사', '부사장', '전무', '상무', '이사', '본부장', '실장', '팀장',
];

int _positionRank(String? position) {
  if (position == null || position.isEmpty) return _positionOrder.length;
  final i = _positionOrder.indexOf(position);
  return i < 0 ? _positionOrder.length : i;
}

/// 메모 작성/수정 — 디자인(MemoForm) 기반 중앙 모달. 성공 시 true 반환.
Future<bool?> showWriteMemoSheet(BuildContext context, {Memo? edit}) {
  return showDialog<bool>(
    context: context,
    useRootNavigator: true,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (_) => _WriteMemoDialog(edit: edit),
  );
}

class _WriteMemoDialog extends ConsumerStatefulWidget {
  const _WriteMemoDialog({this.edit});
  final Memo? edit;
  @override
  ConsumerState<_WriteMemoDialog> createState() => _WriteMemoDialogState();
}

class _WriteMemoDialogState extends ConsumerState<_WriteMemoDialog> {
  late final TextEditingController _title;
  late final TextEditingController _content;
  late String _priority;
  late String _category;
  DateTime? _scheduledDate;
  late List<UserRef> _assignees;
  late List<Attachment> _existingAttachments; // 수정 모드: 서버에 있는 첨부
  final List<PlatformFile> _pendingFiles = []; // 새로 선택(저장 시 업로드)
  // 인라인 검색(확인자/사업)
  final TextEditingController _assigneeQuery = TextEditingController();
  final TextEditingController _projectQuery = TextEditingController();
  final FocusNode _assigneeFocus = FocusNode();
  final FocusNode _projectFocus = FocusNode();
  bool _saving = false;

  bool get _isEdit => widget.edit != null;
  // 긴급 메모는 확인자(담당자) 1명 이상 필수 (#3).
  bool get _needsConfirmer => _priority == MemoPriority.urgent;
  bool get _canSubmit =>
      _title.text.trim().isNotEmpty &&
      (_category != MemoCategory.schedule || _scheduledDate != null) &&
      (!_needsConfirmer || _assignees.isNotEmpty);

  @override
  void initState() {
    super.initState();
    final e = widget.edit;
    _title = TextEditingController(text: e?.title ?? '');
    _content = TextEditingController(text: e?.content ?? '');
    _priority = e?.priority ?? MemoPriority.normal;
    _category = e?.category ?? MemoCategory.schedule;
    _scheduledDate = e?.scheduledDate;
    _assignees = e?.assignees
            .map((a) => UserRef(id: a.userId, name: a.name))
            .toList() ??
        [];
    _existingAttachments = e?.attachments.toList() ?? [];
    _projectQuery.text = e?.project?.name ?? '';
    _assigneeFocus.addListener(() => setState(() {}));
    _projectFocus.addListener(() => setState(() {}));
  }

  int get _attachmentCount => _existingAttachments.length + _pendingFiles.length;

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    _assigneeQuery.dispose();
    _projectQuery.dispose();
    _assigneeFocus.dispose();
    _projectFocus.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_canSubmit) return;
    setState(() => _saving = true);
    final draft = MemoDraft(
      title: _title.text.trim(),
      content: _content.text.trim(),
      priority: _priority,
      category: _category,
      projectId: _projectTag(),
      scheduledDate:
          _category == MemoCategory.schedule ? _scheduledDate : null,
      assigneeIds: _assignees.map((u) => u.id).toList(),
    );
    try {
      final repo = ref.read(memoRepositoryProvider);
      final Memo saved = _isEdit
          ? await repo.update(widget.edit!.id, draft)
          : await repo.create(draft);
      // 새로 선택한 첨부 업로드 (메모 생성 후 memoId 필요)
      for (final f in _pendingFiles) {
        final path = f.path;
        if (path != null) await repo.uploadAttachment(saved.id, path, f.name);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('저장에 실패했습니다.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = (size.width * 0.95).clamp(0.0, 480.0);
    return Dialog(
      insetPadding: const EdgeInsets.all(12),
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width,
          maxHeight: size.height * 0.88,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(),
            Flexible(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _field('제목',
                      TextField(
                        controller: _title,
                        onChanged: (_) => setState(() {}),
                        style: _inputTextStyle,
                        decoration: _dec('메모 제목을 입력하세요'),
                      )),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _field('중요도',
                            _dropdown(_priority, MemoPriority.all,
                                (v) => setState(() => _priority = v))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _field('카테고리',
                            _dropdown(_category, MemoCategory.all,
                                (v) => setState(() => _category = v))),
                      ),
                    ],
                  ),
                  if (_category == MemoCategory.schedule) ...[
                    const SizedBox(height: 16),
                    _field('일정 일시',
                        WismDatePicker(
                          value: _scheduledDate,
                          onChanged: (d) => setState(() => _scheduledDate = d),
                        )),
                  ],
                  const SizedBox(height: 16),
                  _field('사업 (프로젝트)', _projectField(), optional: true),
                  const SizedBox(height: 16),
                  _field('내용',
                      TextField(
                        controller: _content,
                        maxLines: 5,
                        style: _inputTextStyle,
                        decoration: _dec('메모 내용을 입력하세요'),
                      )),
                  const SizedBox(height: 16),
                  _field(_needsConfirmer ? '확인자 태그 *' : '확인자 태그',
                      _assigneeField(), optional: !_needsConfirmer),
                  const SizedBox(height: 16),
                  _field('첨부파일', _attachmentField(), optional: true),
                ],
              ),
            ),
            _footer(),
          ],
        ),
      ),
    );
  }

  // ── 헤더 ──
  Widget _header() => Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            Text(_isEdit ? '메모 수정' : '새 메모 작성',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textTitle)),
            const Spacer(),
            InkWell(
              onTap: () => Navigator.pop(context),
              customBorder: const CircleBorder(),
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                    color: AppColors.background, shape: BoxShape.circle),
                child: const Icon(LucideIcons.x, size: 15, color: AppColors.textSub),
              ),
            ),
          ],
        ),
      );

  // ── 푸터 ──
  Widget _footer() => Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSub,
                  backgroundColor: AppColors.background,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                ),
                child: const Text('취소',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: (_saving || !_canSubmit) ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.buttonDisabled,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                ),
                child: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('저장',
                        style:
                            TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      );

  // ── 공통 필드 (라벨 + 위젯) ──
  Widget _field(String label, Widget child, {bool optional = false}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTitle)),
                if (optional) ...[
                  const SizedBox(width: 4),
                  const Text('(선택)',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textMuted)),
                ],
              ],
            ),
          ),
          child,
        ],
      );

  static const _inputTextStyle =
      TextStyle(fontSize: 14, color: AppColors.textTitle);

  InputDecoration _dec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: Color(0xFFA0ADB8)),
        isDense: true,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        enabledBorder: _border(AppColors.border, 1),
        focusedBorder: _border(AppColors.primary, 1),
        border: _border(AppColors.border, 1),
      );

  static OutlineInputBorder _border(Color c, double w) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: c, width: w),
      );

  Widget _dropdown(String value, List<String> items, ValueChanged<String> onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isDense: true,
      icon: const Icon(LucideIcons.chevronDown, size: 16, color: AppColors.textSub),
      style: _inputTextStyle,
      decoration: _dec(''),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) => v == null ? null : onChanged(v),
    );
  }

  /// 저장할 사업 태그. 자유 입력이라 적은 글자가 곧 값이다(선택 강제 없음).
  String? _projectTag() {
    final t = _projectQuery.text.trim();
    return t.isEmpty ? null : t;
  }

  // ── 사업(프로젝트): 자유 입력 태그 + 이미 쓰인 태그 추천 ──
  //
  // 회사 공식 사업명을 아직 받을 수 없어 사용자가 직접 적는다. 다만 같은 사업을
  // 사람마다 다르게 적으면 나중에 사업별로 묶어 볼 수 없으므로, 이미 쓰인 태그를
  // 같이 띄워 눌러 쓰게 한다(메모 목록에 들어있는 값이라 서버 호출 없음).
  Widget _projectField() {
    final q = _projectQuery.text.trim();
    final showPanel = _projectFocus.hasFocus;
    final remain = ProjectTag.maxChars - _projectQuery.text.runes.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _searchInput(
          controller: _projectQuery,
          focus: _projectFocus,
          hint: '사업명을 입력하세요',
          inputFormatters: const [_ProjectTagFormatter()],
          onChanged: () {},
          onClear: q.isEmpty ? null : () => setState(_projectQuery.clear),
        ),
        if (showPanel) ...[
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              '최대 ${ProjectTag.maxChars}자 · $remain자 남음',
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ),
          _panelBox(
            child: ref.watch(usedProjectTagsProvider).maybeWhen(
                  data: (tags) => _projectSuggestions(tags, q),
                  orElse: _panelLoading,
                ),
          ),
        ],
      ],
    );
  }

  /// 추천 목록 = (이미 쓰인 태그 중 입력어와 겹치는 것) + (신규 태그로 쓰기).
  Widget _projectSuggestions(List<String> tags, String q) {
    final matched = tags
        .where((t) => q.isEmpty || t.toLowerCase().contains(q.toLowerCase()))
        .toList();
    final isNew = q.isNotEmpty && !tags.any((t) => t == q);
    if (matched.isEmpty && !isNew) {
      return _panelEmpty('아직 쓰인 사업이 없습니다. 직접 입력하세요');
    }
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 4),
      children: [
        if (isNew)
          _panelTile(
            leading: _miniIcon(LucideIcons.plus),
            title: '\'$q\' 새 사업으로 쓰기',
            onTap: () => setState(_projectFocus.unfocus),
          ),
        ...matched.map((t) => _panelTile(
              leading: _miniIcon(LucideIcons.briefcase),
              title: t,
              onTap: () => setState(() {
                _projectQuery.text = t;
                _projectFocus.unfocus();
              }),
            )),
      ],
    );
  }

  // ── 확인자: 인라인 검색 드롭다운 (이름·부서명 검색 → 개인 결과, 직급 순) ──
  Widget _assigneeField() {
    final showRequiredHint = _needsConfirmer && _assignees.isEmpty;
    final q = _assigneeQuery.text.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_assignees.isNotEmpty) ...[
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _assignees.map((u) {
              return Container(
                padding: const EdgeInsets.fromLTRB(8, 3, 6, 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FB),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('@${u.name}',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary)),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => setState(() => _assignees.remove(u)),
                      child: const Icon(LucideIcons.x,
                          size: 11, color: AppColors.primary),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ],
        _searchInput(
          controller: _assigneeQuery,
          focus: _assigneeFocus,
          hint: '이름 또는 부서명으로 검색',
          onChanged: () {},
        ),
        if (_assigneeFocus.hasFocus) _assigneePanel(q),
        if (showRequiredHint) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.error_outline,
                  size: 13, color: AppColors.danger),
              const SizedBox(width: 4),
              Text('긴급 메모는 확인자를 1명 이상 지정해야 합니다.',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.danger.withValues(alpha: 0.9))),
            ],
          ),
        ],
      ],
    );
  }

  Widget _assigneePanel(String q) {
    // 포커스 시 입력 전에도 전체 사용자 목록을 미리보기로 노출(부서→직급→이름 순).
    final userList = ref.watch(userSearchProvider(q)).maybeWhen(
          data: (all) {
            final filtered = all
                .where((u) => !_assignees.any((e) => e.id == u.id))
                .toList()
              // 부서 → 직급(높은 직급 먼저) → 이름 순
              ..sort((a, b) {
                final d = (a.dept ?? '').compareTo(b.dept ?? '');
                if (d != 0) return d;
                final r = _positionRank(a.position)
                    .compareTo(_positionRank(b.position));
                return r != 0 ? r : a.name.compareTo(b.name);
              });
            return filtered;
          },
          orElse: () => <UserRef>[],
        );
    if (userList.isEmpty) {
      return _panelBox(
        child: _panelEmpty(q.isEmpty ? '이름 또는 부서명을 입력하세요' : '검색 결과가 없습니다'),
      );
    }
    return _panelBox(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 4),
        children: userList
            .map((u) => _panelTile(
                  leading: _miniAvatar(u.name.characters.first),
                  title: (u.position == null || u.position!.isEmpty)
                      ? u.name
                      : '${u.name} ${u.position}',
                  subtitle: u.dept,
                  onTap: () => setState(() {
                    _assignees.add(u);
                    _assigneeQuery.clear();
                  }),
                ))
            .toList(),
      ),
    );
  }

  // ── 인라인 검색 공용 위젯 ──
  Widget _searchInput({
    required TextEditingController controller,
    required FocusNode focus,
    required String hint,
    VoidCallback? onChanged,
    VoidCallback? onClear,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      focusNode: focus,
      inputFormatters: inputFormatters,
      style: _inputTextStyle,
      onChanged: (_) => setState(() => onChanged?.call()),
      decoration: _dec(hint).copyWith(
        prefixIcon:
            const Icon(LucideIcons.search, size: 16, color: AppColors.textMuted),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 38, minHeight: 38),
        suffixIcon: onClear == null
            ? null
            : IconButton(
                icon: const Icon(LucideIcons.x,
                    size: 16, color: AppColors.textMuted),
                onPressed: onClear,
              ),
      ),
    );
  }

  Widget _panelBox({required Widget child}) => Container(
        margin: const EdgeInsets.only(top: 4),
        constraints: const BoxConstraints(maxHeight: 220),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 16,
                offset: const Offset(0, 4)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      );

  Widget _panelTile({
    required Widget leading,
    required String title,
    String? subtitle,
    String? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 44,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              leading,
              const SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textTitle)),
              ),
              if (subtitle != null && subtitle.isNotEmpty)
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted)),
              if (trailing != null)
                Text(trailing,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _panelEmpty(String t) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
            child: Text(t,
                style:
                    const TextStyle(fontSize: 13, color: AppColors.textMuted))),
      );

  Widget _panelLoading() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: SizedBox(
              width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );

  Widget _miniIcon(IconData icon) => SizedBox(
        width: 22,
        child: Icon(icon, size: 16, color: AppColors.primary),
      );

  Widget _miniAvatar(String initial) => Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(
            color: Color(0xFFEBF3FB), shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Text(initial,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.primary)),
      );

  // ── 첨부파일 ──
  String _kindOf(String name) {
    final ext = name.contains('.') ? name.split('.').last.toLowerCase() : '';
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

  String _sizeLabel(int bytes) {
    final kb = bytes / 1024;
    if (kb >= 1024) return '${(kb / 1024).toStringAsFixed(1)} MB';
    return '${kb.round()} KB';
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _pickFiles() async {
    if (_attachmentCount >= AttachmentLimit.maxPerMemo) {
      _toast('첨부는 최대 ${AttachmentLimit.maxPerMemo}개까지입니다.');
      return;
    }
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: AttachmentLimit.allowedExtensions,
    );
    if (result == null) return;
    for (final f in result.files) {
      if (_attachmentCount >= AttachmentLimit.maxPerMemo) {
        _toast('첨부는 최대 ${AttachmentLimit.maxPerMemo}개까지입니다.');
        break;
      }
      final ext = (f.extension ?? '').toLowerCase();
      if (!AttachmentLimit.allowedExtensions.contains(ext)) {
        _toast('허용되지 않은 형식입니다: ${f.name}');
        continue;
      }
      if (f.size > AttachmentLimit.maxBytes) {
        _toast('10MB를 초과했습니다: ${f.name}');
        continue;
      }
      setState(() => _pendingFiles.add(f));
    }
  }

  Future<void> _removeExisting(Attachment a) async {
    try {
      await ref.read(memoRepositoryProvider).deleteAttachment(a.id);
      if (mounted) {
        setState(() => _existingAttachments.removeWhere((e) => e.id == a.id));
      }
    } catch (_) {
      _toast('첨부 삭제에 실패했습니다.');
    }
  }

  Widget _attachmentField() {
    final canAdd = _attachmentCount < AttachmentLimit.maxPerMemo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 점선 파일 첨부 버튼
        Opacity(
          opacity: canAdd ? 1 : 0.45,
          child: InkWell(
            onTap: canAdd ? _pickFiles : null,
            borderRadius: BorderRadius.circular(12),
            child: CustomPaint(
              painter: _DashedRRectPainter(
                  color: AppColors.border, radius: 12, dash: 5, gap: 4),
              child: const SizedBox(
                width: double.infinity,
                height: 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.paperclip, size: 16, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('파일 첨부',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary)),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Center(
          child: Text('이미지·PDF·문서 첨부 가능 (최대 3개·10MB)',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ),
        // 기존(서버) 첨부
        for (final a in _existingAttachments) ...[
          const SizedBox(height: 8),
          _attachmentRow(
            kind: a.kind,
            name: a.fileName,
            sizeText: a.sizeLabel,
            onRemove: () => _removeExisting(a),
          ),
        ],
        // 새로 선택한 파일
        for (final f in _pendingFiles) ...[
          const SizedBox(height: 8),
          _attachmentRow(
            kind: _kindOf(f.name),
            name: f.name,
            sizeText: _sizeLabel(f.size),
            onRemove: () => setState(() => _pendingFiles.remove(f)),
          ),
        ],
      ],
    );
  }

  Widget _attachmentRow({
    required String kind,
    required String name,
    required String sizeText,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          AttachmentTypeIcon(kind),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTitle)),
                const SizedBox(height: 2),
                Text(sizeText,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(LucideIcons.x, size: 16, color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }

}

/// 점선 둥근 사각 테두리 (첨부 버튼) — 디자인의 dashed border.
class _DashedRRectPainter extends CustomPainter {
  _DashedRRectPainter({
    required this.color,
    required this.radius,
    this.dash = 5,
    this.gap = 4,
  });
  final Color color;
  final double radius;
  final double dash;
  final double gap;
  final double strokeWidth = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    for (final metric in path.computeMetrics()) {
      var dist = 0.0;
      while (dist < metric.length) {
        final next = dist + dash;
        canvas.drawPath(
          metric.extractPath(dist, next.clamp(0, metric.length)),
          paint,
        );
        dist = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRRectPainter old) =>
      old.color != color || old.radius != radius;
}

/// 사업 태그 입력 제한.
///
/// 사용자에게는 "10자"로만 안내하지만, 저장처인 오라클 `PJTCODE` 는 30 **바이트**
/// 제한이라 이모지처럼 무거운 문자가 섞이면 10자여도 넘칠 수 있다. 넘치면 오라클이
/// ORA-12899 로 거부해 저장 자체가 실패하므로, 글자 수와 바이트 수를 함께 막는다.
class _ProjectTagFormatter extends TextInputFormatter {
  const _ProjectTagFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.runes.length <= ProjectTag.maxChars &&
        utf8.encode(text).length <= ProjectTag.maxBytes) {
      return newValue;
    }
    return oldValue; // 한도를 넘는 입력은 그냥 무시한다.
  }
}
