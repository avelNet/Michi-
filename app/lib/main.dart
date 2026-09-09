import 'package:flutter/material.dart';

import 'data/database.dart';
import 'data/seed/content_seed.dart';
import 'data/seed/srs_enrollment.dart';
import 'features/roadmap/roadmap_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MichiApp());
}

/// Тема живёт на уровне приложения (MaterialApp.themeMode), а не внутри
/// одного экрана — иначе при переходе на другой экран (Navigator.push)
/// он не наследует локальный выбор темы и падает на дефолтную светлую.
/// Так тёмная тема применяется одинаково везде: на Карте, в Уроке,
/// в Повторении.
class MichiApp extends StatefulWidget {
  const MichiApp({super.key});

  @override
  State<MichiApp> createState() => _MichiAppState();
}

class _MichiAppState extends State<MichiApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Michi',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: _themeMode,
      home: _AppRoot(isDark: _themeMode == ThemeMode.dark, onToggleTheme: _toggleTheme),
    );
  }
}

/// Открывает БД, засеивает минимальный реальный контент при первом
/// запуске и показывает Дорожную карту.
class _AppRoot extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const _AppRoot({required this.isDark, required this.onToggleTheme});

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  late final AppDatabase _db;
  late final Future<void> _ready;

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _ready = seedContentIfEmpty(_db).then((_) => enrollAccessibleContentInSrs(_db, localUserId));
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _ready,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Ошибка запуска: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
              ),
            ),
          );
        }
        return RoadmapScreen(db: _db, isDark: widget.isDark, onToggleTheme: widget.onToggleTheme);
      },
    );
  }
}
