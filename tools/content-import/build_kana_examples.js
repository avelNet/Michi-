// Собирает примеры-слова для каждого знака хираганы/катаканы — тот же
// принцип "не в отрыве от контекста", что и для кандзи, и из того же
// источника (AnchorI/jlpt-kanji-dictionary, JMdict-based, MIT).
// Требует те же dictionary_part_1..4.json рядом со скриптом, что и
// build_kanji_dataset.js (см. его README).

const fs = require('fs');
const path = require('path');
const DIR = __dirname;

function loadJson(name) {
  return JSON.parse(fs.readFileSync(path.join(DIR, name), 'utf8'));
}

const HIRAGANA_RE = /^[぀-ゟ]+$/;
const KATAKANA_RE = /^[゠-ヿー]+$/;

// Та же логика фильтра, что и в build_kanji_dataset.js — включая теги
// организаций/сокращений/собственных имён, которые особенно часто
// портят примеры именно для катаканы (она вся из заимствований —
// названия агентств, аббревиатуры и т.п. попадаются на каждом шагу).
const BAD_POS = /\b(vulg|sl|arch|obs|derog|male-sl|fem-sl|X|organization|company|abbr|hist|Buddh|work|fict|myth|ship|given|surname)\b/;
const BAD_REGISTER = /^\((уст|кн|прост|поэт|ист|ср|см)\b/i;

// Годзюон — тот же список, что и в content_seed.dart, чтобы результат
// совпадал 1:1 с уже засеянными знаками.
const GOJUON = [
  ['a','あ','ア'],['i','い','イ'],['u','う','ウ'],['e','え','エ'],['o','お','オ'],
  ['ka','か','カ'],['ki','き','キ'],['ku','く','ク'],['ke','け','ケ'],['ko','こ','コ'],
  ['sa','さ','サ'],['shi','し','シ'],['su','す','ス'],['se','せ','セ'],['so','そ','ソ'],
  ['ta','た','タ'],['chi','ち','チ'],['tsu','つ','ツ'],['te','て','テ'],['to','と','ト'],
  ['na','な','ナ'],['ni','に','ニ'],['nu','ぬ','ヌ'],['ne','ね','ネ'],['no','の','ノ'],
  ['ha','は','ハ'],['hi','ひ','ヒ'],['fu','ふ','フ'],['he','へ','ヘ'],['ho','ほ','ホ'],
  ['ma','ま','マ'],['mi','み','ミ'],['mu','む','ム'],['me','め','メ'],['mo','も','モ'],
  ['ya','や','ヤ'],['yu','ゆ','ユ'],['yo','よ','ヨ'],
  ['ra','ら','ラ'],['ri','り','リ'],['ru','る','ル'],['re','れ','レ'],['ro','ろ','ロ'],
  ['wa','わ','ワ'],['wo','を','ヲ'],
  ['n','ん','ン'],
];

function buildIndex(scriptRe) {
  const index = new Map(); // char -> [{surface, reading, meanings_ru, len}]
  for (let p = 1; p <= 4; p++) {
    const entries = loadJson(`dictionary_part_${p}.json`);
    for (const e of entries) {
      if (!e.kanji || !e.glossary_ru || e.glossary_ru.length === 0) continue;
      if (!scriptRe.test(e.kanji)) continue; // только чистая кана нужного алфавита
      if (e.pos && BAD_POS.test(e.pos)) continue;
      const primaryGloss = e.glossary_ru[0] || '';
      if (BAD_REGISTER.test(primaryGloss.trim())) continue;
      if (e.kanji.length < 2 || e.kanji.length > 5) continue; // не сам символ и не простыня

      for (const c of new Set(e.kanji)) {
        if (!index.has(c)) index.set(c, []);
        index.get(c).push({
          surface: e.kanji,
          reading: e.reading,
          meanings_ru: e.glossary_ru.filter((g) => !g.match(/[「」。、]/)).slice(0, 2),
          len: e.kanji.length,
        });
      }
    }
  }
  return index;
}

function main() {
  const hiraIndex = buildIndex(HIRAGANA_RE);
  const kataIndex = buildIndex(KATAKANA_RE);

  const out = [];
  for (const [romaji, hira, kata] of GOJUON) {
    const hiraWords = (hiraIndex.get(hira) || [])
      .sort((a, b) => a.len - b.len)
      .slice(0, 2);
    const kataWords = (kataIndex.get(kata) || [])
      .sort((a, b) => a.len - b.len)
      .slice(0, 2);
    out.push({ romaji, script: 'hiragana', char: hira, words: hiraWords });
    out.push({ romaji, script: 'katakana', char: kata, words: kataWords });
  }

  fs.writeFileSync(path.join(DIR, 'kana_examples.json'), JSON.stringify(out, null, 2), 'utf8');
  const withWords = out.filter((k) => k.words.length > 0).length;
  console.error(`done: ${out.length} kana entries, ${withWords} with >=1 example word`);
}

main();
