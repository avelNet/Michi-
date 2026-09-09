import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../database.dart';

/// Импортирует примеры-слова для каждого знака каны (assets/content/
/// kana_examples.json — тот же источник и тот же принцип, что и для
/// кандзи: слово не выдумано, а найдено в реальном словаре и отфильтровано
/// от жаргона/архаики). Слова НЕ добавляются в unit_items юнитов
/// Хирагана/Катакана — иначе 46-знаковый юнит распух бы карточками вдвое;
/// они только связываются через word_kana и всплывают как контекст на
/// карточке самой каны (см. RoadmapRepository/ReviewRepository).
Future<void> importKanaExamples(AppDatabase db) async {
  final raw = await rootBundle.loadString('assets/content/kana_examples.json');
  final List<dynamic> entries = jsonDecode(raw);

  final kanaRows = await db.select(db.kana).get();
  final kanaIdByScriptChar = {
    for (final k in kanaRows) '${k.script}|${k.char}': k.contentItemId,
  };

  final maxIdRow = await db
      .customSelect('SELECT COALESCE(MAX(id), 0) AS m FROM content_items')
      .getSingle();
  var nextId = maxIdRow.data['m'] as int;
  int allocId() => ++nextId;

  final wordIdByKey = <String, int>{};
  final contentItemRows = <ContentItemsCompanion>[];
  final wordRows = <WordsCompanion>[];
  final wordKanaRows = <WordKanaCompanion>[];

  for (final e in entries) {
    final script = e['script'] as String;
    final char = e['char'] as String;
    final kanaContentId = kanaIdByScriptChar['$script|$char'];
    if (kanaContentId == null) continue; // кана ещё не засеяна — пропускаем

    final words = (e['words'] as List).cast<Map<String, dynamic>>();
    for (final w in words) {
      final surface = w['surface'] as String;
      final reading = w['reading'] as String;
      final wMeanings = (w['meanings_ru'] as List).cast<String>();
      final key = '$surface|$reading';

      var wordId = wordIdByKey[key];
      if (wordId == null) {
        wordId = allocId();
        contentItemRows.add(ContentItemsCompanion.insert(id: Value(wordId), kind: 'word'));
        wordRows.add(
          WordsCompanion.insert(
            contentItemId: Value(wordId),
            surfaceForm: surface,
            reading: reading,
            meaningsRu: jsonEncode(wMeanings),
            isKanaOnly: const Value(1),
          ),
        );
        wordIdByKey[key] = wordId;
      }
      wordKanaRows.add(
        WordKanaCompanion.insert(wordContentItemId: wordId, kanaContentItemId: kanaContentId, position: 0),
      );
    }
  }

  await db.batch((batch) {
    batch.insertAll(db.contentItems, contentItemRows, mode: InsertMode.insertOrIgnore);
    batch.insertAll(db.words, wordRows, mode: InsertMode.insertOrIgnore);
    batch.insertAll(db.wordKana, wordKanaRows, mode: InsertMode.insertOrIgnore);
  });
}
