import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/application/auth_controller.dart';
import '../../help/presentation/help_screen.dart';
import '../application/profile_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final stats = ref.watch(profileStatsProvider);
    final pushEnabled = ref.watch(pushEnabledProvider);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final initials = user.name.characters.take(2).toString();

    return Scaffold(
      appBar: AppBar(title: const Text('프로필')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── 1. 프로필 카드 ──
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                            color: Color(0xFFEBF3FB), shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: Text(initials,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textTitle)),
                            if ([user.dept, user.position]
                                .any((e) => e != null && e.isNotEmpty)) ...[
                              const SizedBox(height: 2),
                              Text(
                                [user.dept, user.position]
                                    .where((e) => e != null && e.isNotEmpty)
                                    .join(' · '),
                                style: const TextStyle(
                                    fontSize: 12, color: AppColors.textMuted),
                              ),
                            ],
                          ],
                        ),
                      ),
                      // 프로필은 회사 인사시스템(WGSOM) 소유 — 앱에서 수정 불가(읽기전용)
                    ],
                  ),
                ),
                _fullDivider(),
                _infoRow(LucideIcons.mail, '이메일', user.email ?? '-'),
                _indentDivider(),
                _infoRow(LucideIcons.phone, '전화번호', user.phone ?? '-'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── 2. 활동 통계 ──
          const _SectionLabel('활동 통계'),
          _card(
            child: stats.when(
              loading: () => const SizedBox(
                  height: 88, child: Center(child: CircularProgressIndicator())),
              error: (_, _) => const SizedBox(
                  height: 88, child: Center(child: Text('통계를 불러오지 못했습니다.'))),
              data: (s) => IntrinsicHeight(
                child: Row(
                  children: [
                    _stat('내 메모', s.memos, AppColors.primary,
                        const Color(0xFFEBF3FB), LucideIcons.fileText),
                    _statDivider(),
                    _stat('댓글', s.comments, AppColors.catMeeting,
                        const Color(0xFFEEEAF6), LucideIcons.messageSquare),
                    _statDivider(),
                    _stat('북마크', s.bookmarks, AppColors.catDecision,
                        const Color(0xFFE6F4EA), LucideIcons.bookmark),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── 3. 설정 ──
          const _SectionLabel('설정'),
          _card(
            child: Column(
              children: [
                _settingRow(
                  iconBg: const Color(0xFFFEF3E2),
                  iconColor: const Color(0xFFD9822B),
                  icon: LucideIcons.bell,
                  label: '푸시 알림',
                  trailing: _Toggle(
                    value: pushEnabled,
                    onChanged: (v) =>
                        ref.read(pushEnabledProvider.notifier).set(v),
                  ),
                ),
                _indentDivider(),
                _settingRow(
                  iconBg: const Color(0xFFEEF1F5),
                  iconColor: AppColors.textSub,
                  icon: LucideIcons.info,
                  label: '버전 정보',
                  trailing: const Text(AppInfo.versionLabel,
                      style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                ),
                _indentDivider(),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HelpScreen()),
                  ),
                  child: _settingRow(
                    iconBg: const Color(0xFFEBF3FB),
                    iconColor: AppColors.primary,
                    icon: LucideIcons.circleHelp,
                    label: '도움말',
                    trailing: const Icon(LucideIcons.chevronRight,
                        size: 18, color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── 4. 로그아웃 ──
          _fullDivider(),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => ref.read(authControllerProvider.notifier).logout(),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.logOut, size: 16, color: AppColors.danger),
                  SizedBox(width: 8),
                  Text('로그아웃',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.danger)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: child,
      );

  Widget _fullDivider() =>
      Container(height: 1, color: AppColors.divider);

  Widget _indentDivider() => Container(
      height: 1, margin: const EdgeInsets.only(left: 56), color: AppColors.divider);

  Widget _infoRow(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFEBF3FB),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 16, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textMuted)),
                  Text(value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.textBody)),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _settingRow({
    required Color iconBg,
    required Color iconColor,
    required IconData icon,
    required String label,
    required Widget trailing,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration:
                  BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
              alignment: Alignment.center,
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: const TextStyle(fontSize: 14, color: AppColors.textBody)),
            ),
            trailing,
          ],
        ),
      );

  Widget _stat(String label, int count, Color iconColor, Color bg, IconData icon) =>
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(height: 6),
              Text('$count',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      height: 1)),
              const SizedBox(height: 2),
              Text(label,
                  style:
                      const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
        ),
      );

  Widget _statDivider() => Container(
      width: 1,
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: AppColors.divider);
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(text,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted)),
      );
}

/// 커스텀 토글 — 44×24, ON 네이비 / OFF #D1D8E0.
class _Toggle extends StatelessWidget {
  const _Toggle({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          color: value ? AppColors.primary : AppColors.toggleOff,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(2),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
