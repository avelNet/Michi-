import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../theme/app_theme.dart';

/// Мастер первичной настройки. Пишет `user_profile` (веса 4 столпов,
/// дневная цель, целевой и стартовый уровень JLPT) и ставит
/// `users.onboarded_at` — после этого маршрутизатор открывает приложение.
class OnboardingScreen extends ConsumerStatefulWidget {
  final String userId;
  const OnboardingScreen({super.key, required this.userId});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  // Ползунки столпов — «сырые» значения 1..10, нормируем в проценты при
  // сохранении. Понимание речи и чтение по умолчанию весомее — это то,
  // на чём строится реальный прогресс новичка.
  double _listening = 7;
  double _speaking = 4;
  double _reading = 7;
  double _writing = 3;

  int _dailyMinutes = 15;
  String _targetJlpt = 'N5';
  String _placement = 'N5';
  bool _saving = false;

  static const _pageCount = 5;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _pageCount - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
    } else {
      _finish();
    }
  }

  void _back() {
    if (_page > 0) {
      _controller.previousPage(duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
    }
  }

  Future<void> _finish() async {
    setState(() => _saving = true);
    final total = _listening + _speaking + _reading + _writing;
    int pct(double v) => (v / total * 100).round();

    final settings = ref.read(settingsRepositoryProvider);
    await settings.saveOnboarding(
      widget.userId,
      weightListening: pct(_listening),
      weightSpeaking: pct(_speaking),
      weightReading: pct(_reading),
      weightWriting: pct(_writing),
      dailyMinutesGoal: _dailyMinutes,
      targetJlptLevel: _targetJlpt,
      placementLevel: _placement,
    );
    await ref.read(authRepositoryProvider).markOnboarded(widget.userId);
    ref.invalidate(currentUserProvider);
    ref.invalidate(profileProvider);
    // Маршрутизатор среагирует на обновлённый currentUserProvider.
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: Row(
                children: [
                  for (var i = 0; i < _pageCount; i++)
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: i == _pageCount - 1 ? 0 : 6),
                        height: 4,
                        decoration: BoxDecoration(
                          color: i <= _page ? colors.accent : colors.line,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _WhyPillars(colors: colors),
                  _PillarBalance(
                    colors: colors,
                    listening: _listening,
                    speaking: _speaking,
                    reading: _reading,
                    writing: _writing,
                    onChanged: (l, s, r, w) => setState(() {
                      _listening = l;
                      _speaking = s;
                      _reading = r;
                      _writing = w;
                    }),
                  ),
                  _DailyGoal(
                    colors: colors,
                    minutes: _dailyMinutes,
                    onChanged: (m) => setState(() => _dailyMinutes = m),
                  ),
                  _JlptTarget(
                    colors: colors,
                    value: _targetJlpt,
                    onChanged: (v) => setState(() => _targetJlpt = v),
                  ),
                  _Placement(
                    colors: colors,
                    value: _placement,
                    onChanged: (v) => setState(() => _placement = v),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_page > 0)
                    TextButton(onPressed: _saving ? null : _back, child: const Text('Назад')),
                  const Spacer(),
                  FilledButton(
                    onPressed: _saving ? null : _next,
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14)),
                    child: _saving
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(_page == _pageCount - 1 ? 'Начать учиться' : 'Дальше'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final AppColors colors;
  final String kicker;
  final String title;
  final String subtitle;
  final Widget child;
  const _Step({
    required this.colors,
    required this.kicker,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(kicker, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: colors.accent)),
              const SizedBox(height: 10),
              Text(title, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: colors.ink)),
              const SizedBox(height: 8),
              Text(subtitle, style: TextStyle(fontSize: 14.5, height: 1.5, color: colors.muted)),
              const SizedBox(height: 24),
              child,
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _WhyPillars extends StatelessWidget {
  final AppColors colors;
  const _WhyPillars({required this.colors});

  @override
  Widget build(BuildContext context) {
    const items = [
      ('👂', 'Понимание речи', 'Слушать и узнавать слова на слух — с первых уроков, не «когда-нибудь потом»'),
      ('🗣️', 'Речь', 'Проговаривать вслух, повторять за образцом — язык живёт в артикуляции'),
      ('📖', 'Чтение', 'Кана → кандзи в связке со словами → живой текст. Ядро маршрута'),
      ('✍️', 'Письмо', 'Порядок черт и распознавание знаков — закрепляет чтение'),
    ];
    return _Step(
      colors: colors,
      kicker: 'ЗАЧЕМ ЭТО',
      title: 'Четыре опоры языка',
      subtitle:
          'Michi ведёт вас по одному последовательному маршруту, но следит, '
          'чтобы все четыре навыка росли вместе. Дальше вы зададите, чему '
          'уделять больше времени.',
      child: Column(
        children: [
          for (final (emoji, name, desc) in items)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.line),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: TextStyle(fontWeight: FontWeight.w700, color: colors.ink)),
                        const SizedBox(height: 3),
                        Text(desc, style: TextStyle(fontSize: 13, height: 1.4, color: colors.muted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PillarBalance extends StatelessWidget {
  final AppColors colors;
  final double listening, speaking, reading, writing;
  final void Function(double l, double s, double r, double w) onChanged;

  const _PillarBalance({
    required this.colors,
    required this.listening,
    required this.speaking,
    required this.reading,
    required this.writing,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final total = listening + speaking + reading + writing;
    int pct(double v) => (v / total * 100).round();

    Widget slider(String label, double value, ValueChanged<double> set) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: colors.ink))),
              Text('${pct(value)}%', style: TextStyle(color: colors.muted, fontWeight: FontWeight.w700)),
            ],
          ),
          Slider(
            value: value,
            min: 1,
            max: 10,
            divisions: 9,
            activeColor: colors.accent,
            onChanged: set,
          ),
        ],
      );
    }

    return _Step(
      colors: colors,
      kicker: 'ВАШ БАЛАНС',
      title: 'Чему уделять больше',
      subtitle:
          'Это влияет на то, каких повторений и упражнений будет больше. '
          'Точные проценты не важны — важно соотношение. Позже поменяете в настройках.',
      child: Column(
        children: [
          slider('👂 Понимание речи', listening, (v) => onChanged(v, speaking, reading, writing)),
          slider('🗣️ Речь', speaking, (v) => onChanged(listening, v, reading, writing)),
          slider('📖 Чтение', reading, (v) => onChanged(listening, speaking, v, writing)),
          slider('✍️ Письмо', writing, (v) => onChanged(listening, speaking, reading, v)),
        ],
      ),
    );
  }
}

class _DailyGoal extends StatelessWidget {
  final AppColors colors;
  final int minutes;
  final ValueChanged<int> onChanged;
  const _DailyGoal({required this.colors, required this.minutes, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const options = [5, 10, 15, 20, 30, 45];
    return _Step(
      colors: colors,
      kicker: 'ТЕМП',
      title: 'Сколько минут в день',
      subtitle:
          'Честная небольшая цель, которую реально выполнять каждый день, '
          'работает лучше редких марафонов. Серия дней строится именно на этом.',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final m in options)
            ChoiceChip(
              label: Text('$m мин'),
              selected: minutes == m,
              onSelected: (_) => onChanged(m),
              selectedColor: colors.accent.withValues(alpha: 0.18),
            ),
        ],
      ),
    );
  }
}

