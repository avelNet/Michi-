/// Конвертер каны (хирагана + катакана) в ромадзи по системе Хэпбёрна.
/// Стандартные, детерминированные правила транслитерации — не «на
/// глаз», поэтому, в отличие от порядка черт, это безопасно писать
/// прямо в коде, а не ждать внешний датасет.
library;

const Map<String, String> _digraphs = {
  // Хирагана, ёon (сочетания с маленькими や/ゆ/よ)
  'きゃ': 'kya', 'きゅ': 'kyu', 'きょ': 'kyo',
  'ぎゃ': 'gya', 'ぎゅ': 'gyu', 'ぎょ': 'gyo',
  'しゃ': 'sha', 'しゅ': 'shu', 'しょ': 'sho',
  'じゃ': 'ja', 'じゅ': 'ju', 'じょ': 'jo',
  'ちゃ': 'cha', 'ちゅ': 'chu', 'ちょ': 'cho',
  'ぢゃ': 'ja', 'ぢゅ': 'ju', 'ぢょ': 'jo',
  'にゃ': 'nya', 'にゅ': 'nyu', 'にょ': 'nyo',
  'ひゃ': 'hya', 'ひゅ': 'hyu', 'ひょ': 'hyo',
  'びゃ': 'bya', 'びゅ': 'byu', 'びょ': 'byo',
  'ぴゃ': 'pya', 'ぴゅ': 'pyu', 'ぴょ': 'pyo',
  'みゃ': 'mya', 'みゅ': 'myu', 'みょ': 'myo',
  'りゃ': 'rya', 'りゅ': 'ryu', 'りょ': 'ryo',
  // Катакана — те же сочетания + типичные для заимствований
  'キャ': 'kya', 'キュ': 'kyu', 'キョ': 'kyo',
  'ギャ': 'gya', 'ギュ': 'gyu', 'ギョ': 'gyo',
  'シャ': 'sha', 'シュ': 'shu', 'ショ': 'sho',
  'ジャ': 'ja', 'ジュ': 'ju', 'ジョ': 'jo',
  'チャ': 'cha', 'チュ': 'chu', 'チョ': 'cho',
  'ニャ': 'nya', 'ニュ': 'nyu', 'ニョ': 'nyo',
  'ヒャ': 'hya', 'ヒュ': 'hyu', 'ヒョ': 'hyo',
  'ビャ': 'bya', 'ビュ': 'byu', 'ビョ': 'byo',
  'ピャ': 'pya', 'ピュ': 'pyu', 'ピョ': 'pyo',
  'ミャ': 'mya', 'ミュ': 'myu', 'ミョ': 'myo',
  'リャ': 'rya', 'リュ': 'ryu', 'リョ': 'ryo',
  'ファ': 'fa', 'フィ': 'fi', 'フェ': 'fe', 'フォ': 'fo',
  'ウィ': 'wi', 'ウェ': 'we', 'ウォ': 'wo',
  'ヴァ': 'va', 'ヴィ': 'vi', 'ヴェ': 've', 'ヴォ': 'vo', 'ヴ': 'vu',
  'ティ': 'ti', 'ディ': 'di', 'トゥ': 'tu', 'ドゥ': 'du',
  'チェ': 'che', 'ジェ': 'je', 'シェ': 'she',
};

