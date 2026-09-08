import 'package:flutter/material.dart';

/// Цветовые и типографические токены приложения — прямое зеркало
/// палитры и шрифтов из макета «Дорожная карта»
/// (design/roadmap/Main.dc.html): тёплый washi-фон, чернильный текст,
/// акцент цвета печати-ханко (vermillion), Zen Maru Gothic для японских
/// глифов, PT Serif для заголовков, Golos Text для основного текста.
class AppColors extends ThemeExtension<AppColors> {
  final Color bg;
  final Color surface;
  final Color surface2;
  final Color ink;
  final Color inkSoft;
  final Color muted;
  final Color line;
  final Color pathLine;
  final Color pathLineLocked;
  final Color lockedFill;
  final Color lockedText;
  final Color accent;

  const AppColors({
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.ink,
    required this.inkSoft,
    required this.muted,
    required this.line,
    required this.pathLine,
    required this.pathLineLocked,
    required this.lockedFill,
    required this.lockedText,
    required this.accent,
  });

  static const accentDefault = Color(0xFFB3261E);

  static const light = AppColors(
    bg: Color(0xFFF7F4EF),
    surface: Color(0xFFFDFCFA),
    surface2: Color(0xFFEFEBE3),
    ink: Color(0xFF232227),
    inkSoft: Color(0xFF4B4750),
    muted: Color(0xFF8C8878),
    line: Color(0xFFDDD8CB),
    pathLine: Color(0xFF4D5A73),
    pathLineLocked: Color(0xFFDAD5C7),
    lockedFill: Color(0xFFE2DDD0),
    lockedText: Color(0xFF9A9584),
    accent: accentDefault,
  );

  static const dark = AppColors(
    bg: Color(0xFF232025),
    surface: Color(0xFF2C2830),
    surface2: Color(0xFF29252D),
    ink: Color(0xFFEDE8E0),
    inkSoft: Color(0xFFC5BEB4),
    muted: Color(0xFF938C81),
    line: Color(0xFF433D46),
    pathLine: Color(0xFF7C8CAD),
    pathLineLocked: Color(0xFF433D46),
    lockedFill: Color(0xFF37323B),
    lockedText: Color(0xFF847D74),
    accent: accentDefault,
  );

  @override
  AppColors copyWith({
    Color? bg,
    Color? surface,
    Color? surface2,
    Color? ink,
    Color? inkSoft,
    Color? muted,
    Color? line,
    Color? pathLine,
    Color? pathLineLocked,
    Color? lockedFill,
    Color? lockedText,
    Color? accent,
  }) {
    return AppColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      ink: ink ?? this.ink,
      inkSoft: inkSoft ?? this.inkSoft,
      muted: muted ?? this.muted,
      line: line ?? this.line,
      pathLine: pathLine ?? this.pathLine,
      pathLineLocked: pathLineLocked ?? this.pathLineLocked,
      lockedFill: lockedFill ?? this.lockedFill,
      lockedText: lockedText ?? this.lockedText,
      accent: accent ?? this.accent,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkSoft: Color.lerp(inkSoft, other.inkSoft, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      line: Color.lerp(line, other.line, t)!,
      pathLine: Color.lerp(pathLine, other.pathLine, t)!,
      pathLineLocked: Color.lerp(pathLineLocked, other.pathLineLocked, t)!,
      lockedFill: Color.lerp(lockedFill, other.lockedFill, t)!,
      lockedText: Color.lerp(lockedText, other.lockedText, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }
}

class AppFonts {
  // TODO: заменить на отдельный акцидентный шрифт (PT Serif не скачался
  // с доступных источников на момент написания) — пока заголовки идут
  // жирным начертанием основного шрифта.
  static const display = 'GolosText';
  static const body = 'GolosText';
  static const jp = 'ZenMaruGothic';
}

ThemeData buildAppTheme(Brightness brightness) {
  final colors = brightness == Brightness.dark ? AppColors.dark : AppColors.light;
  final base = ThemeData(
    brightness: brightness,
    useMaterial3: true,
    scaffoldBackgroundColor: colors.bg,
    fontFamily: AppFonts.body,
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: colors.accent,
      onPrimary: Colors.white,
      secondary: colors.accent,
      onSecondary: Colors.white,
      error: const Color(0xFFB3261E),
      onError: Colors.white,
      surface: colors.surface,
      onSurface: colors.ink,
    ),
  );
  return base.copyWith(
    extensions: [colors],
    textTheme: base.textTheme.copyWith(
      headlineMedium: base.textTheme.headlineMedium?.copyWith(
        fontFamily: AppFonts.display,
        fontWeight: FontWeight.w700,
        color: colors.ink,
      ),
      titleLarge: base.textTheme.titleLarge?.copyWith(
        fontFamily: AppFonts.display,
        fontWeight: FontWeight.w700,
        color: colors.ink,
      ),
      titleMedium: base.textTheme.titleMedium?.copyWith(
        fontFamily: AppFonts.display,
        fontWeight: FontWeight.w700,
        color: colors.ink,
      ),
      bodyMedium: base.textTheme.bodyMedium?.copyWith(color: colors.inkSoft),
      bodySmall: base.textTheme.bodySmall?.copyWith(color: colors.muted),
    ),
  );
}

extension AppColorsX on ThemeData {
  AppColors get colors => extension<AppColors>() ?? AppColors.light;
}
