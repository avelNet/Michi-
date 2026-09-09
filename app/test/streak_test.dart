import 'package:flutter_test/flutter_test.dart';
import 'package:michi/domain/streak.dart';

void main() {
  String k(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  final now = DateTime(2026, 9, 9, 15);
  DateTime day(int back) => DateTime(2026, 9, 9).subtract(Duration(days: back));

  test('пустая история — 0', () {
    expect(currentStreak({}, now: now), 0);
  });

  test('занимался сегодня и два дня до — серия 3', () {
    expect(currentStreak({k(day(0)), k(day(1)), k(day(2))}, now: now), 3);
  });

  test('сегодня пусто, но вчера и позавчера — серия 2 (не прервана)', () {
    expect(currentStreak({k(day(1)), k(day(2))}, now: now), 2);
  });

  test('сегодня и вчера пусто — серия 0', () {
    expect(currentStreak({k(day(2)), k(day(3))}, now: now), 0);
  });

  test('дырка в середине обрывает счёт', () {
    expect(currentStreak({k(day(0)), k(day(1)), k(day(3)), k(day(4))}, now: now), 2);
  });

  test('самая длинная серия', () {
    final dates = {k(day(0)), k(day(1)), k(day(5)), k(day(6)), k(day(7)), k(day(8))};
    expect(longestStreak(dates), 4);
  });
}
