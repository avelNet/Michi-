# Настройка окружения разработки (Windows)

Зафиксировано по итогам первой настройки — пригодится при переносе на
другую машину или после переустановки.

## Установлено

- **Flutter SDK** — не через winget (официального пакета нет), а клоном
  stable-канала: `git clone https://github.com/flutter/flutter.git -b stable C:\flutter`,
  затем `C:\flutter\bin` добавлен в PATH пользователя.
- **Visual Studio Build Tools 2022** с workload'ом «Разработка классических
  приложений на C++» (`Microsoft.VisualStudio.Workload.VCTools`) — нужен
  для компиляции нативного Windows-рантайма Flutter (CMake + MSBuild).
- **Режим разработчика Windows** включён (Параметры → Для разработчиков) —
  нужен для symlink'ов, которые Flutter создаёт при сборке.

Проверка: `flutter doctor -v` — пункт «Visual Studio - develop Windows
apps» должен быть зелёным.

## Важная особенность этой машины: кириллица в путях

Имя пользователя Windows и изначальное расположение проекта содержали
кириллицу (`C:\Users\Пав\...`, `Z:\Development\Изучение японского`).
Инструментарий Dart (конкретно — резолвинг `package_config.json` в
`dart run`/`build_runner`, а также сам `PUB_CACHE`) периодически падает на
таких путях с ошибками вида `did not contain its own root package` или
`Unable to load packages, no ...pubspec.yaml found` — при том что
`flutter`/`dart pub deps` могут работать нормально, что сбивает с толку.

Решение — все пути, которые видит тулчейн Dart/Flutter, ASCII-only:

- Проект перенесён в `C:\Dev\michi` (было — кириллический путь на Z:).
- `PUB_CACHE` переопределён на `C:\Dev\pub-cache` (было — под
  `C:\Users\Пав\AppData\Local\Pub\Cache`, тоже кириллица), переменная
  окружения выставлена персистентно на уровне пользователя.

**Если в новом терминале `flutter`/`dart` не находится или пакеты не
резолвятся** — скорее всего, `PUB_CACHE` не подхватился в текущей сессии.
Проверить: `echo $env:PUB_CACHE` (PowerShell) должно показывать
`C:\Dev\pub-cache`.

## Структура репозитория

```
C:\Dev\michi\
├── app/     — Flutter-приложение (Windows сейчас, Android/iOS позже)
├── db/      — db/schema.sql, каноничная схема БД
├── docs/    — проектная документация (этот файл, database-design.md)
└── design/  — макеты (roadmap/ — дорожная карта, .dc.html + опубликованный Artifact)
```
