import 'dart:io';

/// Озвучка японского без нативного плагина — через System.Speech (SAPI)
/// из PowerShell. Работает на любой установке Windows; японский голос
/// звучит правильно, только если в системе стоит языковой пакет
/// «Японский» (Параметры → Время и язык → Язык → добавить японский,
/// пункт «Речь»). Если голоса ja-JP нет — метод [hasJapaneseVoice]
/// вернёт false, и экран сам предложит читать вслух по ромадзи.
class SpeechService {
  SpeechService._();
  static final SpeechService instance = SpeechService._();

  bool? _hasJa;
  Process? _current;

  Future<bool> hasJapaneseVoice() async {
    if (_hasJa != null) return _hasJa!;
    if (!Platform.isWindows) return _hasJa = false;
    try {
      final res = await Process.run('powershell', [
        '-NoProfile',
        '-NonInteractive',
        '-Command',
        r"Add-Type -AssemblyName System.Speech; "
            r"(New-Object System.Speech.Synthesis.SpeechSynthesizer).GetInstalledVoices() "
            r"| ForEach-Object { $_.VoiceInfo.Culture.Name } | Select-String 'ja' | Measure-Object | ForEach-Object { $_.Count }",
      ]);
      final n = int.tryParse((res.stdout as String).trim()) ?? 0;
      return _hasJa = n > 0;
    } catch (_) {
      return _hasJa = false;
    }
  }

  /// Проговаривает японский текст. rate: -3..3 (0 — обычный).
  Future<void> speak(String japanese, {int rate = -1}) async {
    if (!Platform.isWindows) return;
    await stop();
    final safe = japanese.replaceAll("'", "''").replaceAll('\r', ' ').replaceAll('\n', ' ');
    final script = "Add-Type -AssemblyName System.Speech; "
        "\$s = New-Object System.Speech.Synthesis.SpeechSynthesizer; "
        "try { \$s.SelectVoiceByHints('NotSet','NotSet',0,[System.Globalization.CultureInfo]::GetCultureInfo('ja-JP')) } catch {} "
        "\$s.Rate = $rate; "
        "\$s.Speak('$safe');";
    try {
      _current = await Process.start('powershell', [
        '-NoProfile',
        '-NonInteractive',
        '-WindowStyle',
        'Hidden',
        '-Command',
        script,
      ]);
    } catch (_) {
      _current = null;
    }
  }

  Future<void> stop() async {
    final p = _current;
    _current = null;
    if (p != null) {
      try {
        p.kill();
      } catch (_) {}
    }
  }
}
