# Сборка датасета кандзи

`build_kanji_dataset.js` — разовый скрипт (не часть приложения),
собирающий `app/assets/content/kanji.json` из открытых источников.
См. [docs/content-sources.md](../../docs/content-sources.md) за
атрибуцией.

## Запуск

Нужны локально (скрипт их сам не качает):
- `jlpt-kanji.json` и `dictionary_part_1..4.json` из
  https://github.com/AnchorI/jlpt-kanji-dictionary (скачать raw-файлы
  в ту же папку, где лежит скрипт).

```bash
node build_kanji_dataset.js > /dev/null
```

Пишет `kanji_final.json` рядом со скриптом — переименовать/скопировать
в `app/assets/content/kanji.json` вручную (сделано осознанно, чтобы
случайный перезапуск не тихо перезаписал уже проверенный asset).

Делает ~2100 запросов к kanjiapi.dev (12 параллельно) — занимает
пару минут.
