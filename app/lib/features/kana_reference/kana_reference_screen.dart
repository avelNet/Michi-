import 'package:flutter/material.dart';

import '../../data/database.dart';
import '../../domain/japanese/romaji.dart';
import '../../theme/app_theme.dart';
import 'kana_reference_repository.dart';

/// Справочник каны — отдельный экран, не завязанный на прогресс по
/// Карте: вся хирагана и катакана всегда под рукой, можно посмотреть
/// в любой момент вне зависимости от того, что уже пройдено уроками.
class KanaReferenceScreen extends StatefulWidget {
  final AppDatabase db;
  const KanaReferenceScreen({super.key, required this.db});

  @override
  State<KanaReferenceScreen> createState() => _KanaReferenceScreenState();
}

class _KanaReferenceScreenState extends State<KanaReferenceScreen> {
  late final KanaReferenceRepository _repo;
  late Future<List<KanaEntry>> _future;
  String _script = 'hiragana';
  KanaEntry? _selected;

  @override
  void initState() {
    super.initState();
    _repo = KanaReferenceRepository(widget.db);
    _future = _repo.loadAll(_script);
  }

  void _switchScript(String script) {
    setState(() {
      _script = script;
      _selected = null;
      _future = _repo.loadAll(script);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    return Scaffold(
      appBar: AppBar(title: const Text('Кана — справочник')),
      backgroundColor: colors.bg,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _scriptTab('Хирагана', 'hiragana', colors),
                const SizedBox(width: 8),
                _scriptTab('Катакана', 'katakana', colors),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<KanaEntry>>(
              future: _future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final entries = snapshot.data!;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 10,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: entries.length,
                          itemBuilder: (context, i) => _kanaCell(entries[i], colors),
                        ),
                      ),
                    ),
                    _detailPanel(colors),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _scriptTab(String label, String script, AppColors colors) {
    final selected = _script == script;
    return InkWell(
      onTap: () => _switchScript(script),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? colors.accent : colors.surface2,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : colors.inkSoft,
          ),
        ),
      ),
    );
  }

  Widget _kanaCell(KanaEntry entry, AppColors colors) {
    final selected = _selected?.contentItemId == entry.contentItemId;
    return InkWell(
      onTap: () => setState(() => _selected = entry),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? colors.accent : colors.line, width: selected ? 2 : 1),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(entry.char, style: TextStyle(fontFamily: AppFonts.jp, fontSize: 26, color: colors.ink)),
            const SizedBox(height: 2),
            Text(entry.romaji, style: TextStyle(fontSize: 11, color: colors.muted)),
          ],
        ),
      ),
    );
  }

  Widget _detailPanel(AppColors colors) {
    return Container(
      width: 300,
      margin: const EdgeInsets.fromLTRB(0, 0, 20, 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line),
      ),
      child: _selected == null
          ? Center(
              child: Text('Выбери знак', style: TextStyle(color: colors.muted)),
            )
          : _SelectedKanaDetail(colors: colors, entry: _selected!, repo: _repo),
    );
  }
}

class _SelectedKanaDetail extends StatelessWidget {
  final AppColors colors;
  final KanaEntry entry;
  final KanaReferenceRepository repo;

  const _SelectedKanaDetail({required this.colors, required this.entry, required this.repo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(entry.char, style: TextStyle(fontFamily: AppFonts.jp, fontSize: 56, color: colors.ink)),
        const SizedBox(height: 4),
        Text(entry.romaji, style: TextStyle(fontSize: 18, color: colors.inkSoft)),
        const SizedBox(height: 20),
        Text(
          'ПРИМЕРЫ',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: colors.muted),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: FutureBuilder<List<KanaExampleWord>>(
            future: repo.loadExamples(entry.contentItemId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              final words = snapshot.data!;
              if (words.isEmpty) {
                return Text('Пока без примера', style: TextStyle(color: colors.muted, fontSize: 13));
              }
              return ListView.separated(
                itemCount: words.length,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (context, i) {
                  final w = words[i];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(w.surface, style: TextStyle(fontFamily: AppFonts.jp, fontSize: 18, color: colors.ink)),
                      Text(
                        '${w.reading} (${kanaToRomaji(w.reading)})',
                        style: TextStyle(fontSize: 12.5, color: colors.muted),
                      ),
                      const SizedBox(height: 2),
                      Text(_meaning(w.meaningsRu), style: TextStyle(fontSize: 13, color: colors.inkSoft)),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  String _meaning(String jsonArray) {
    final inner = jsonArray.trim().replaceAll(RegExp(r'^\[|\]$'), '');
    return inner.split(',').map((s) => s.trim().replaceAll('"', '')).where((s) => s.isNotEmpty).join(', ');
  }
}
