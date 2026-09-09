/// Единая логика «серии дней» — чтобы Карта, Профиль и Статистика
/// считали её одинаково.
library;

String _key(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Текущая серия: сколько дней подряд (считая назад от сегодня) была
/// активность. Если сегодня ещё пусто, но вчера — да, серия не прервана
/// и считается от вчера.
int currentStreak(Set<String> activeDates, {DateTime? now}) {
  if (activeDates.isEmpty) return 0;
  final today = () {
    final n = now ?? DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }();

  var cursor = today;
  if (!activeDates.contains(_key(today))) {
    final y = today.subtract(const Duration(days: 1));
    if (!activeDates.contains(_key(y))) return 0;
    cursor = y;
  }
  var n = 0;
  while (activeDates.contains(_key(cursor))) {
    n++;
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return n;
}

/// Самая длинная серия за всё время.
int longestStreak(Set<String> activeDates) {
  if (activeDates.isEmpty) return 0;
  final dates = activeDates.map(DateTime.parse).toList()..sort();
  var best = 1;
  var run = 1;
  for (var i = 1; i < dates.length; i++) {
    if (dates[i].difference(dates[i - 1]).inDays == 1) {
      run++;
      if (run > best) best = run;
    } else {
      run = 1;
    }
  }
  return best;
}
