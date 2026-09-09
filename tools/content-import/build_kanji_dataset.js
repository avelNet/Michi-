// Собирает полный датасет кандзи+слов из открытых источников:
//  - jlpt-kanji.json (AnchorI/jlpt-kanji-dictionary, MIT) — список кандзи
//    по уровням JLPT, частотность.
//  - dictionary_part_*.json (тот же репозиторий) — словарные статьи
//    (JMdict-based) с русскими переводами (glossary_ru).
//  - kanjiapi.dev (публичное API поверх KANJIDIC2) — авторитетные
//    он/кун чтения и штрихи для каждого кандзи.
// Результат: assets/content/kanji.json — по одному объекту на кандзи
// со связанными словами.

const fs = require('fs');
const path = require('path');

const DIR = __dirname;

function loadJson(name) {
  return JSON.parse(fs.readFileSync(path.join(DIR, name), 'utf8'));
}

// Простые, надёжные переводы базовых значений кандзи на русский —
// только для короткого списка типичных английских глянцев KANJIDIC2,
// которые реально повторяются у сотен кандзи. Что не найдено в словаре —
// остаётся на английском с пометкой, чтобы не выдумывать перевод.
const MEANING_RU = {
  'person':'человек','one':'один','day':'день','sun':'солнце','big':'большой','year':'год',
  'go out':'выходить','exit':'выход','book':'книга','origin':'основа','middle':'середина',
  'inside':'внутри','child':'ребёнок','see':'видеть','look':'смотреть','build':'строить','built':'построенный',
  'read':'читать','write':'писать','word':'слово','say':'говорить','language':'язык','speech':'речь',
  'now':'сейчас','time':'время','hour':'час','come':'приходить','go':'идти','exist':'существовать','have':'иметь',
  'life':'жизнь','live':'жить','birth':'рождение','raw':'сырой','stand':'стоять','rise':'подниматься',
  'up':'вверх','above':'над','down':'вниз','below':'под','under':'под','out':'наружу','ten':'десять',
  'hand':'рука','eye':'глаз','ear':'ухо','mouth':'рот','foot':'нога','leg':'нога','water':'вода','fire':'огонь',
  'tree':'дерево','wood':'дерево','gold':'золото','metal':'металл','money':'деньги','earth':'земля','soil':'земля',
  'moon':'луна','month':'месяц','rain':'дождь','sky':'небо','air':'воздух','mountain':'гора','river':'река',
  'stone':'камень','field':'поле','king':'король','ruler':'король','country':'страна','nation':'страна',
  'town':'город','village':'деревня','city':'город','house':'дом','gate':'ворота','door':'дверь',
  'car':'машина','vehicle':'машина','road':'дорога','way':'путь','name':'имя','character':'иероглиф',
  'letter':'буква','east':'восток','west':'запад','south':'юг','north':'север','left':'левый','right':'правый',
  'front':'перёд','before':'до','after':'после','back':'спина','behind':'сзади','white':'белый','black':'чёрный',
  'red':'красный','blue':'синий','green':'зелёный','what':'что','thing':'вещь','object':'предмет','many':'много',
  'few':'мало','little':'маленький','small':'маленький','long':'длинный','short':'короткий','high':'высокий',
  'tall':'высокий','new':'новый','old':'старый','all':'все','together':'вместе','half':'половина',
  'friend':'друг','parent':'родитель','father':'отец','mother':'мать','older brother':'старший брат',
  'older sister':'старшая сестра','younger brother':'младший брат','younger sister':'младшая сестра',
  'woman':'женщина','man':'мужчина','male':'мужчина','female':'женщина','study':'учиться','learning':'учёба',
  'school':'школа','teach':'учить','question':'вопрос','answer':'ответ','morning':'утро','noon':'полдень',
  'evening':'вечер','night':'ночь','week':'неделя','early':'рано','fast':'быстро','slow':'медленно',
  'walk':'ходить','run':'бежать','stop':'останавливаться','open':'открывать','close':'закрывать',
  'shut':'закрывать','enter':'входить','buy':'покупать','sell':'продавать','eat':'есть','drink':'пить',
  'talk':'разговаривать','hear':'слышать','listen':'слушать','think':'думать','know':'знать',
  'like':'нравиться','love':'любовь','play':'играть','work':'работать','use':'использовать',
  'make':'делать','do':'делать','put':'класть','take':'брать','give':'давать','receive':'получать',
  'meet':'встречать','bright':'светлый','light':'свет','dark':'тёмный','food':'еда','rice':'рис',
  'meal':'еда','shop':'магазин','store':'магазин','sea':'море','ocean':'море','sound':'звук',
  'voice':'голос','music':'музыка','song':'песня','sing':'петь','room':'комната','inside a house':'дом',
  'paper':'бумага','pen':'ручка','letter (mail)':'письмо','思':'думать',
};

