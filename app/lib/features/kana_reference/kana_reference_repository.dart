import 'package:drift/drift.dart';

import '../../data/database.dart';

class KanaEntry {
  final int contentItemId;
  final String script;
  final String char;
  final String romaji;
  final String? gojuonRow;
  final int sortOrder;

  KanaEntry({
    required this.contentItemId,
    required this.script,
    required this.char,
    required this.romaji,
    required this.gojuonRow,
    required this.sortOrder,
  });
}

class KanaExampleWord {
  final String surface;
  final String reading;
  final String meaningsRu;

  KanaExampleWord({required this.surface, required this.reading, required this.meaningsRu});
}

/// Справочник каны — не завязан на прогресс/уроки, всегда доступен
/// целиком, независимо от того, что уже пройдено на Карте.
class KanaReferenceRepository {
  final AppDatabase db;
  KanaReferenceRepository(this.db);

  Future<List<KanaEntry>> loadAll(String script) async {
    final rows = await (db.select(db.kana)
          ..where((t) => t.script.equals(script))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    return rows
        .map((k) => KanaEntry(
              contentItemId: k.contentItemId,
              script: k.script,
              char: k.char,
              romaji: k.romaji,
              gojuonRow: k.gojuonRow,
              sortOrder: k.sortOrder ?? 0,
            ))
        .toList();
  }

  Future<List<KanaExampleWord>> loadExamples(int kanaContentItemId) async {
    final query = db.select(db.wordKana).join([
      innerJoin(db.words, db.words.contentItemId.equalsExp(db.wordKana.wordContentItemId)),
    ])
      ..where(db.wordKana.kanaContentItemId.equals(kanaContentItemId));
    final rows = await query.get();
    return rows.map((row) {
      final w = row.readTable(db.words);
      return KanaExampleWord(surface: w.surfaceForm, reading: w.reading, meaningsRu: w.meaningsRu);
    }).toList();
  }
}
