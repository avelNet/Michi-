import 'package:flutter_test/flutter_test.dart';
import 'package:michi/domain/japanese/romaji.dart';

void main() {
  test('базовые слоги', () {
    expect(kanaToRomaji('あ'), 'a');
    expect(kanaToRomaji('こんにちは'), 'konnichiha');
    expect(kanaToRomaji('ひらがな'), 'hiragana');
  });

  test('дакутэн/хандакутэн', () {
    expect(kanaToRomaji('がっこう'), 'gakkou'); // и сокуон заодно
    expect(kanaToRomaji('ぱん'), 'pan');
  });

  test('ёon-сочетания', () {
    expect(kanaToRomaji('きょう'), 'kyou');
    expect(kanaToRomaji('しゃしん'), 'shashin');
    expect(kanaToRomaji('じゃ'), 'ja');
  });

  test('катакана и долгота', () {
    expect(kanaToRomaji('コーヒー'), 'koohii');
    expect(kanaToRomaji('パン'), 'pan');
  });

  test('чтения кандзи с окуриганой через точку', () {
    expect(kanaToRomaji('た.べる'), 'ta.beru');
  });

  test('не-кана символы переносятся как есть', () {
    expect(kanaToRomaji('日本'), '日本');
  });
}