function translateMeanings(englishMeanings) {
  const ru = [];
  for (const m of englishMeanings) {
    const key = m.toLowerCase().trim();
    if (MEANING_RU[key]) ru.push(MEANING_RU[key]);
  }
  if (ru.length === 0) return englishMeanings; // честно оставляем английский, не выдумываем
  return [...new Set(ru)];
}

const BAD_POS = /\b(vulg|sl|arch|obs|derog|male-sl|fem-sl|X)\b/;

function buildVocabIndex(kanjiChars) {
  const charSet = new Set(kanjiChars);
  const index = new Map(); // char -> [{surface, reading, meanings_ru, len}]
  for (let p = 1; p <= 4; p++) {
    const entries = loadJson(`dictionary_part_${p}.json`);
    for (const e of entries) {
      if (!e.kanji || !e.glossary_ru || e.glossary_ru.length === 0) continue;
      if (e.pos && BAD_POS.test(e.pos)) continue;
      if (e.kanji.length > 4) continue; // отсекаем длинные редкие составные слова
      const charsHere = new Set(e.kanji.split('').filter((c) => charSet.has(c)));
      for (const c of charsHere) {
        if (!index.has(c)) index.set(c, []);
        index.get(c).push({
          surface: e.kanji,
          reading: e.reading,
          meanings_ru: e.glossary_ru.filter((g) => !g.match(/[「」。、]/)).slice(0, 2),
          len: e.kanji.length,
        });
      }
    }
    console.error(`indexed part ${p}`);
  }
  return index;
}

async function fetchKanjiApi(char) {
  const res = await fetch(`https://kanjiapi.dev/v1/kanji/${encodeURIComponent(char)}`);
  if (!res.ok) return null;
  return res.json();
}

async function main() {
  const jlptKanji = loadJson('jlpt-kanji.json');
  const withLevel = jlptKanji.filter((k) => k.jlpt);
  console.error(`kanji with a JLPT level: ${withLevel.length}`);

  const chars = withLevel.map((k) => k.kanji);
  const vocabIndex = buildVocabIndex(chars);

  const out = [];
  const CONCURRENCY = 12;
  let cursor = 0;
  let done = 0;

  async function worker() {
    while (cursor < withLevel.length) {
      const k = withLevel[cursor++];
      const api = await fetchKanjiApi(k.kanji).catch(() => null);
      done++;
      if (!api) {
        console.error(`no kanjiapi data for ${k.kanji}, skipping`);
        continue;
      }
      // Приоритет настоящим сочетаниям (2-3 символа) — сам кандзи как
      // "слово из одного символа" технически валиден, но не показывает
      // ничего нового по сравнению с карточкой кандзи, поэтому в конец.
      const priority = (len) => (len === 1 ? 100 + len : len);
      const words = (vocabIndex.get(k.kanji) || [])
        .sort((a, b) => priority(a.len) - priority(b.len))
        .slice(0, 3);

      out.push({
        char: k.kanji,
        jlpt: k.jlpt,
        frequency: k.frequency ?? null,
        stroke_count: api.stroke_count ?? k.strokes ?? null,
        on_yomi: api.on_readings || [],
        kun_yomi: api.kun_readings || [],
        meanings_en: api.meanings || [],
        meanings_ru: translateMeanings(api.meanings || []),
        words,
      });
      if (done % 50 === 0) console.error(`...${done}/${withLevel.length}`);
    }
  }

  await Promise.all(Array.from({ length: CONCURRENCY }, worker));

  fs.writeFileSync(path.join(DIR, 'kanji_final.json'), JSON.stringify(out, null, 2), 'utf8');
  console.error(`done: ${out.length} kanji written to kanji_final.json`);
}

main().catch((e) => { console.error(e); process.exit(1); });
