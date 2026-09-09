import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/providers.dart';
import '../features/hints/hint_repository.dart';
import '../theme/app_theme.dart';

/// Обучающая подсказка «что за что отвечает». Показывается один раз (пока
/// ключ не в ui_hint_seen), сворачивается по кнопке «Понятно». Рядом —
/// маленькая «?», чтобы открыть подсказку снова в любой момент.
class HintBanner extends ConsumerWidget {
  final String hintKey;
  final String title;
  final String body;
  final List<String>? bullets;

  const HintBanner({
    super.key,
    required this.hintKey,
    required this.title,
    required this.body,
    this.bullets,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colors;
    final seen = ref.watch(seenHintsProvider).value ?? const <String>{};
    final userId = ref.watch(sessionProvider).value;

    if (seen.contains(hintKey)) {
      return Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: () => _openSheet(context, colors),
          icon: Icon(Icons.help_outline, size: 15, color: colors.muted),
          label: Text('Что это за раздел', style: TextStyle(fontSize: 12, color: colors.muted)),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
      decoration: BoxDecoration(
        color: colors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.accent.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, size: 20, color: colors.accent),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: colors.ink, fontSize: 14.5)),
                const SizedBox(height: 4),
                Text(body, style: TextStyle(fontSize: 13, height: 1.5, color: colors.inkSoft)),
                if (bullets != null) ...[
                  const SizedBox(height: 8),
                  for (final b in bullets!)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('•  ', style: TextStyle(color: colors.accent, fontSize: 13)),
                          Expanded(child: Text(b, style: TextStyle(fontSize: 12.5, height: 1.45, color: colors.inkSoft))),
                        ],
                      ),
                    ),
                ],
                const SizedBox(height: 10),
                TextButton(
                  onPressed: userId == null
                      ? null
                      : () async {
                          await ref.read(hintRepositoryProvider).markSeen(userId, hintKey);
                          ref.invalidate(seenHintsProvider);
                        },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    backgroundColor: colors.accent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Понятно'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openSheet(BuildContext context, AppColors colors) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(body, style: const TextStyle(height: 1.5)),
            if (bullets != null) ...[
              const SizedBox(height: 12),
              for (final b in bullets!)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text('•  $b', style: const TextStyle(height: 1.4)),
                ),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Закрыть')),
        ],
      ),
    );
  }
}
