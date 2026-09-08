import 'package:flutter/material.dart';

import 'data/database.dart';
import 'data/seed/content_seed.dart';
import 'features/roadmap/roadmap_screen.dart';

void main() {
  runApp(const MichiApp());
}

class MichiApp extends StatelessWidget {
  const MichiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Michi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color(0xFFB3261E)),
      home: const _AppRoot(),
    );
  }
}

/// Открывает БД, засеивает минимальный реальный контент при первом
/// запуске и показывает Дорожную карту.
class _AppRoot extends StatefulWidget {
  const _AppRoot();

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
    _ready = seedContentIfEmpty(_db);
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
        return RoadmapScreen(db: _db);
      },
    );
  }
}
