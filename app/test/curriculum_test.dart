import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:michi/data/database.dart';
import 'package:michi/data/seed/curriculum.dart';

/// Проверяет, что досборка курса работает на «голой» базе (только кана-
/// юниты + один kanji_vocab), идемпотентна и строит связный граф.
void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    // Минимум, на который опирается ensureCurriculum.
    await db.into(db.units).insert(UnitsCompanion.insert(
        title: 'Хирагана', kind: 'kana', jlptLevel: const Value('N5'), sortOrder: 1));
    await db.into(db.units).insert(UnitsCompanion.insert(
        title: 'Катакана', kind: 'kana', jlptLevel: const Value('N5'), sortOrder: 2));
    await db.into(db.units).insert(UnitsCompanion.insert(
        title: 'Кандзи и слова I',
        kind: 'kanji_vocab',
        jlptLevel: const Value('N5'),
        sortOrder: 3));
  });

  tearDown(() => db.close());

  test('первый прогон наполняет грамматику, частицы, лексику, аудирование', () async {
    await ensureCurriculum(db);

    final grammar = await db.select(db.grammarPoints).get();
    final particles = await db.select(db.particles).get();
    final words = await db.select(db.words).get();

    expect(grammar.length, greaterThanOrEqualTo(25));
    expect(particles.length, greaterThanOrEqualTo(15));
    expect(words.length, greaterThanOrEqualTo(80));

    // Все элементы привязаны к юнитам.
    final links = await db.select(db.unitItems).get();
    expect(links.length, greaterThanOrEqualTo(grammar.length + particles.length));

    // Дорожная карта — связный маршрут: у Вехи есть предпосылки.
    final milestone =
        await (db.select(db.units)..where((t) => t.kind.equals('milestone'))).getSingle();
    final milestoneReqs = await (db.select(db.unitPrerequisites)
          ..where((t) => t.unitId.equals(milestone.id)))
        .get();
    expect(milestoneReqs, isNotEmpty);
  });

  test('повторный прогон ничего не дублирует', () async {
    await ensureCurriculum(db);
    final g1 = (await db.select(db.grammarPoints).get()).length;
    final p1 = (await db.select(db.particles).get()).length;
    final w1 = (await db.select(db.words).get()).length;
    final u1 = (await db.select(db.units).get()).length;
    final links1 = (await db.select(db.unitItems).get()).length;

    await ensureCurriculum(db);
    await ensureCurriculum(db);

    expect((await db.select(db.grammarPoints).get()).length, g1);
    expect((await db.select(db.particles).get()).length, p1);
    expect((await db.select(db.words).get()).length, w1);
    expect((await db.select(db.units).get()).length, u1);
    expect((await db.select(db.unitItems).get()).length, links1);
  });

  test('на «старой» установке не плодит дубли юнитов и чинит граф', () async {
    // Симулируем состояние после старого сида: пустые юниты уже есть,
    // и есть устаревшие/конфликтующие предпосылки.
    final g1 = await db.into(db.units).insert(UnitsCompanion.insert(
        title: 'Грамматика N5 I', kind: 'grammar', jlptLevel: const Value('N5'), sortOrder: 9));
    final p1 = await db.into(db.units).insert(UnitsCompanion.insert(
        title: 'Частицы I', kind: 'particle', jlptLevel: const Value('N5'), sortOrder: 8));
    await db.into(db.units).insert(UnitsCompanion.insert(
        title: 'Веха N5', kind: 'milestone', jlptLevel: const Value('N5'), sortOrder: 14));
    // Старая предпосылка: Грамматика I требует Частицы I (в новой карте — наоборот).
    await db.into(db.unitPrerequisites).insert(
        UnitPrerequisitesCompanion.insert(unitId: g1, requiresUnitId: p1));

    await ensureCurriculum(db);

    // По одному юниту на каждый заголовок.
    for (final title in ['Грамматика N5 I', 'Частицы I', 'Веха N5']) {
      final rows = await (db.select(db.units)..where((t) => t.title.equals(title))).get();
      expect(rows.length, 1, reason: 'дубль юнита "$title"');
    }
    // Конфликтующей предпосылки больше нет (граф пересобран).
    final gReqP = await (db.select(db.unitPrerequisites)
          ..where((t) => t.unitId.equals(g1) & t.requiresUnitId.equals(p1)))
        .get();
    expect(gReqP, isEmpty);

    // Пустые юниты наполнились.
    final g1Items = await (db.select(db.unitItems)..where((t) => t.unitId.equals(g1))).get();
    expect(g1Items, isNotEmpty);
  });

  test('граф прерогатив без циклов и достижим с каны', () async {
    await ensureCurriculum(db);
    final units = await db.select(db.units).get();
    final prereqs = await db.select(db.unitPrerequisites).get();

    final deps = <int, List<int>>{};
    for (final p in prereqs) {
      deps.putIfAbsent(p.unitId, () => []).add(p.requiresUnitId);
    }

    // Топологическая проверка: каждый юнит достижим (нет цикла).
    final resolved = <int>{};
    var changed = true;
    while (changed) {
      changed = false;
      for (final u in units) {
        if (resolved.contains(u.id)) continue;
        final need = deps[u.id] ?? const [];
        if (need.every(resolved.contains)) {
          resolved.add(u.id);
          changed = true;
        }
      }
    }
    expect(resolved.length, units.length, reason: 'есть недостижимые юниты (цикл?)');
  });
}
