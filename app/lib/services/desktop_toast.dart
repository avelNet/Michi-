import 'dart:io';

/// Системный тост Windows без нативного плагина — через WinRT из
/// PowerShell (System.Runtime → Windows.UI.Notifications). Плагины
/// flutter_local_notifications на этой машине не собираются (нужны ATL и
/// nuget.exe), а этот путь работает на голой установке.
///
/// Это «лучшая попытка»: если PowerShell урезан или WinRT недоступен —
/// молча ничего не делает. Основной канал напоминаний — баннер внутри
/// приложения (см. AppShell), тост лишь дополняет его, когда окно
/// свёрнуто.
class DesktopToast {
  static Future<void> show(String title, String body) async {
    if (!Platform.isWindows) return;
    final t = _escape(title);
    final b = _escape(body);
    final script = '''
\$ErrorActionPreference = 'Stop'
try {
  \$null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
  \$xml = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)
  \$nodes = \$xml.GetElementsByTagName('text')
  \$nodes.Item(0).AppendChild(\$xml.CreateTextNode('$t')) | Out-Null
  \$nodes.Item(1).AppendChild(\$xml.CreateTextNode('$b')) | Out-Null
  \$toast = [Windows.UI.Notifications.ToastNotification]::new(\$xml)
  \$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('Microsoft.WindowsTerminal_8wekyb3d8bbwe!App')
  \$notifier.Show(\$toast)
} catch {
  # Резервный путь — обычный балун через System.Windows.Forms
  try {
    Add-Type -AssemblyName System.Windows.Forms
    \$ni = New-Object System.Windows.Forms.NotifyIcon
    \$ni.Icon = [System.Drawing.SystemIcons]::Information
    \$ni.BalloonTipTitle = '$t'
    \$ni.BalloonTipText = '$b'
    \$ni.Visible = \$true
    \$ni.ShowBalloonTip(6000)
    Start-Sleep -Milliseconds 7000
    \$ni.Dispose()
  } catch {}
}
''';
    try {
      await Process.run(
        'powershell',
        ['-NoProfile', '-NonInteractive', '-WindowStyle', 'Hidden', '-Command', script],
      );
    } catch (_) {
      // окружение без PowerShell — ничего страшного
    }
  }

  static String _escape(String s) =>
      s.replaceAll("'", "''").replaceAll('\r', ' ').replaceAll('\n', ' ');
}