class _JlptTarget extends StatelessWidget {
  final AppColors colors;
  final String value;
  final ValueChanged<String> onChanged;
  const _JlptTarget({required this.colors, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const levels = [
      ('N5', 'Базовые фразы, ~800 слов, ~100 кандзи'),
      ('N4', 'Простые бытовые тексты, ~1500 слов'),
      ('N3', 'Мостик к свободному чтению'),
      ('N2', 'Газеты, деловое общение'),
      ('N1', 'Свободное владение'),
    ];
    return _Step(
      colors: colors,
      kicker: 'ЦЕЛЬ',
      title: 'Куда идём',
      subtitle: 'Ориентир для маршрута. Его всегда можно поднять позже.',
      child: Column(
        children: [
          for (final (lvl, desc) in levels)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _PickRow(
                colors: colors,
                selected: value == lvl,
                title: lvl,
                subtitle: desc,
                onTap: () => onChanged(lvl),
              ),
            ),
        ],
      ),
    );
  }
}

class _Placement extends StatelessWidget {
  final AppColors colors;
  final String value;
  final ValueChanged<String> onChanged;
  const _Placement({required this.colors, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const levels = [
      ('N5', 'Начинаю с нуля — с хираганы'),
      ('N4', 'Уже читаю кану, знаю немного слов'),
      ('N3', 'Уверенно на уровне N5'),
      ('N2', 'Уверенно на уровне N4'),
      ('N1', 'Уверенно на уровне N3+'),
    ];
    return _Step(
      colors: colors,
      kicker: 'СТАРТ',
      title: 'Что уже знаете',
      subtitle:
          'Маршрут всегда начинается с каны, но это поможет не заставлять '
          'вас повторять уже знакомое слишком долго.',
      child: Column(
        children: [
          for (final (lvl, desc) in levels)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _PickRow(
                colors: colors,
                selected: value == lvl,
                title: lvl,
                subtitle: desc,
                onTap: () => onChanged(lvl),
              ),
            ),
        ],
      ),
    );
  }
}

class _PickRow extends StatelessWidget {
  final AppColors colors;
  final bool selected;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _PickRow({
    required this.colors,
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? colors.accent.withValues(alpha: 0.12) : colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? colors.accent : colors.line, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 42,
              child: Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: selected ? colors.accent : colors.ink)),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(subtitle, style: TextStyle(fontSize: 13, color: colors.muted))),
            if (selected) Icon(Icons.check_circle, color: colors.accent, size: 20),
          ],
        ),
      ),
    );
  }
}
