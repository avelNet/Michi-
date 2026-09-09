import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../database.dart';

/// Результат импорта — кандзи сгруппированы по уровню JLPT, с их
/// content_item_id, чтобы вызывающий код (content_seed) мог собрать
/// из них юниты дорожной карты в нужном порядке.
class KanjiImportResult {
  final Map<String, List<ImportedKanji>> byLevel;
  KanjiImportResult(this.byLevel);
}

class ImportedKanji {
  final int contentItemId;
  final String char;
  final List<int> wordContentItemIds;
  ImportedKanji(this.contentItemId, this.char, this.wordContentItemIds);
}

/// Импортирует весь датасет кандзи (assets/content/kanji.json — собран из
/// открытых источников: список и частотность кандзи по JLPT из
/// AnchorI/jlpt-kanji-dictionary (MIT), он/кун-чтения из kanjiapi.dev
/// (KANJIDIC2), слова-сочетания с русским переводом из того же
/// jlpt-kanji-dictionary — см. docs/database-design.md). Не только N5:
/// весь набор (~2100 кандзи всех уровней) сразу доступен в базе для
/// будущих юнитов и справочного просмотра, а не только то, что уже
/// вынесено в юниты Карты.
///
/// Все строки собираются в памяти и пишутся через `batch()`, а не по
/// одной — с ~2100 кандзи и несколькими тысячами слов поштучные insert
/// (каждый — отдельный проход через изолят БД) тянут первый запуск на
/// минуту с лишним; батчем — секунды.
Future<KanjiImportResult> importKanjiDataset(AppDatabase db) async {
  final raw = await rootBundle.loadString('assets/content/kanji.json');
  final List<dynamic> entries = jsonDecode(raw);

  final maxIdRow = await db
      .customSelect('SELECT COALESCE(MAX(id), 0) AS m FROM content_items')
      .getSingle();
  var nextId = maxIdRow.data['m'] as int;
  int allocId() => ++nextId;

  final wordIdByKey = <String, int>{};
  final byLevel = <String, List<ImportedKanji>>{};

  final contentItemRows = <ContentItemsCompanion>[];
  final kanjiRows = <KanjiCompanion>[];
  final wordRows = <WordsCompanion>[];
  final wordKanjiRows = <WordKanjiCompanion>[];

  for (final e in entries) {
    final char = e['char'] as String;
    final jlpt = e['jlpt'] as String?;
    final strokeCount = e['stroke_count'] as int?;
    final onYomi = (e['on_yomi'] as List).cast<String>();
    final kunYomi = (e['kun_yomi'] as List).cast<String>();
    final meaningsRu = (e['meanings_ru'] as List).cast<String>();
    final words = (e['words'] as List).cast<Map<String, dynamic>>();

    final kanjiContentId = allocId();
    contentItemRows.add(
      ContentItemsCompanion.insert(id: Value(kanjiContentId), kind: 'kanji', jlptLevel: Value(jlpt)),
    );
    kanjiRows.add(
      KanjiCompanion.insert(
        contentItemId: Value(kanjiContentId),
        char: char,
        meaningsRu: jsonEncode(meaningsRu),
        onYomi: Value(jsonEncode(onYomi)),
        kunYomi: Value(jsonEncode(kunYomi)),
        strokeCount: Value(strokeCount),
      ),
    );

    final wordIds = <int>[];
    for (final w in words) {
      final surface = w['surface'] as String;
      final reading = w['reading'] as String;
      final wMeanings = (w['meanings_ru'] as List).cast<String>();
      final key = '$surface|$reading';

      var wordId = wordIdByKey[key];
      if (wordId == null) {
        wordId = allocId();
        contentItemRows.add(
          ContentItemsCompanion.insert(id: Value(wordId), kind: 'word', jlptLevel: Value(jlpt)),
        );
        wordRows.add(
          WordsCompanion.insert(
            contentItemId: Value(wordId),
            surfaceForm: surface,
            reading: reading,
            meaningsRu: jsonEncode(wMeanings),
          ),
        );
        wordIdByKey[key] = wordId;
      }
      wordKanjiRows.add(
        WordKanjiCompanion.insert(wordContentItemId: wordId, kanjiContentItemId: kanjiContentId, position: 0),
      );
      wordIds.add(wordId);
    }

    (byLevel[jlpt ?? 'unknown'] ??= []).add(ImportedKanji(kanjiContentId, char, wordIds));
  }

  await db.batch((batch) {
    batch.insertAll(db.contentItems, contentItemRows, mode: InsertMode.insertOrIgnore);
    batch.insertAll(db.kanji, kanjiRows, mode: InsertMode.insertOrIgnore);
    batch.insertAll(db.words, wordRows, mode: InsertMode.insertOrIgnore);
    batch.insertAll(db.wordKanji, wordKanjiRows, mode: InsertMode.insertOrIgnore);
  });

  return KanjiImportResult(byLevel);
}
