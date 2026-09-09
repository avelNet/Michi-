import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../data/database.dart';

/// Краткая карточка профиля для экрана выбора.
class ProfileSummary {
  final String id;
  final String displayName;
  final String avatarEmoji;
  final bool hasPin;
  final bool onboarded;
  final String? lastActiveAt;

  ProfileSummary({
    required this.id,
    required this.displayName,
    required this.avatarEmoji,
    required this.hasPin,
    required this.onboarded,
    required this.lastActiveAt,
  });
}

/// Локальные аккаунты: без сервера, всё в SQLite этого ПК. PIN
/// необязателен; когда задан — хранится как sha256(pin + соль), а не
/// открытым текстом. Задел под облачный аккаунт — поле `email` и UUID
/// как id (совместимо с Supabase auth.users.id), но синхронизации пока
/// нет.
class AuthRepository {
  final AppDatabase db;
  AuthRepository(this.db);

  static const _uuid = Uuid();
  static final _rng = Random.secure();

  Future<List<ProfileSummary>> listProfiles() async {
    final rows = await (db.select(db.users)
          ..orderBy([
            (t) => OrderingTerm.desc(t.lastActiveAt),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .get();
    return rows
        .map((u) => ProfileSummary(
              id: u.id,
              displayName: (u.displayName?.trim().isNotEmpty ?? false)
                  ? u.displayName!.trim()
                  : 'Профиль',
              avatarEmoji: u.avatarEmoji ?? '🌸',
              hasPin: u.pinHash != null,
              onboarded: u.onboardedAt != null,
              lastActiveAt: u.lastActiveAt,
            ))
        .toList();
  }

  Future<bool> profileExists(String userId) async {
    final row = await (db.select(db.users)..where((t) => t.id.equals(userId)))
        .getSingleOrNull();
    return row != null;
  }

  Future<bool> nameTaken(String name, {String? exceptUserId}) async {
    final trimmed = name.trim().toLowerCase();
    final rows = await db.select(db.users).get();
    return rows.any((u) =>
        u.id != exceptUserId &&
        (u.displayName?.trim().toLowerCase() ?? '') == trimmed);
  }

  /// Создаёт профиль + строку user_profile с дефолтами. Возвращает id.
  /// Онбординг ещё НЕ пройден (onboarded_at = null) — это делает мастер.
  Future<String> register({
    required String name,
    String? email,
    String? pin,
    String avatarEmoji = '🌸',
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now().toIso8601String();
    String? salt;
    String? hash;
    if (pin != null && pin.isNotEmpty) {
      salt = _newSalt();
      hash = _hashPin(pin, salt);
    }

    await db.transaction(() async {
      await db.into(db.users).insert(UsersCompanion.insert(
            id: id,
            displayName: Value(name.trim()),
            email: Value(email?.trim().isEmpty ?? true ? null : email!.trim()),
            pinHash: Value(hash),
            pinSalt: Value(salt),
            avatarEmoji: Value(avatarEmoji),
            lastActiveAt: Value(now),
            createdAt: Value(now),
          ));
      await db.into(db.userProfile).insert(
            UserProfileCompanion.insert(userId: id),
            mode: InsertMode.insertOrIgnore,
          );
    });
    return id;
  }

  Future<bool> verifyPin(String userId, String pin) async {
    final row = await (db.select(db.users)..where((t) => t.id.equals(userId)))
        .getSingleOrNull();
    if (row == null) return false;
    if (row.pinHash == null || row.pinSalt == null) return true; // PIN не задан
    return _hashPin(pin, row.pinSalt!) == row.pinHash;
  }

  Future<void> setPin(String userId, String? pin) async {
    String? salt;
    String? hash;
    if (pin != null && pin.isNotEmpty) {
      salt = _newSalt();
      hash = _hashPin(pin, salt);
    }
    await (db.update(db.users)..where((t) => t.id.equals(userId))).write(
      UsersCompanion(pinHash: Value(hash), pinSalt: Value(salt)),
    );
  }

  Future<void> updateProfileBasics(
    String userId, {
    String? name,
    String? email,
    String? avatarEmoji,
  }) async {
    await (db.update(db.users)..where((t) => t.id.equals(userId))).write(
      UsersCompanion(
        displayName: name == null ? const Value.absent() : Value(name.trim()),
        email: email == null
            ? const Value.absent()
            : Value(email.trim().isEmpty ? null : email.trim()),
        avatarEmoji: avatarEmoji == null
            ? const Value.absent()
            : Value(avatarEmoji),
      ),
    );
  }

  Future<void> markOnboarded(String userId) async {
    await (db.update(db.users)..where((t) => t.id.equals(userId))).write(
      UsersCompanion(onboardedAt: Value(DateTime.now().toIso8601String())),
    );
  }

  Future<void> touchLastActive(String userId) async {
    await (db.update(db.users)..where((t) => t.id.equals(userId))).write(
      UsersCompanion(lastActiveAt: Value(DateTime.now().toIso8601String())),
    );
  }

  /// Полностью удаляет профиль и все его пользовательские данные. Контент
  /// (кана/кандзи/слова/юниты) общий — его не трогаем.
  Future<void> deleteProfile(String userId) async {
    await db.transaction(() async {
      await (db.delete(db.reviewLog)..where((t) => t.userId.equals(userId))).go();
      await (db.delete(db.srsCards)..where((t) => t.userId.equals(userId))).go();
      await (db.delete(db.unitProgress)..where((t) => t.userId.equals(userId)))
          .go();
      await (db.delete(db.userVocab)..where((t) => t.userId.equals(userId))).go();
      await (db.delete(db.dailyActivity)..where((t) => t.userId.equals(userId)))
          .go();
      await (db.delete(db.comprehensionSnapshot)
            ..where((t) => t.userId.equals(userId)))
          .go();
      await (db.delete(db.uiHintSeen)..where((t) => t.userId.equals(userId)))
          .go();
      await (db.delete(db.userProfile)..where((t) => t.userId.equals(userId)))
          .go();
      await (db.delete(db.users)..where((t) => t.id.equals(userId))).go();
    });
  }

  /// Сбрасывает только прогресс обучения, оставляя сам профиль и его
  /// настройки. Для кнопки «Начать сначала» в настройках.
  Future<void> resetProgress(String userId) async {
    await db.transaction(() async {
      await (db.delete(db.reviewLog)..where((t) => t.userId.equals(userId))).go();
      await (db.delete(db.srsCards)..where((t) => t.userId.equals(userId))).go();
      await (db.delete(db.unitProgress)..where((t) => t.userId.equals(userId)))
          .go();
      await (db.delete(db.dailyActivity)..where((t) => t.userId.equals(userId)))
          .go();
      await (db.delete(db.comprehensionSnapshot)
            ..where((t) => t.userId.equals(userId)))
          .go();
    });
  }

  static String _newSalt() {
    final bytes = List<int>.generate(16, (_) => _rng.nextInt(256));
    return base64Url.encode(bytes);
  }

  static String _hashPin(String pin, String salt) {
    return sha256.convert(utf8.encode('$salt|$pin')).toString();
  }
}