const Map<String, String> _singles = {
  'あ': 'a', 'い': 'i', 'う': 'u', 'え': 'e', 'お': 'o',
  'か': 'ka', 'き': 'ki', 'く': 'ku', 'け': 'ke', 'こ': 'ko',
  'が': 'ga', 'ぎ': 'gi', 'ぐ': 'gu', 'げ': 'ge', 'ご': 'go',
  'さ': 'sa', 'し': 'shi', 'す': 'su', 'せ': 'se', 'そ': 'so',
  'ざ': 'za', 'じ': 'ji', 'ず': 'zu', 'ぜ': 'ze', 'ぞ': 'zo',
  'た': 'ta', 'ち': 'chi', 'つ': 'tsu', 'て': 'te', 'と': 'to',
  'だ': 'da', 'ぢ': 'ji', 'づ': 'zu', 'で': 'de', 'ど': 'do',
  'な': 'na', 'に': 'ni', 'ぬ': 'nu', 'ね': 'ne', 'の': 'no',
  'は': 'ha', 'ひ': 'hi', 'ふ': 'fu', 'へ': 'he', 'ほ': 'ho',
  'ば': 'ba', 'び': 'bi', 'ぶ': 'bu', 'べ': 'be', 'ぼ': 'bo',
  'ぱ': 'pa', 'ぴ': 'pi', 'ぷ': 'pu', 'ぺ': 'pe', 'ぽ': 'po',
  'ま': 'ma', 'み': 'mi', 'む': 'mu', 'め': 'me', 'も': 'mo',
  'や': 'ya', 'ゆ': 'yu', 'よ': 'yo',
  'ら': 'ra', 'り': 'ri', 'る': 'ru', 'れ': 're', 'ろ': 'ro',
  'わ': 'wa', 'ゐ': 'wi', 'ゑ': 'we', 'を': 'wo',
  'ん': 'n',
  // Катакана
  'ア': 'a', 'イ': 'i', 'ウ': 'u', 'エ': 'e', 'オ': 'o',
  'カ': 'ka', 'キ': 'ki', 'ク': 'ku', 'ケ': 'ke', 'コ': 'ko',
  'ガ': 'ga', 'ギ': 'gi', 'グ': 'gu', 'ゲ': 'ge', 'ゴ': 'go',
  'サ': 'sa', 'シ': 'shi', 'ス': 'su', 'セ': 'se', 'ソ': 'so',
  'ザ': 'za', 'ジ': 'ji', 'ズ': 'zu', 'ゼ': 'ze', 'ゾ': 'zo',
  'タ': 'ta', 'チ': 'chi', 'ツ': 'tsu', 'テ': 'te', 'ト': 'to',
  'ダ': 'da', 'ヂ': 'ji', 'ヅ': 'zu', 'デ': 'de', 'ド': 'do',
  'ナ': 'na', 'ニ': 'ni', 'ヌ': 'nu', 'ネ': 'ne', 'ノ': 'no',
  'ハ': 'ha', 'ヒ': 'hi', 'フ': 'fu', 'ヘ': 'he', 'ホ': 'ho',
  'バ': 'ba', 'ビ': 'bi', 'ブ': 'bu', 'ベ': 'be', 'ボ': 'bo',
  'パ': 'pa', 'ピ': 'pi', 'プ': 'pu', 'ペ': 'pe', 'ポ': 'po',
  'マ': 'ma', 'ミ': 'mi', 'ム': 'mu', 'メ': 'me', 'モ': 'mo',
  'ヤ': 'ya', 'ユ': 'yu', 'ヨ': 'yo',
  'ラ': 'ra', 'リ': 'ri', 'ル': 'ru', 'レ': 're', 'ロ': 'ro',
  'ワ': 'wa', 'ヲ': 'wo', 'ン': 'n',
};

const _sokuon = {'っ', 'ッ'}; // маленькое つ/ツ — удваивает следующий согласный
const _choonpu = 'ー'; // знак долготы в катакане — тянет предыдущую гласную

/// Переводит строку хираганы/катаканы в ромадзи (латиницу).
/// Не-кана символы (кандзи, пунктуация, пробелы) переносятся как есть —
/// функция рассчитана на чтения (`reading`), которые в нашей базе
/// хранятся чистой каной, но не падает и на смешанном тексте.
String kanaToRomaji(String kana) {
  final buffer = StringBuffer();
  var i = 0;
  while (i < kana.length) {
    // Долгота — тянем последнюю гласную вывода.
    if (kana[i] == _choonpu) {
      final current = buffer.toString();
      if (current.isNotEmpty) {
        buffer.write(current[current.length - 1]);
      }
      i++;
      continue;
    }

    // Сокуон — запоминаем удвоение следующего согласного.
    if (_sokuon.contains(kana[i])) {
      final next = i + 1 < kana.length ? kana.substring(i + 1, (i + 3).clamp(0, kana.length)) : '';
      final nextRomaji = _digraphs[next.length >= 2 ? next.substring(0, 2) : ''] ??
          (next.isNotEmpty ? _singles[next[0]] : null);
      if (nextRomaji != null && nextRomaji.isNotEmpty) {
        buffer.write(nextRomaji[0] == 'c' ? 't' : nextRomaji[0]); // choきゃ->tch, упрощаем до t
      }
      i++;
      continue;
    }

    // Двухсимвольные сочетания (ёon) — проверяем раньше одиночных.
    if (i + 1 < kana.length) {
      final pair = kana.substring(i, i + 2);
      final digraph = _digraphs[pair];
      if (digraph != null) {
        buffer.write(digraph);
        i += 2;
        continue;
      }
    }

    final single = _singles[kana[i]];
    if (single != null) {
      buffer.write(single);
    } else {
      buffer.write(kana[i]); // не кана — переносим как есть (кандзи, знаки)
    }
    i++;
  }
  return buffer.toString();
}
