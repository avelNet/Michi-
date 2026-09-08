import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import 'data/database.dart';

void main() {
  runApp(const MichiApp());
}

class MichiApp extends StatelessWidget {
  const MichiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Michi — проверка БД',
      theme: ThemeData(colorSchemeSeed: const Color(0xFFB3261E)),
      home: const DbSmokeTestPage(),
    );
  }
}

/// Временный экран Фазы 1: подтверждает, что вся цепочка
/// Flutter -> Drift -> нативный SQLite реально работает на Windows.
/// Открывает базу, при пустой базе засеивает пару строк и показывает
/// результат сквозного запроса. Сменится на настоящий экран
/// "Дорожная карта" следующим шагом.
class DbSmokeTestPage extends StatefulWidget {
  const DbSmokeTestPage({super.key});

  @override
  State<DbSmokeTestPage> createState() => _DbSmokeTestPageState();
}

class _DbSmokeTestPageState extends State<DbSmokeTestPage> {
  late final AppDatabase _db;
  late final Future<_SmokeTestResult> _future;

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _future = _runSmokeTest(_db);
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  static Future<_SmokeTestResult> _runSmokeTest(AppDatabase db) async {
    final existingKanji = await db.select(db.kanji).get();
    if (existingKanji.isEmpty) {
      await db.transaction(() async {
        final contentId = await db.into(db.contentItems).insert(
              ContentItemsCompanion.insert(
                kind: 'kanji',
                jlptLevel: const Value('N5'),
              ),
            );
        await db.into(db.kanji).insert(
              KanjiCompanion.insert(
                contentItemId: Value(contentId),
                char: '食',
                meaningsRu: '["еда","есть"]',
                onYomi: const Value('["ショク"]'),
                kunYomi: const Value('["た.べる"]'),
                strokeCount: const Value(9),
              ),
            );

        final wordContentId = await db.into(db.contentItems).insert(
              ContentItemsCompanion.insert(
                kind: 'word',
                jlptLevel: const Value('N5'),
              ),
            );
        await db.into(db.words).insert(
              WordsCompanion.insert(
                contentItemId: Value(wordContentId),
                surfaceForm: '食べる',
                reading: 'たべる',
                meaningsRu: '["есть, кушать"]',
              ),
            );
        await db.into(db.wordKanji).insert(
              WordKanjiCompanion.insert(
                wordContentItemId: wordContentId,
                kanjiContentItemId: contentId,
                position: 0,
              ),
            );
      });
    }

    final kanjiRows = await db.select(db.kanji).get();
    final wordRows = await db.select(db.words).get();
    final tableNames = db.allTables.map((t) => t.actualTableName).toList()
      ..sort();

    return _SmokeTestResult(
      tableCount: tableNames.length,
      tableNames: tableNames,
      kanjiCount: kanjiRows.length,
      wordCount: wordRows.length,
      firstKanjiChar: kanjiRows.isNotEmpty ? kanjiRows.first.char : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Проверка базы данных (Фаза 1)')),
      body: FutureBuilder<_SmokeTestResult>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Ошибка: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }
          final result = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'База открыта, таблиц: ${result.tableCount}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text('Кандзи в базе: ${result.kanjiCount}'),
              Text('Слов в базе: ${result.wordCount}'),
              if (result.firstKanjiChar != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Первый кандзи: ${result.firstKanjiChar}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              const SizedBox(height: 24),
              Text('Таблицы схемы:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: result.tableNames
                    .map((name) => Chip(label: Text(name)))
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SmokeTestResult {
  final int tableCount;
  final List<String> tableNames;
  final int kanjiCount;
  final int wordCount;
  final String? firstKanjiChar;

  _SmokeTestResult({
    required this.tableCount,
    required this.tableNames,
    required this.kanjiCount,
    required this.wordCount,
    required this.firstKanjiChar,
  });
}
