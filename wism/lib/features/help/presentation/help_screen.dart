import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../onboarding/presentation/onboarding_screen.dart';

/// 도움말 (#2) — 디자인 HelpScreen 기반. 확인자/확인 완료 워딩.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('도움말'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
        children: [
          _section('WISM이란?', [
            _body('관리자들이 중요한 일정·이슈·결정사항을 함께 공유하고 기록하는 앱입니다.'),
            const SizedBox(height: 8),
            _body('대화처럼 흘러가 사라지지 않고, 회사의 기록으로 남습니다.'),
          ]),
          const SizedBox(height: 12),
          _section('이렇게 사용하세요', const [
            _StepItem(
                title: '메모 작성하기',
                body:
                    "화면 오른쪽 아래 [+] 버튼을 누릅니다. 제목과 내용을 적고, 중요도(일반/긴급)와 카테고리를 고릅니다. 꼭 확인해야 할 사람을 '확인자'로 지정하고 [저장]을 누르면 관리자들에게 공유됩니다."),
            _StepItem(
                title: '긴급 이슈 확인하기',
                body:
                    "홈 맨 위 '미확인 긴급 이슈'에 내가 확인할 긴급한 글이 모입니다. 글을 열고 [확인 완료]를 누르면 확인 표시가 남고, 미확인 목록에서 사라집니다."),
            _StepItem(
                title: '확인 현황 보기',
                body:
                    "글쓴이는 누가 확인했고 누가 안 했는지 볼 수 있습니다. 상세 화면의 '확인 3/5'는 확인자 5명 중 3명이 확인했다는 뜻입니다."),
            _StepItem(
                title: '찾기 / 보관하기',
                body:
                    "위쪽 검색창에 제목·내용·프로젝트명을 넣어 찾습니다. 긴급·일정·이슈 버튼으로 종류별로 거릅니다. 글의 책갈피 표시를 누르면 '북마크' 탭에 모아둘 수 있습니다."),
            _StepItem(
                title: '알림',
                body: '오른쪽 위 종 모양에서 새 소식을 봅니다. 알림은 프로필 > 설정에서 켜고 끌 수 있습니다.'),
          ]),
          const SizedBox(height: 12),
          _section('용어 설명', [
            for (final (i, t) in _terms.indexed)
              _TermItem(term: t.$1, desc: t.$2, isFirst: i == 0),
          ]),
          const SizedBox(height: 12),
          // 온보딩 다시 보기
          Material(
            color: const Color(0xFFEBF3FB),
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (ctx) =>
                      OnboardingScreen(onFinish: () => Navigator.pop(ctx)),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.circlePlay, size: 18, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('처음 안내 다시 보기',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text('WISM ${AppInfo.versionLabel} · Wintek Corp.',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ),
        ],
      ),
    );
  }

  static const List<(String, String)> _terms = [
    ('미확인 긴급', '내가 확인자인 긴급 글 중, 아직 [확인 완료]를 안 누른 글'),
    ('확인 완료', "'이 내용을 봤습니다'를 기록하는 버튼 (누른 사람·시각이 남음)"),
    ('확인 3/5', '확인자 5명 중 3명이 확인 (누가 안 했는지는 글쓴이가 봄)'),
    ('확인자', '이 글을 꼭 확인해야 하는 사람. 긴급 글은 반드시 지정'),
    ('중요도/카테고리', '글의 성격을 나누는 표시 (일반·긴급 / 일정·이슈·결정사항·회의록 등)'),
  ];

  Widget _section(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textTitle)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  static Widget _body(String text) => Text(text,
      style: const TextStyle(
          fontSize: 16, height: 1.9, color: AppColors.textBody));
}

class _StepItem extends StatelessWidget {
  const _StepItem({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                    color: AppColors.primary, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textTitle)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(body,
                style: const TextStyle(
                    fontSize: 16, height: 1.9, color: AppColors.textBody)),
          ),
        ],
      ),
    );
  }
}

class _TermItem extends StatelessWidget {
  const _TermItem(
      {required this.term, required this.desc, required this.isFirst});
  final String term;
  final String desc;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: isFirst ? 0 : 12, bottom: 12),
      decoration: isFirst
          ? null
          : const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.divider))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(term,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary)),
          const SizedBox(height: 4),
          Text(desc,
              style: const TextStyle(
                  fontSize: 16, height: 1.85, color: AppColors.textBody)),
        ],
      ),
    );
  }
}
