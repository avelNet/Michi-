// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class ContentItems extends Table with TableInfo<ContentItems, ContentItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ContentItems(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (kind IN (\'kana\', \'kanji\', \'word\', \'particle\', \'grammar_point\'))',
  );
  static const VerificationMeta _jlptLevelMeta = const VerificationMeta(
    'jlptLevel',
  );
  late final GeneratedColumn<String> jlptLevel = GeneratedColumn<String>(
    'jlpt_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK (jlpt_level IN (\'N5\', \'N4\', \'N3\', \'N2\', \'N1\'))',
  );
  static const VerificationMeta _frequencyRankMeta = const VerificationMeta(
    'frequencyRank',
  );
  late final GeneratedColumn<int> frequencyRank = GeneratedColumn<int>(
    'frequency_rank',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (datetime(\'now\'))',
    defaultValue: const CustomExpression('datetime(\'now\')'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    jlptLevel,
    frequencyRank,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('jlpt_level')) {
      context.handle(
        _jlptLevelMeta,
        jlptLevel.isAcceptableOrUnknown(data['jlpt_level']!, _jlptLevelMeta),
      );
    }
    if (data.containsKey('frequency_rank')) {
      context.handle(
        _frequencyRankMeta,
        frequencyRank.isAcceptableOrUnknown(
          data['frequency_rank']!,
          _frequencyRankMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContentItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      jlptLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jlpt_level'],
      ),
      frequencyRank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frequency_rank'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  ContentItems createAlias(String alias) {
    return ContentItems(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class ContentItem extends DataClass implements Insertable<ContentItem> {
  final int id;
  final String kind;
  final String? jlptLevel;
  final int? frequencyRank;
  final String createdAt;
  const ContentItem({
    required this.id,
    required this.kind,
    this.jlptLevel,
    this.frequencyRank,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || jlptLevel != null) {
      map['jlpt_level'] = Variable<String>(jlptLevel);
    }
    if (!nullToAbsent || frequencyRank != null) {
      map['frequency_rank'] = Variable<int>(frequencyRank);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  ContentItemsCompanion toCompanion(bool nullToAbsent) {
    return ContentItemsCompanion(
      id: Value(id),
      kind: Value(kind),
      jlptLevel: jlptLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(jlptLevel),
      frequencyRank: frequencyRank == null && nullToAbsent
          ? const Value.absent()
          : Value(frequencyRank),
      createdAt: Value(createdAt),
    );
  }

  factory ContentItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentItem(
      id: serializer.fromJson<int>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      jlptLevel: serializer.fromJson<String?>(json['jlpt_level']),
      frequencyRank: serializer.fromJson<int?>(json['frequency_rank']),
      createdAt: serializer.fromJson<String>(json['created_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(kind),
      'jlpt_level': serializer.toJson<String?>(jlptLevel),
      'frequency_rank': serializer.toJson<int?>(frequencyRank),
      'created_at': serializer.toJson<String>(createdAt),
    };
  }

  ContentItem copyWith({
    int? id,
    String? kind,
    Value<String?> jlptLevel = const Value.absent(),
    Value<int?> frequencyRank = const Value.absent(),
    String? createdAt,
  }) => ContentItem(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    jlptLevel: jlptLevel.present ? jlptLevel.value : this.jlptLevel,
    frequencyRank: frequencyRank.present
        ? frequencyRank.value
        : this.frequencyRank,
    createdAt: createdAt ?? this.createdAt,
  );
  ContentItem copyWithCompanion(ContentItemsCompanion data) {
    return ContentItem(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      jlptLevel: data.jlptLevel.present ? data.jlptLevel.value : this.jlptLevel,
      frequencyRank: data.frequencyRank.present
          ? data.frequencyRank.value
          : this.frequencyRank,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentItem(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('jlptLevel: $jlptLevel, ')
          ..write('frequencyRank: $frequencyRank, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kind, jlptLevel, frequencyRank, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentItem &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.jlptLevel == this.jlptLevel &&
          other.frequencyRank == this.frequencyRank &&
          other.createdAt == this.createdAt);
}

class ContentItemsCompanion extends UpdateCompanion<ContentItem> {
  final Value<int> id;
  final Value<String> kind;
  final Value<String?> jlptLevel;
  final Value<int?> frequencyRank;
  final Value<String> createdAt;
  const ContentItemsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.jlptLevel = const Value.absent(),
    this.frequencyRank = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ContentItemsCompanion.insert({
    this.id = const Value.absent(),
    required String kind,
    this.jlptLevel = const Value.absent(),
    this.frequencyRank = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : kind = Value(kind);
  static Insertable<ContentItem> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? jlptLevel,
    Expression<int>? frequencyRank,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (jlptLevel != null) 'jlpt_level': jlptLevel,
      if (frequencyRank != null) 'frequency_rank': frequencyRank,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ContentItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? kind,
    Value<String?>? jlptLevel,
    Value<int?>? frequencyRank,
    Value<String>? createdAt,
  }) {
    return ContentItemsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      jlptLevel: jlptLevel ?? this.jlptLevel,
      frequencyRank: frequencyRank ?? this.frequencyRank,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (jlptLevel.present) {
      map['jlpt_level'] = Variable<String>(jlptLevel.value);
    }
    if (frequencyRank.present) {
      map['frequency_rank'] = Variable<int>(frequencyRank.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentItemsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('jlptLevel: $jlptLevel, ')
          ..write('frequencyRank: $frequencyRank, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class Kana extends Table with TableInfo<Kana, KanaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Kana(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentItemIdMeta = const VerificationMeta(
    'contentItemId',
  );
  late final GeneratedColumn<int> contentItemId = GeneratedColumn<int>(
    'content_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY REFERENCES content_items(id)',
  );
  static const VerificationMeta _scriptMeta = const VerificationMeta('script');
  late final GeneratedColumn<String> script = GeneratedColumn<String>(
    'script',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (script IN (\'hiragana\', \'katakana\'))',
  );
  static const VerificationMeta _charMeta = const VerificationMeta('char');
  late final GeneratedColumn<String> char = GeneratedColumn<String>(
    'char',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _romajiMeta = const VerificationMeta('romaji');
  late final GeneratedColumn<String> romaji = GeneratedColumn<String>(
    'romaji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _gojuonRowMeta = const VerificationMeta(
    'gojuonRow',
  );
  late final GeneratedColumn<String> gojuonRow = GeneratedColumn<String>(
    'gojuon_row',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _variantMeta = const VerificationMeta(
    'variant',
  );
  late final GeneratedColumn<String> variant = GeneratedColumn<String>(
    'variant',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK (variant IN (\'base\', \'dakuten\', \'handakuten\', \'youon\'))',
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _strokeDataMeta = const VerificationMeta(
    'strokeData',
  );
  late final GeneratedColumn<String> strokeData = GeneratedColumn<String>(
    'stroke_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    contentItemId,
    script,
    char,
    romaji,
    gojuonRow,
    variant,
    audioUrl,
    strokeData,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kana';
  @override
  VerificationContext validateIntegrity(
    Insertable<KanaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_item_id')) {
      context.handle(
        _contentItemIdMeta,
        contentItemId.isAcceptableOrUnknown(
          data['content_item_id']!,
          _contentItemIdMeta,
        ),
      );
    }
    if (data.containsKey('script')) {
      context.handle(
        _scriptMeta,
        script.isAcceptableOrUnknown(data['script']!, _scriptMeta),
      );
    } else if (isInserting) {
      context.missing(_scriptMeta);
    }
    if (data.containsKey('char')) {
      context.handle(
        _charMeta,
        char.isAcceptableOrUnknown(data['char']!, _charMeta),
      );
    } else if (isInserting) {
      context.missing(_charMeta);
    }
    if (data.containsKey('romaji')) {
      context.handle(
        _romajiMeta,
        romaji.isAcceptableOrUnknown(data['romaji']!, _romajiMeta),
      );
    } else if (isInserting) {
      context.missing(_romajiMeta);
    }
    if (data.containsKey('gojuon_row')) {
      context.handle(
        _gojuonRowMeta,
        gojuonRow.isAcceptableOrUnknown(data['gojuon_row']!, _gojuonRowMeta),
      );
    }
    if (data.containsKey('variant')) {
      context.handle(
        _variantMeta,
        variant.isAcceptableOrUnknown(data['variant']!, _variantMeta),
      );
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    }
    if (data.containsKey('stroke_data')) {
      context.handle(
        _strokeDataMeta,
        strokeData.isAcceptableOrUnknown(data['stroke_data']!, _strokeDataMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentItemId};
  @override
  KanaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KanaData(
      contentItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_item_id'],
      )!,
      script: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}script'],
      )!,
      char: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}char'],
      )!,
      romaji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}romaji'],
      )!,
      gojuonRow: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gojuon_row'],
      ),
      variant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variant'],
      ),
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      ),
      strokeData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stroke_data'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      ),
    );
  }

  @override
  Kana createAlias(String alias) {
    return Kana(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class KanaData extends DataClass implements Insertable<KanaData> {
  final int contentItemId;
  final String script;
  final String char;
  final String romaji;
  final String? gojuonRow;
  final String? variant;
  final String? audioUrl;
  final String? strokeData;
  final int? sortOrder;
  const KanaData({
    required this.contentItemId,
    required this.script,
    required this.char,
    required this.romaji,
    this.gojuonRow,
    this.variant,
    this.audioUrl,
    this.strokeData,
    this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_item_id'] = Variable<int>(contentItemId);
    map['script'] = Variable<String>(script);
    map['char'] = Variable<String>(char);
    map['romaji'] = Variable<String>(romaji);
    if (!nullToAbsent || gojuonRow != null) {
      map['gojuon_row'] = Variable<String>(gojuonRow);
    }
    if (!nullToAbsent || variant != null) {
      map['variant'] = Variable<String>(variant);
    }
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    if (!nullToAbsent || strokeData != null) {
      map['stroke_data'] = Variable<String>(strokeData);
    }
    if (!nullToAbsent || sortOrder != null) {
      map['sort_order'] = Variable<int>(sortOrder);
    }
    return map;
  }

  KanaCompanion toCompanion(bool nullToAbsent) {
    return KanaCompanion(
      contentItemId: Value(contentItemId),
      script: Value(script),
      char: Value(char),
      romaji: Value(romaji),
      gojuonRow: gojuonRow == null && nullToAbsent
          ? const Value.absent()
          : Value(gojuonRow),
      variant: variant == null && nullToAbsent
          ? const Value.absent()
          : Value(variant),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
      strokeData: strokeData == null && nullToAbsent
          ? const Value.absent()
          : Value(strokeData),
      sortOrder: sortOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(sortOrder),
    );
  }

  factory KanaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KanaData(
      contentItemId: serializer.fromJson<int>(json['content_item_id']),
      script: serializer.fromJson<String>(json['script']),
      char: serializer.fromJson<String>(json['char']),
      romaji: serializer.fromJson<String>(json['romaji']),
      gojuonRow: serializer.fromJson<String?>(json['gojuon_row']),
      variant: serializer.fromJson<String?>(json['variant']),
      audioUrl: serializer.fromJson<String?>(json['audio_url']),
      strokeData: serializer.fromJson<String?>(json['stroke_data']),
      sortOrder: serializer.fromJson<int?>(json['sort_order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'content_item_id': serializer.toJson<int>(contentItemId),
      'script': serializer.toJson<String>(script),
      'char': serializer.toJson<String>(char),
      'romaji': serializer.toJson<String>(romaji),
      'gojuon_row': serializer.toJson<String?>(gojuonRow),
      'variant': serializer.toJson<String?>(variant),
      'audio_url': serializer.toJson<String?>(audioUrl),
      'stroke_data': serializer.toJson<String?>(strokeData),
      'sort_order': serializer.toJson<int?>(sortOrder),
    };
  }

  KanaData copyWith({
    int? contentItemId,
    String? script,
    String? char,
    String? romaji,
    Value<String?> gojuonRow = const Value.absent(),
    Value<String?> variant = const Value.absent(),
    Value<String?> audioUrl = const Value.absent(),
    Value<String?> strokeData = const Value.absent(),
    Value<int?> sortOrder = const Value.absent(),
  }) => KanaData(
    contentItemId: contentItemId ?? this.contentItemId,
    script: script ?? this.script,
    char: char ?? this.char,
    romaji: romaji ?? this.romaji,
    gojuonRow: gojuonRow.present ? gojuonRow.value : this.gojuonRow,
    variant: variant.present ? variant.value : this.variant,
    audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
    strokeData: strokeData.present ? strokeData.value : this.strokeData,
    sortOrder: sortOrder.present ? sortOrder.value : this.sortOrder,
  );
  KanaData copyWithCompanion(KanaCompanion data) {
    return KanaData(
      contentItemId: data.contentItemId.present
          ? data.contentItemId.value
          : this.contentItemId,
      script: data.script.present ? data.script.value : this.script,
      char: data.char.present ? data.char.value : this.char,
      romaji: data.romaji.present ? data.romaji.value : this.romaji,
      gojuonRow: data.gojuonRow.present ? data.gojuonRow.value : this.gojuonRow,
      variant: data.variant.present ? data.variant.value : this.variant,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      strokeData: data.strokeData.present
          ? data.strokeData.value
          : this.strokeData,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KanaData(')
          ..write('contentItemId: $contentItemId, ')
          ..write('script: $script, ')
          ..write('char: $char, ')
          ..write('romaji: $romaji, ')
          ..write('gojuonRow: $gojuonRow, ')
          ..write('variant: $variant, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('strokeData: $strokeData, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    contentItemId,
    script,
    char,
    romaji,
    gojuonRow,
    variant,
    audioUrl,
    strokeData,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KanaData &&
          other.contentItemId == this.contentItemId &&
          other.script == this.script &&
          other.char == this.char &&
          other.romaji == this.romaji &&
          other.gojuonRow == this.gojuonRow &&
          other.variant == this.variant &&
          other.audioUrl == this.audioUrl &&
          other.strokeData == this.strokeData &&
          other.sortOrder == this.sortOrder);
}

class KanaCompanion extends UpdateCompanion<KanaData> {
  final Value<int> contentItemId;
  final Value<String> script;
  final Value<String> char;
  final Value<String> romaji;
  final Value<String?> gojuonRow;
  final Value<String?> variant;
  final Value<String?> audioUrl;
  final Value<String?> strokeData;
  final Value<int?> sortOrder;
  const KanaCompanion({
    this.contentItemId = const Value.absent(),
    this.script = const Value.absent(),
    this.char = const Value.absent(),
    this.romaji = const Value.absent(),
    this.gojuonRow = const Value.absent(),
    this.variant = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.strokeData = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  KanaCompanion.insert({
    this.contentItemId = const Value.absent(),
    required String script,
    required String char,
    required String romaji,
    this.gojuonRow = const Value.absent(),
    this.variant = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.strokeData = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : script = Value(script),
       char = Value(char),
       romaji = Value(romaji);
  static Insertable<KanaData> custom({
    Expression<int>? contentItemId,
    Expression<String>? script,
    Expression<String>? char,
    Expression<String>? romaji,
    Expression<String>? gojuonRow,
    Expression<String>? variant,
    Expression<String>? audioUrl,
    Expression<String>? strokeData,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (contentItemId != null) 'content_item_id': contentItemId,
      if (script != null) 'script': script,
      if (char != null) 'char': char,
      if (romaji != null) 'romaji': romaji,
      if (gojuonRow != null) 'gojuon_row': gojuonRow,
      if (variant != null) 'variant': variant,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (strokeData != null) 'stroke_data': strokeData,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  KanaCompanion copyWith({
    Value<int>? contentItemId,
    Value<String>? script,
    Value<String>? char,
    Value<String>? romaji,
    Value<String?>? gojuonRow,
    Value<String?>? variant,
    Value<String?>? audioUrl,
    Value<String?>? strokeData,
    Value<int?>? sortOrder,
  }) {
    return KanaCompanion(
      contentItemId: contentItemId ?? this.contentItemId,
      script: script ?? this.script,
      char: char ?? this.char,
      romaji: romaji ?? this.romaji,
      gojuonRow: gojuonRow ?? this.gojuonRow,
      variant: variant ?? this.variant,
      audioUrl: audioUrl ?? this.audioUrl,
      strokeData: strokeData ?? this.strokeData,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentItemId.present) {
      map['content_item_id'] = Variable<int>(contentItemId.value);
    }
    if (script.present) {
      map['script'] = Variable<String>(script.value);
    }
    if (char.present) {
      map['char'] = Variable<String>(char.value);
    }
    if (romaji.present) {
      map['romaji'] = Variable<String>(romaji.value);
    }
    if (gojuonRow.present) {
      map['gojuon_row'] = Variable<String>(gojuonRow.value);
    }
    if (variant.present) {
      map['variant'] = Variable<String>(variant.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (strokeData.present) {
      map['stroke_data'] = Variable<String>(strokeData.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KanaCompanion(')
          ..write('contentItemId: $contentItemId, ')
          ..write('script: $script, ')
          ..write('char: $char, ')
          ..write('romaji: $romaji, ')
          ..write('gojuonRow: $gojuonRow, ')
          ..write('variant: $variant, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('strokeData: $strokeData, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class Radicals extends Table with TableInfo<Radicals, Radical> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Radicals(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _charMeta = const VerificationMeta('char');
  late final GeneratedColumn<String> char = GeneratedColumn<String>(
    'char',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _meaningRuMeta = const VerificationMeta(
    'meaningRu',
  );
  late final GeneratedColumn<String> meaningRu = GeneratedColumn<String>(
    'meaning_ru',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _strokeCountMeta = const VerificationMeta(
    'strokeCount',
  );
  late final GeneratedColumn<int> strokeCount = GeneratedColumn<int>(
    'stroke_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _mnemonicMeta = const VerificationMeta(
    'mnemonic',
  );
  late final GeneratedColumn<String> mnemonic = GeneratedColumn<String>(
    'mnemonic',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _strokeDataMeta = const VerificationMeta(
    'strokeData',
  );
  late final GeneratedColumn<String> strokeData = GeneratedColumn<String>(
    'stroke_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    char,
    meaningRu,
    strokeCount,
    mnemonic,
    strokeData,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'radicals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Radical> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('char')) {
      context.handle(
        _charMeta,
        char.isAcceptableOrUnknown(data['char']!, _charMeta),
      );
    } else if (isInserting) {
      context.missing(_charMeta);
    }
    if (data.containsKey('meaning_ru')) {
      context.handle(
        _meaningRuMeta,
        meaningRu.isAcceptableOrUnknown(data['meaning_ru']!, _meaningRuMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningRuMeta);
    }
    if (data.containsKey('stroke_count')) {
      context.handle(
        _strokeCountMeta,
        strokeCount.isAcceptableOrUnknown(
          data['stroke_count']!,
          _strokeCountMeta,
        ),
      );
    }
    if (data.containsKey('mnemonic')) {
      context.handle(
        _mnemonicMeta,
        mnemonic.isAcceptableOrUnknown(data['mnemonic']!, _mnemonicMeta),
      );
    }
    if (data.containsKey('stroke_data')) {
      context.handle(
        _strokeDataMeta,
        strokeData.isAcceptableOrUnknown(data['stroke_data']!, _strokeDataMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Radical map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Radical(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      char: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}char'],
      )!,
      meaningRu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning_ru'],
      )!,
      strokeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stroke_count'],
      ),
      mnemonic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mnemonic'],
      ),
      strokeData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stroke_data'],
      ),
    );
  }

  @override
  Radicals createAlias(String alias) {
    return Radicals(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Radical extends DataClass implements Insertable<Radical> {
  final int id;
  final String char;
  final String meaningRu;
  final int? strokeCount;
  final String? mnemonic;
  final String? strokeData;
  const Radical({
    required this.id,
    required this.char,
    required this.meaningRu,
    this.strokeCount,
    this.mnemonic,
    this.strokeData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['char'] = Variable<String>(char);
    map['meaning_ru'] = Variable<String>(meaningRu);
    if (!nullToAbsent || strokeCount != null) {
      map['stroke_count'] = Variable<int>(strokeCount);
    }
    if (!nullToAbsent || mnemonic != null) {
      map['mnemonic'] = Variable<String>(mnemonic);
    }
    if (!nullToAbsent || strokeData != null) {
      map['stroke_data'] = Variable<String>(strokeData);
    }
    return map;
  }

  RadicalsCompanion toCompanion(bool nullToAbsent) {
    return RadicalsCompanion(
      id: Value(id),
      char: Value(char),
      meaningRu: Value(meaningRu),
      strokeCount: strokeCount == null && nullToAbsent
          ? const Value.absent()
          : Value(strokeCount),
      mnemonic: mnemonic == null && nullToAbsent
          ? const Value.absent()
          : Value(mnemonic),
      strokeData: strokeData == null && nullToAbsent
          ? const Value.absent()
          : Value(strokeData),
    );
  }

  factory Radical.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Radical(
      id: serializer.fromJson<int>(json['id']),
      char: serializer.fromJson<String>(json['char']),
      meaningRu: serializer.fromJson<String>(json['meaning_ru']),
      strokeCount: serializer.fromJson<int?>(json['stroke_count']),
      mnemonic: serializer.fromJson<String?>(json['mnemonic']),
      strokeData: serializer.fromJson<String?>(json['stroke_data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'char': serializer.toJson<String>(char),
      'meaning_ru': serializer.toJson<String>(meaningRu),
      'stroke_count': serializer.toJson<int?>(strokeCount),
      'mnemonic': serializer.toJson<String?>(mnemonic),
      'stroke_data': serializer.toJson<String?>(strokeData),
    };
  }

  Radical copyWith({
    int? id,
    String? char,
    String? meaningRu,
    Value<int?> strokeCount = const Value.absent(),
    Value<String?> mnemonic = const Value.absent(),
    Value<String?> strokeData = const Value.absent(),
  }) => Radical(
    id: id ?? this.id,
    char: char ?? this.char,
    meaningRu: meaningRu ?? this.meaningRu,
    strokeCount: strokeCount.present ? strokeCount.value : this.strokeCount,
    mnemonic: mnemonic.present ? mnemonic.value : this.mnemonic,
    strokeData: strokeData.present ? strokeData.value : this.strokeData,
  );
  Radical copyWithCompanion(RadicalsCompanion data) {
    return Radical(
      id: data.id.present ? data.id.value : this.id,
      char: data.char.present ? data.char.value : this.char,
      meaningRu: data.meaningRu.present ? data.meaningRu.value : this.meaningRu,
      strokeCount: data.strokeCount.present
          ? data.strokeCount.value
          : this.strokeCount,
      mnemonic: data.mnemonic.present ? data.mnemonic.value : this.mnemonic,
      strokeData: data.strokeData.present
          ? data.strokeData.value
          : this.strokeData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Radical(')
          ..write('id: $id, ')
          ..write('char: $char, ')
          ..write('meaningRu: $meaningRu, ')
          ..write('strokeCount: $strokeCount, ')
          ..write('mnemonic: $mnemonic, ')
          ..write('strokeData: $strokeData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, char, meaningRu, strokeCount, mnemonic, strokeData);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Radical &&
          other.id == this.id &&
          other.char == this.char &&
          other.meaningRu == this.meaningRu &&
          other.strokeCount == this.strokeCount &&
          other.mnemonic == this.mnemonic &&
          other.strokeData == this.strokeData);
}

class RadicalsCompanion extends UpdateCompanion<Radical> {
  final Value<int> id;
  final Value<String> char;
  final Value<String> meaningRu;
  final Value<int?> strokeCount;
  final Value<String?> mnemonic;
  final Value<String?> strokeData;
  const RadicalsCompanion({
    this.id = const Value.absent(),
    this.char = const Value.absent(),
    this.meaningRu = const Value.absent(),
    this.strokeCount = const Value.absent(),
    this.mnemonic = const Value.absent(),
    this.strokeData = const Value.absent(),
  });
  RadicalsCompanion.insert({
    this.id = const Value.absent(),
    required String char,
    required String meaningRu,
    this.strokeCount = const Value.absent(),
    this.mnemonic = const Value.absent(),
    this.strokeData = const Value.absent(),
  }) : char = Value(char),
       meaningRu = Value(meaningRu);
  static Insertable<Radical> custom({
    Expression<int>? id,
    Expression<String>? char,
    Expression<String>? meaningRu,
    Expression<int>? strokeCount,
    Expression<String>? mnemonic,
    Expression<String>? strokeData,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (char != null) 'char': char,
      if (meaningRu != null) 'meaning_ru': meaningRu,
      if (strokeCount != null) 'stroke_count': strokeCount,
      if (mnemonic != null) 'mnemonic': mnemonic,
      if (strokeData != null) 'stroke_data': strokeData,
    });
  }

  RadicalsCompanion copyWith({
    Value<int>? id,
    Value<String>? char,
    Value<String>? meaningRu,
    Value<int?>? strokeCount,
    Value<String?>? mnemonic,
    Value<String?>? strokeData,
  }) {
    return RadicalsCompanion(
      id: id ?? this.id,
      char: char ?? this.char,
      meaningRu: meaningRu ?? this.meaningRu,
      strokeCount: strokeCount ?? this.strokeCount,
      mnemonic: mnemonic ?? this.mnemonic,
      strokeData: strokeData ?? this.strokeData,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (char.present) {
      map['char'] = Variable<String>(char.value);
    }
    if (meaningRu.present) {
      map['meaning_ru'] = Variable<String>(meaningRu.value);
    }
    if (strokeCount.present) {
      map['stroke_count'] = Variable<int>(strokeCount.value);
    }
    if (mnemonic.present) {
      map['mnemonic'] = Variable<String>(mnemonic.value);
    }
    if (strokeData.present) {
      map['stroke_data'] = Variable<String>(strokeData.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RadicalsCompanion(')
          ..write('id: $id, ')
          ..write('char: $char, ')
          ..write('meaningRu: $meaningRu, ')
          ..write('strokeCount: $strokeCount, ')
          ..write('mnemonic: $mnemonic, ')
          ..write('strokeData: $strokeData')
          ..write(')'))
        .toString();
  }
}

class Kanji extends Table with TableInfo<Kanji, KanjiData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Kanji(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentItemIdMeta = const VerificationMeta(
    'contentItemId',
  );
  late final GeneratedColumn<int> contentItemId = GeneratedColumn<int>(
    'content_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY REFERENCES content_items(id)',
  );
  static const VerificationMeta _charMeta = const VerificationMeta('char');
  late final GeneratedColumn<String> char = GeneratedColumn<String>(
    'char',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _meaningsRuMeta = const VerificationMeta(
    'meaningsRu',
  );
  late final GeneratedColumn<String> meaningsRu = GeneratedColumn<String>(
    'meanings_ru',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _onYomiMeta = const VerificationMeta('onYomi');
  late final GeneratedColumn<String> onYomi = GeneratedColumn<String>(
    'on_yomi',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _kunYomiMeta = const VerificationMeta(
    'kunYomi',
  );
  late final GeneratedColumn<String> kunYomi = GeneratedColumn<String>(
    'kun_yomi',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _joyoGradeMeta = const VerificationMeta(
    'joyoGrade',
  );
  late final GeneratedColumn<int> joyoGrade = GeneratedColumn<int>(
    'joyo_grade',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _strokeCountMeta = const VerificationMeta(
    'strokeCount',
  );
  late final GeneratedColumn<int> strokeCount = GeneratedColumn<int>(
    'stroke_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _mnemonicMeta = const VerificationMeta(
    'mnemonic',
  );
  late final GeneratedColumn<String> mnemonic = GeneratedColumn<String>(
    'mnemonic',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _strokeDataMeta = const VerificationMeta(
    'strokeData',
  );
  late final GeneratedColumn<String> strokeData = GeneratedColumn<String>(
    'stroke_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    contentItemId,
    char,
    meaningsRu,
    onYomi,
    kunYomi,
    joyoGrade,
    strokeCount,
    mnemonic,
    strokeData,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kanji';
  @override
  VerificationContext validateIntegrity(
    Insertable<KanjiData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_item_id')) {
      context.handle(
        _contentItemIdMeta,
        contentItemId.isAcceptableOrUnknown(
          data['content_item_id']!,
          _contentItemIdMeta,
        ),
      );
    }
    if (data.containsKey('char')) {
      context.handle(
        _charMeta,
        char.isAcceptableOrUnknown(data['char']!, _charMeta),
      );
    } else if (isInserting) {
      context.missing(_charMeta);
    }
    if (data.containsKey('meanings_ru')) {
      context.handle(
        _meaningsRuMeta,
        meaningsRu.isAcceptableOrUnknown(data['meanings_ru']!, _meaningsRuMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningsRuMeta);
    }
    if (data.containsKey('on_yomi')) {
      context.handle(
        _onYomiMeta,
        onYomi.isAcceptableOrUnknown(data['on_yomi']!, _onYomiMeta),
      );
    }
    if (data.containsKey('kun_yomi')) {
      context.handle(
        _kunYomiMeta,
        kunYomi.isAcceptableOrUnknown(data['kun_yomi']!, _kunYomiMeta),
      );
    }
    if (data.containsKey('joyo_grade')) {
      context.handle(
        _joyoGradeMeta,
        joyoGrade.isAcceptableOrUnknown(data['joyo_grade']!, _joyoGradeMeta),
      );
    }
    if (data.containsKey('stroke_count')) {
      context.handle(
        _strokeCountMeta,
        strokeCount.isAcceptableOrUnknown(
          data['stroke_count']!,
          _strokeCountMeta,
        ),
      );
    }
    if (data.containsKey('mnemonic')) {
      context.handle(
        _mnemonicMeta,
        mnemonic.isAcceptableOrUnknown(data['mnemonic']!, _mnemonicMeta),
      );
    }
    if (data.containsKey('stroke_data')) {
      context.handle(
        _strokeDataMeta,
        strokeData.isAcceptableOrUnknown(data['stroke_data']!, _strokeDataMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentItemId};
  @override
  KanjiData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KanjiData(
      contentItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_item_id'],
      )!,
      char: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}char'],
      )!,
      meaningsRu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meanings_ru'],
      )!,
      onYomi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}on_yomi'],
      ),
      kunYomi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kun_yomi'],
      ),
      joyoGrade: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}joyo_grade'],
      ),
      strokeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stroke_count'],
      ),
      mnemonic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mnemonic'],
      ),
      strokeData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stroke_data'],
      ),
    );
  }

  @override
  Kanji createAlias(String alias) {
    return Kanji(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class KanjiData extends DataClass implements Insertable<KanjiData> {
  final int contentItemId;
  final String char;
  final String meaningsRu;
  final String? onYomi;
  final String? kunYomi;
  final int? joyoGrade;
  final int? strokeCount;
  final String? mnemonic;
  final String? strokeData;
  const KanjiData({
    required this.contentItemId,
    required this.char,
    required this.meaningsRu,
    this.onYomi,
    this.kunYomi,
    this.joyoGrade,
    this.strokeCount,
    this.mnemonic,
    this.strokeData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_item_id'] = Variable<int>(contentItemId);
    map['char'] = Variable<String>(char);
    map['meanings_ru'] = Variable<String>(meaningsRu);
    if (!nullToAbsent || onYomi != null) {
      map['on_yomi'] = Variable<String>(onYomi);
    }
    if (!nullToAbsent || kunYomi != null) {
      map['kun_yomi'] = Variable<String>(kunYomi);
    }
    if (!nullToAbsent || joyoGrade != null) {
      map['joyo_grade'] = Variable<int>(joyoGrade);
    }
    if (!nullToAbsent || strokeCount != null) {
      map['stroke_count'] = Variable<int>(strokeCount);
    }
    if (!nullToAbsent || mnemonic != null) {
      map['mnemonic'] = Variable<String>(mnemonic);
    }
    if (!nullToAbsent || strokeData != null) {
      map['stroke_data'] = Variable<String>(strokeData);
    }
    return map;
  }

  KanjiCompanion toCompanion(bool nullToAbsent) {
    return KanjiCompanion(
      contentItemId: Value(contentItemId),
      char: Value(char),
      meaningsRu: Value(meaningsRu),
      onYomi: onYomi == null && nullToAbsent
          ? const Value.absent()
          : Value(onYomi),
      kunYomi: kunYomi == null && nullToAbsent
          ? const Value.absent()
          : Value(kunYomi),
      joyoGrade: joyoGrade == null && nullToAbsent
          ? const Value.absent()
          : Value(joyoGrade),
      strokeCount: strokeCount == null && nullToAbsent
          ? const Value.absent()
          : Value(strokeCount),
      mnemonic: mnemonic == null && nullToAbsent
          ? const Value.absent()
          : Value(mnemonic),
      strokeData: strokeData == null && nullToAbsent
          ? const Value.absent()
          : Value(strokeData),
    );
  }

  factory KanjiData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KanjiData(
      contentItemId: serializer.fromJson<int>(json['content_item_id']),
      char: serializer.fromJson<String>(json['char']),
      meaningsRu: serializer.fromJson<String>(json['meanings_ru']),
      onYomi: serializer.fromJson<String?>(json['on_yomi']),
      kunYomi: serializer.fromJson<String?>(json['kun_yomi']),
      joyoGrade: serializer.fromJson<int?>(json['joyo_grade']),
      strokeCount: serializer.fromJson<int?>(json['stroke_count']),
      mnemonic: serializer.fromJson<String?>(json['mnemonic']),
      strokeData: serializer.fromJson<String?>(json['stroke_data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'content_item_id': serializer.toJson<int>(contentItemId),
      'char': serializer.toJson<String>(char),
      'meanings_ru': serializer.toJson<String>(meaningsRu),
      'on_yomi': serializer.toJson<String?>(onYomi),
      'kun_yomi': serializer.toJson<String?>(kunYomi),
      'joyo_grade': serializer.toJson<int?>(joyoGrade),
      'stroke_count': serializer.toJson<int?>(strokeCount),
      'mnemonic': serializer.toJson<String?>(mnemonic),
      'stroke_data': serializer.toJson<String?>(strokeData),
    };
  }

  KanjiData copyWith({
    int? contentItemId,
    String? char,
    String? meaningsRu,
    Value<String?> onYomi = const Value.absent(),
    Value<String?> kunYomi = const Value.absent(),
    Value<int?> joyoGrade = const Value.absent(),
    Value<int?> strokeCount = const Value.absent(),
    Value<String?> mnemonic = const Value.absent(),
    Value<String?> strokeData = const Value.absent(),
  }) => KanjiData(
    contentItemId: contentItemId ?? this.contentItemId,
    char: char ?? this.char,
    meaningsRu: meaningsRu ?? this.meaningsRu,
    onYomi: onYomi.present ? onYomi.value : this.onYomi,
    kunYomi: kunYomi.present ? kunYomi.value : this.kunYomi,
    joyoGrade: joyoGrade.present ? joyoGrade.value : this.joyoGrade,
    strokeCount: strokeCount.present ? strokeCount.value : this.strokeCount,
    mnemonic: mnemonic.present ? mnemonic.value : this.mnemonic,
    strokeData: strokeData.present ? strokeData.value : this.strokeData,
  );
  KanjiData copyWithCompanion(KanjiCompanion data) {
    return KanjiData(
      contentItemId: data.contentItemId.present
          ? data.contentItemId.value
          : this.contentItemId,
      char: data.char.present ? data.char.value : this.char,
      meaningsRu: data.meaningsRu.present
          ? data.meaningsRu.value
          : this.meaningsRu,
      onYomi: data.onYomi.present ? data.onYomi.value : this.onYomi,
      kunYomi: data.kunYomi.present ? data.kunYomi.value : this.kunYomi,
      joyoGrade: data.joyoGrade.present ? data.joyoGrade.value : this.joyoGrade,
      strokeCount: data.strokeCount.present
          ? data.strokeCount.value
          : this.strokeCount,
      mnemonic: data.mnemonic.present ? data.mnemonic.value : this.mnemonic,
      strokeData: data.strokeData.present
          ? data.strokeData.value
          : this.strokeData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KanjiData(')
          ..write('contentItemId: $contentItemId, ')
          ..write('char: $char, ')
          ..write('meaningsRu: $meaningsRu, ')
          ..write('onYomi: $onYomi, ')
          ..write('kunYomi: $kunYomi, ')
          ..write('joyoGrade: $joyoGrade, ')
          ..write('strokeCount: $strokeCount, ')
          ..write('mnemonic: $mnemonic, ')
          ..write('strokeData: $strokeData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    contentItemId,
    char,
    meaningsRu,
    onYomi,
    kunYomi,
    joyoGrade,
    strokeCount,
    mnemonic,
    strokeData,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KanjiData &&
          other.contentItemId == this.contentItemId &&
          other.char == this.char &&
          other.meaningsRu == this.meaningsRu &&
          other.onYomi == this.onYomi &&
          other.kunYomi == this.kunYomi &&
          other.joyoGrade == this.joyoGrade &&
          other.strokeCount == this.strokeCount &&
          other.mnemonic == this.mnemonic &&
          other.strokeData == this.strokeData);
}

class KanjiCompanion extends UpdateCompanion<KanjiData> {
  final Value<int> contentItemId;
  final Value<String> char;
  final Value<String> meaningsRu;
  final Value<String?> onYomi;
  final Value<String?> kunYomi;
  final Value<int?> joyoGrade;
  final Value<int?> strokeCount;
  final Value<String?> mnemonic;
  final Value<String?> strokeData;
  const KanjiCompanion({
    this.contentItemId = const Value.absent(),
    this.char = const Value.absent(),
    this.meaningsRu = const Value.absent(),
    this.onYomi = const Value.absent(),
    this.kunYomi = const Value.absent(),
    this.joyoGrade = const Value.absent(),
    this.strokeCount = const Value.absent(),
    this.mnemonic = const Value.absent(),
    this.strokeData = const Value.absent(),
  });
  KanjiCompanion.insert({
    this.contentItemId = const Value.absent(),
    required String char,
    required String meaningsRu,
    this.onYomi = const Value.absent(),
    this.kunYomi = const Value.absent(),
    this.joyoGrade = const Value.absent(),
    this.strokeCount = const Value.absent(),
    this.mnemonic = const Value.absent(),
    this.strokeData = const Value.absent(),
  }) : char = Value(char),
       meaningsRu = Value(meaningsRu);
  static Insertable<KanjiData> custom({
    Expression<int>? contentItemId,
    Expression<String>? char,
    Expression<String>? meaningsRu,
    Expression<String>? onYomi,
    Expression<String>? kunYomi,
    Expression<int>? joyoGrade,
    Expression<int>? strokeCount,
    Expression<String>? mnemonic,
    Expression<String>? strokeData,
  }) {
    return RawValuesInsertable({
      if (contentItemId != null) 'content_item_id': contentItemId,
      if (char != null) 'char': char,
      if (meaningsRu != null) 'meanings_ru': meaningsRu,
      if (onYomi != null) 'on_yomi': onYomi,
      if (kunYomi != null) 'kun_yomi': kunYomi,
      if (joyoGrade != null) 'joyo_grade': joyoGrade,
      if (strokeCount != null) 'stroke_count': strokeCount,
      if (mnemonic != null) 'mnemonic': mnemonic,
      if (strokeData != null) 'stroke_data': strokeData,
    });
  }

  KanjiCompanion copyWith({
    Value<int>? contentItemId,
    Value<String>? char,
    Value<String>? meaningsRu,
    Value<String?>? onYomi,
    Value<String?>? kunYomi,
    Value<int?>? joyoGrade,
    Value<int?>? strokeCount,
    Value<String?>? mnemonic,
    Value<String?>? strokeData,
  }) {
    return KanjiCompanion(
      contentItemId: contentItemId ?? this.contentItemId,
      char: char ?? this.char,
      meaningsRu: meaningsRu ?? this.meaningsRu,
      onYomi: onYomi ?? this.onYomi,
      kunYomi: kunYomi ?? this.kunYomi,
      joyoGrade: joyoGrade ?? this.joyoGrade,
      strokeCount: strokeCount ?? this.strokeCount,
      mnemonic: mnemonic ?? this.mnemonic,
      strokeData: strokeData ?? this.strokeData,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentItemId.present) {
      map['content_item_id'] = Variable<int>(contentItemId.value);
    }
    if (char.present) {
      map['char'] = Variable<String>(char.value);
    }
    if (meaningsRu.present) {
      map['meanings_ru'] = Variable<String>(meaningsRu.value);
    }
    if (onYomi.present) {
      map['on_yomi'] = Variable<String>(onYomi.value);
    }
    if (kunYomi.present) {
      map['kun_yomi'] = Variable<String>(kunYomi.value);
    }
    if (joyoGrade.present) {
      map['joyo_grade'] = Variable<int>(joyoGrade.value);
    }
    if (strokeCount.present) {
      map['stroke_count'] = Variable<int>(strokeCount.value);
    }
    if (mnemonic.present) {
      map['mnemonic'] = Variable<String>(mnemonic.value);
    }
    if (strokeData.present) {
      map['stroke_data'] = Variable<String>(strokeData.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KanjiCompanion(')
          ..write('contentItemId: $contentItemId, ')
          ..write('char: $char, ')
          ..write('meaningsRu: $meaningsRu, ')
          ..write('onYomi: $onYomi, ')
          ..write('kunYomi: $kunYomi, ')
          ..write('joyoGrade: $joyoGrade, ')
          ..write('strokeCount: $strokeCount, ')
          ..write('mnemonic: $mnemonic, ')
          ..write('strokeData: $strokeData')
          ..write(')'))
        .toString();
  }
}

class KanjiRadicals extends Table with TableInfo<KanjiRadicals, KanjiRadical> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  KanjiRadicals(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentItemIdMeta = const VerificationMeta(
    'contentItemId',
  );
  late final GeneratedColumn<int> contentItemId = GeneratedColumn<int>(
    'content_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES kanji(content_item_id)',
  );
  static const VerificationMeta _radicalIdMeta = const VerificationMeta(
    'radicalId',
  );
  late final GeneratedColumn<int> radicalId = GeneratedColumn<int>(
    'radical_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES radicals(id)',
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  late final GeneratedColumn<String> position = GeneratedColumn<String>(
    'position',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [contentItemId, radicalId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kanji_radicals';
  @override
  VerificationContext validateIntegrity(
    Insertable<KanjiRadical> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_item_id')) {
      context.handle(
        _contentItemIdMeta,
        contentItemId.isAcceptableOrUnknown(
          data['content_item_id']!,
          _contentItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentItemIdMeta);
    }
    if (data.containsKey('radical_id')) {
      context.handle(
        _radicalIdMeta,
        radicalId.isAcceptableOrUnknown(data['radical_id']!, _radicalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_radicalIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentItemId, radicalId};
  @override
  KanjiRadical map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KanjiRadical(
      contentItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_item_id'],
      )!,
      radicalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}radical_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}position'],
      ),
    );
  }

  @override
  KanjiRadicals createAlias(String alias) {
    return KanjiRadicals(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(content_item_id, radical_id)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class KanjiRadical extends DataClass implements Insertable<KanjiRadical> {
  final int contentItemId;
  final int radicalId;
  final String? position;
  const KanjiRadical({
    required this.contentItemId,
    required this.radicalId,
    this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_item_id'] = Variable<int>(contentItemId);
    map['radical_id'] = Variable<int>(radicalId);
    if (!nullToAbsent || position != null) {
      map['position'] = Variable<String>(position);
    }
    return map;
  }

  KanjiRadicalsCompanion toCompanion(bool nullToAbsent) {
    return KanjiRadicalsCompanion(
      contentItemId: Value(contentItemId),
      radicalId: Value(radicalId),
      position: position == null && nullToAbsent
          ? const Value.absent()
          : Value(position),
    );
  }

  factory KanjiRadical.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KanjiRadical(
      contentItemId: serializer.fromJson<int>(json['content_item_id']),
      radicalId: serializer.fromJson<int>(json['radical_id']),
      position: serializer.fromJson<String?>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'content_item_id': serializer.toJson<int>(contentItemId),
      'radical_id': serializer.toJson<int>(radicalId),
      'position': serializer.toJson<String?>(position),
    };
  }

  KanjiRadical copyWith({
    int? contentItemId,
    int? radicalId,
    Value<String?> position = const Value.absent(),
  }) => KanjiRadical(
    contentItemId: contentItemId ?? this.contentItemId,
    radicalId: radicalId ?? this.radicalId,
    position: position.present ? position.value : this.position,
  );
  KanjiRadical copyWithCompanion(KanjiRadicalsCompanion data) {
    return KanjiRadical(
      contentItemId: data.contentItemId.present
          ? data.contentItemId.value
          : this.contentItemId,
      radicalId: data.radicalId.present ? data.radicalId.value : this.radicalId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KanjiRadical(')
          ..write('contentItemId: $contentItemId, ')
          ..write('radicalId: $radicalId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(contentItemId, radicalId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KanjiRadical &&
          other.contentItemId == this.contentItemId &&
          other.radicalId == this.radicalId &&
          other.position == this.position);
}

class KanjiRadicalsCompanion extends UpdateCompanion<KanjiRadical> {
  final Value<int> contentItemId;
  final Value<int> radicalId;
  final Value<String?> position;
  final Value<int> rowid;
  const KanjiRadicalsCompanion({
    this.contentItemId = const Value.absent(),
    this.radicalId = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KanjiRadicalsCompanion.insert({
    required int contentItemId,
    required int radicalId,
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : contentItemId = Value(contentItemId),
       radicalId = Value(radicalId);
  static Insertable<KanjiRadical> custom({
    Expression<int>? contentItemId,
    Expression<int>? radicalId,
    Expression<String>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentItemId != null) 'content_item_id': contentItemId,
      if (radicalId != null) 'radical_id': radicalId,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KanjiRadicalsCompanion copyWith({
    Value<int>? contentItemId,
    Value<int>? radicalId,
    Value<String?>? position,
    Value<int>? rowid,
  }) {
    return KanjiRadicalsCompanion(
      contentItemId: contentItemId ?? this.contentItemId,
      radicalId: radicalId ?? this.radicalId,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentItemId.present) {
      map['content_item_id'] = Variable<int>(contentItemId.value);
    }
    if (radicalId.present) {
      map['radical_id'] = Variable<int>(radicalId.value);
    }
    if (position.present) {
      map['position'] = Variable<String>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KanjiRadicalsCompanion(')
          ..write('contentItemId: $contentItemId, ')
          ..write('radicalId: $radicalId, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Words extends Table with TableInfo<Words, Word> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Words(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentItemIdMeta = const VerificationMeta(
    'contentItemId',
  );
  late final GeneratedColumn<int> contentItemId = GeneratedColumn<int>(
    'content_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY REFERENCES content_items(id)',
  );
  static const VerificationMeta _surfaceFormMeta = const VerificationMeta(
    'surfaceForm',
  );
  late final GeneratedColumn<String> surfaceForm = GeneratedColumn<String>(
    'surface_form',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _readingMeta = const VerificationMeta(
    'reading',
  );
  late final GeneratedColumn<String> reading = GeneratedColumn<String>(
    'reading',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _meaningsRuMeta = const VerificationMeta(
    'meaningsRu',
  );
  late final GeneratedColumn<String> meaningsRu = GeneratedColumn<String>(
    'meanings_ru',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _partOfSpeechMeta = const VerificationMeta(
    'partOfSpeech',
  );
  late final GeneratedColumn<String> partOfSpeech = GeneratedColumn<String>(
    'part_of_speech',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _isKanaOnlyMeta = const VerificationMeta(
    'isKanaOnly',
  );
  late final GeneratedColumn<int> isKanaOnly = GeneratedColumn<int>(
    'is_kana_only',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _pitchAccentMeta = const VerificationMeta(
    'pitchAccent',
  );
  late final GeneratedColumn<int> pitchAccent = GeneratedColumn<int>(
    'pitch_accent',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    contentItemId,
    surfaceForm,
    reading,
    meaningsRu,
    partOfSpeech,
    isKanaOnly,
    pitchAccent,
    audioUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'words';
  @override
  VerificationContext validateIntegrity(
    Insertable<Word> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_item_id')) {
      context.handle(
        _contentItemIdMeta,
        contentItemId.isAcceptableOrUnknown(
          data['content_item_id']!,
          _contentItemIdMeta,
        ),
      );
    }
    if (data.containsKey('surface_form')) {
      context.handle(
        _surfaceFormMeta,
        surfaceForm.isAcceptableOrUnknown(
          data['surface_form']!,
          _surfaceFormMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_surfaceFormMeta);
    }
    if (data.containsKey('reading')) {
      context.handle(
        _readingMeta,
        reading.isAcceptableOrUnknown(data['reading']!, _readingMeta),
      );
    } else if (isInserting) {
      context.missing(_readingMeta);
    }
    if (data.containsKey('meanings_ru')) {
      context.handle(
        _meaningsRuMeta,
        meaningsRu.isAcceptableOrUnknown(data['meanings_ru']!, _meaningsRuMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningsRuMeta);
    }
    if (data.containsKey('part_of_speech')) {
      context.handle(
        _partOfSpeechMeta,
        partOfSpeech.isAcceptableOrUnknown(
          data['part_of_speech']!,
          _partOfSpeechMeta,
        ),
      );
    }
    if (data.containsKey('is_kana_only')) {
      context.handle(
        _isKanaOnlyMeta,
        isKanaOnly.isAcceptableOrUnknown(
          data['is_kana_only']!,
          _isKanaOnlyMeta,
        ),
      );
    }
    if (data.containsKey('pitch_accent')) {
      context.handle(
        _pitchAccentMeta,
        pitchAccent.isAcceptableOrUnknown(
          data['pitch_accent']!,
          _pitchAccentMeta,
        ),
      );
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentItemId};
  @override
  Word map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Word(
      contentItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_item_id'],
      )!,
      surfaceForm: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}surface_form'],
      )!,
      reading: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading'],
      )!,
      meaningsRu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meanings_ru'],
      )!,
      partOfSpeech: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_of_speech'],
      ),
      isKanaOnly: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_kana_only'],
      )!,
      pitchAccent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pitch_accent'],
      ),
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      ),
    );
  }

  @override
  Words createAlias(String alias) {
    return Words(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Word extends DataClass implements Insertable<Word> {
  final int contentItemId;
  final String surfaceForm;
  final String reading;
  final String meaningsRu;
  final String? partOfSpeech;
  final int isKanaOnly;
  final int? pitchAccent;
  final String? audioUrl;
  const Word({
    required this.contentItemId,
    required this.surfaceForm,
    required this.reading,
    required this.meaningsRu,
    this.partOfSpeech,
    required this.isKanaOnly,
    this.pitchAccent,
    this.audioUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_item_id'] = Variable<int>(contentItemId);
    map['surface_form'] = Variable<String>(surfaceForm);
    map['reading'] = Variable<String>(reading);
    map['meanings_ru'] = Variable<String>(meaningsRu);
    if (!nullToAbsent || partOfSpeech != null) {
      map['part_of_speech'] = Variable<String>(partOfSpeech);
    }
    map['is_kana_only'] = Variable<int>(isKanaOnly);
    if (!nullToAbsent || pitchAccent != null) {
      map['pitch_accent'] = Variable<int>(pitchAccent);
    }
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      contentItemId: Value(contentItemId),
      surfaceForm: Value(surfaceForm),
      reading: Value(reading),
      meaningsRu: Value(meaningsRu),
      partOfSpeech: partOfSpeech == null && nullToAbsent
          ? const Value.absent()
          : Value(partOfSpeech),
      isKanaOnly: Value(isKanaOnly),
      pitchAccent: pitchAccent == null && nullToAbsent
          ? const Value.absent()
          : Value(pitchAccent),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
    );
  }

  factory Word.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Word(
      contentItemId: serializer.fromJson<int>(json['content_item_id']),
      surfaceForm: serializer.fromJson<String>(json['surface_form']),
      reading: serializer.fromJson<String>(json['reading']),
      meaningsRu: serializer.fromJson<String>(json['meanings_ru']),
      partOfSpeech: serializer.fromJson<String?>(json['part_of_speech']),
      isKanaOnly: serializer.fromJson<int>(json['is_kana_only']),
      pitchAccent: serializer.fromJson<int?>(json['pitch_accent']),
      audioUrl: serializer.fromJson<String?>(json['audio_url']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'content_item_id': serializer.toJson<int>(contentItemId),
      'surface_form': serializer.toJson<String>(surfaceForm),
      'reading': serializer.toJson<String>(reading),
      'meanings_ru': serializer.toJson<String>(meaningsRu),
      'part_of_speech': serializer.toJson<String?>(partOfSpeech),
      'is_kana_only': serializer.toJson<int>(isKanaOnly),
      'pitch_accent': serializer.toJson<int?>(pitchAccent),
      'audio_url': serializer.toJson<String?>(audioUrl),
    };
  }

  Word copyWith({
    int? contentItemId,
    String? surfaceForm,
    String? reading,
    String? meaningsRu,
    Value<String?> partOfSpeech = const Value.absent(),
    int? isKanaOnly,
    Value<int?> pitchAccent = const Value.absent(),
    Value<String?> audioUrl = const Value.absent(),
  }) => Word(
    contentItemId: contentItemId ?? this.contentItemId,
    surfaceForm: surfaceForm ?? this.surfaceForm,
    reading: reading ?? this.reading,
    meaningsRu: meaningsRu ?? this.meaningsRu,
    partOfSpeech: partOfSpeech.present ? partOfSpeech.value : this.partOfSpeech,
    isKanaOnly: isKanaOnly ?? this.isKanaOnly,
    pitchAccent: pitchAccent.present ? pitchAccent.value : this.pitchAccent,
    audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
  );
  Word copyWithCompanion(WordsCompanion data) {
    return Word(
      contentItemId: data.contentItemId.present
          ? data.contentItemId.value
          : this.contentItemId,
      surfaceForm: data.surfaceForm.present
          ? data.surfaceForm.value
          : this.surfaceForm,
      reading: data.reading.present ? data.reading.value : this.reading,
      meaningsRu: data.meaningsRu.present
          ? data.meaningsRu.value
          : this.meaningsRu,
      partOfSpeech: data.partOfSpeech.present
          ? data.partOfSpeech.value
          : this.partOfSpeech,
      isKanaOnly: data.isKanaOnly.present
          ? data.isKanaOnly.value
          : this.isKanaOnly,
      pitchAccent: data.pitchAccent.present
          ? data.pitchAccent.value
          : this.pitchAccent,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Word(')
          ..write('contentItemId: $contentItemId, ')
          ..write('surfaceForm: $surfaceForm, ')
          ..write('reading: $reading, ')
          ..write('meaningsRu: $meaningsRu, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('isKanaOnly: $isKanaOnly, ')
          ..write('pitchAccent: $pitchAccent, ')
          ..write('audioUrl: $audioUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    contentItemId,
    surfaceForm,
    reading,
    meaningsRu,
    partOfSpeech,
    isKanaOnly,
    pitchAccent,
    audioUrl,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Word &&
          other.contentItemId == this.contentItemId &&
          other.surfaceForm == this.surfaceForm &&
          other.reading == this.reading &&
          other.meaningsRu == this.meaningsRu &&
          other.partOfSpeech == this.partOfSpeech &&
          other.isKanaOnly == this.isKanaOnly &&
          other.pitchAccent == this.pitchAccent &&
          other.audioUrl == this.audioUrl);
}

class WordsCompanion extends UpdateCompanion<Word> {
  final Value<int> contentItemId;
  final Value<String> surfaceForm;
  final Value<String> reading;
  final Value<String> meaningsRu;
  final Value<String?> partOfSpeech;
  final Value<int> isKanaOnly;
  final Value<int?> pitchAccent;
  final Value<String?> audioUrl;
  const WordsCompanion({
    this.contentItemId = const Value.absent(),
    this.surfaceForm = const Value.absent(),
    this.reading = const Value.absent(),
    this.meaningsRu = const Value.absent(),
    this.partOfSpeech = const Value.absent(),
    this.isKanaOnly = const Value.absent(),
    this.pitchAccent = const Value.absent(),
    this.audioUrl = const Value.absent(),
  });
  WordsCompanion.insert({
    this.contentItemId = const Value.absent(),
    required String surfaceForm,
    required String reading,
    required String meaningsRu,
    this.partOfSpeech = const Value.absent(),
    this.isKanaOnly = const Value.absent(),
    this.pitchAccent = const Value.absent(),
    this.audioUrl = const Value.absent(),
  }) : surfaceForm = Value(surfaceForm),
       reading = Value(reading),
       meaningsRu = Value(meaningsRu);
  static Insertable<Word> custom({
    Expression<int>? contentItemId,
    Expression<String>? surfaceForm,
    Expression<String>? reading,
    Expression<String>? meaningsRu,
    Expression<String>? partOfSpeech,
    Expression<int>? isKanaOnly,
    Expression<int>? pitchAccent,
    Expression<String>? audioUrl,
  }) {
    return RawValuesInsertable({
      if (contentItemId != null) 'content_item_id': contentItemId,
      if (surfaceForm != null) 'surface_form': surfaceForm,
      if (reading != null) 'reading': reading,
      if (meaningsRu != null) 'meanings_ru': meaningsRu,
      if (partOfSpeech != null) 'part_of_speech': partOfSpeech,
      if (isKanaOnly != null) 'is_kana_only': isKanaOnly,
      if (pitchAccent != null) 'pitch_accent': pitchAccent,
      if (audioUrl != null) 'audio_url': audioUrl,
    });
  }

  WordsCompanion copyWith({
    Value<int>? contentItemId,
    Value<String>? surfaceForm,
    Value<String>? reading,
    Value<String>? meaningsRu,
    Value<String?>? partOfSpeech,
    Value<int>? isKanaOnly,
    Value<int?>? pitchAccent,
    Value<String?>? audioUrl,
  }) {
    return WordsCompanion(
      contentItemId: contentItemId ?? this.contentItemId,
      surfaceForm: surfaceForm ?? this.surfaceForm,
      reading: reading ?? this.reading,
      meaningsRu: meaningsRu ?? this.meaningsRu,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      isKanaOnly: isKanaOnly ?? this.isKanaOnly,
      pitchAccent: pitchAccent ?? this.pitchAccent,
      audioUrl: audioUrl ?? this.audioUrl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentItemId.present) {
      map['content_item_id'] = Variable<int>(contentItemId.value);
    }
    if (surfaceForm.present) {
      map['surface_form'] = Variable<String>(surfaceForm.value);
    }
    if (reading.present) {
      map['reading'] = Variable<String>(reading.value);
    }
    if (meaningsRu.present) {
      map['meanings_ru'] = Variable<String>(meaningsRu.value);
    }
    if (partOfSpeech.present) {
      map['part_of_speech'] = Variable<String>(partOfSpeech.value);
    }
    if (isKanaOnly.present) {
      map['is_kana_only'] = Variable<int>(isKanaOnly.value);
    }
    if (pitchAccent.present) {
      map['pitch_accent'] = Variable<int>(pitchAccent.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsCompanion(')
          ..write('contentItemId: $contentItemId, ')
          ..write('surfaceForm: $surfaceForm, ')
          ..write('reading: $reading, ')
          ..write('meaningsRu: $meaningsRu, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('isKanaOnly: $isKanaOnly, ')
          ..write('pitchAccent: $pitchAccent, ')
          ..write('audioUrl: $audioUrl')
          ..write(')'))
        .toString();
  }
}

class WordKanji extends Table with TableInfo<WordKanji, WordKanjiData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  WordKanji(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _wordContentItemIdMeta = const VerificationMeta(
    'wordContentItemId',
  );
  late final GeneratedColumn<int> wordContentItemId = GeneratedColumn<int>(
    'word_content_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES words(content_item_id)',
  );
  static const VerificationMeta _kanjiContentItemIdMeta =
      const VerificationMeta('kanjiContentItemId');
  late final GeneratedColumn<int> kanjiContentItemId = GeneratedColumn<int>(
    'kanji_content_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES kanji(content_item_id)',
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    wordContentItemId,
    kanjiContentItemId,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'word_kanji';
  @override
  VerificationContext validateIntegrity(
    Insertable<WordKanjiData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('word_content_item_id')) {
      context.handle(
        _wordContentItemIdMeta,
        wordContentItemId.isAcceptableOrUnknown(
          data['word_content_item_id']!,
          _wordContentItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_wordContentItemIdMeta);
    }
    if (data.containsKey('kanji_content_item_id')) {
      context.handle(
        _kanjiContentItemIdMeta,
        kanjiContentItemId.isAcceptableOrUnknown(
          data['kanji_content_item_id']!,
          _kanjiContentItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_kanjiContentItemIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {
    wordContentItemId,
    kanjiContentItemId,
  };
  @override
  WordKanjiData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordKanjiData(
      wordContentItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_content_item_id'],
      )!,
      kanjiContentItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kanji_content_item_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  WordKanji createAlias(String alias) {
    return WordKanji(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(word_content_item_id, kanji_content_item_id)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class WordKanjiData extends DataClass implements Insertable<WordKanjiData> {
  final int wordContentItemId;
  final int kanjiContentItemId;
  final int position;
  const WordKanjiData({
    required this.wordContentItemId,
    required this.kanjiContentItemId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['word_content_item_id'] = Variable<int>(wordContentItemId);
    map['kanji_content_item_id'] = Variable<int>(kanjiContentItemId);
    map['position'] = Variable<int>(position);
    return map;
  }

  WordKanjiCompanion toCompanion(bool nullToAbsent) {
    return WordKanjiCompanion(
      wordContentItemId: Value(wordContentItemId),
      kanjiContentItemId: Value(kanjiContentItemId),
      position: Value(position),
    );
  }

  factory WordKanjiData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordKanjiData(
      wordContentItemId: serializer.fromJson<int>(json['word_content_item_id']),
      kanjiContentItemId: serializer.fromJson<int>(
        json['kanji_content_item_id'],
      ),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'word_content_item_id': serializer.toJson<int>(wordContentItemId),
      'kanji_content_item_id': serializer.toJson<int>(kanjiContentItemId),
      'position': serializer.toJson<int>(position),
    };
  }

  WordKanjiData copyWith({
    int? wordContentItemId,
    int? kanjiContentItemId,
    int? position,
  }) => WordKanjiData(
    wordContentItemId: wordContentItemId ?? this.wordContentItemId,
    kanjiContentItemId: kanjiContentItemId ?? this.kanjiContentItemId,
    position: position ?? this.position,
  );
  WordKanjiData copyWithCompanion(WordKanjiCompanion data) {
    return WordKanjiData(
      wordContentItemId: data.wordContentItemId.present
          ? data.wordContentItemId.value
          : this.wordContentItemId,
      kanjiContentItemId: data.kanjiContentItemId.present
          ? data.kanjiContentItemId.value
          : this.kanjiContentItemId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordKanjiData(')
          ..write('wordContentItemId: $wordContentItemId, ')
          ..write('kanjiContentItemId: $kanjiContentItemId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(wordContentItemId, kanjiContentItemId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordKanjiData &&
          other.wordContentItemId == this.wordContentItemId &&
          other.kanjiContentItemId == this.kanjiContentItemId &&
          other.position == this.position);
}

class WordKanjiCompanion extends UpdateCompanion<WordKanjiData> {
  final Value<int> wordContentItemId;
  final Value<int> kanjiContentItemId;
  final Value<int> position;
  final Value<int> rowid;
  const WordKanjiCompanion({
    this.wordContentItemId = const Value.absent(),
    this.kanjiContentItemId = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WordKanjiCompanion.insert({
    required int wordContentItemId,
    required int kanjiContentItemId,
    required int position,
    this.rowid = const Value.absent(),
  }) : wordContentItemId = Value(wordContentItemId),
       kanjiContentItemId = Value(kanjiContentItemId),
       position = Value(position);
  static Insertable<WordKanjiData> custom({
    Expression<int>? wordContentItemId,
    Expression<int>? kanjiContentItemId,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (wordContentItemId != null) 'word_content_item_id': wordContentItemId,
      if (kanjiContentItemId != null)
        'kanji_content_item_id': kanjiContentItemId,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WordKanjiCompanion copyWith({
    Value<int>? wordContentItemId,
    Value<int>? kanjiContentItemId,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return WordKanjiCompanion(
      wordContentItemId: wordContentItemId ?? this.wordContentItemId,
      kanjiContentItemId: kanjiContentItemId ?? this.kanjiContentItemId,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (wordContentItemId.present) {
      map['word_content_item_id'] = Variable<int>(wordContentItemId.value);
    }
    if (kanjiContentItemId.present) {
      map['kanji_content_item_id'] = Variable<int>(kanjiContentItemId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordKanjiCompanion(')
          ..write('wordContentItemId: $wordContentItemId, ')
          ..write('kanjiContentItemId: $kanjiContentItemId, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class WordKana extends Table with TableInfo<WordKana, WordKanaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  WordKana(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _wordContentItemIdMeta = const VerificationMeta(
    'wordContentItemId',
  );
  late final GeneratedColumn<int> wordContentItemId = GeneratedColumn<int>(
    'word_content_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES words(content_item_id)',
  );
  static const VerificationMeta _kanaContentItemIdMeta = const VerificationMeta(
    'kanaContentItemId',
  );
  late final GeneratedColumn<int> kanaContentItemId = GeneratedColumn<int>(
    'kana_content_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES kana(content_item_id)',
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    wordContentItemId,
    kanaContentItemId,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'word_kana';
  @override
  VerificationContext validateIntegrity(
    Insertable<WordKanaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('word_content_item_id')) {
      context.handle(
        _wordContentItemIdMeta,
        wordContentItemId.isAcceptableOrUnknown(
          data['word_content_item_id']!,
          _wordContentItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_wordContentItemIdMeta);
    }
    if (data.containsKey('kana_content_item_id')) {
      context.handle(
        _kanaContentItemIdMeta,
        kanaContentItemId.isAcceptableOrUnknown(
          data['kana_content_item_id']!,
          _kanaContentItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_kanaContentItemIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {
    wordContentItemId,
    kanaContentItemId,
  };
  @override
  WordKanaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordKanaData(
      wordContentItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_content_item_id'],
      )!,
      kanaContentItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kana_content_item_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  WordKana createAlias(String alias) {
    return WordKana(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(word_content_item_id, kana_content_item_id)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class WordKanaData extends DataClass implements Insertable<WordKanaData> {
  final int wordContentItemId;
  final int kanaContentItemId;
  final int position;
  const WordKanaData({
    required this.wordContentItemId,
    required this.kanaContentItemId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['word_content_item_id'] = Variable<int>(wordContentItemId);
    map['kana_content_item_id'] = Variable<int>(kanaContentItemId);
    map['position'] = Variable<int>(position);
    return map;
  }

  WordKanaCompanion toCompanion(bool nullToAbsent) {
    return WordKanaCompanion(
      wordContentItemId: Value(wordContentItemId),
      kanaContentItemId: Value(kanaContentItemId),
      position: Value(position),
    );
  }

  factory WordKanaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordKanaData(
      wordContentItemId: serializer.fromJson<int>(json['word_content_item_id']),
      kanaContentItemId: serializer.fromJson<int>(json['kana_content_item_id']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'word_content_item_id': serializer.toJson<int>(wordContentItemId),
      'kana_content_item_id': serializer.toJson<int>(kanaContentItemId),
      'position': serializer.toJson<int>(position),
    };
  }

  WordKanaData copyWith({
    int? wordContentItemId,
    int? kanaContentItemId,
    int? position,
  }) => WordKanaData(
    wordContentItemId: wordContentItemId ?? this.wordContentItemId,
    kanaContentItemId: kanaContentItemId ?? this.kanaContentItemId,
    position: position ?? this.position,
  );
  WordKanaData copyWithCompanion(WordKanaCompanion data) {
    return WordKanaData(
      wordContentItemId: data.wordContentItemId.present
          ? data.wordContentItemId.value
          : this.wordContentItemId,
      kanaContentItemId: data.kanaContentItemId.present
          ? data.kanaContentItemId.value
          : this.kanaContentItemId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordKanaData(')
          ..write('wordContentItemId: $wordContentItemId, ')
          ..write('kanaContentItemId: $kanaContentItemId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(wordContentItemId, kanaContentItemId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordKanaData &&
          other.wordContentItemId == this.wordContentItemId &&
          other.kanaContentItemId == this.kanaContentItemId &&
          other.position == this.position);
}

class WordKanaCompanion extends UpdateCompanion<WordKanaData> {
  final Value<int> wordContentItemId;
  final Value<int> kanaContentItemId;
  final Value<int> position;
  final Value<int> rowid;
  const WordKanaCompanion({
    this.wordContentItemId = const Value.absent(),
    this.kanaContentItemId = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WordKanaCompanion.insert({
    required int wordContentItemId,
    required int kanaContentItemId,
    required int position,
    this.rowid = const Value.absent(),
  }) : wordContentItemId = Value(wordContentItemId),
       kanaContentItemId = Value(kanaContentItemId),
       position = Value(position);
  static Insertable<WordKanaData> custom({
    Expression<int>? wordContentItemId,
    Expression<int>? kanaContentItemId,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (wordContentItemId != null) 'word_content_item_id': wordContentItemId,
      if (kanaContentItemId != null) 'kana_content_item_id': kanaContentItemId,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WordKanaCompanion copyWith({
    Value<int>? wordContentItemId,
    Value<int>? kanaContentItemId,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return WordKanaCompanion(
      wordContentItemId: wordContentItemId ?? this.wordContentItemId,
      kanaContentItemId: kanaContentItemId ?? this.kanaContentItemId,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (wordContentItemId.present) {
      map['word_content_item_id'] = Variable<int>(wordContentItemId.value);
    }
    if (kanaContentItemId.present) {
      map['kana_content_item_id'] = Variable<int>(kanaContentItemId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordKanaCompanion(')
          ..write('wordContentItemId: $wordContentItemId, ')
          ..write('kanaContentItemId: $kanaContentItemId, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Particles extends Table with TableInfo<Particles, Particle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Particles(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentItemIdMeta = const VerificationMeta(
    'contentItemId',
  );
  late final GeneratedColumn<int> contentItemId = GeneratedColumn<int>(
    'content_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY REFERENCES content_items(id)',
  );
  static const VerificationMeta _particleMeta = const VerificationMeta(
    'particle',
  );
  late final GeneratedColumn<String> particle = GeneratedColumn<String>(
    'particle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _shortDescriptionMeta = const VerificationMeta(
    'shortDescription',
  );
  late final GeneratedColumn<String> shortDescription = GeneratedColumn<String>(
    'short_description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _longTheoryMeta = const VerificationMeta(
    'longTheory',
  );
  late final GeneratedColumn<String> longTheory = GeneratedColumn<String>(
    'long_theory',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _confusableWithMeta = const VerificationMeta(
    'confusableWith',
  );
  late final GeneratedColumn<String> confusableWith = GeneratedColumn<String>(
    'confusable_with',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    contentItemId,
    particle,
    category,
    shortDescription,
    longTheory,
    confusableWith,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'particles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Particle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_item_id')) {
      context.handle(
        _contentItemIdMeta,
        contentItemId.isAcceptableOrUnknown(
          data['content_item_id']!,
          _contentItemIdMeta,
        ),
      );
    }
    if (data.containsKey('particle')) {
      context.handle(
        _particleMeta,
        particle.isAcceptableOrUnknown(data['particle']!, _particleMeta),
      );
    } else if (isInserting) {
      context.missing(_particleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('short_description')) {
      context.handle(
        _shortDescriptionMeta,
        shortDescription.isAcceptableOrUnknown(
          data['short_description']!,
          _shortDescriptionMeta,
        ),
      );
    }
    if (data.containsKey('long_theory')) {
      context.handle(
        _longTheoryMeta,
        longTheory.isAcceptableOrUnknown(data['long_theory']!, _longTheoryMeta),
      );
    }
    if (data.containsKey('confusable_with')) {
      context.handle(
        _confusableWithMeta,
        confusableWith.isAcceptableOrUnknown(
          data['confusable_with']!,
          _confusableWithMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentItemId};
  @override
  Particle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Particle(
      contentItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_item_id'],
      )!,
      particle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}particle'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      shortDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}short_description'],
      ),
      longTheory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}long_theory'],
      ),
      confusableWith: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confusable_with'],
      ),
    );
  }

  @override
  Particles createAlias(String alias) {
    return Particles(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Particle extends DataClass implements Insertable<Particle> {
  final int contentItemId;
  final String particle;
  final String? category;
  final String? shortDescription;
  final String? longTheory;
  final String? confusableWith;
  const Particle({
    required this.contentItemId,
    required this.particle,
    this.category,
    this.shortDescription,
    this.longTheory,
    this.confusableWith,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_item_id'] = Variable<int>(contentItemId);
    map['particle'] = Variable<String>(particle);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || shortDescription != null) {
      map['short_description'] = Variable<String>(shortDescription);
    }
    if (!nullToAbsent || longTheory != null) {
      map['long_theory'] = Variable<String>(longTheory);
    }
    if (!nullToAbsent || confusableWith != null) {
      map['confusable_with'] = Variable<String>(confusableWith);
    }
    return map;
  }

  ParticlesCompanion toCompanion(bool nullToAbsent) {
    return ParticlesCompanion(
      contentItemId: Value(contentItemId),
      particle: Value(particle),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      shortDescription: shortDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(shortDescription),
      longTheory: longTheory == null && nullToAbsent
          ? const Value.absent()
          : Value(longTheory),
      confusableWith: confusableWith == null && nullToAbsent
          ? const Value.absent()
          : Value(confusableWith),
    );
  }

  factory Particle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Particle(
      contentItemId: serializer.fromJson<int>(json['content_item_id']),
      particle: serializer.fromJson<String>(json['particle']),
      category: serializer.fromJson<String?>(json['category']),
      shortDescription: serializer.fromJson<String?>(json['short_description']),
      longTheory: serializer.fromJson<String?>(json['long_theory']),
      confusableWith: serializer.fromJson<String?>(json['confusable_with']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'content_item_id': serializer.toJson<int>(contentItemId),
      'particle': serializer.toJson<String>(particle),
      'category': serializer.toJson<String?>(category),
      'short_description': serializer.toJson<String?>(shortDescription),
      'long_theory': serializer.toJson<String?>(longTheory),
      'confusable_with': serializer.toJson<String?>(confusableWith),
    };
  }

  Particle copyWith({
    int? contentItemId,
    String? particle,
    Value<String?> category = const Value.absent(),
    Value<String?> shortDescription = const Value.absent(),
    Value<String?> longTheory = const Value.absent(),
    Value<String?> confusableWith = const Value.absent(),
  }) => Particle(
    contentItemId: contentItemId ?? this.contentItemId,
    particle: particle ?? this.particle,
    category: category.present ? category.value : this.category,
    shortDescription: shortDescription.present
        ? shortDescription.value
        : this.shortDescription,
    longTheory: longTheory.present ? longTheory.value : this.longTheory,
    confusableWith: confusableWith.present
        ? confusableWith.value
        : this.confusableWith,
  );
  Particle copyWithCompanion(ParticlesCompanion data) {
    return Particle(
      contentItemId: data.contentItemId.present
          ? data.contentItemId.value
          : this.contentItemId,
      particle: data.particle.present ? data.particle.value : this.particle,
      category: data.category.present ? data.category.value : this.category,
      shortDescription: data.shortDescription.present
          ? data.shortDescription.value
          : this.shortDescription,
      longTheory: data.longTheory.present
          ? data.longTheory.value
          : this.longTheory,
      confusableWith: data.confusableWith.present
          ? data.confusableWith.value
          : this.confusableWith,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Particle(')
          ..write('contentItemId: $contentItemId, ')
          ..write('particle: $particle, ')
          ..write('category: $category, ')
          ..write('shortDescription: $shortDescription, ')
          ..write('longTheory: $longTheory, ')
          ..write('confusableWith: $confusableWith')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    contentItemId,
    particle,
    category,
    shortDescription,
    longTheory,
    confusableWith,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Particle &&
          other.contentItemId == this.contentItemId &&
          other.particle == this.particle &&
          other.category == this.category &&
          other.shortDescription == this.shortDescription &&
          other.longTheory == this.longTheory &&
          other.confusableWith == this.confusableWith);
}

class ParticlesCompanion extends UpdateCompanion<Particle> {
  final Value<int> contentItemId;
  final Value<String> particle;
  final Value<String?> category;
  final Value<String?> shortDescription;
  final Value<String?> longTheory;
  final Value<String?> confusableWith;
  const ParticlesCompanion({
    this.contentItemId = const Value.absent(),
    this.particle = const Value.absent(),
    this.category = const Value.absent(),
    this.shortDescription = const Value.absent(),
    this.longTheory = const Value.absent(),
    this.confusableWith = const Value.absent(),
  });
  ParticlesCompanion.insert({
    this.contentItemId = const Value.absent(),
    required String particle,
    this.category = const Value.absent(),
    this.shortDescription = const Value.absent(),
    this.longTheory = const Value.absent(),
    this.confusableWith = const Value.absent(),
  }) : particle = Value(particle);
  static Insertable<Particle> custom({
    Expression<int>? contentItemId,
    Expression<String>? particle,
    Expression<String>? category,
    Expression<String>? shortDescription,
    Expression<String>? longTheory,
    Expression<String>? confusableWith,
  }) {
    return RawValuesInsertable({
      if (contentItemId != null) 'content_item_id': contentItemId,
      if (particle != null) 'particle': particle,
      if (category != null) 'category': category,
      if (shortDescription != null) 'short_description': shortDescription,
      if (longTheory != null) 'long_theory': longTheory,
      if (confusableWith != null) 'confusable_with': confusableWith,
    });
  }

  ParticlesCompanion copyWith({
    Value<int>? contentItemId,
    Value<String>? particle,
    Value<String?>? category,
    Value<String?>? shortDescription,
    Value<String?>? longTheory,
    Value<String?>? confusableWith,
  }) {
    return ParticlesCompanion(
      contentItemId: contentItemId ?? this.contentItemId,
      particle: particle ?? this.particle,
      category: category ?? this.category,
      shortDescription: shortDescription ?? this.shortDescription,
      longTheory: longTheory ?? this.longTheory,
      confusableWith: confusableWith ?? this.confusableWith,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentItemId.present) {
      map['content_item_id'] = Variable<int>(contentItemId.value);
    }
    if (particle.present) {
      map['particle'] = Variable<String>(particle.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (shortDescription.present) {
      map['short_description'] = Variable<String>(shortDescription.value);
    }
    if (longTheory.present) {
      map['long_theory'] = Variable<String>(longTheory.value);
    }
    if (confusableWith.present) {
      map['confusable_with'] = Variable<String>(confusableWith.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParticlesCompanion(')
          ..write('contentItemId: $contentItemId, ')
          ..write('particle: $particle, ')
          ..write('category: $category, ')
          ..write('shortDescription: $shortDescription, ')
          ..write('longTheory: $longTheory, ')
          ..write('confusableWith: $confusableWith')
          ..write(')'))
        .toString();
  }
}

class GrammarPoints extends Table with TableInfo<GrammarPoints, GrammarPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  GrammarPoints(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentItemIdMeta = const VerificationMeta(
    'contentItemId',
  );
  late final GeneratedColumn<int> contentItemId = GeneratedColumn<int>(
    'content_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY REFERENCES content_items(id)',
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _patternMeta = const VerificationMeta(
    'pattern',
  );
  late final GeneratedColumn<String> pattern = GeneratedColumn<String>(
    'pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _registerMeta = const VerificationMeta(
    'register',
  );
  late final GeneratedColumn<String> register = GeneratedColumn<String>(
    'register',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK (register IN (\'casual\', \'polite\', \'formal\'))',
  );
  static const VerificationMeta _relatedGrammarIdsMeta = const VerificationMeta(
    'relatedGrammarIds',
  );
  late final GeneratedColumn<String> relatedGrammarIds =
      GeneratedColumn<String>(
        'related_grammar_ids',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        $customConstraints: '',
      );
  @override
  List<GeneratedColumn> get $columns => [
    contentItemId,
    title,
    pattern,
    explanation,
    register,
    relatedGrammarIds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrammarPoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_item_id')) {
      context.handle(
        _contentItemIdMeta,
        contentItemId.isAcceptableOrUnknown(
          data['content_item_id']!,
          _contentItemIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('pattern')) {
      context.handle(
        _patternMeta,
        pattern.isAcceptableOrUnknown(data['pattern']!, _patternMeta),
      );
    } else if (isInserting) {
      context.missing(_patternMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explanationMeta);
    }
    if (data.containsKey('register')) {
      context.handle(
        _registerMeta,
        register.isAcceptableOrUnknown(data['register']!, _registerMeta),
      );
    }
    if (data.containsKey('related_grammar_ids')) {
      context.handle(
        _relatedGrammarIdsMeta,
        relatedGrammarIds.isAcceptableOrUnknown(
          data['related_grammar_ids']!,
          _relatedGrammarIdsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentItemId};
  @override
  GrammarPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarPoint(
      contentItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_item_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      pattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      )!,
      register: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}register'],
      ),
      relatedGrammarIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}related_grammar_ids'],
      ),
    );
  }

  @override
  GrammarPoints createAlias(String alias) {
    return GrammarPoints(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class GrammarPoint extends DataClass implements Insertable<GrammarPoint> {
  final int contentItemId;
  final String title;
  final String pattern;
  final String explanation;
  final String? register;
  final String? relatedGrammarIds;
  const GrammarPoint({
    required this.contentItemId,
    required this.title,
    required this.pattern,
    required this.explanation,
    this.register,
    this.relatedGrammarIds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_item_id'] = Variable<int>(contentItemId);
    map['title'] = Variable<String>(title);
    map['pattern'] = Variable<String>(pattern);
    map['explanation'] = Variable<String>(explanation);
    if (!nullToAbsent || register != null) {
      map['register'] = Variable<String>(register);
    }
    if (!nullToAbsent || relatedGrammarIds != null) {
      map['related_grammar_ids'] = Variable<String>(relatedGrammarIds);
    }
    return map;
  }

  GrammarPointsCompanion toCompanion(bool nullToAbsent) {
    return GrammarPointsCompanion(
      contentItemId: Value(contentItemId),
      title: Value(title),
      pattern: Value(pattern),
      explanation: Value(explanation),
      register: register == null && nullToAbsent
          ? const Value.absent()
          : Value(register),
      relatedGrammarIds: relatedGrammarIds == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedGrammarIds),
    );
  }

  factory GrammarPoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarPoint(
      contentItemId: serializer.fromJson<int>(json['content_item_id']),
      title: serializer.fromJson<String>(json['title']),
      pattern: serializer.fromJson<String>(json['pattern']),
      explanation: serializer.fromJson<String>(json['explanation']),
      register: serializer.fromJson<String?>(json['register']),
      relatedGrammarIds: serializer.fromJson<String?>(
        json['related_grammar_ids'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'content_item_id': serializer.toJson<int>(contentItemId),
      'title': serializer.toJson<String>(title),
      'pattern': serializer.toJson<String>(pattern),
      'explanation': serializer.toJson<String>(explanation),
      'register': serializer.toJson<String?>(register),
      'related_grammar_ids': serializer.toJson<String?>(relatedGrammarIds),
    };
  }

  GrammarPoint copyWith({
    int? contentItemId,
    String? title,
    String? pattern,
    String? explanation,
    Value<String?> register = const Value.absent(),
    Value<String?> relatedGrammarIds = const Value.absent(),
  }) => GrammarPoint(
    contentItemId: contentItemId ?? this.contentItemId,
    title: title ?? this.title,
    pattern: pattern ?? this.pattern,
    explanation: explanation ?? this.explanation,
    register: register.present ? register.value : this.register,
    relatedGrammarIds: relatedGrammarIds.present
        ? relatedGrammarIds.value
        : this.relatedGrammarIds,
  );
  GrammarPoint copyWithCompanion(GrammarPointsCompanion data) {
    return GrammarPoint(
      contentItemId: data.contentItemId.present
          ? data.contentItemId.value
          : this.contentItemId,
      title: data.title.present ? data.title.value : this.title,
      pattern: data.pattern.present ? data.pattern.value : this.pattern,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
      register: data.register.present ? data.register.value : this.register,
      relatedGrammarIds: data.relatedGrammarIds.present
          ? data.relatedGrammarIds.value
          : this.relatedGrammarIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarPoint(')
          ..write('contentItemId: $contentItemId, ')
          ..write('title: $title, ')
          ..write('pattern: $pattern, ')
          ..write('explanation: $explanation, ')
          ..write('register: $register, ')
          ..write('relatedGrammarIds: $relatedGrammarIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    contentItemId,
    title,
    pattern,
    explanation,
    register,
    relatedGrammarIds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarPoint &&
          other.contentItemId == this.contentItemId &&
          other.title == this.title &&
          other.pattern == this.pattern &&
          other.explanation == this.explanation &&
          other.register == this.register &&
          other.relatedGrammarIds == this.relatedGrammarIds);
}

class GrammarPointsCompanion extends UpdateCompanion<GrammarPoint> {
  final Value<int> contentItemId;
  final Value<String> title;
  final Value<String> pattern;
  final Value<String> explanation;
  final Value<String?> register;
  final Value<String?> relatedGrammarIds;
  const GrammarPointsCompanion({
    this.contentItemId = const Value.absent(),
    this.title = const Value.absent(),
    this.pattern = const Value.absent(),
    this.explanation = const Value.absent(),
    this.register = const Value.absent(),
    this.relatedGrammarIds = const Value.absent(),
  });
  GrammarPointsCompanion.insert({
    this.contentItemId = const Value.absent(),
    required String title,
    required String pattern,
    required String explanation,
    this.register = const Value.absent(),
    this.relatedGrammarIds = const Value.absent(),
  }) : title = Value(title),
       pattern = Value(pattern),
       explanation = Value(explanation);
  static Insertable<GrammarPoint> custom({
    Expression<int>? contentItemId,
    Expression<String>? title,
    Expression<String>? pattern,
    Expression<String>? explanation,
    Expression<String>? register,
    Expression<String>? relatedGrammarIds,
  }) {
    return RawValuesInsertable({
      if (contentItemId != null) 'content_item_id': contentItemId,
      if (title != null) 'title': title,
      if (pattern != null) 'pattern': pattern,
      if (explanation != null) 'explanation': explanation,
      if (register != null) 'register': register,
      if (relatedGrammarIds != null) 'related_grammar_ids': relatedGrammarIds,
    });
  }

  GrammarPointsCompanion copyWith({
    Value<int>? contentItemId,
    Value<String>? title,
    Value<String>? pattern,
    Value<String>? explanation,
    Value<String?>? register,
    Value<String?>? relatedGrammarIds,
  }) {
    return GrammarPointsCompanion(
      contentItemId: contentItemId ?? this.contentItemId,
      title: title ?? this.title,
      pattern: pattern ?? this.pattern,
      explanation: explanation ?? this.explanation,
      register: register ?? this.register,
      relatedGrammarIds: relatedGrammarIds ?? this.relatedGrammarIds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentItemId.present) {
      map['content_item_id'] = Variable<int>(contentItemId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (pattern.present) {
      map['pattern'] = Variable<String>(pattern.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (register.present) {
      map['register'] = Variable<String>(register.value);
    }
    if (relatedGrammarIds.present) {
      map['related_grammar_ids'] = Variable<String>(relatedGrammarIds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarPointsCompanion(')
          ..write('contentItemId: $contentItemId, ')
          ..write('title: $title, ')
          ..write('pattern: $pattern, ')
          ..write('explanation: $explanation, ')
          ..write('register: $register, ')
          ..write('relatedGrammarIds: $relatedGrammarIds')
          ..write(')'))
        .toString();
  }
}

class Sentences extends Table with TableInfo<Sentences, Sentence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Sentences(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _textJpMeta = const VerificationMeta('textJp');
  late final GeneratedColumn<String> textJp = GeneratedColumn<String>(
    'text_jp',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _textFuriganaMeta = const VerificationMeta(
    'textFurigana',
  );
  late final GeneratedColumn<String> textFurigana = GeneratedColumn<String>(
    'text_furigana',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _textTranslationRuMeta = const VerificationMeta(
    'textTranslationRu',
  );
  late final GeneratedColumn<String> textTranslationRu =
      GeneratedColumn<String>(
        'text_translation_ru',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        $customConstraints: 'NOT NULL',
      );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _jlptLevelMeta = const VerificationMeta(
    'jlptLevel',
  );
  late final GeneratedColumn<String> jlptLevel = GeneratedColumn<String>(
    'jlpt_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK (jlpt_level IN (\'N5\', \'N4\', \'N3\', \'N2\', \'N1\'))',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    textJp,
    textFurigana,
    textTranslationRu,
    audioUrl,
    jlptLevel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sentences';
  @override
  VerificationContext validateIntegrity(
    Insertable<Sentence> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('text_jp')) {
      context.handle(
        _textJpMeta,
        textJp.isAcceptableOrUnknown(data['text_jp']!, _textJpMeta),
      );
    } else if (isInserting) {
      context.missing(_textJpMeta);
    }
    if (data.containsKey('text_furigana')) {
      context.handle(
        _textFuriganaMeta,
        textFurigana.isAcceptableOrUnknown(
          data['text_furigana']!,
          _textFuriganaMeta,
        ),
      );
    }
    if (data.containsKey('text_translation_ru')) {
      context.handle(
        _textTranslationRuMeta,
        textTranslationRu.isAcceptableOrUnknown(
          data['text_translation_ru']!,
          _textTranslationRuMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_textTranslationRuMeta);
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    }
    if (data.containsKey('jlpt_level')) {
      context.handle(
        _jlptLevelMeta,
        jlptLevel.isAcceptableOrUnknown(data['jlpt_level']!, _jlptLevelMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sentence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sentence(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      textJp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_jp'],
      )!,
      textFurigana: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_furigana'],
      ),
      textTranslationRu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_translation_ru'],
      )!,
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      ),
      jlptLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jlpt_level'],
      ),
    );
  }

  @override
  Sentences createAlias(String alias) {
    return Sentences(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Sentence extends DataClass implements Insertable<Sentence> {
  final int id;
  final String textJp;
  final String? textFurigana;
  final String textTranslationRu;
  final String? audioUrl;
  final String? jlptLevel;
  const Sentence({
    required this.id,
    required this.textJp,
    this.textFurigana,
    required this.textTranslationRu,
    this.audioUrl,
    this.jlptLevel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['text_jp'] = Variable<String>(textJp);
    if (!nullToAbsent || textFurigana != null) {
      map['text_furigana'] = Variable<String>(textFurigana);
    }
    map['text_translation_ru'] = Variable<String>(textTranslationRu);
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    if (!nullToAbsent || jlptLevel != null) {
      map['jlpt_level'] = Variable<String>(jlptLevel);
    }
    return map;
  }

  SentencesCompanion toCompanion(bool nullToAbsent) {
    return SentencesCompanion(
      id: Value(id),
      textJp: Value(textJp),
      textFurigana: textFurigana == null && nullToAbsent
          ? const Value.absent()
          : Value(textFurigana),
      textTranslationRu: Value(textTranslationRu),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
      jlptLevel: jlptLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(jlptLevel),
    );
  }

  factory Sentence.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sentence(
      id: serializer.fromJson<int>(json['id']),
      textJp: serializer.fromJson<String>(json['text_jp']),
      textFurigana: serializer.fromJson<String?>(json['text_furigana']),
      textTranslationRu: serializer.fromJson<String>(
        json['text_translation_ru'],
      ),
      audioUrl: serializer.fromJson<String?>(json['audio_url']),
      jlptLevel: serializer.fromJson<String?>(json['jlpt_level']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'text_jp': serializer.toJson<String>(textJp),
      'text_furigana': serializer.toJson<String?>(textFurigana),
      'text_translation_ru': serializer.toJson<String>(textTranslationRu),
      'audio_url': serializer.toJson<String?>(audioUrl),
      'jlpt_level': serializer.toJson<String?>(jlptLevel),
    };
  }

  Sentence copyWith({
    int? id,
    String? textJp,
    Value<String?> textFurigana = const Value.absent(),
    String? textTranslationRu,
    Value<String?> audioUrl = const Value.absent(),
    Value<String?> jlptLevel = const Value.absent(),
  }) => Sentence(
    id: id ?? this.id,
    textJp: textJp ?? this.textJp,
    textFurigana: textFurigana.present ? textFurigana.value : this.textFurigana,
    textTranslationRu: textTranslationRu ?? this.textTranslationRu,
    audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
    jlptLevel: jlptLevel.present ? jlptLevel.value : this.jlptLevel,
  );
  Sentence copyWithCompanion(SentencesCompanion data) {
    return Sentence(
      id: data.id.present ? data.id.value : this.id,
      textJp: data.textJp.present ? data.textJp.value : this.textJp,
      textFurigana: data.textFurigana.present
          ? data.textFurigana.value
          : this.textFurigana,
      textTranslationRu: data.textTranslationRu.present
          ? data.textTranslationRu.value
          : this.textTranslationRu,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      jlptLevel: data.jlptLevel.present ? data.jlptLevel.value : this.jlptLevel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sentence(')
          ..write('id: $id, ')
          ..write('textJp: $textJp, ')
          ..write('textFurigana: $textFurigana, ')
          ..write('textTranslationRu: $textTranslationRu, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('jlptLevel: $jlptLevel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    textJp,
    textFurigana,
    textTranslationRu,
    audioUrl,
    jlptLevel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sentence &&
          other.id == this.id &&
          other.textJp == this.textJp &&
          other.textFurigana == this.textFurigana &&
          other.textTranslationRu == this.textTranslationRu &&
          other.audioUrl == this.audioUrl &&
          other.jlptLevel == this.jlptLevel);
}

class SentencesCompanion extends UpdateCompanion<Sentence> {
  final Value<int> id;
  final Value<String> textJp;
  final Value<String?> textFurigana;
  final Value<String> textTranslationRu;
  final Value<String?> audioUrl;
  final Value<String?> jlptLevel;
  const SentencesCompanion({
    this.id = const Value.absent(),
    this.textJp = const Value.absent(),
    this.textFurigana = const Value.absent(),
    this.textTranslationRu = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.jlptLevel = const Value.absent(),
  });
  SentencesCompanion.insert({
    this.id = const Value.absent(),
    required String textJp,
    this.textFurigana = const Value.absent(),
    required String textTranslationRu,
    this.audioUrl = const Value.absent(),
    this.jlptLevel = const Value.absent(),
  }) : textJp = Value(textJp),
       textTranslationRu = Value(textTranslationRu);
  static Insertable<Sentence> custom({
    Expression<int>? id,
    Expression<String>? textJp,
    Expression<String>? textFurigana,
    Expression<String>? textTranslationRu,
    Expression<String>? audioUrl,
    Expression<String>? jlptLevel,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (textJp != null) 'text_jp': textJp,
      if (textFurigana != null) 'text_furigana': textFurigana,
      if (textTranslationRu != null) 'text_translation_ru': textTranslationRu,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (jlptLevel != null) 'jlpt_level': jlptLevel,
    });
  }

  SentencesCompanion copyWith({
    Value<int>? id,
    Value<String>? textJp,
    Value<String?>? textFurigana,
    Value<String>? textTranslationRu,
    Value<String?>? audioUrl,
    Value<String?>? jlptLevel,
  }) {
    return SentencesCompanion(
      id: id ?? this.id,
      textJp: textJp ?? this.textJp,
      textFurigana: textFurigana ?? this.textFurigana,
      textTranslationRu: textTranslationRu ?? this.textTranslationRu,
      audioUrl: audioUrl ?? this.audioUrl,
      jlptLevel: jlptLevel ?? this.jlptLevel,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (textJp.present) {
      map['text_jp'] = Variable<String>(textJp.value);
    }
    if (textFurigana.present) {
      map['text_furigana'] = Variable<String>(textFurigana.value);
    }
    if (textTranslationRu.present) {
      map['text_translation_ru'] = Variable<String>(textTranslationRu.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (jlptLevel.present) {
      map['jlpt_level'] = Variable<String>(jlptLevel.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SentencesCompanion(')
          ..write('id: $id, ')
          ..write('textJp: $textJp, ')
          ..write('textFurigana: $textFurigana, ')
          ..write('textTranslationRu: $textTranslationRu, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('jlptLevel: $jlptLevel')
          ..write(')'))
        .toString();
  }
}

class SentenceContentItems extends Table
    with TableInfo<SentenceContentItems, SentenceContentItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SentenceContentItems(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sentenceIdMeta = const VerificationMeta(
    'sentenceId',
  );
  late final GeneratedColumn<int> sentenceId = GeneratedColumn<int>(
    'sentence_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES sentences(id)',
  );
  static const VerificationMeta _contentItemIdMeta = const VerificationMeta(
    'contentItemId',
  );
  late final GeneratedColumn<int> contentItemId = GeneratedColumn<int>(
    'content_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES content_items(id)',
  );
  static const VerificationMeta _usageNoteMeta = const VerificationMeta(
    'usageNote',
  );
  late final GeneratedColumn<String> usageNote = GeneratedColumn<String>(
    'usage_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [sentenceId, contentItemId, usageNote];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sentence_content_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SentenceContentItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sentence_id')) {
      context.handle(
        _sentenceIdMeta,
        sentenceId.isAcceptableOrUnknown(data['sentence_id']!, _sentenceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sentenceIdMeta);
    }
    if (data.containsKey('content_item_id')) {
      context.handle(
        _contentItemIdMeta,
        contentItemId.isAcceptableOrUnknown(
          data['content_item_id']!,
          _contentItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentItemIdMeta);
    }
    if (data.containsKey('usage_note')) {
      context.handle(
        _usageNoteMeta,
        usageNote.isAcceptableOrUnknown(data['usage_note']!, _usageNoteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sentenceId, contentItemId};
  @override
  SentenceContentItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SentenceContentItem(
      sentenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sentence_id'],
      )!,
      contentItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_item_id'],
      )!,
      usageNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usage_note'],
      ),
    );
  }

  @override
  SentenceContentItems createAlias(String alias) {
    return SentenceContentItems(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(sentence_id, content_item_id)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class SentenceContentItem extends DataClass
    implements Insertable<SentenceContentItem> {
  final int sentenceId;
  final int contentItemId;
  final String? usageNote;
  const SentenceContentItem({
    required this.sentenceId,
    required this.contentItemId,
    this.usageNote,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sentence_id'] = Variable<int>(sentenceId);
    map['content_item_id'] = Variable<int>(contentItemId);
    if (!nullToAbsent || usageNote != null) {
      map['usage_note'] = Variable<String>(usageNote);
    }
    return map;
  }

  SentenceContentItemsCompanion toCompanion(bool nullToAbsent) {
    return SentenceContentItemsCompanion(
      sentenceId: Value(sentenceId),
      contentItemId: Value(contentItemId),
      usageNote: usageNote == null && nullToAbsent
          ? const Value.absent()
          : Value(usageNote),
    );
  }

  factory SentenceContentItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SentenceContentItem(
      sentenceId: serializer.fromJson<int>(json['sentence_id']),
      contentItemId: serializer.fromJson<int>(json['content_item_id']),
      usageNote: serializer.fromJson<String?>(json['usage_note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sentence_id': serializer.toJson<int>(sentenceId),
      'content_item_id': serializer.toJson<int>(contentItemId),
      'usage_note': serializer.toJson<String?>(usageNote),
    };
  }

  SentenceContentItem copyWith({
    int? sentenceId,
    int? contentItemId,
    Value<String?> usageNote = const Value.absent(),
  }) => SentenceContentItem(
    sentenceId: sentenceId ?? this.sentenceId,
    contentItemId: contentItemId ?? this.contentItemId,
    usageNote: usageNote.present ? usageNote.value : this.usageNote,
  );
  SentenceContentItem copyWithCompanion(SentenceContentItemsCompanion data) {
    return SentenceContentItem(
      sentenceId: data.sentenceId.present
          ? data.sentenceId.value
          : this.sentenceId,
      contentItemId: data.contentItemId.present
          ? data.contentItemId.value
          : this.contentItemId,
      usageNote: data.usageNote.present ? data.usageNote.value : this.usageNote,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SentenceContentItem(')
          ..write('sentenceId: $sentenceId, ')
          ..write('contentItemId: $contentItemId, ')
          ..write('usageNote: $usageNote')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(sentenceId, contentItemId, usageNote);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SentenceContentItem &&
          other.sentenceId == this.sentenceId &&
          other.contentItemId == this.contentItemId &&
          other.usageNote == this.usageNote);
}

class SentenceContentItemsCompanion
    extends UpdateCompanion<SentenceContentItem> {
  final Value<int> sentenceId;
  final Value<int> contentItemId;
  final Value<String?> usageNote;
  final Value<int> rowid;
  const SentenceContentItemsCompanion({
    this.sentenceId = const Value.absent(),
    this.contentItemId = const Value.absent(),
    this.usageNote = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SentenceContentItemsCompanion.insert({
    required int sentenceId,
    required int contentItemId,
    this.usageNote = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sentenceId = Value(sentenceId),
       contentItemId = Value(contentItemId);
  static Insertable<SentenceContentItem> custom({
    Expression<int>? sentenceId,
    Expression<int>? contentItemId,
    Expression<String>? usageNote,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sentenceId != null) 'sentence_id': sentenceId,
      if (contentItemId != null) 'content_item_id': contentItemId,
      if (usageNote != null) 'usage_note': usageNote,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SentenceContentItemsCompanion copyWith({
    Value<int>? sentenceId,
    Value<int>? contentItemId,
    Value<String?>? usageNote,
    Value<int>? rowid,
  }) {
    return SentenceContentItemsCompanion(
      sentenceId: sentenceId ?? this.sentenceId,
      contentItemId: contentItemId ?? this.contentItemId,
      usageNote: usageNote ?? this.usageNote,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sentenceId.present) {
      map['sentence_id'] = Variable<int>(sentenceId.value);
    }
    if (contentItemId.present) {
      map['content_item_id'] = Variable<int>(contentItemId.value);
    }
    if (usageNote.present) {
      map['usage_note'] = Variable<String>(usageNote.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SentenceContentItemsCompanion(')
          ..write('sentenceId: $sentenceId, ')
          ..write('contentItemId: $contentItemId, ')
          ..write('usageNote: $usageNote, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class ExerciseTypes extends Table with TableInfo<ExerciseTypes, ExerciseType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ExerciseTypes(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _pillarMeta = const VerificationMeta('pillar');
  late final GeneratedColumn<String> pillar = GeneratedColumn<String>(
    'pillar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (pillar IN (\'reading\', \'listening\', \'speaking\', \'writing\'))',
  );
  static const VerificationMeta _labelRuMeta = const VerificationMeta(
    'labelRu',
  );
  late final GeneratedColumn<String> labelRu = GeneratedColumn<String>(
    'label_ru',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [code, pillar, labelRu];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseType> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('pillar')) {
      context.handle(
        _pillarMeta,
        pillar.isAcceptableOrUnknown(data['pillar']!, _pillarMeta),
      );
    } else if (isInserting) {
      context.missing(_pillarMeta);
    }
    if (data.containsKey('label_ru')) {
      context.handle(
        _labelRuMeta,
        labelRu.isAcceptableOrUnknown(data['label_ru']!, _labelRuMeta),
      );
    } else if (isInserting) {
      context.missing(_labelRuMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  ExerciseType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseType(
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      pillar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pillar'],
      )!,
      labelRu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label_ru'],
      )!,
    );
  }

  @override
  ExerciseTypes createAlias(String alias) {
    return ExerciseTypes(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class ExerciseType extends DataClass implements Insertable<ExerciseType> {
  final String code;
  final String pillar;
  final String labelRu;
  const ExerciseType({
    required this.code,
    required this.pillar,
    required this.labelRu,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['pillar'] = Variable<String>(pillar);
    map['label_ru'] = Variable<String>(labelRu);
    return map;
  }

  ExerciseTypesCompanion toCompanion(bool nullToAbsent) {
    return ExerciseTypesCompanion(
      code: Value(code),
      pillar: Value(pillar),
      labelRu: Value(labelRu),
    );
  }

  factory ExerciseType.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseType(
      code: serializer.fromJson<String>(json['code']),
      pillar: serializer.fromJson<String>(json['pillar']),
      labelRu: serializer.fromJson<String>(json['label_ru']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'pillar': serializer.toJson<String>(pillar),
      'label_ru': serializer.toJson<String>(labelRu),
    };
  }

  ExerciseType copyWith({String? code, String? pillar, String? labelRu}) =>
      ExerciseType(
        code: code ?? this.code,
        pillar: pillar ?? this.pillar,
        labelRu: labelRu ?? this.labelRu,
      );
  ExerciseType copyWithCompanion(ExerciseTypesCompanion data) {
    return ExerciseType(
      code: data.code.present ? data.code.value : this.code,
      pillar: data.pillar.present ? data.pillar.value : this.pillar,
      labelRu: data.labelRu.present ? data.labelRu.value : this.labelRu,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseType(')
          ..write('code: $code, ')
          ..write('pillar: $pillar, ')
          ..write('labelRu: $labelRu')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, pillar, labelRu);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseType &&
          other.code == this.code &&
          other.pillar == this.pillar &&
          other.labelRu == this.labelRu);
}

class ExerciseTypesCompanion extends UpdateCompanion<ExerciseType> {
  final Value<String> code;
  final Value<String> pillar;
  final Value<String> labelRu;
  final Value<int> rowid;
  const ExerciseTypesCompanion({
    this.code = const Value.absent(),
    this.pillar = const Value.absent(),
    this.labelRu = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseTypesCompanion.insert({
    required String code,
    required String pillar,
    required String labelRu,
    this.rowid = const Value.absent(),
  }) : code = Value(code),
       pillar = Value(pillar),
       labelRu = Value(labelRu);
  static Insertable<ExerciseType> custom({
    Expression<String>? code,
    Expression<String>? pillar,
    Expression<String>? labelRu,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (pillar != null) 'pillar': pillar,
      if (labelRu != null) 'label_ru': labelRu,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseTypesCompanion copyWith({
    Value<String>? code,
    Value<String>? pillar,
    Value<String>? labelRu,
    Value<int>? rowid,
  }) {
    return ExerciseTypesCompanion(
      code: code ?? this.code,
      pillar: pillar ?? this.pillar,
      labelRu: labelRu ?? this.labelRu,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (pillar.present) {
      map['pillar'] = Variable<String>(pillar.value);
    }
    if (labelRu.present) {
      map['label_ru'] = Variable<String>(labelRu.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseTypesCompanion(')
          ..write('code: $code, ')
          ..write('pillar: $pillar, ')
          ..write('labelRu: $labelRu, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Units extends Table with TableInfo<Units, Unit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Units(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _subtitleMeta = const VerificationMeta(
    'subtitle',
  );
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
    'subtitle',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (kind IN (\'kana\', \'kanji_vocab\', \'particle\', \'grammar\', \'listening\', \'reading\', \'milestone\', \'mixed\'))',
  );
  static const VerificationMeta _jlptLevelMeta = const VerificationMeta(
    'jlptLevel',
  );
  late final GeneratedColumn<String> jlptLevel = GeneratedColumn<String>(
    'jlpt_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK (jlpt_level IN (\'N5\', \'N4\', \'N3\', \'N2\', \'N1\'))',
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    subtitle,
    kind,
    jlptLevel,
    sortOrder,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units';
  @override
  VerificationContext validateIntegrity(
    Insertable<Unit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('subtitle')) {
      context.handle(
        _subtitleMeta,
        subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('jlpt_level')) {
      context.handle(
        _jlptLevelMeta,
        jlptLevel.isAcceptableOrUnknown(data['jlpt_level']!, _jlptLevelMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Unit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      subtitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtitle'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      jlptLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jlpt_level'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  Units createAlias(String alias) {
    return Units(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Unit extends DataClass implements Insertable<Unit> {
  final int id;
  final String title;
  final String? subtitle;
  final String kind;
  final String? jlptLevel;
  final int sortOrder;
  final String? description;
  const Unit({
    required this.id,
    required this.title,
    this.subtitle,
    required this.kind,
    this.jlptLevel,
    required this.sortOrder,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || subtitle != null) {
      map['subtitle'] = Variable<String>(subtitle);
    }
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || jlptLevel != null) {
      map['jlpt_level'] = Variable<String>(jlptLevel);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      id: Value(id),
      title: Value(title),
      subtitle: subtitle == null && nullToAbsent
          ? const Value.absent()
          : Value(subtitle),
      kind: Value(kind),
      jlptLevel: jlptLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(jlptLevel),
      sortOrder: Value(sortOrder),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory Unit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unit(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      subtitle: serializer.fromJson<String?>(json['subtitle']),
      kind: serializer.fromJson<String>(json['kind']),
      jlptLevel: serializer.fromJson<String?>(json['jlpt_level']),
      sortOrder: serializer.fromJson<int>(json['sort_order']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'subtitle': serializer.toJson<String?>(subtitle),
      'kind': serializer.toJson<String>(kind),
      'jlpt_level': serializer.toJson<String?>(jlptLevel),
      'sort_order': serializer.toJson<int>(sortOrder),
      'description': serializer.toJson<String?>(description),
    };
  }

  Unit copyWith({
    int? id,
    String? title,
    Value<String?> subtitle = const Value.absent(),
    String? kind,
    Value<String?> jlptLevel = const Value.absent(),
    int? sortOrder,
    Value<String?> description = const Value.absent(),
  }) => Unit(
    id: id ?? this.id,
    title: title ?? this.title,
    subtitle: subtitle.present ? subtitle.value : this.subtitle,
    kind: kind ?? this.kind,
    jlptLevel: jlptLevel.present ? jlptLevel.value : this.jlptLevel,
    sortOrder: sortOrder ?? this.sortOrder,
    description: description.present ? description.value : this.description,
  );
  Unit copyWithCompanion(UnitsCompanion data) {
    return Unit(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      kind: data.kind.present ? data.kind.value : this.kind,
      jlptLevel: data.jlptLevel.present ? data.jlptLevel.value : this.jlptLevel,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Unit(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('kind: $kind, ')
          ..write('jlptLevel: $jlptLevel, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, subtitle, kind, jlptLevel, sortOrder, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unit &&
          other.id == this.id &&
          other.title == this.title &&
          other.subtitle == this.subtitle &&
          other.kind == this.kind &&
          other.jlptLevel == this.jlptLevel &&
          other.sortOrder == this.sortOrder &&
          other.description == this.description);
}

class UnitsCompanion extends UpdateCompanion<Unit> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> subtitle;
  final Value<String> kind;
  final Value<String?> jlptLevel;
  final Value<int> sortOrder;
  final Value<String?> description;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.kind = const Value.absent(),
    this.jlptLevel = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.description = const Value.absent(),
  });
  UnitsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.subtitle = const Value.absent(),
    required String kind,
    this.jlptLevel = const Value.absent(),
    required int sortOrder,
    this.description = const Value.absent(),
  }) : title = Value(title),
       kind = Value(kind),
       sortOrder = Value(sortOrder);
  static Insertable<Unit> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? subtitle,
    Expression<String>? kind,
    Expression<String>? jlptLevel,
    Expression<int>? sortOrder,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (kind != null) 'kind': kind,
      if (jlptLevel != null) 'jlpt_level': jlptLevel,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (description != null) 'description': description,
    });
  }

  UnitsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? subtitle,
    Value<String>? kind,
    Value<String?>? jlptLevel,
    Value<int>? sortOrder,
    Value<String?>? description,
  }) {
    return UnitsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      kind: kind ?? this.kind,
      jlptLevel: jlptLevel ?? this.jlptLevel,
      sortOrder: sortOrder ?? this.sortOrder,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (jlptLevel.present) {
      map['jlpt_level'] = Variable<String>(jlptLevel.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('kind: $kind, ')
          ..write('jlptLevel: $jlptLevel, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class UnitPrerequisites extends Table
    with TableInfo<UnitPrerequisites, UnitPrerequisite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  UnitPrerequisites(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
    'unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES units(id)',
  );
  static const VerificationMeta _requiresUnitIdMeta = const VerificationMeta(
    'requiresUnitId',
  );
  late final GeneratedColumn<int> requiresUnitId = GeneratedColumn<int>(
    'requires_unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES units(id)',
  );
  @override
  List<GeneratedColumn> get $columns => [unitId, requiresUnitId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unit_prerequisites';
  @override
  VerificationContext validateIntegrity(
    Insertable<UnitPrerequisite> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('requires_unit_id')) {
      context.handle(
        _requiresUnitIdMeta,
        requiresUnitId.isAcceptableOrUnknown(
          data['requires_unit_id']!,
          _requiresUnitIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requiresUnitIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {unitId, requiresUnitId};
  @override
  UnitPrerequisite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnitPrerequisite(
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_id'],
      )!,
      requiresUnitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}requires_unit_id'],
      )!,
    );
  }

  @override
  UnitPrerequisites createAlias(String alias) {
    return UnitPrerequisites(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(unit_id, requires_unit_id)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class UnitPrerequisite extends DataClass
    implements Insertable<UnitPrerequisite> {
  final int unitId;
  final int requiresUnitId;
  const UnitPrerequisite({required this.unitId, required this.requiresUnitId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['unit_id'] = Variable<int>(unitId);
    map['requires_unit_id'] = Variable<int>(requiresUnitId);
    return map;
  }

  UnitPrerequisitesCompanion toCompanion(bool nullToAbsent) {
    return UnitPrerequisitesCompanion(
      unitId: Value(unitId),
      requiresUnitId: Value(requiresUnitId),
    );
  }

  factory UnitPrerequisite.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnitPrerequisite(
      unitId: serializer.fromJson<int>(json['unit_id']),
      requiresUnitId: serializer.fromJson<int>(json['requires_unit_id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'unit_id': serializer.toJson<int>(unitId),
      'requires_unit_id': serializer.toJson<int>(requiresUnitId),
    };
  }

  UnitPrerequisite copyWith({int? unitId, int? requiresUnitId}) =>
      UnitPrerequisite(
        unitId: unitId ?? this.unitId,
        requiresUnitId: requiresUnitId ?? this.requiresUnitId,
      );
  UnitPrerequisite copyWithCompanion(UnitPrerequisitesCompanion data) {
    return UnitPrerequisite(
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      requiresUnitId: data.requiresUnitId.present
          ? data.requiresUnitId.value
          : this.requiresUnitId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnitPrerequisite(')
          ..write('unitId: $unitId, ')
          ..write('requiresUnitId: $requiresUnitId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(unitId, requiresUnitId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnitPrerequisite &&
          other.unitId == this.unitId &&
          other.requiresUnitId == this.requiresUnitId);
}

class UnitPrerequisitesCompanion extends UpdateCompanion<UnitPrerequisite> {
  final Value<int> unitId;
  final Value<int> requiresUnitId;
  final Value<int> rowid;
  const UnitPrerequisitesCompanion({
    this.unitId = const Value.absent(),
    this.requiresUnitId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnitPrerequisitesCompanion.insert({
    required int unitId,
    required int requiresUnitId,
    this.rowid = const Value.absent(),
  }) : unitId = Value(unitId),
       requiresUnitId = Value(requiresUnitId);
  static Insertable<UnitPrerequisite> custom({
    Expression<int>? unitId,
    Expression<int>? requiresUnitId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (unitId != null) 'unit_id': unitId,
      if (requiresUnitId != null) 'requires_unit_id': requiresUnitId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnitPrerequisitesCompanion copyWith({
    Value<int>? unitId,
    Value<int>? requiresUnitId,
    Value<int>? rowid,
  }) {
    return UnitPrerequisitesCompanion(
      unitId: unitId ?? this.unitId,
      requiresUnitId: requiresUnitId ?? this.requiresUnitId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    if (requiresUnitId.present) {
      map['requires_unit_id'] = Variable<int>(requiresUnitId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitPrerequisitesCompanion(')
          ..write('unitId: $unitId, ')
          ..write('requiresUnitId: $requiresUnitId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class UnitItems extends Table with TableInfo<UnitItems, UnitItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  UnitItems(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
    'unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES units(id)',
  );
  static const VerificationMeta _contentItemIdMeta = const VerificationMeta(
    'contentItemId',
  );
  late final GeneratedColumn<int> contentItemId = GeneratedColumn<int>(
    'content_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES content_items(id)',
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL DEFAULT \'new\' CHECK (role IN (\'new\', \'reinforcement\'))',
    defaultValue: const CustomExpression('\'new\''),
  );
  @override
  List<GeneratedColumn> get $columns => [unitId, contentItemId, role];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unit_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<UnitItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('content_item_id')) {
      context.handle(
        _contentItemIdMeta,
        contentItemId.isAcceptableOrUnknown(
          data['content_item_id']!,
          _contentItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentItemIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {unitId, contentItemId};
  @override
  UnitItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnitItem(
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_id'],
      )!,
      contentItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_item_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
    );
  }

  @override
  UnitItems createAlias(String alias) {
    return UnitItems(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(unit_id, content_item_id)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class UnitItem extends DataClass implements Insertable<UnitItem> {
  final int unitId;
  final int contentItemId;
  final String role;
  const UnitItem({
    required this.unitId,
    required this.contentItemId,
    required this.role,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['unit_id'] = Variable<int>(unitId);
    map['content_item_id'] = Variable<int>(contentItemId);
    map['role'] = Variable<String>(role);
    return map;
  }

  UnitItemsCompanion toCompanion(bool nullToAbsent) {
    return UnitItemsCompanion(
      unitId: Value(unitId),
      contentItemId: Value(contentItemId),
      role: Value(role),
    );
  }

  factory UnitItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnitItem(
      unitId: serializer.fromJson<int>(json['unit_id']),
      contentItemId: serializer.fromJson<int>(json['content_item_id']),
      role: serializer.fromJson<String>(json['role']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'unit_id': serializer.toJson<int>(unitId),
      'content_item_id': serializer.toJson<int>(contentItemId),
      'role': serializer.toJson<String>(role),
    };
  }

  UnitItem copyWith({int? unitId, int? contentItemId, String? role}) =>
      UnitItem(
        unitId: unitId ?? this.unitId,
        contentItemId: contentItemId ?? this.contentItemId,
        role: role ?? this.role,
      );
  UnitItem copyWithCompanion(UnitItemsCompanion data) {
    return UnitItem(
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      contentItemId: data.contentItemId.present
          ? data.contentItemId.value
          : this.contentItemId,
      role: data.role.present ? data.role.value : this.role,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnitItem(')
          ..write('unitId: $unitId, ')
          ..write('contentItemId: $contentItemId, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(unitId, contentItemId, role);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnitItem &&
          other.unitId == this.unitId &&
          other.contentItemId == this.contentItemId &&
          other.role == this.role);
}

class UnitItemsCompanion extends UpdateCompanion<UnitItem> {
  final Value<int> unitId;
  final Value<int> contentItemId;
  final Value<String> role;
  final Value<int> rowid;
  const UnitItemsCompanion({
    this.unitId = const Value.absent(),
    this.contentItemId = const Value.absent(),
    this.role = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnitItemsCompanion.insert({
    required int unitId,
    required int contentItemId,
    this.role = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : unitId = Value(unitId),
       contentItemId = Value(contentItemId);
  static Insertable<UnitItem> custom({
    Expression<int>? unitId,
    Expression<int>? contentItemId,
    Expression<String>? role,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (unitId != null) 'unit_id': unitId,
      if (contentItemId != null) 'content_item_id': contentItemId,
      if (role != null) 'role': role,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnitItemsCompanion copyWith({
    Value<int>? unitId,
    Value<int>? contentItemId,
    Value<String>? role,
    Value<int>? rowid,
  }) {
    return UnitItemsCompanion(
      unitId: unitId ?? this.unitId,
      contentItemId: contentItemId ?? this.contentItemId,
      role: role ?? this.role,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    if (contentItemId.present) {
      map['content_item_id'] = Variable<int>(contentItemId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitItemsCompanion(')
          ..write('unitId: $unitId, ')
          ..write('contentItemId: $contentItemId, ')
          ..write('role: $role, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Users extends Table with TableInfo<Users, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Users(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (datetime(\'now\'))',
    defaultValue: const CustomExpression('datetime(\'now\')'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, displayName, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  Users createAlias(String alias) {
    return Users(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String? displayName;
  final String createdAt;
  const User({required this.id, this.displayName, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String?>(json['display_name']),
      createdAt: serializer.fromJson<String>(json['created_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'display_name': serializer.toJson<String?>(displayName),
      'created_at': serializer.toJson<String>(createdAt),
    };
  }

  User copyWith({
    String? id,
    Value<String?> displayName = const Value.absent(),
    String? createdAt,
  }) => User(
    id: id ?? this.id,
    displayName: displayName.present ? displayName.value : this.displayName,
    createdAt: createdAt ?? this.createdAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, displayName, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String?> displayName;
  final Value<String> createdAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    this.displayName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String?>? displayName,
    Value<String>? createdAt,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class UserProfile extends Table with TableInfo<UserProfile, UserProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  UserProfile(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY REFERENCES users(id)',
  );
  static const VerificationMeta _weightListeningMeta = const VerificationMeta(
    'weightListening',
  );
  late final GeneratedColumn<int> weightListening = GeneratedColumn<int>(
    'weight_listening',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 25',
    defaultValue: const CustomExpression('25'),
  );
  static const VerificationMeta _weightSpeakingMeta = const VerificationMeta(
    'weightSpeaking',
  );
  late final GeneratedColumn<int> weightSpeaking = GeneratedColumn<int>(
    'weight_speaking',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 25',
    defaultValue: const CustomExpression('25'),
  );
  static const VerificationMeta _weightReadingMeta = const VerificationMeta(
    'weightReading',
  );
  late final GeneratedColumn<int> weightReading = GeneratedColumn<int>(
    'weight_reading',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 25',
    defaultValue: const CustomExpression('25'),
  );
  static const VerificationMeta _weightWritingMeta = const VerificationMeta(
    'weightWriting',
  );
  late final GeneratedColumn<int> weightWriting = GeneratedColumn<int>(
    'weight_writing',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 25',
    defaultValue: const CustomExpression('25'),
  );
  static const VerificationMeta _dailyMinutesGoalMeta = const VerificationMeta(
    'dailyMinutesGoal',
  );
  late final GeneratedColumn<int> dailyMinutesGoal = GeneratedColumn<int>(
    'daily_minutes_goal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 15',
    defaultValue: const CustomExpression('15'),
  );
  static const VerificationMeta _comprehensionGoalPctMeta =
      const VerificationMeta('comprehensionGoalPct');
  late final GeneratedColumn<int> comprehensionGoalPct = GeneratedColumn<int>(
    'comprehension_goal_pct',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _targetJlptLevelMeta = const VerificationMeta(
    'targetJlptLevel',
  );
  late final GeneratedColumn<String> targetJlptLevel = GeneratedColumn<String>(
    'target_jlpt_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK (target_jlpt_level IN (\'N5\', \'N4\', \'N3\', \'N2\', \'N1\'))',
  );
  static const VerificationMeta _placementLevelMeta = const VerificationMeta(
    'placementLevel',
  );
  late final GeneratedColumn<String> placementLevel = GeneratedColumn<String>(
    'placement_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK (placement_level IN (\'N5\', \'N4\', \'N3\', \'N2\', \'N1\'))',
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (datetime(\'now\'))',
    defaultValue: const CustomExpression('datetime(\'now\')'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    weightListening,
    weightSpeaking,
    weightReading,
    weightWriting,
    dailyMinutesGoal,
    comprehensionGoalPct,
    targetJlptLevel,
    placementLevel,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfileData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('weight_listening')) {
      context.handle(
        _weightListeningMeta,
        weightListening.isAcceptableOrUnknown(
          data['weight_listening']!,
          _weightListeningMeta,
        ),
      );
    }
    if (data.containsKey('weight_speaking')) {
      context.handle(
        _weightSpeakingMeta,
        weightSpeaking.isAcceptableOrUnknown(
          data['weight_speaking']!,
          _weightSpeakingMeta,
        ),
      );
    }
    if (data.containsKey('weight_reading')) {
      context.handle(
        _weightReadingMeta,
        weightReading.isAcceptableOrUnknown(
          data['weight_reading']!,
          _weightReadingMeta,
        ),
      );
    }
    if (data.containsKey('weight_writing')) {
      context.handle(
        _weightWritingMeta,
        weightWriting.isAcceptableOrUnknown(
          data['weight_writing']!,
          _weightWritingMeta,
        ),
      );
    }
    if (data.containsKey('daily_minutes_goal')) {
      context.handle(
        _dailyMinutesGoalMeta,
        dailyMinutesGoal.isAcceptableOrUnknown(
          data['daily_minutes_goal']!,
          _dailyMinutesGoalMeta,
        ),
      );
    }
    if (data.containsKey('comprehension_goal_pct')) {
      context.handle(
        _comprehensionGoalPctMeta,
        comprehensionGoalPct.isAcceptableOrUnknown(
          data['comprehension_goal_pct']!,
          _comprehensionGoalPctMeta,
        ),
      );
    }
    if (data.containsKey('target_jlpt_level')) {
      context.handle(
        _targetJlptLevelMeta,
        targetJlptLevel.isAcceptableOrUnknown(
          data['target_jlpt_level']!,
          _targetJlptLevelMeta,
        ),
      );
    }
    if (data.containsKey('placement_level')) {
      context.handle(
        _placementLevelMeta,
        placementLevel.isAcceptableOrUnknown(
          data['placement_level']!,
          _placementLevelMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  UserProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      weightListening: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight_listening'],
      )!,
      weightSpeaking: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight_speaking'],
      )!,
      weightReading: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight_reading'],
      )!,
      weightWriting: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight_writing'],
      )!,
      dailyMinutesGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_minutes_goal'],
      )!,
      comprehensionGoalPct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}comprehension_goal_pct'],
      ),
      targetJlptLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_jlpt_level'],
      ),
      placementLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}placement_level'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  UserProfile createAlias(String alias) {
    return UserProfile(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class UserProfileData extends DataClass implements Insertable<UserProfileData> {
  final String userId;
  final int weightListening;
  final int weightSpeaking;
  final int weightReading;
  final int weightWriting;
  final int dailyMinutesGoal;
  final int? comprehensionGoalPct;
  final String? targetJlptLevel;
  final String? placementLevel;
  final String updatedAt;
  const UserProfileData({
    required this.userId,
    required this.weightListening,
    required this.weightSpeaking,
    required this.weightReading,
    required this.weightWriting,
    required this.dailyMinutesGoal,
    this.comprehensionGoalPct,
    this.targetJlptLevel,
    this.placementLevel,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['weight_listening'] = Variable<int>(weightListening);
    map['weight_speaking'] = Variable<int>(weightSpeaking);
    map['weight_reading'] = Variable<int>(weightReading);
    map['weight_writing'] = Variable<int>(weightWriting);
    map['daily_minutes_goal'] = Variable<int>(dailyMinutesGoal);
    if (!nullToAbsent || comprehensionGoalPct != null) {
      map['comprehension_goal_pct'] = Variable<int>(comprehensionGoalPct);
    }
    if (!nullToAbsent || targetJlptLevel != null) {
      map['target_jlpt_level'] = Variable<String>(targetJlptLevel);
    }
    if (!nullToAbsent || placementLevel != null) {
      map['placement_level'] = Variable<String>(placementLevel);
    }
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  UserProfileCompanion toCompanion(bool nullToAbsent) {
    return UserProfileCompanion(
      userId: Value(userId),
      weightListening: Value(weightListening),
      weightSpeaking: Value(weightSpeaking),
      weightReading: Value(weightReading),
      weightWriting: Value(weightWriting),
      dailyMinutesGoal: Value(dailyMinutesGoal),
      comprehensionGoalPct: comprehensionGoalPct == null && nullToAbsent
          ? const Value.absent()
          : Value(comprehensionGoalPct),
      targetJlptLevel: targetJlptLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(targetJlptLevel),
      placementLevel: placementLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(placementLevel),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserProfileData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileData(
      userId: serializer.fromJson<String>(json['user_id']),
      weightListening: serializer.fromJson<int>(json['weight_listening']),
      weightSpeaking: serializer.fromJson<int>(json['weight_speaking']),
      weightReading: serializer.fromJson<int>(json['weight_reading']),
      weightWriting: serializer.fromJson<int>(json['weight_writing']),
      dailyMinutesGoal: serializer.fromJson<int>(json['daily_minutes_goal']),
      comprehensionGoalPct: serializer.fromJson<int?>(
        json['comprehension_goal_pct'],
      ),
      targetJlptLevel: serializer.fromJson<String?>(json['target_jlpt_level']),
      placementLevel: serializer.fromJson<String?>(json['placement_level']),
      updatedAt: serializer.fromJson<String>(json['updated_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'user_id': serializer.toJson<String>(userId),
      'weight_listening': serializer.toJson<int>(weightListening),
      'weight_speaking': serializer.toJson<int>(weightSpeaking),
      'weight_reading': serializer.toJson<int>(weightReading),
      'weight_writing': serializer.toJson<int>(weightWriting),
      'daily_minutes_goal': serializer.toJson<int>(dailyMinutesGoal),
      'comprehension_goal_pct': serializer.toJson<int?>(comprehensionGoalPct),
      'target_jlpt_level': serializer.toJson<String?>(targetJlptLevel),
      'placement_level': serializer.toJson<String?>(placementLevel),
      'updated_at': serializer.toJson<String>(updatedAt),
    };
  }

  UserProfileData copyWith({
    String? userId,
    int? weightListening,
    int? weightSpeaking,
    int? weightReading,
    int? weightWriting,
    int? dailyMinutesGoal,
    Value<int?> comprehensionGoalPct = const Value.absent(),
    Value<String?> targetJlptLevel = const Value.absent(),
    Value<String?> placementLevel = const Value.absent(),
    String? updatedAt,
  }) => UserProfileData(
    userId: userId ?? this.userId,
    weightListening: weightListening ?? this.weightListening,
    weightSpeaking: weightSpeaking ?? this.weightSpeaking,
    weightReading: weightReading ?? this.weightReading,
    weightWriting: weightWriting ?? this.weightWriting,
    dailyMinutesGoal: dailyMinutesGoal ?? this.dailyMinutesGoal,
    comprehensionGoalPct: comprehensionGoalPct.present
        ? comprehensionGoalPct.value
        : this.comprehensionGoalPct,
    targetJlptLevel: targetJlptLevel.present
        ? targetJlptLevel.value
        : this.targetJlptLevel,
    placementLevel: placementLevel.present
        ? placementLevel.value
        : this.placementLevel,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserProfileData copyWithCompanion(UserProfileCompanion data) {
    return UserProfileData(
      userId: data.userId.present ? data.userId.value : this.userId,
      weightListening: data.weightListening.present
          ? data.weightListening.value
          : this.weightListening,
      weightSpeaking: data.weightSpeaking.present
          ? data.weightSpeaking.value
          : this.weightSpeaking,
      weightReading: data.weightReading.present
          ? data.weightReading.value
          : this.weightReading,
      weightWriting: data.weightWriting.present
          ? data.weightWriting.value
          : this.weightWriting,
      dailyMinutesGoal: data.dailyMinutesGoal.present
          ? data.dailyMinutesGoal.value
          : this.dailyMinutesGoal,
      comprehensionGoalPct: data.comprehensionGoalPct.present
          ? data.comprehensionGoalPct.value
          : this.comprehensionGoalPct,
      targetJlptLevel: data.targetJlptLevel.present
          ? data.targetJlptLevel.value
          : this.targetJlptLevel,
      placementLevel: data.placementLevel.present
          ? data.placementLevel.value
          : this.placementLevel,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileData(')
          ..write('userId: $userId, ')
          ..write('weightListening: $weightListening, ')
          ..write('weightSpeaking: $weightSpeaking, ')
          ..write('weightReading: $weightReading, ')
          ..write('weightWriting: $weightWriting, ')
          ..write('dailyMinutesGoal: $dailyMinutesGoal, ')
          ..write('comprehensionGoalPct: $comprehensionGoalPct, ')
          ..write('targetJlptLevel: $targetJlptLevel, ')
          ..write('placementLevel: $placementLevel, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    weightListening,
    weightSpeaking,
    weightReading,
    weightWriting,
    dailyMinutesGoal,
    comprehensionGoalPct,
    targetJlptLevel,
    placementLevel,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileData &&
          other.userId == this.userId &&
          other.weightListening == this.weightListening &&
          other.weightSpeaking == this.weightSpeaking &&
          other.weightReading == this.weightReading &&
          other.weightWriting == this.weightWriting &&
          other.dailyMinutesGoal == this.dailyMinutesGoal &&
          other.comprehensionGoalPct == this.comprehensionGoalPct &&
          other.targetJlptLevel == this.targetJlptLevel &&
          other.placementLevel == this.placementLevel &&
          other.updatedAt == this.updatedAt);
}

class UserProfileCompanion extends UpdateCompanion<UserProfileData> {
  final Value<String> userId;
  final Value<int> weightListening;
  final Value<int> weightSpeaking;
  final Value<int> weightReading;
  final Value<int> weightWriting;
  final Value<int> dailyMinutesGoal;
  final Value<int?> comprehensionGoalPct;
  final Value<String?> targetJlptLevel;
  final Value<String?> placementLevel;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const UserProfileCompanion({
    this.userId = const Value.absent(),
    this.weightListening = const Value.absent(),
    this.weightSpeaking = const Value.absent(),
    this.weightReading = const Value.absent(),
    this.weightWriting = const Value.absent(),
    this.dailyMinutesGoal = const Value.absent(),
    this.comprehensionGoalPct = const Value.absent(),
    this.targetJlptLevel = const Value.absent(),
    this.placementLevel = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfileCompanion.insert({
    required String userId,
    this.weightListening = const Value.absent(),
    this.weightSpeaking = const Value.absent(),
    this.weightReading = const Value.absent(),
    this.weightWriting = const Value.absent(),
    this.dailyMinutesGoal = const Value.absent(),
    this.comprehensionGoalPct = const Value.absent(),
    this.targetJlptLevel = const Value.absent(),
    this.placementLevel = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<UserProfileData> custom({
    Expression<String>? userId,
    Expression<int>? weightListening,
    Expression<int>? weightSpeaking,
    Expression<int>? weightReading,
    Expression<int>? weightWriting,
    Expression<int>? dailyMinutesGoal,
    Expression<int>? comprehensionGoalPct,
    Expression<String>? targetJlptLevel,
    Expression<String>? placementLevel,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (weightListening != null) 'weight_listening': weightListening,
      if (weightSpeaking != null) 'weight_speaking': weightSpeaking,
      if (weightReading != null) 'weight_reading': weightReading,
      if (weightWriting != null) 'weight_writing': weightWriting,
      if (dailyMinutesGoal != null) 'daily_minutes_goal': dailyMinutesGoal,
      if (comprehensionGoalPct != null)
        'comprehension_goal_pct': comprehensionGoalPct,
      if (targetJlptLevel != null) 'target_jlpt_level': targetJlptLevel,
      if (placementLevel != null) 'placement_level': placementLevel,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfileCompanion copyWith({
    Value<String>? userId,
    Value<int>? weightListening,
    Value<int>? weightSpeaking,
    Value<int>? weightReading,
    Value<int>? weightWriting,
    Value<int>? dailyMinutesGoal,
    Value<int?>? comprehensionGoalPct,
    Value<String?>? targetJlptLevel,
    Value<String?>? placementLevel,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserProfileCompanion(
      userId: userId ?? this.userId,
      weightListening: weightListening ?? this.weightListening,
      weightSpeaking: weightSpeaking ?? this.weightSpeaking,
      weightReading: weightReading ?? this.weightReading,
      weightWriting: weightWriting ?? this.weightWriting,
      dailyMinutesGoal: dailyMinutesGoal ?? this.dailyMinutesGoal,
      comprehensionGoalPct: comprehensionGoalPct ?? this.comprehensionGoalPct,
      targetJlptLevel: targetJlptLevel ?? this.targetJlptLevel,
      placementLevel: placementLevel ?? this.placementLevel,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (weightListening.present) {
      map['weight_listening'] = Variable<int>(weightListening.value);
    }
    if (weightSpeaking.present) {
      map['weight_speaking'] = Variable<int>(weightSpeaking.value);
    }
    if (weightReading.present) {
      map['weight_reading'] = Variable<int>(weightReading.value);
    }
    if (weightWriting.present) {
      map['weight_writing'] = Variable<int>(weightWriting.value);
    }
    if (dailyMinutesGoal.present) {
      map['daily_minutes_goal'] = Variable<int>(dailyMinutesGoal.value);
    }
    if (comprehensionGoalPct.present) {
      map['comprehension_goal_pct'] = Variable<int>(comprehensionGoalPct.value);
    }
    if (targetJlptLevel.present) {
      map['target_jlpt_level'] = Variable<String>(targetJlptLevel.value);
    }
    if (placementLevel.present) {
      map['placement_level'] = Variable<String>(placementLevel.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileCompanion(')
          ..write('userId: $userId, ')
          ..write('weightListening: $weightListening, ')
          ..write('weightSpeaking: $weightSpeaking, ')
          ..write('weightReading: $weightReading, ')
          ..write('weightWriting: $weightWriting, ')
          ..write('dailyMinutesGoal: $dailyMinutesGoal, ')
          ..write('comprehensionGoalPct: $comprehensionGoalPct, ')
          ..write('targetJlptLevel: $targetJlptLevel, ')
          ..write('placementLevel: $placementLevel, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class SrsCards extends Table with TableInfo<SrsCards, SrsCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SrsCards(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES users(id)',
  );
  static const VerificationMeta _contentItemIdMeta = const VerificationMeta(
    'contentItemId',
  );
  late final GeneratedColumn<int> contentItemId = GeneratedColumn<int>(
    'content_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES content_items(id)',
  );
  static const VerificationMeta _exerciseTypeMeta = const VerificationMeta(
    'exerciseType',
  );
  late final GeneratedColumn<String> exerciseType = GeneratedColumn<String>(
    'exercise_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES exercise_types(code)',
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'new\' CHECK (state IN (\'new\', \'learning\', \'review\', \'relearning\', \'suspended\'))',
    defaultValue: const CustomExpression('\'new\''),
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  late final GeneratedColumn<String> dueAt = GeneratedColumn<String>(
    'due_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _stabilityMeta = const VerificationMeta(
    'stability',
  );
  late final GeneratedColumn<double> stability = GeneratedColumn<double>(
    'stability',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  late final GeneratedColumn<double> difficulty = GeneratedColumn<double>(
    'difficulty',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
    'lapses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _lastReviewedAtMeta = const VerificationMeta(
    'lastReviewedAt',
  );
  late final GeneratedColumn<String> lastReviewedAt = GeneratedColumn<String>(
    'last_reviewed_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    contentItemId,
    exerciseType,
    state,
    dueAt,
    stability,
    difficulty,
    reps,
    lapses,
    lastReviewedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srs_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrsCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('content_item_id')) {
      context.handle(
        _contentItemIdMeta,
        contentItemId.isAcceptableOrUnknown(
          data['content_item_id']!,
          _contentItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentItemIdMeta);
    }
    if (data.containsKey('exercise_type')) {
      context.handle(
        _exerciseTypeMeta,
        exerciseType.isAcceptableOrUnknown(
          data['exercise_type']!,
          _exerciseTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseTypeMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    }
    if (data.containsKey('stability')) {
      context.handle(
        _stabilityMeta,
        stability.isAcceptableOrUnknown(data['stability']!, _stabilityMeta),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('lapses')) {
      context.handle(
        _lapsesMeta,
        lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta),
      );
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
        _lastReviewedAtMeta,
        lastReviewedAt.isAcceptableOrUnknown(
          data['last_reviewed_at']!,
          _lastReviewedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {userId, contentItemId, exerciseType},
  ];
  @override
  SrsCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrsCard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      contentItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_item_id'],
      )!,
      exerciseType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_type'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_at'],
      ),
      stability: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stability'],
      ),
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}difficulty'],
      ),
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      lapses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lapses'],
      )!,
      lastReviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_reviewed_at'],
      ),
    );
  }

  @override
  SrsCards createAlias(String alias) {
    return SrsCards(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'UNIQUE(user_id, content_item_id, exercise_type)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class SrsCard extends DataClass implements Insertable<SrsCard> {
  final String id;
  final String userId;
  final int contentItemId;
  final String exerciseType;
  final String state;
  final String? dueAt;
  final double? stability;
  final double? difficulty;
  final int reps;
  final int lapses;
  final String? lastReviewedAt;
  const SrsCard({
    required this.id,
    required this.userId,
    required this.contentItemId,
    required this.exerciseType,
    required this.state,
    this.dueAt,
    this.stability,
    this.difficulty,
    required this.reps,
    required this.lapses,
    this.lastReviewedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['content_item_id'] = Variable<int>(contentItemId);
    map['exercise_type'] = Variable<String>(exerciseType);
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<String>(dueAt);
    }
    if (!nullToAbsent || stability != null) {
      map['stability'] = Variable<double>(stability);
    }
    if (!nullToAbsent || difficulty != null) {
      map['difficulty'] = Variable<double>(difficulty);
    }
    map['reps'] = Variable<int>(reps);
    map['lapses'] = Variable<int>(lapses);
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<String>(lastReviewedAt);
    }
    return map;
  }

  SrsCardsCompanion toCompanion(bool nullToAbsent) {
    return SrsCardsCompanion(
      id: Value(id),
      userId: Value(userId),
      contentItemId: Value(contentItemId),
      exerciseType: Value(exerciseType),
      state: Value(state),
      dueAt: dueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAt),
      stability: stability == null && nullToAbsent
          ? const Value.absent()
          : Value(stability),
      difficulty: difficulty == null && nullToAbsent
          ? const Value.absent()
          : Value(difficulty),
      reps: Value(reps),
      lapses: Value(lapses),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
    );
  }

  factory SrsCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrsCard(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['user_id']),
      contentItemId: serializer.fromJson<int>(json['content_item_id']),
      exerciseType: serializer.fromJson<String>(json['exercise_type']),
      state: serializer.fromJson<String>(json['state']),
      dueAt: serializer.fromJson<String?>(json['due_at']),
      stability: serializer.fromJson<double?>(json['stability']),
      difficulty: serializer.fromJson<double?>(json['difficulty']),
      reps: serializer.fromJson<int>(json['reps']),
      lapses: serializer.fromJson<int>(json['lapses']),
      lastReviewedAt: serializer.fromJson<String?>(json['last_reviewed_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'user_id': serializer.toJson<String>(userId),
      'content_item_id': serializer.toJson<int>(contentItemId),
      'exercise_type': serializer.toJson<String>(exerciseType),
      'state': serializer.toJson<String>(state),
      'due_at': serializer.toJson<String?>(dueAt),
      'stability': serializer.toJson<double?>(stability),
      'difficulty': serializer.toJson<double?>(difficulty),
      'reps': serializer.toJson<int>(reps),
      'lapses': serializer.toJson<int>(lapses),
      'last_reviewed_at': serializer.toJson<String?>(lastReviewedAt),
    };
  }

  SrsCard copyWith({
    String? id,
    String? userId,
    int? contentItemId,
    String? exerciseType,
    String? state,
    Value<String?> dueAt = const Value.absent(),
    Value<double?> stability = const Value.absent(),
    Value<double?> difficulty = const Value.absent(),
    int? reps,
    int? lapses,
    Value<String?> lastReviewedAt = const Value.absent(),
  }) => SrsCard(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    contentItemId: contentItemId ?? this.contentItemId,
    exerciseType: exerciseType ?? this.exerciseType,
    state: state ?? this.state,
    dueAt: dueAt.present ? dueAt.value : this.dueAt,
    stability: stability.present ? stability.value : this.stability,
    difficulty: difficulty.present ? difficulty.value : this.difficulty,
    reps: reps ?? this.reps,
    lapses: lapses ?? this.lapses,
    lastReviewedAt: lastReviewedAt.present
        ? lastReviewedAt.value
        : this.lastReviewedAt,
  );
  SrsCard copyWithCompanion(SrsCardsCompanion data) {
    return SrsCard(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      contentItemId: data.contentItemId.present
          ? data.contentItemId.value
          : this.contentItemId,
      exerciseType: data.exerciseType.present
          ? data.exerciseType.value
          : this.exerciseType,
      state: data.state.present ? data.state.value : this.state,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      stability: data.stability.present ? data.stability.value : this.stability,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      reps: data.reps.present ? data.reps.value : this.reps,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrsCard(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('contentItemId: $contentItemId, ')
          ..write('exerciseType: $exerciseType, ')
          ..write('state: $state, ')
          ..write('dueAt: $dueAt, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('lastReviewedAt: $lastReviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    contentItemId,
    exerciseType,
    state,
    dueAt,
    stability,
    difficulty,
    reps,
    lapses,
    lastReviewedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrsCard &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.contentItemId == this.contentItemId &&
          other.exerciseType == this.exerciseType &&
          other.state == this.state &&
          other.dueAt == this.dueAt &&
          other.stability == this.stability &&
          other.difficulty == this.difficulty &&
          other.reps == this.reps &&
          other.lapses == this.lapses &&
          other.lastReviewedAt == this.lastReviewedAt);
}

class SrsCardsCompanion extends UpdateCompanion<SrsCard> {
  final Value<String> id;
  final Value<String> userId;
  final Value<int> contentItemId;
  final Value<String> exerciseType;
  final Value<String> state;
  final Value<String?> dueAt;
  final Value<double?> stability;
  final Value<double?> difficulty;
  final Value<int> reps;
  final Value<int> lapses;
  final Value<String?> lastReviewedAt;
  final Value<int> rowid;
  const SrsCardsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.contentItemId = const Value.absent(),
    this.exerciseType = const Value.absent(),
    this.state = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.reps = const Value.absent(),
    this.lapses = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SrsCardsCompanion.insert({
    required String id,
    required String userId,
    required int contentItemId,
    required String exerciseType,
    this.state = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.reps = const Value.absent(),
    this.lapses = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       contentItemId = Value(contentItemId),
       exerciseType = Value(exerciseType);
  static Insertable<SrsCard> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<int>? contentItemId,
    Expression<String>? exerciseType,
    Expression<String>? state,
    Expression<String>? dueAt,
    Expression<double>? stability,
    Expression<double>? difficulty,
    Expression<int>? reps,
    Expression<int>? lapses,
    Expression<String>? lastReviewedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (contentItemId != null) 'content_item_id': contentItemId,
      if (exerciseType != null) 'exercise_type': exerciseType,
      if (state != null) 'state': state,
      if (dueAt != null) 'due_at': dueAt,
      if (stability != null) 'stability': stability,
      if (difficulty != null) 'difficulty': difficulty,
      if (reps != null) 'reps': reps,
      if (lapses != null) 'lapses': lapses,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SrsCardsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<int>? contentItemId,
    Value<String>? exerciseType,
    Value<String>? state,
    Value<String?>? dueAt,
    Value<double?>? stability,
    Value<double?>? difficulty,
    Value<int>? reps,
    Value<int>? lapses,
    Value<String?>? lastReviewedAt,
    Value<int>? rowid,
  }) {
    return SrsCardsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      contentItemId: contentItemId ?? this.contentItemId,
      exerciseType: exerciseType ?? this.exerciseType,
      state: state ?? this.state,
      dueAt: dueAt ?? this.dueAt,
      stability: stability ?? this.stability,
      difficulty: difficulty ?? this.difficulty,
      reps: reps ?? this.reps,
      lapses: lapses ?? this.lapses,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (contentItemId.present) {
      map['content_item_id'] = Variable<int>(contentItemId.value);
    }
    if (exerciseType.present) {
      map['exercise_type'] = Variable<String>(exerciseType.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<String>(dueAt.value);
    }
    if (stability.present) {
      map['stability'] = Variable<double>(stability.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<double>(difficulty.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<String>(lastReviewedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrsCardsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('contentItemId: $contentItemId, ')
          ..write('exerciseType: $exerciseType, ')
          ..write('state: $state, ')
          ..write('dueAt: $dueAt, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class ReviewLog extends Table with TableInfo<ReviewLog, ReviewLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ReviewLog(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES users(id)',
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES srs_cards(id)',
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  late final GeneratedColumn<String> rating = GeneratedColumn<String>(
    'rating',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (rating IN (\'again\', \'hard\', \'good\', \'easy\'))',
  );
  static const VerificationMeta _reviewedAtMeta = const VerificationMeta(
    'reviewedAt',
  );
  late final GeneratedColumn<String> reviewedAt = GeneratedColumn<String>(
    'reviewed_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _responseTimeMsMeta = const VerificationMeta(
    'responseTimeMs',
  );
  late final GeneratedColumn<int> responseTimeMs = GeneratedColumn<int>(
    'response_time_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _deviceMeta = const VerificationMeta('device');
  late final GeneratedColumn<String> device = GeneratedColumn<String>(
    'device',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    cardId,
    rating,
    reviewedAt,
    responseTimeMs,
    device,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
        _reviewedAtMeta,
        reviewedAt.isAcceptableOrUnknown(data['reviewed_at']!, _reviewedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_reviewedAtMeta);
    }
    if (data.containsKey('response_time_ms')) {
      context.handle(
        _responseTimeMsMeta,
        responseTimeMs.isAcceptableOrUnknown(
          data['response_time_ms']!,
          _responseTimeMsMeta,
        ),
      );
    }
    if (data.containsKey('device')) {
      context.handle(
        _deviceMeta,
        device.isAcceptableOrUnknown(data['device']!, _deviceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rating'],
      )!,
      reviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reviewed_at'],
      )!,
      responseTimeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}response_time_ms'],
      ),
      device: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device'],
      ),
    );
  }

  @override
  ReviewLog createAlias(String alias) {
    return ReviewLog(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class ReviewLogData extends DataClass implements Insertable<ReviewLogData> {
  final String id;
  final String userId;
  final String cardId;
  final String rating;
  final String reviewedAt;
  final int? responseTimeMs;
  final String? device;
  const ReviewLogData({
    required this.id,
    required this.userId,
    required this.cardId,
    required this.rating,
    required this.reviewedAt,
    this.responseTimeMs,
    this.device,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['card_id'] = Variable<String>(cardId);
    map['rating'] = Variable<String>(rating);
    map['reviewed_at'] = Variable<String>(reviewedAt);
    if (!nullToAbsent || responseTimeMs != null) {
      map['response_time_ms'] = Variable<int>(responseTimeMs);
    }
    if (!nullToAbsent || device != null) {
      map['device'] = Variable<String>(device);
    }
    return map;
  }

  ReviewLogCompanion toCompanion(bool nullToAbsent) {
    return ReviewLogCompanion(
      id: Value(id),
      userId: Value(userId),
      cardId: Value(cardId),
      rating: Value(rating),
      reviewedAt: Value(reviewedAt),
      responseTimeMs: responseTimeMs == null && nullToAbsent
          ? const Value.absent()
          : Value(responseTimeMs),
      device: device == null && nullToAbsent
          ? const Value.absent()
          : Value(device),
    );
  }

  factory ReviewLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewLogData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['user_id']),
      cardId: serializer.fromJson<String>(json['card_id']),
      rating: serializer.fromJson<String>(json['rating']),
      reviewedAt: serializer.fromJson<String>(json['reviewed_at']),
      responseTimeMs: serializer.fromJson<int?>(json['response_time_ms']),
      device: serializer.fromJson<String?>(json['device']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'user_id': serializer.toJson<String>(userId),
      'card_id': serializer.toJson<String>(cardId),
      'rating': serializer.toJson<String>(rating),
      'reviewed_at': serializer.toJson<String>(reviewedAt),
      'response_time_ms': serializer.toJson<int?>(responseTimeMs),
      'device': serializer.toJson<String?>(device),
    };
  }

  ReviewLogData copyWith({
    String? id,
    String? userId,
    String? cardId,
    String? rating,
    String? reviewedAt,
    Value<int?> responseTimeMs = const Value.absent(),
    Value<String?> device = const Value.absent(),
  }) => ReviewLogData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    cardId: cardId ?? this.cardId,
    rating: rating ?? this.rating,
    reviewedAt: reviewedAt ?? this.reviewedAt,
    responseTimeMs: responseTimeMs.present
        ? responseTimeMs.value
        : this.responseTimeMs,
    device: device.present ? device.value : this.device,
  );
  ReviewLogData copyWithCompanion(ReviewLogCompanion data) {
    return ReviewLogData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      rating: data.rating.present ? data.rating.value : this.rating,
      reviewedAt: data.reviewedAt.present
          ? data.reviewedAt.value
          : this.reviewedAt,
      responseTimeMs: data.responseTimeMs.present
          ? data.responseTimeMs.value
          : this.responseTimeMs,
      device: data.device.present ? data.device.value : this.device,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLogData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('cardId: $cardId, ')
          ..write('rating: $rating, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('responseTimeMs: $responseTimeMs, ')
          ..write('device: $device')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    cardId,
    rating,
    reviewedAt,
    responseTimeMs,
    device,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewLogData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.cardId == this.cardId &&
          other.rating == this.rating &&
          other.reviewedAt == this.reviewedAt &&
          other.responseTimeMs == this.responseTimeMs &&
          other.device == this.device);
}

class ReviewLogCompanion extends UpdateCompanion<ReviewLogData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> cardId;
  final Value<String> rating;
  final Value<String> reviewedAt;
  final Value<int?> responseTimeMs;
  final Value<String?> device;
  final Value<int> rowid;
  const ReviewLogCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.cardId = const Value.absent(),
    this.rating = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    this.responseTimeMs = const Value.absent(),
    this.device = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReviewLogCompanion.insert({
    required String id,
    required String userId,
    required String cardId,
    required String rating,
    required String reviewedAt,
    this.responseTimeMs = const Value.absent(),
    this.device = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       cardId = Value(cardId),
       rating = Value(rating),
       reviewedAt = Value(reviewedAt);
  static Insertable<ReviewLogData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? cardId,
    Expression<String>? rating,
    Expression<String>? reviewedAt,
    Expression<int>? responseTimeMs,
    Expression<String>? device,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (cardId != null) 'card_id': cardId,
      if (rating != null) 'rating': rating,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
      if (responseTimeMs != null) 'response_time_ms': responseTimeMs,
      if (device != null) 'device': device,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReviewLogCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? cardId,
    Value<String>? rating,
    Value<String>? reviewedAt,
    Value<int?>? responseTimeMs,
    Value<String?>? device,
    Value<int>? rowid,
  }) {
    return ReviewLogCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cardId: cardId ?? this.cardId,
      rating: rating ?? this.rating,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      responseTimeMs: responseTimeMs ?? this.responseTimeMs,
      device: device ?? this.device,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (rating.present) {
      map['rating'] = Variable<String>(rating.value);
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<String>(reviewedAt.value);
    }
    if (responseTimeMs.present) {
      map['response_time_ms'] = Variable<int>(responseTimeMs.value);
    }
    if (device.present) {
      map['device'] = Variable<String>(device.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLogCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('cardId: $cardId, ')
          ..write('rating: $rating, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('responseTimeMs: $responseTimeMs, ')
          ..write('device: $device, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class UnitProgress extends Table
    with TableInfo<UnitProgress, UnitProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  UnitProgress(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES users(id)',
  );
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
    'unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES units(id)',
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'locked\' CHECK (status IN (\'locked\', \'unlocked\', \'in_progress\', \'completed\'))',
    defaultValue: const CustomExpression('\'locked\''),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  late final GeneratedColumn<String> startedAt = GeneratedColumn<String>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  late final GeneratedColumn<String> completedAt = GeneratedColumn<String>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    unitId,
    status,
    startedAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unit_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<UnitProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, unitId};
  @override
  UnitProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnitProgressData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  UnitProgress createAlias(String alias) {
    return UnitProgress(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['PRIMARY KEY(user_id, unit_id)'];
  @override
  bool get dontWriteConstraints => true;
}

class UnitProgressData extends DataClass
    implements Insertable<UnitProgressData> {
  final String userId;
  final int unitId;
  final String status;
  final String? startedAt;
  final String? completedAt;
  const UnitProgressData({
    required this.userId,
    required this.unitId,
    required this.status,
    this.startedAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['unit_id'] = Variable<int>(unitId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<String>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<String>(completedAt);
    }
    return map;
  }

  UnitProgressCompanion toCompanion(bool nullToAbsent) {
    return UnitProgressCompanion(
      userId: Value(userId),
      unitId: Value(unitId),
      status: Value(status),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory UnitProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnitProgressData(
      userId: serializer.fromJson<String>(json['user_id']),
      unitId: serializer.fromJson<int>(json['unit_id']),
      status: serializer.fromJson<String>(json['status']),
      startedAt: serializer.fromJson<String?>(json['started_at']),
      completedAt: serializer.fromJson<String?>(json['completed_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'user_id': serializer.toJson<String>(userId),
      'unit_id': serializer.toJson<int>(unitId),
      'status': serializer.toJson<String>(status),
      'started_at': serializer.toJson<String?>(startedAt),
      'completed_at': serializer.toJson<String?>(completedAt),
    };
  }

  UnitProgressData copyWith({
    String? userId,
    int? unitId,
    String? status,
    Value<String?> startedAt = const Value.absent(),
    Value<String?> completedAt = const Value.absent(),
  }) => UnitProgressData(
    userId: userId ?? this.userId,
    unitId: unitId ?? this.unitId,
    status: status ?? this.status,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  UnitProgressData copyWithCompanion(UnitProgressCompanion data) {
    return UnitProgressData(
      userId: data.userId.present ? data.userId.value : this.userId,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnitProgressData(')
          ..write('userId: $userId, ')
          ..write('unitId: $unitId, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(userId, unitId, status, startedAt, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnitProgressData &&
          other.userId == this.userId &&
          other.unitId == this.unitId &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt);
}

class UnitProgressCompanion extends UpdateCompanion<UnitProgressData> {
  final Value<String> userId;
  final Value<int> unitId;
  final Value<String> status;
  final Value<String?> startedAt;
  final Value<String?> completedAt;
  final Value<int> rowid;
  const UnitProgressCompanion({
    this.userId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnitProgressCompanion.insert({
    required String userId,
    required int unitId,
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       unitId = Value(unitId);
  static Insertable<UnitProgressData> custom({
    Expression<String>? userId,
    Expression<int>? unitId,
    Expression<String>? status,
    Expression<String>? startedAt,
    Expression<String>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (unitId != null) 'unit_id': unitId,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnitProgressCompanion copyWith({
    Value<String>? userId,
    Value<int>? unitId,
    Value<String>? status,
    Value<String?>? startedAt,
    Value<String?>? completedAt,
    Value<int>? rowid,
  }) {
    return UnitProgressCompanion(
      userId: userId ?? this.userId,
      unitId: unitId ?? this.unitId,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<String>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<String>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitProgressCompanion(')
          ..write('userId: $userId, ')
          ..write('unitId: $unitId, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class UserVocab extends Table with TableInfo<UserVocab, UserVocabData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  UserVocab(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES users(id)',
  );
  static const VerificationMeta _contentItemIdMeta = const VerificationMeta(
    'contentItemId',
  );
  late final GeneratedColumn<int> contentItemId = GeneratedColumn<int>(
    'content_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES content_items(id)',
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  late final GeneratedColumn<String> addedAt = GeneratedColumn<String>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (datetime(\'now\'))',
    defaultValue: const CustomExpression('datetime(\'now\')'),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK (source IN (\'manual\', \'from_unit\', \'from_reading\'))',
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    contentItemId,
    addedAt,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_vocab';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserVocabData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('content_item_id')) {
      context.handle(
        _contentItemIdMeta,
        contentItemId.isAcceptableOrUnknown(
          data['content_item_id']!,
          _contentItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentItemIdMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, contentItemId};
  @override
  UserVocabData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserVocabData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      contentItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_item_id'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}added_at'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
    );
  }

  @override
  UserVocab createAlias(String alias) {
    return UserVocab(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(user_id, content_item_id)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class UserVocabData extends DataClass implements Insertable<UserVocabData> {
  final String userId;
  final int contentItemId;
  final String addedAt;
  final String? source;
  const UserVocabData({
    required this.userId,
    required this.contentItemId,
    required this.addedAt,
    this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['content_item_id'] = Variable<int>(contentItemId);
    map['added_at'] = Variable<String>(addedAt);
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    return map;
  }

  UserVocabCompanion toCompanion(bool nullToAbsent) {
    return UserVocabCompanion(
      userId: Value(userId),
      contentItemId: Value(contentItemId),
      addedAt: Value(addedAt),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
    );
  }

  factory UserVocabData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserVocabData(
      userId: serializer.fromJson<String>(json['user_id']),
      contentItemId: serializer.fromJson<int>(json['content_item_id']),
      addedAt: serializer.fromJson<String>(json['added_at']),
      source: serializer.fromJson<String?>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'user_id': serializer.toJson<String>(userId),
      'content_item_id': serializer.toJson<int>(contentItemId),
      'added_at': serializer.toJson<String>(addedAt),
      'source': serializer.toJson<String?>(source),
    };
  }

  UserVocabData copyWith({
    String? userId,
    int? contentItemId,
    String? addedAt,
    Value<String?> source = const Value.absent(),
  }) => UserVocabData(
    userId: userId ?? this.userId,
    contentItemId: contentItemId ?? this.contentItemId,
    addedAt: addedAt ?? this.addedAt,
    source: source.present ? source.value : this.source,
  );
  UserVocabData copyWithCompanion(UserVocabCompanion data) {
    return UserVocabData(
      userId: data.userId.present ? data.userId.value : this.userId,
      contentItemId: data.contentItemId.present
          ? data.contentItemId.value
          : this.contentItemId,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserVocabData(')
          ..write('userId: $userId, ')
          ..write('contentItemId: $contentItemId, ')
          ..write('addedAt: $addedAt, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, contentItemId, addedAt, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserVocabData &&
          other.userId == this.userId &&
          other.contentItemId == this.contentItemId &&
          other.addedAt == this.addedAt &&
          other.source == this.source);
}

class UserVocabCompanion extends UpdateCompanion<UserVocabData> {
  final Value<String> userId;
  final Value<int> contentItemId;
  final Value<String> addedAt;
  final Value<String?> source;
  final Value<int> rowid;
  const UserVocabCompanion({
    this.userId = const Value.absent(),
    this.contentItemId = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserVocabCompanion.insert({
    required String userId,
    required int contentItemId,
    this.addedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       contentItemId = Value(contentItemId);
  static Insertable<UserVocabData> custom({
    Expression<String>? userId,
    Expression<int>? contentItemId,
    Expression<String>? addedAt,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (contentItemId != null) 'content_item_id': contentItemId,
      if (addedAt != null) 'added_at': addedAt,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserVocabCompanion copyWith({
    Value<String>? userId,
    Value<int>? contentItemId,
    Value<String>? addedAt,
    Value<String?>? source,
    Value<int>? rowid,
  }) {
    return UserVocabCompanion(
      userId: userId ?? this.userId,
      contentItemId: contentItemId ?? this.contentItemId,
      addedAt: addedAt ?? this.addedAt,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (contentItemId.present) {
      map['content_item_id'] = Variable<int>(contentItemId.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<String>(addedAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserVocabCompanion(')
          ..write('userId: $userId, ')
          ..write('contentItemId: $contentItemId, ')
          ..write('addedAt: $addedAt, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DailyActivity extends Table
    with TableInfo<DailyActivity, DailyActivityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DailyActivity(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES users(id)',
  );
  static const VerificationMeta _activityDateMeta = const VerificationMeta(
    'activityDate',
  );
  late final GeneratedColumn<String> activityDate = GeneratedColumn<String>(
    'activity_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _reviewsDoneMeta = const VerificationMeta(
    'reviewsDone',
  );
  late final GeneratedColumn<int> reviewsDone = GeneratedColumn<int>(
    'reviews_done',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _newItemsLearnedMeta = const VerificationMeta(
    'newItemsLearned',
  );
  late final GeneratedColumn<int> newItemsLearned = GeneratedColumn<int>(
    'new_items_learned',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _minutesSpentMeta = const VerificationMeta(
    'minutesSpent',
  );
  late final GeneratedColumn<int> minutesSpent = GeneratedColumn<int>(
    'minutes_spent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _goalMetMeta = const VerificationMeta(
    'goalMet',
  );
  late final GeneratedColumn<int> goalMet = GeneratedColumn<int>(
    'goal_met',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    activityDate,
    reviewsDone,
    newItemsLearned,
    minutesSpent,
    goalMet,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_activity';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyActivityData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('activity_date')) {
      context.handle(
        _activityDateMeta,
        activityDate.isAcceptableOrUnknown(
          data['activity_date']!,
          _activityDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activityDateMeta);
    }
    if (data.containsKey('reviews_done')) {
      context.handle(
        _reviewsDoneMeta,
        reviewsDone.isAcceptableOrUnknown(
          data['reviews_done']!,
          _reviewsDoneMeta,
        ),
      );
    }
    if (data.containsKey('new_items_learned')) {
      context.handle(
        _newItemsLearnedMeta,
        newItemsLearned.isAcceptableOrUnknown(
          data['new_items_learned']!,
          _newItemsLearnedMeta,
        ),
      );
    }
    if (data.containsKey('minutes_spent')) {
      context.handle(
        _minutesSpentMeta,
        minutesSpent.isAcceptableOrUnknown(
          data['minutes_spent']!,
          _minutesSpentMeta,
        ),
      );
    }
    if (data.containsKey('goal_met')) {
      context.handle(
        _goalMetMeta,
        goalMet.isAcceptableOrUnknown(data['goal_met']!, _goalMetMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, activityDate};
  @override
  DailyActivityData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyActivityData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      activityDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_date'],
      )!,
      reviewsDone: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reviews_done'],
      )!,
      newItemsLearned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}new_items_learned'],
      )!,
      minutesSpent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes_spent'],
      )!,
      goalMet: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_met'],
      )!,
    );
  }

  @override
  DailyActivity createAlias(String alias) {
    return DailyActivity(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(user_id, activity_date)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class DailyActivityData extends DataClass
    implements Insertable<DailyActivityData> {
  final String userId;
  final String activityDate;
  final int reviewsDone;
  final int newItemsLearned;
  final int minutesSpent;
  final int goalMet;
  const DailyActivityData({
    required this.userId,
    required this.activityDate,
    required this.reviewsDone,
    required this.newItemsLearned,
    required this.minutesSpent,
    required this.goalMet,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['activity_date'] = Variable<String>(activityDate);
    map['reviews_done'] = Variable<int>(reviewsDone);
    map['new_items_learned'] = Variable<int>(newItemsLearned);
    map['minutes_spent'] = Variable<int>(minutesSpent);
    map['goal_met'] = Variable<int>(goalMet);
    return map;
  }

  DailyActivityCompanion toCompanion(bool nullToAbsent) {
    return DailyActivityCompanion(
      userId: Value(userId),
      activityDate: Value(activityDate),
      reviewsDone: Value(reviewsDone),
      newItemsLearned: Value(newItemsLearned),
      minutesSpent: Value(minutesSpent),
      goalMet: Value(goalMet),
    );
  }

  factory DailyActivityData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyActivityData(
      userId: serializer.fromJson<String>(json['user_id']),
      activityDate: serializer.fromJson<String>(json['activity_date']),
      reviewsDone: serializer.fromJson<int>(json['reviews_done']),
      newItemsLearned: serializer.fromJson<int>(json['new_items_learned']),
      minutesSpent: serializer.fromJson<int>(json['minutes_spent']),
      goalMet: serializer.fromJson<int>(json['goal_met']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'user_id': serializer.toJson<String>(userId),
      'activity_date': serializer.toJson<String>(activityDate),
      'reviews_done': serializer.toJson<int>(reviewsDone),
      'new_items_learned': serializer.toJson<int>(newItemsLearned),
      'minutes_spent': serializer.toJson<int>(minutesSpent),
      'goal_met': serializer.toJson<int>(goalMet),
    };
  }

  DailyActivityData copyWith({
    String? userId,
    String? activityDate,
    int? reviewsDone,
    int? newItemsLearned,
    int? minutesSpent,
    int? goalMet,
  }) => DailyActivityData(
    userId: userId ?? this.userId,
    activityDate: activityDate ?? this.activityDate,
    reviewsDone: reviewsDone ?? this.reviewsDone,
    newItemsLearned: newItemsLearned ?? this.newItemsLearned,
    minutesSpent: minutesSpent ?? this.minutesSpent,
    goalMet: goalMet ?? this.goalMet,
  );
  DailyActivityData copyWithCompanion(DailyActivityCompanion data) {
    return DailyActivityData(
      userId: data.userId.present ? data.userId.value : this.userId,
      activityDate: data.activityDate.present
          ? data.activityDate.value
          : this.activityDate,
      reviewsDone: data.reviewsDone.present
          ? data.reviewsDone.value
          : this.reviewsDone,
      newItemsLearned: data.newItemsLearned.present
          ? data.newItemsLearned.value
          : this.newItemsLearned,
      minutesSpent: data.minutesSpent.present
          ? data.minutesSpent.value
          : this.minutesSpent,
      goalMet: data.goalMet.present ? data.goalMet.value : this.goalMet,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyActivityData(')
          ..write('userId: $userId, ')
          ..write('activityDate: $activityDate, ')
          ..write('reviewsDone: $reviewsDone, ')
          ..write('newItemsLearned: $newItemsLearned, ')
          ..write('minutesSpent: $minutesSpent, ')
          ..write('goalMet: $goalMet')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    activityDate,
    reviewsDone,
    newItemsLearned,
    minutesSpent,
    goalMet,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyActivityData &&
          other.userId == this.userId &&
          other.activityDate == this.activityDate &&
          other.reviewsDone == this.reviewsDone &&
          other.newItemsLearned == this.newItemsLearned &&
          other.minutesSpent == this.minutesSpent &&
          other.goalMet == this.goalMet);
}

class DailyActivityCompanion extends UpdateCompanion<DailyActivityData> {
  final Value<String> userId;
  final Value<String> activityDate;
  final Value<int> reviewsDone;
  final Value<int> newItemsLearned;
  final Value<int> minutesSpent;
  final Value<int> goalMet;
  final Value<int> rowid;
  const DailyActivityCompanion({
    this.userId = const Value.absent(),
    this.activityDate = const Value.absent(),
    this.reviewsDone = const Value.absent(),
    this.newItemsLearned = const Value.absent(),
    this.minutesSpent = const Value.absent(),
    this.goalMet = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyActivityCompanion.insert({
    required String userId,
    required String activityDate,
    this.reviewsDone = const Value.absent(),
    this.newItemsLearned = const Value.absent(),
    this.minutesSpent = const Value.absent(),
    this.goalMet = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       activityDate = Value(activityDate);
  static Insertable<DailyActivityData> custom({
    Expression<String>? userId,
    Expression<String>? activityDate,
    Expression<int>? reviewsDone,
    Expression<int>? newItemsLearned,
    Expression<int>? minutesSpent,
    Expression<int>? goalMet,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (activityDate != null) 'activity_date': activityDate,
      if (reviewsDone != null) 'reviews_done': reviewsDone,
      if (newItemsLearned != null) 'new_items_learned': newItemsLearned,
      if (minutesSpent != null) 'minutes_spent': minutesSpent,
      if (goalMet != null) 'goal_met': goalMet,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyActivityCompanion copyWith({
    Value<String>? userId,
    Value<String>? activityDate,
    Value<int>? reviewsDone,
    Value<int>? newItemsLearned,
    Value<int>? minutesSpent,
    Value<int>? goalMet,
    Value<int>? rowid,
  }) {
    return DailyActivityCompanion(
      userId: userId ?? this.userId,
      activityDate: activityDate ?? this.activityDate,
      reviewsDone: reviewsDone ?? this.reviewsDone,
      newItemsLearned: newItemsLearned ?? this.newItemsLearned,
      minutesSpent: minutesSpent ?? this.minutesSpent,
      goalMet: goalMet ?? this.goalMet,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (activityDate.present) {
      map['activity_date'] = Variable<String>(activityDate.value);
    }
    if (reviewsDone.present) {
      map['reviews_done'] = Variable<int>(reviewsDone.value);
    }
    if (newItemsLearned.present) {
      map['new_items_learned'] = Variable<int>(newItemsLearned.value);
    }
    if (minutesSpent.present) {
      map['minutes_spent'] = Variable<int>(minutesSpent.value);
    }
    if (goalMet.present) {
      map['goal_met'] = Variable<int>(goalMet.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyActivityCompanion(')
          ..write('userId: $userId, ')
          ..write('activityDate: $activityDate, ')
          ..write('reviewsDone: $reviewsDone, ')
          ..write('newItemsLearned: $newItemsLearned, ')
          ..write('minutesSpent: $minutesSpent, ')
          ..write('goalMet: $goalMet, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class ComprehensionSnapshot extends Table
    with TableInfo<ComprehensionSnapshot, ComprehensionSnapshotData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ComprehensionSnapshot(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES users(id)',
  );
  static const VerificationMeta _snapshotDateMeta = const VerificationMeta(
    'snapshotDate',
  );
  late final GeneratedColumn<String> snapshotDate = GeneratedColumn<String>(
    'snapshot_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _readingPctMeta = const VerificationMeta(
    'readingPct',
  );
  late final GeneratedColumn<double> readingPct = GeneratedColumn<double>(
    'reading_pct',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _listeningPctMeta = const VerificationMeta(
    'listeningPct',
  );
  late final GeneratedColumn<double> listeningPct = GeneratedColumn<double>(
    'listening_pct',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _speakingScoreMeta = const VerificationMeta(
    'speakingScore',
  );
  late final GeneratedColumn<double> speakingScore = GeneratedColumn<double>(
    'speaking_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _writingScoreMeta = const VerificationMeta(
    'writingScore',
  );
  late final GeneratedColumn<double> writingScore = GeneratedColumn<double>(
    'writing_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _overallPctMeta = const VerificationMeta(
    'overallPct',
  );
  late final GeneratedColumn<double> overallPct = GeneratedColumn<double>(
    'overall_pct',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    snapshotDate,
    readingPct,
    listeningPct,
    speakingScore,
    writingScore,
    overallPct,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'comprehension_snapshot';
  @override
  VerificationContext validateIntegrity(
    Insertable<ComprehensionSnapshotData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('snapshot_date')) {
      context.handle(
        _snapshotDateMeta,
        snapshotDate.isAcceptableOrUnknown(
          data['snapshot_date']!,
          _snapshotDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_snapshotDateMeta);
    }
    if (data.containsKey('reading_pct')) {
      context.handle(
        _readingPctMeta,
        readingPct.isAcceptableOrUnknown(data['reading_pct']!, _readingPctMeta),
      );
    }
    if (data.containsKey('listening_pct')) {
      context.handle(
        _listeningPctMeta,
        listeningPct.isAcceptableOrUnknown(
          data['listening_pct']!,
          _listeningPctMeta,
        ),
      );
    }
    if (data.containsKey('speaking_score')) {
      context.handle(
        _speakingScoreMeta,
        speakingScore.isAcceptableOrUnknown(
          data['speaking_score']!,
          _speakingScoreMeta,
        ),
      );
    }
    if (data.containsKey('writing_score')) {
      context.handle(
        _writingScoreMeta,
        writingScore.isAcceptableOrUnknown(
          data['writing_score']!,
          _writingScoreMeta,
        ),
      );
    }
    if (data.containsKey('overall_pct')) {
      context.handle(
        _overallPctMeta,
        overallPct.isAcceptableOrUnknown(data['overall_pct']!, _overallPctMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, snapshotDate};
  @override
  ComprehensionSnapshotData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ComprehensionSnapshotData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      snapshotDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snapshot_date'],
      )!,
      readingPct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}reading_pct'],
      ),
      listeningPct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}listening_pct'],
      ),
      speakingScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speaking_score'],
      ),
      writingScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}writing_score'],
      ),
      overallPct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}overall_pct'],
      ),
    );
  }

  @override
  ComprehensionSnapshot createAlias(String alias) {
    return ComprehensionSnapshot(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(user_id, snapshot_date)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class ComprehensionSnapshotData extends DataClass
    implements Insertable<ComprehensionSnapshotData> {
  final String userId;
  final String snapshotDate;
  final double? readingPct;
  final double? listeningPct;
  final double? speakingScore;
  final double? writingScore;
  final double? overallPct;
  const ComprehensionSnapshotData({
    required this.userId,
    required this.snapshotDate,
    this.readingPct,
    this.listeningPct,
    this.speakingScore,
    this.writingScore,
    this.overallPct,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['snapshot_date'] = Variable<String>(snapshotDate);
    if (!nullToAbsent || readingPct != null) {
      map['reading_pct'] = Variable<double>(readingPct);
    }
    if (!nullToAbsent || listeningPct != null) {
      map['listening_pct'] = Variable<double>(listeningPct);
    }
    if (!nullToAbsent || speakingScore != null) {
      map['speaking_score'] = Variable<double>(speakingScore);
    }
    if (!nullToAbsent || writingScore != null) {
      map['writing_score'] = Variable<double>(writingScore);
    }
    if (!nullToAbsent || overallPct != null) {
      map['overall_pct'] = Variable<double>(overallPct);
    }
    return map;
  }

  ComprehensionSnapshotCompanion toCompanion(bool nullToAbsent) {
    return ComprehensionSnapshotCompanion(
      userId: Value(userId),
      snapshotDate: Value(snapshotDate),
      readingPct: readingPct == null && nullToAbsent
          ? const Value.absent()
          : Value(readingPct),
      listeningPct: listeningPct == null && nullToAbsent
          ? const Value.absent()
          : Value(listeningPct),
      speakingScore: speakingScore == null && nullToAbsent
          ? const Value.absent()
          : Value(speakingScore),
      writingScore: writingScore == null && nullToAbsent
          ? const Value.absent()
          : Value(writingScore),
      overallPct: overallPct == null && nullToAbsent
          ? const Value.absent()
          : Value(overallPct),
    );
  }

  factory ComprehensionSnapshotData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ComprehensionSnapshotData(
      userId: serializer.fromJson<String>(json['user_id']),
      snapshotDate: serializer.fromJson<String>(json['snapshot_date']),
      readingPct: serializer.fromJson<double?>(json['reading_pct']),
      listeningPct: serializer.fromJson<double?>(json['listening_pct']),
      speakingScore: serializer.fromJson<double?>(json['speaking_score']),
      writingScore: serializer.fromJson<double?>(json['writing_score']),
      overallPct: serializer.fromJson<double?>(json['overall_pct']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'user_id': serializer.toJson<String>(userId),
      'snapshot_date': serializer.toJson<String>(snapshotDate),
      'reading_pct': serializer.toJson<double?>(readingPct),
      'listening_pct': serializer.toJson<double?>(listeningPct),
      'speaking_score': serializer.toJson<double?>(speakingScore),
      'writing_score': serializer.toJson<double?>(writingScore),
      'overall_pct': serializer.toJson<double?>(overallPct),
    };
  }

  ComprehensionSnapshotData copyWith({
    String? userId,
    String? snapshotDate,
    Value<double?> readingPct = const Value.absent(),
    Value<double?> listeningPct = const Value.absent(),
    Value<double?> speakingScore = const Value.absent(),
    Value<double?> writingScore = const Value.absent(),
    Value<double?> overallPct = const Value.absent(),
  }) => ComprehensionSnapshotData(
    userId: userId ?? this.userId,
    snapshotDate: snapshotDate ?? this.snapshotDate,
    readingPct: readingPct.present ? readingPct.value : this.readingPct,
    listeningPct: listeningPct.present ? listeningPct.value : this.listeningPct,
    speakingScore: speakingScore.present
        ? speakingScore.value
        : this.speakingScore,
    writingScore: writingScore.present ? writingScore.value : this.writingScore,
    overallPct: overallPct.present ? overallPct.value : this.overallPct,
  );
  ComprehensionSnapshotData copyWithCompanion(
    ComprehensionSnapshotCompanion data,
  ) {
    return ComprehensionSnapshotData(
      userId: data.userId.present ? data.userId.value : this.userId,
      snapshotDate: data.snapshotDate.present
          ? data.snapshotDate.value
          : this.snapshotDate,
      readingPct: data.readingPct.present
          ? data.readingPct.value
          : this.readingPct,
      listeningPct: data.listeningPct.present
          ? data.listeningPct.value
          : this.listeningPct,
      speakingScore: data.speakingScore.present
          ? data.speakingScore.value
          : this.speakingScore,
      writingScore: data.writingScore.present
          ? data.writingScore.value
          : this.writingScore,
      overallPct: data.overallPct.present
          ? data.overallPct.value
          : this.overallPct,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ComprehensionSnapshotData(')
          ..write('userId: $userId, ')
          ..write('snapshotDate: $snapshotDate, ')
          ..write('readingPct: $readingPct, ')
          ..write('listeningPct: $listeningPct, ')
          ..write('speakingScore: $speakingScore, ')
          ..write('writingScore: $writingScore, ')
          ..write('overallPct: $overallPct')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    snapshotDate,
    readingPct,
    listeningPct,
    speakingScore,
    writingScore,
    overallPct,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ComprehensionSnapshotData &&
          other.userId == this.userId &&
          other.snapshotDate == this.snapshotDate &&
          other.readingPct == this.readingPct &&
          other.listeningPct == this.listeningPct &&
          other.speakingScore == this.speakingScore &&
          other.writingScore == this.writingScore &&
          other.overallPct == this.overallPct);
}

class ComprehensionSnapshotCompanion
    extends UpdateCompanion<ComprehensionSnapshotData> {
  final Value<String> userId;
  final Value<String> snapshotDate;
  final Value<double?> readingPct;
  final Value<double?> listeningPct;
  final Value<double?> speakingScore;
  final Value<double?> writingScore;
  final Value<double?> overallPct;
  final Value<int> rowid;
  const ComprehensionSnapshotCompanion({
    this.userId = const Value.absent(),
    this.snapshotDate = const Value.absent(),
    this.readingPct = const Value.absent(),
    this.listeningPct = const Value.absent(),
    this.speakingScore = const Value.absent(),
    this.writingScore = const Value.absent(),
    this.overallPct = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ComprehensionSnapshotCompanion.insert({
    required String userId,
    required String snapshotDate,
    this.readingPct = const Value.absent(),
    this.listeningPct = const Value.absent(),
    this.speakingScore = const Value.absent(),
    this.writingScore = const Value.absent(),
    this.overallPct = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       snapshotDate = Value(snapshotDate);
  static Insertable<ComprehensionSnapshotData> custom({
    Expression<String>? userId,
    Expression<String>? snapshotDate,
    Expression<double>? readingPct,
    Expression<double>? listeningPct,
    Expression<double>? speakingScore,
    Expression<double>? writingScore,
    Expression<double>? overallPct,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (snapshotDate != null) 'snapshot_date': snapshotDate,
      if (readingPct != null) 'reading_pct': readingPct,
      if (listeningPct != null) 'listening_pct': listeningPct,
      if (speakingScore != null) 'speaking_score': speakingScore,
      if (writingScore != null) 'writing_score': writingScore,
      if (overallPct != null) 'overall_pct': overallPct,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ComprehensionSnapshotCompanion copyWith({
    Value<String>? userId,
    Value<String>? snapshotDate,
    Value<double?>? readingPct,
    Value<double?>? listeningPct,
    Value<double?>? speakingScore,
    Value<double?>? writingScore,
    Value<double?>? overallPct,
    Value<int>? rowid,
  }) {
    return ComprehensionSnapshotCompanion(
      userId: userId ?? this.userId,
      snapshotDate: snapshotDate ?? this.snapshotDate,
      readingPct: readingPct ?? this.readingPct,
      listeningPct: listeningPct ?? this.listeningPct,
      speakingScore: speakingScore ?? this.speakingScore,
      writingScore: writingScore ?? this.writingScore,
      overallPct: overallPct ?? this.overallPct,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (snapshotDate.present) {
      map['snapshot_date'] = Variable<String>(snapshotDate.value);
    }
    if (readingPct.present) {
      map['reading_pct'] = Variable<double>(readingPct.value);
    }
    if (listeningPct.present) {
      map['listening_pct'] = Variable<double>(listeningPct.value);
    }
    if (speakingScore.present) {
      map['speaking_score'] = Variable<double>(speakingScore.value);
    }
    if (writingScore.present) {
      map['writing_score'] = Variable<double>(writingScore.value);
    }
    if (overallPct.present) {
      map['overall_pct'] = Variable<double>(overallPct.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComprehensionSnapshotCompanion(')
          ..write('userId: $userId, ')
          ..write('snapshotDate: $snapshotDate, ')
          ..write('readingPct: $readingPct, ')
          ..write('listeningPct: $listeningPct, ')
          ..write('speakingScore: $speakingScore, ')
          ..write('writingScore: $writingScore, ')
          ..write('overallPct: $overallPct, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final ContentItems contentItems = ContentItems(this);
  late final Index idxContentItemsKindLevel = Index(
    'idx_content_items_kind_level',
    'CREATE INDEX idx_content_items_kind_level ON content_items (kind, jlpt_level)',
  );
  late final Kana kana = Kana(this);
  late final Radicals radicals = Radicals(this);
  late final Kanji kanji = Kanji(this);
  late final KanjiRadicals kanjiRadicals = KanjiRadicals(this);
  late final Words words = Words(this);
  late final WordKanji wordKanji = WordKanji(this);
  late final WordKana wordKana = WordKana(this);
  late final Particles particles = Particles(this);
  late final GrammarPoints grammarPoints = GrammarPoints(this);
  late final Sentences sentences = Sentences(this);
  late final SentenceContentItems sentenceContentItems = SentenceContentItems(
    this,
  );
  late final ExerciseTypes exerciseTypes = ExerciseTypes(this);
  late final Units units = Units(this);
  late final UnitPrerequisites unitPrerequisites = UnitPrerequisites(this);
  late final UnitItems unitItems = UnitItems(this);
  late final Users users = Users(this);
  late final UserProfile userProfile = UserProfile(this);
  late final SrsCards srsCards = SrsCards(this);
  late final Index idxSrsDue = Index(
    'idx_srs_due',
    'CREATE INDEX idx_srs_due ON srs_cards (user_id, due_at)',
  );
  late final ReviewLog reviewLog = ReviewLog(this);
  late final Index idxReviewLogUserTime = Index(
    'idx_review_log_user_time',
    'CREATE INDEX idx_review_log_user_time ON review_log (user_id, reviewed_at)',
  );
  late final UnitProgress unitProgress = UnitProgress(this);
  late final UserVocab userVocab = UserVocab(this);
  late final DailyActivity dailyActivity = DailyActivity(this);
  late final ComprehensionSnapshot comprehensionSnapshot =
      ComprehensionSnapshot(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    contentItems,
    idxContentItemsKindLevel,
    kana,
    radicals,
    kanji,
    kanjiRadicals,
    words,
    wordKanji,
    wordKana,
    particles,
    grammarPoints,
    sentences,
    sentenceContentItems,
    exerciseTypes,
    units,
    unitPrerequisites,
    unitItems,
    users,
    userProfile,
    srsCards,
    idxSrsDue,
    reviewLog,
    idxReviewLogUserTime,
    unitProgress,
    userVocab,
    dailyActivity,
    comprehensionSnapshot,
  ];
}

typedef $ContentItemsCreateCompanionBuilder = ContentItemsCompanion Function({
  Value<int> id,
  required String kind,
  Value<String?> jlptLevel,
  Value<int?> frequencyRank,
  Value<String> createdAt,
});
typedef $ContentItemsUpdateCompanionBuilder = ContentItemsCompanion Function({
  Value<int> id,
  Value<String> kind,
  Value<String?> jlptLevel,
  Value<int?> frequencyRank,
  Value<String> createdAt,
});

final class $ContentItemsReferences
    extends BaseReferences<_$AppDatabase, ContentItems, ContentItem> {
  $ContentItemsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Kana, List<KanaData>> _kanaRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.kana,
    aliasName: 'content_items__id__kana__content_item_id',
  );

  $KanaProcessedTableManager get kanaRefs {
    final manager = $KanaTableManager(
      $_db,
      $_db.kana,
    ).filter((f) => f.contentItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_kanaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Kanji, List<KanjiData>> _kanjiRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.kanji,
    aliasName: 'content_items__id__kanji__content_item_id',
  );

  $KanjiProcessedTableManager get kanjiRefs {
    final manager = $KanjiTableManager(
      $_db,
      $_db.kanji,
    ).filter((f) => f.contentItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_kanjiRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Words, List<Word>> _wordsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.words,
    aliasName: 'content_items__id__words__content_item_id',
  );

  $WordsProcessedTableManager get wordsRefs {
    final manager = $WordsTableManager(
      $_db,
      $_db.words,
    ).filter((f) => f.contentItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_wordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Particles, List<Particle>> _particlesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.particles,
    aliasName: 'content_items__id__particles__content_item_id',
  );

  $ParticlesProcessedTableManager get particlesRefs {
    final manager = $ParticlesTableManager(
      $_db,
      $_db.particles,
    ).filter((f) => f.contentItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_particlesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<GrammarPoints, List<GrammarPoint>>
  _grammarPointsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.grammarPoints,
    aliasName: 'content_items__id__grammar_points__content_item_id',
  );

  $GrammarPointsProcessedTableManager get grammarPointsRefs {
    final manager = $GrammarPointsTableManager(
      $_db,
      $_db.grammarPoints,
    ).filter((f) => f.contentItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_grammarPointsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<SentenceContentItems, List<SentenceContentItem>>
  _sentenceContentItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.sentenceContentItems,
        aliasName: 'content_items__id__sentence_content_items__content_item_id',
      );

  $SentenceContentItemsProcessedTableManager get sentenceContentItemsRefs {
    final manager = $SentenceContentItemsTableManager(
      $_db,
      $_db.sentenceContentItems,
    ).filter((f) => f.contentItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sentenceContentItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<UnitItems, List<UnitItem>> _unitItemsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.unitItems,
    aliasName: 'content_items__id__unit_items__content_item_id',
  );

  $UnitItemsProcessedTableManager get unitItemsRefs {
    final manager = $UnitItemsTableManager(
      $_db,
      $_db.unitItems,
    ).filter((f) => f.contentItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_unitItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<SrsCards, List<SrsCard>> _srsCardsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.srsCards,
    aliasName: 'content_items__id__srs_cards__content_item_id',
  );

  $SrsCardsProcessedTableManager get srsCardsRefs {
    final manager = $SrsCardsTableManager(
      $_db,
      $_db.srsCards,
    ).filter((f) => f.contentItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_srsCardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<UserVocab, List<UserVocabData>>
  _userVocabRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userVocab,
    aliasName: 'content_items__id__user_vocab__content_item_id',
  );

  $UserVocabProcessedTableManager get userVocabRefs {
    final manager = $UserVocabTableManager(
      $_db,
      $_db.userVocab,
    ).filter((f) => f.contentItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_userVocabRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $ContentItemsFilterComposer
    extends Composer<_$AppDatabase, ContentItems> {
  $ContentItemsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jlptLevel => $composableBuilder(
    column: $table.jlptLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frequencyRank => $composableBuilder(
    column: $table.frequencyRank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> kanaRefs(
    Expression<bool> Function($KanaFilterComposer f) f,
  ) {
    final $KanaFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kana,
      getReferencedColumn: (t) => t.contentItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $KanaFilterComposer(
            $db: $db,
            $table: $db.kana,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> kanjiRefs(
    Expression<bool> Function($KanjiFilterComposer f) f,
  ) {
    final $KanjiFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kanji,
      getReferencedColumn: (t) => t.contentItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $KanjiFilterComposer(
            $db: $db,
            $table: $db.kanji,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> wordsRefs(
    Expression<bool> Function($WordsFilterComposer f) f,
  ) {
    final $WordsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.contentItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $WordsFilterComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> particlesRefs(
    Expression<bool> Function($ParticlesFilterComposer f) f,
  ) {
    final $ParticlesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.particles,
      getReferencedColumn: (t) => t.contentItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ParticlesFilterComposer(
            $db: $db,
            $table: $db.particles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> grammarPointsRefs(
    Expression<bool> Function($GrammarPointsFilterComposer f) f,
  ) {
    final $GrammarPointsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.grammarPoints,
      getReferencedColumn: (t) => t.contentItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $GrammarPointsFilterComposer(
            $db: $db,
            $table: $db.grammarPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sentenceContentItemsRefs(
    Expression<bool> Function($SentenceContentItemsFilterComposer f) f,
  ) {
    final $SentenceContentItemsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sentenceContentItems,
      getReferencedColumn: (t) => t.contentItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SentenceContentItemsFilterComposer(
            $db: $db,
            $table: $db.sentenceContentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> unitItemsRefs(
    Expression<bool> Function($UnitItemsFilterComposer f) f,
  ) {
    final $UnitItemsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.unitItems,
      getReferencedColumn: (t) => t.contentItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UnitItemsFilterComposer(
            $db: $db,
            $table: $db.unitItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> srsCardsRefs(
    Expression<bool> Function($SrsCardsFilterComposer f) f,
  ) {
    final $SrsCardsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.srsCards,
      getReferencedColumn: (t) => t.contentItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SrsCardsFilterComposer(
            $db: $db,
            $table: $db.srsCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> userVocabRefs(
    Expression<bool> Function($UserVocabFilterComposer f) f,
  ) {
    final $UserVocabFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userVocab,
      getReferencedColumn: (t) => t.contentItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UserVocabFilterComposer(
            $db: $db,
            $table: $db.userVocab,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $ContentItemsOrderingComposer
    extends Composer<_$AppDatabase, ContentItems> {
  $ContentItemsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jlptLevel => $composableBuilder(
    column: $table.jlptLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frequencyRank => $composableBuilder(
    column: $table.frequencyRank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $ContentItemsAnnotationComposer
    extends Composer<_$AppDatabase, ContentItems> {
  $ContentItemsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get jlptLevel =>
      $composableBuilder(column: $table.jlptLevel, builder: (column) => column);

  GeneratedColumn<int> get frequencyRank => $composableBuilder(
    column: $table.frequencyRank,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> kanaRefs<T extends Object>(
    Expression<T> Function($KanaAnnotationComposer a) f,
  ) {
    final $KanaAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kana,
      getReferencedColumn: (t) => t.contentItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $KanaAnnotationComposer(
            $db: $db,
            $table: $db.kana,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> kanjiRefs<T extends Object>(
    Expression<T> Function($KanjiAnnotationComposer a) f,
  ) {
    final $KanjiAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kanji,
      getReferencedColumn: (t) => t.contentItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $KanjiAnnotationComposer(
            $db: $db,
            $table: $db.kanji,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> wordsRefs<T extends Object>(
    Expression<T> Function($WordsAnnotationComposer a) f,
  ) {
    final $WordsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.contentItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $WordsAnnotationComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> particlesRefs<T extends Object>(
    Expression<T> Function($ParticlesAnnotationComposer a) f,
  ) {
    final $ParticlesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.particles,
      getReferencedColumn: (t) => t.contentItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ParticlesAnnotationComposer(
            $db: $db,
            $table: $db.particles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> grammarPointsRefs<T extends Object>(
    Expression<T> Function($GrammarPointsAnnotationComposer a) f,
  ) {
    final $GrammarPointsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.grammarPoints,
      getReferencedColumn: (t) => t.contentItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $GrammarPointsAnnotationComposer(
            $db: $db,
            $table: $db.grammarPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sentenceContentItemsRefs<T extends Object>(
    Expression<T> Function($SentenceContentItemsAnnotationComposer a) f,
  ) {
    final $SentenceContentItemsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sentenceContentItems,
      getReferencedColumn: (t) => t.contentItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SentenceContentItemsAnnotationComposer(
            $db: $db,
            $table: $db.sentenceContentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> unitItemsRefs<T extends Object>(
    Expression<T> Function($UnitItemsAnnotationComposer a) f,
  ) {
    final $UnitItemsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.unitItems,
      getReferencedColumn: (t) => t.contentItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UnitItemsAnnotationComposer(
            $db: $db,
            $table: $db.unitItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> srsCardsRefs<T extends Object>(
    Expression<T> Function($SrsCardsAnnotationComposer a) f,
  ) {
    final $SrsCardsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.srsCards,
      getReferencedColumn: (t) => t.contentItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SrsCardsAnnotationComposer(
            $db: $db,
            $table: $db.srsCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> userVocabRefs<T extends Object>(
    Expression<T> Function($UserVocabAnnotationComposer a) f,
  ) {
    final $UserVocabAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userVocab,
      getReferencedColumn: (t) => t.contentItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UserVocabAnnotationComposer(
            $db: $db,
            $table: $db.userVocab,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $ContentItemsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          ContentItems,
          ContentItem,
          $ContentItemsFilterComposer,
          $ContentItemsOrderingComposer,
          $ContentItemsAnnotationComposer,
          $ContentItemsCreateCompanionBuilder,
          $ContentItemsUpdateCompanionBuilder,
          (ContentItem, $ContentItemsReferences),
          ContentItem,
          PrefetchHooks Function({
            bool kanaRefs,
            bool kanjiRefs,
            bool wordsRefs,
            bool particlesRefs,
            bool grammarPointsRefs,
            bool sentenceContentItemsRefs,
            bool unitItemsRefs,
            bool srsCardsRefs,
            bool userVocabRefs,
          })
        > {
  $ContentItemsTableManager(_$AppDatabase db, ContentItems table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ContentItemsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ContentItemsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ContentItemsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> jlptLevel = const Value.absent(),
                Value<int?> frequencyRank = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => ContentItemsCompanion(
                id: id,
                kind: kind,
                jlptLevel: jlptLevel,
                frequencyRank: frequencyRank,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String kind,
                Value<String?> jlptLevel = const Value.absent(),
                Value<int?> frequencyRank = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => ContentItemsCompanion.insert(
                id: id,
                kind: kind,
                jlptLevel: jlptLevel,
                frequencyRank: frequencyRank,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<ContentItems, ContentItem>(table),
                  $ContentItemsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                kanaRefs = false,
                kanjiRefs = false,
                wordsRefs = false,
                particlesRefs = false,
                grammarPointsRefs = false,
                sentenceContentItemsRefs = false,
                unitItemsRefs = false,
                srsCardsRefs = false,
                userVocabRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (kanaRefs) db.kana,
                    if (kanjiRefs) db.kanji,
                    if (wordsRefs) db.words,
                    if (particlesRefs) db.particles,
                    if (grammarPointsRefs) db.grammarPoints,
                    if (sentenceContentItemsRefs) db.sentenceContentItems,
                    if (unitItemsRefs) db.unitItems,
                    if (srsCardsRefs) db.srsCards,
                    if (userVocabRefs) db.userVocab,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (kanaRefs)
                        await $_getPrefetchedData<
                          ContentItem,
                          ContentItems,
                          KanaData
                        >(
                          currentTable: table,
                          referencedTable: $ContentItemsReferences
                              ._kanaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $ContentItemsReferences(db, table, p0).kanaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.contentItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (kanjiRefs)
                        await $_getPrefetchedData<
                          ContentItem,
                          ContentItems,
                          KanjiData
                        >(
                          currentTable: table,
                          referencedTable: $ContentItemsReferences
                              ._kanjiRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $ContentItemsReferences(db, table, p0).kanjiRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.contentItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (wordsRefs)
                        await $_getPrefetchedData<
                          ContentItem,
                          ContentItems,
                          Word
                        >(
                          currentTable: table,
                          referencedTable: $ContentItemsReferences
                              ._wordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $ContentItemsReferences(db, table, p0).wordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.contentItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (particlesRefs)
                        await $_getPrefetchedData<
                          ContentItem,
                          ContentItems,
                          Particle
                        >(
                          currentTable: table,
                          referencedTable: $ContentItemsReferences
                              ._particlesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $ContentItemsReferences(
                                db,
                                table,
                                p0,
                              ).particlesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.contentItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (grammarPointsRefs)
                        await $_getPrefetchedData<
                          ContentItem,
                          ContentItems,
                          GrammarPoint
                        >(
                          currentTable: table,
                          referencedTable: $ContentItemsReferences
                              ._grammarPointsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $ContentItemsReferences(
                                db,
                                table,
                                p0,
                              ).grammarPointsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.contentItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sentenceContentItemsRefs)
                        await $_getPrefetchedData<
                          ContentItem,
                          ContentItems,
                          SentenceContentItem
                        >(
                          currentTable: table,
                          referencedTable: $ContentItemsReferences
                              ._sentenceContentItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $ContentItemsReferences(
                                db,
                                table,
                                p0,
                              ).sentenceContentItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.contentItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (unitItemsRefs)
                        await $_getPrefetchedData<
                          ContentItem,
                          ContentItems,
                          UnitItem
                        >(
                          currentTable: table,
                          referencedTable: $ContentItemsReferences
                              ._unitItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $ContentItemsReferences(
                                db,
                                table,
                                p0,
                              ).unitItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.contentItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (srsCardsRefs)
                        await $_getPrefetchedData<
                          ContentItem,
                          ContentItems,
                          SrsCard
                        >(
                          currentTable: table,
                          referencedTable: $ContentItemsReferences
                              ._srsCardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $ContentItemsReferences(
                                db,
                                table,
                                p0,
                              ).srsCardsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.contentItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (userVocabRefs)
                        await $_getPrefetchedData<
                          ContentItem,
                          ContentItems,
                          UserVocabData
                        >(
                          currentTable: table,
                          referencedTable: $ContentItemsReferences
                              ._userVocabRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $ContentItemsReferences(
                                db,
                                table,
                                p0,
                              ).userVocabRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.contentItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $ContentItemsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      ContentItems,
      ContentItem,
      $ContentItemsFilterComposer,
      $ContentItemsOrderingComposer,
      $ContentItemsAnnotationComposer,
      $ContentItemsCreateCompanionBuilder,
      $ContentItemsUpdateCompanionBuilder,
      (ContentItem, $ContentItemsReferences),
      ContentItem,
      PrefetchHooks Function({
        bool kanaRefs,
        bool kanjiRefs,
        bool wordsRefs,
        bool particlesRefs,
        bool grammarPointsRefs,
        bool sentenceContentItemsRefs,
        bool unitItemsRefs,
        bool srsCardsRefs,
        bool userVocabRefs,
      })
    >;
typedef $KanaCreateCompanionBuilder = KanaCompanion Function({
  Value<int> contentItemId,
  required String script,
  required String char,
  required String romaji,
  Value<String?> gojuonRow,
  Value<String?> variant,
  Value<String?> audioUrl,
  Value<String?> strokeData,
  Value<int?> sortOrder,
});
typedef $KanaUpdateCompanionBuilder = KanaCompanion Function({
  Value<int> contentItemId,
  Value<String> script,
  Value<String> char,
  Value<String> romaji,
  Value<String?> gojuonRow,
  Value<String?> variant,
  Value<String?> audioUrl,
  Value<String?> strokeData,
  Value<int?> sortOrder,
});

final class $KanaReferences
    extends BaseReferences<_$AppDatabase, Kana, KanaData> {
  $KanaReferences(super.$_db, super.$_table, super.$_typedResult);

  static ContentItems _contentItemIdTable(_$AppDatabase db) =>
      db.contentItems.createAlias('kana__content_item_id__content_items__id');

  $ContentItemsProcessedTableManager get contentItemId {
    final $_column = $_itemColumn<int>('content_item_id')!;

    final manager = $ContentItemsTableManager(
      $_db,
      $_db.contentItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contentItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $KanaFilterComposer extends Composer<_$AppDatabase, Kana> {
  $KanaFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get script => $composableBuilder(
    column: $table.script,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get char => $composableBuilder(
    column: $table.char,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get romaji => $composableBuilder(
    column: $table.romaji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gojuonRow => $composableBuilder(
    column: $table.gojuonRow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variant => $composableBuilder(
    column: $table.variant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get strokeData => $composableBuilder(
    column: $table.strokeData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $ContentItemsFilterComposer get contentItemId {
    final $ContentItemsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsFilterComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $KanaOrderingComposer extends Composer<_$AppDatabase, Kana> {
  $KanaOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get script => $composableBuilder(
    column: $table.script,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get char => $composableBuilder(
    column: $table.char,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get romaji => $composableBuilder(
    column: $table.romaji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gojuonRow => $composableBuilder(
    column: $table.gojuonRow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variant => $composableBuilder(
    column: $table.variant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strokeData => $composableBuilder(
    column: $table.strokeData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $ContentItemsOrderingComposer get contentItemId {
    final $ContentItemsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsOrderingComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $KanaAnnotationComposer extends Composer<_$AppDatabase, Kana> {
  $KanaAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get script =>
      $composableBuilder(column: $table.script, builder: (column) => column);

  GeneratedColumn<String> get char =>
      $composableBuilder(column: $table.char, builder: (column) => column);

  GeneratedColumn<String> get romaji =>
      $composableBuilder(column: $table.romaji, builder: (column) => column);

  GeneratedColumn<String> get gojuonRow =>
      $composableBuilder(column: $table.gojuonRow, builder: (column) => column);

  GeneratedColumn<String> get variant =>
      $composableBuilder(column: $table.variant, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<String> get strokeData => $composableBuilder(
    column: $table.strokeData,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $ContentItemsAnnotationComposer get contentItemId {
    final $ContentItemsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsAnnotationComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $KanaTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Kana,
          KanaData,
          $KanaFilterComposer,
          $KanaOrderingComposer,
          $KanaAnnotationComposer,
          $KanaCreateCompanionBuilder,
          $KanaUpdateCompanionBuilder,
          (KanaData, $KanaReferences),
          KanaData,
          PrefetchHooks Function({bool contentItemId})
        > {
  $KanaTableManager(_$AppDatabase db, Kana table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $KanaFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $KanaOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $KanaAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> contentItemId = const Value.absent(),
                Value<String> script = const Value.absent(),
                Value<String> char = const Value.absent(),
                Value<String> romaji = const Value.absent(),
                Value<String?> gojuonRow = const Value.absent(),
                Value<String?> variant = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<String?> strokeData = const Value.absent(),
                Value<int?> sortOrder = const Value.absent(),
              }) => KanaCompanion(
                contentItemId: contentItemId,
                script: script,
                char: char,
                romaji: romaji,
                gojuonRow: gojuonRow,
                variant: variant,
                audioUrl: audioUrl,
                strokeData: strokeData,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> contentItemId = const Value.absent(),
                required String script,
                required String char,
                required String romaji,
                Value<String?> gojuonRow = const Value.absent(),
                Value<String?> variant = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<String?> strokeData = const Value.absent(),
                Value<int?> sortOrder = const Value.absent(),
              }) => KanaCompanion.insert(
                contentItemId: contentItemId,
                script: script,
                char: char,
                romaji: romaji,
                gojuonRow: gojuonRow,
                variant: variant,
                audioUrl: audioUrl,
                strokeData: strokeData,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Kana, KanaData>(table),
                  $KanaReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({contentItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (contentItemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.contentItemId,
                        referencedTable: $KanaReferences._contentItemIdTable(
                          db,
                        ),
                        referencedColumn: $KanaReferences
                            ._contentItemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $KanaProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Kana,
      KanaData,
      $KanaFilterComposer,
      $KanaOrderingComposer,
      $KanaAnnotationComposer,
      $KanaCreateCompanionBuilder,
      $KanaUpdateCompanionBuilder,
      (KanaData, $KanaReferences),
      KanaData,
      PrefetchHooks Function({bool contentItemId})
    >;
typedef $RadicalsCreateCompanionBuilder = RadicalsCompanion Function({
  Value<int> id,
  required String char,
  required String meaningRu,
  Value<int?> strokeCount,
  Value<String?> mnemonic,
  Value<String?> strokeData,
});
typedef $RadicalsUpdateCompanionBuilder = RadicalsCompanion Function({
  Value<int> id,
  Value<String> char,
  Value<String> meaningRu,
  Value<int?> strokeCount,
  Value<String?> mnemonic,
  Value<String?> strokeData,
});

final class $RadicalsReferences
    extends BaseReferences<_$AppDatabase, Radicals, Radical> {
  $RadicalsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<KanjiRadicals, List<KanjiRadical>>
  _kanjiRadicalsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.kanjiRadicals,
    aliasName: 'radicals__id__kanji_radicals__radical_id',
  );

  $KanjiRadicalsProcessedTableManager get kanjiRadicalsRefs {
    final manager = $KanjiRadicalsTableManager(
      $_db,
      $_db.kanjiRadicals,
    ).filter((f) => f.radicalId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_kanjiRadicalsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $RadicalsFilterComposer extends Composer<_$AppDatabase, Radicals> {
  $RadicalsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get char => $composableBuilder(
    column: $table.char,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaningRu => $composableBuilder(
    column: $table.meaningRu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get strokeCount => $composableBuilder(
    column: $table.strokeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mnemonic => $composableBuilder(
    column: $table.mnemonic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get strokeData => $composableBuilder(
    column: $table.strokeData,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> kanjiRadicalsRefs(
    Expression<bool> Function($KanjiRadicalsFilterComposer f) f,
  ) {
    final $KanjiRadicalsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kanjiRadicals,
      getReferencedColumn: (t) => t.radicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $KanjiRadicalsFilterComposer(
            $db: $db,
            $table: $db.kanjiRadicals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $RadicalsOrderingComposer extends Composer<_$AppDatabase, Radicals> {
  $RadicalsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get char => $composableBuilder(
    column: $table.char,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaningRu => $composableBuilder(
    column: $table.meaningRu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get strokeCount => $composableBuilder(
    column: $table.strokeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mnemonic => $composableBuilder(
    column: $table.mnemonic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strokeData => $composableBuilder(
    column: $table.strokeData,
    builder: (column) => ColumnOrderings(column),
  );
}

class $RadicalsAnnotationComposer extends Composer<_$AppDatabase, Radicals> {
  $RadicalsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get char =>
      $composableBuilder(column: $table.char, builder: (column) => column);

  GeneratedColumn<String> get meaningRu =>
      $composableBuilder(column: $table.meaningRu, builder: (column) => column);

  GeneratedColumn<int> get strokeCount => $composableBuilder(
    column: $table.strokeCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mnemonic =>
      $composableBuilder(column: $table.mnemonic, builder: (column) => column);

  GeneratedColumn<String> get strokeData => $composableBuilder(
    column: $table.strokeData,
    builder: (column) => column,
  );

  Expression<T> kanjiRadicalsRefs<T extends Object>(
    Expression<T> Function($KanjiRadicalsAnnotationComposer a) f,
  ) {
    final $KanjiRadicalsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kanjiRadicals,
      getReferencedColumn: (t) => t.radicalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $KanjiRadicalsAnnotationComposer(
            $db: $db,
            $table: $db.kanjiRadicals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $RadicalsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Radicals,
          Radical,
          $RadicalsFilterComposer,
          $RadicalsOrderingComposer,
          $RadicalsAnnotationComposer,
          $RadicalsCreateCompanionBuilder,
          $RadicalsUpdateCompanionBuilder,
          (Radical, $RadicalsReferences),
          Radical,
          PrefetchHooks Function({bool kanjiRadicalsRefs})
        > {
  $RadicalsTableManager(_$AppDatabase db, Radicals table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $RadicalsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $RadicalsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $RadicalsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> char = const Value.absent(),
                Value<String> meaningRu = const Value.absent(),
                Value<int?> strokeCount = const Value.absent(),
                Value<String?> mnemonic = const Value.absent(),
                Value<String?> strokeData = const Value.absent(),
              }) => RadicalsCompanion(
                id: id,
                char: char,
                meaningRu: meaningRu,
                strokeCount: strokeCount,
                mnemonic: mnemonic,
                strokeData: strokeData,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String char,
                required String meaningRu,
                Value<int?> strokeCount = const Value.absent(),
                Value<String?> mnemonic = const Value.absent(),
                Value<String?> strokeData = const Value.absent(),
              }) => RadicalsCompanion.insert(
                id: id,
                char: char,
                meaningRu: meaningRu,
                strokeCount: strokeCount,
                mnemonic: mnemonic,
                strokeData: strokeData,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Radicals, Radical>(table),
                  $RadicalsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({kanjiRadicalsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (kanjiRadicalsRefs) db.kanjiRadicals,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (kanjiRadicalsRefs)
                    await $_getPrefetchedData<Radical, Radicals, KanjiRadical>(
                      currentTable: table,
                      referencedTable: $RadicalsReferences
                          ._kanjiRadicalsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $RadicalsReferences(db, table, p0).kanjiRadicalsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.radicalId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $RadicalsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Radicals,
      Radical,
      $RadicalsFilterComposer,
      $RadicalsOrderingComposer,
      $RadicalsAnnotationComposer,
      $RadicalsCreateCompanionBuilder,
      $RadicalsUpdateCompanionBuilder,
      (Radical, $RadicalsReferences),
      Radical,
      PrefetchHooks Function({bool kanjiRadicalsRefs})
    >;
typedef $KanjiCreateCompanionBuilder = KanjiCompanion Function({
  Value<int> contentItemId,
  required String char,
  required String meaningsRu,
  Value<String?> onYomi,
  Value<String?> kunYomi,
  Value<int?> joyoGrade,
  Value<int?> strokeCount,
  Value<String?> mnemonic,
  Value<String?> strokeData,
});
typedef $KanjiUpdateCompanionBuilder = KanjiCompanion Function({
  Value<int> contentItemId,
  Value<String> char,
  Value<String> meaningsRu,
  Value<String?> onYomi,
  Value<String?> kunYomi,
  Value<int?> joyoGrade,
  Value<int?> strokeCount,
  Value<String?> mnemonic,
  Value<String?> strokeData,
});

final class $KanjiReferences
    extends BaseReferences<_$AppDatabase, Kanji, KanjiData> {
  $KanjiReferences(super.$_db, super.$_table, super.$_typedResult);

  static ContentItems _contentItemIdTable(_$AppDatabase db) =>
      db.contentItems.createAlias('kanji__content_item_id__content_items__id');

  $ContentItemsProcessedTableManager get contentItemId {
    final $_column = $_itemColumn<int>('content_item_id')!;

    final manager = $ContentItemsTableManager(
      $_db,
      $_db.contentItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contentItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $KanjiFilterComposer extends Composer<_$AppDatabase, Kanji> {
  $KanjiFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get char => $composableBuilder(
    column: $table.char,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaningsRu => $composableBuilder(
    column: $table.meaningsRu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get onYomi => $composableBuilder(
    column: $table.onYomi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kunYomi => $composableBuilder(
    column: $table.kunYomi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get joyoGrade => $composableBuilder(
    column: $table.joyoGrade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get strokeCount => $composableBuilder(
    column: $table.strokeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mnemonic => $composableBuilder(
    column: $table.mnemonic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get strokeData => $composableBuilder(
    column: $table.strokeData,
    builder: (column) => ColumnFilters(column),
  );

  $ContentItemsFilterComposer get contentItemId {
    final $ContentItemsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsFilterComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $KanjiOrderingComposer extends Composer<_$AppDatabase, Kanji> {
  $KanjiOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get char => $composableBuilder(
    column: $table.char,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaningsRu => $composableBuilder(
    column: $table.meaningsRu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get onYomi => $composableBuilder(
    column: $table.onYomi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kunYomi => $composableBuilder(
    column: $table.kunYomi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get joyoGrade => $composableBuilder(
    column: $table.joyoGrade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get strokeCount => $composableBuilder(
    column: $table.strokeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mnemonic => $composableBuilder(
    column: $table.mnemonic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strokeData => $composableBuilder(
    column: $table.strokeData,
    builder: (column) => ColumnOrderings(column),
  );

  $ContentItemsOrderingComposer get contentItemId {
    final $ContentItemsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsOrderingComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $KanjiAnnotationComposer extends Composer<_$AppDatabase, Kanji> {
  $KanjiAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get char =>
      $composableBuilder(column: $table.char, builder: (column) => column);

  GeneratedColumn<String> get meaningsRu => $composableBuilder(
    column: $table.meaningsRu,
    builder: (column) => column,
  );

  GeneratedColumn<String> get onYomi =>
      $composableBuilder(column: $table.onYomi, builder: (column) => column);

  GeneratedColumn<String> get kunYomi =>
      $composableBuilder(column: $table.kunYomi, builder: (column) => column);

  GeneratedColumn<int> get joyoGrade =>
      $composableBuilder(column: $table.joyoGrade, builder: (column) => column);

  GeneratedColumn<int> get strokeCount => $composableBuilder(
    column: $table.strokeCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mnemonic =>
      $composableBuilder(column: $table.mnemonic, builder: (column) => column);

  GeneratedColumn<String> get strokeData => $composableBuilder(
    column: $table.strokeData,
    builder: (column) => column,
  );

  $ContentItemsAnnotationComposer get contentItemId {
    final $ContentItemsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsAnnotationComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $KanjiTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Kanji,
          KanjiData,
          $KanjiFilterComposer,
          $KanjiOrderingComposer,
          $KanjiAnnotationComposer,
          $KanjiCreateCompanionBuilder,
          $KanjiUpdateCompanionBuilder,
          (KanjiData, $KanjiReferences),
          KanjiData,
          PrefetchHooks Function({bool contentItemId})
        > {
  $KanjiTableManager(_$AppDatabase db, Kanji table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $KanjiFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $KanjiOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $KanjiAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> contentItemId = const Value.absent(),
                Value<String> char = const Value.absent(),
                Value<String> meaningsRu = const Value.absent(),
                Value<String?> onYomi = const Value.absent(),
                Value<String?> kunYomi = const Value.absent(),
                Value<int?> joyoGrade = const Value.absent(),
                Value<int?> strokeCount = const Value.absent(),
                Value<String?> mnemonic = const Value.absent(),
                Value<String?> strokeData = const Value.absent(),
              }) => KanjiCompanion(
                contentItemId: contentItemId,
                char: char,
                meaningsRu: meaningsRu,
                onYomi: onYomi,
                kunYomi: kunYomi,
                joyoGrade: joyoGrade,
                strokeCount: strokeCount,
                mnemonic: mnemonic,
                strokeData: strokeData,
              ),
          createCompanionCallback:
              ({
                Value<int> contentItemId = const Value.absent(),
                required String char,
                required String meaningsRu,
                Value<String?> onYomi = const Value.absent(),
                Value<String?> kunYomi = const Value.absent(),
                Value<int?> joyoGrade = const Value.absent(),
                Value<int?> strokeCount = const Value.absent(),
                Value<String?> mnemonic = const Value.absent(),
                Value<String?> strokeData = const Value.absent(),
              }) => KanjiCompanion.insert(
                contentItemId: contentItemId,
                char: char,
                meaningsRu: meaningsRu,
                onYomi: onYomi,
                kunYomi: kunYomi,
                joyoGrade: joyoGrade,
                strokeCount: strokeCount,
                mnemonic: mnemonic,
                strokeData: strokeData,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Kanji, KanjiData>(table),
                  $KanjiReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({contentItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (contentItemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.contentItemId,
                        referencedTable: $KanjiReferences._contentItemIdTable(
                          db,
                        ),
                        referencedColumn: $KanjiReferences
                            ._contentItemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $KanjiProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Kanji,
      KanjiData,
      $KanjiFilterComposer,
      $KanjiOrderingComposer,
      $KanjiAnnotationComposer,
      $KanjiCreateCompanionBuilder,
      $KanjiUpdateCompanionBuilder,
      (KanjiData, $KanjiReferences),
      KanjiData,
      PrefetchHooks Function({bool contentItemId})
    >;
typedef $KanjiRadicalsCreateCompanionBuilder = KanjiRadicalsCompanion Function({
  required int contentItemId,
  required int radicalId,
  Value<String?> position,
  Value<int> rowid,
});
typedef $KanjiRadicalsUpdateCompanionBuilder = KanjiRadicalsCompanion Function({
  Value<int> contentItemId,
  Value<int> radicalId,
  Value<String?> position,
  Value<int> rowid,
});

final class $KanjiRadicalsReferences
    extends BaseReferences<_$AppDatabase, KanjiRadicals, KanjiRadical> {
  $KanjiRadicalsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Radicals _radicalIdTable(_$AppDatabase db) =>
      db.radicals.createAlias('kanji_radicals__radical_id__radicals__id');

  $RadicalsProcessedTableManager get radicalId {
    final $_column = $_itemColumn<int>('radical_id')!;

    final manager = $RadicalsTableManager(
      $_db,
      $_db.radicals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_radicalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $KanjiRadicalsFilterComposer
    extends Composer<_$AppDatabase, KanjiRadicals> {
  $KanjiRadicalsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $RadicalsFilterComposer get radicalId {
    final $RadicalsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.radicalId,
      referencedTable: $db.radicals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RadicalsFilterComposer(
            $db: $db,
            $table: $db.radicals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $KanjiRadicalsOrderingComposer
    extends Composer<_$AppDatabase, KanjiRadicals> {
  $KanjiRadicalsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $RadicalsOrderingComposer get radicalId {
    final $RadicalsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.radicalId,
      referencedTable: $db.radicals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RadicalsOrderingComposer(
            $db: $db,
            $table: $db.radicals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $KanjiRadicalsAnnotationComposer
    extends Composer<_$AppDatabase, KanjiRadicals> {
  $KanjiRadicalsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $RadicalsAnnotationComposer get radicalId {
    final $RadicalsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.radicalId,
      referencedTable: $db.radicals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RadicalsAnnotationComposer(
            $db: $db,
            $table: $db.radicals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $KanjiRadicalsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          KanjiRadicals,
          KanjiRadical,
          $KanjiRadicalsFilterComposer,
          $KanjiRadicalsOrderingComposer,
          $KanjiRadicalsAnnotationComposer,
          $KanjiRadicalsCreateCompanionBuilder,
          $KanjiRadicalsUpdateCompanionBuilder,
          (KanjiRadical, $KanjiRadicalsReferences),
          KanjiRadical,
          PrefetchHooks Function({bool radicalId})
        > {
  $KanjiRadicalsTableManager(_$AppDatabase db, KanjiRadicals table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $KanjiRadicalsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $KanjiRadicalsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $KanjiRadicalsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> contentItemId = const Value.absent(),
                Value<int> radicalId = const Value.absent(),
                Value<String?> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KanjiRadicalsCompanion(
                contentItemId: contentItemId,
                radicalId: radicalId,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int contentItemId,
                required int radicalId,
                Value<String?> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KanjiRadicalsCompanion.insert(
                contentItemId: contentItemId,
                radicalId: radicalId,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<KanjiRadicals, KanjiRadical>(table),
                  $KanjiRadicalsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({radicalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (radicalId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.radicalId,
                        referencedTable: $KanjiRadicalsReferences
                            ._radicalIdTable(db),
                        referencedColumn: $KanjiRadicalsReferences
                            ._radicalIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $KanjiRadicalsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      KanjiRadicals,
      KanjiRadical,
      $KanjiRadicalsFilterComposer,
      $KanjiRadicalsOrderingComposer,
      $KanjiRadicalsAnnotationComposer,
      $KanjiRadicalsCreateCompanionBuilder,
      $KanjiRadicalsUpdateCompanionBuilder,
      (KanjiRadical, $KanjiRadicalsReferences),
      KanjiRadical,
      PrefetchHooks Function({bool radicalId})
    >;
typedef $WordsCreateCompanionBuilder = WordsCompanion Function({
  Value<int> contentItemId,
  required String surfaceForm,
  required String reading,
  required String meaningsRu,
  Value<String?> partOfSpeech,
  Value<int> isKanaOnly,
  Value<int?> pitchAccent,
  Value<String?> audioUrl,
});
typedef $WordsUpdateCompanionBuilder = WordsCompanion Function({
  Value<int> contentItemId,
  Value<String> surfaceForm,
  Value<String> reading,
  Value<String> meaningsRu,
  Value<String?> partOfSpeech,
  Value<int> isKanaOnly,
  Value<int?> pitchAccent,
  Value<String?> audioUrl,
});

final class $WordsReferences
    extends BaseReferences<_$AppDatabase, Words, Word> {
  $WordsReferences(super.$_db, super.$_table, super.$_typedResult);

  static ContentItems _contentItemIdTable(_$AppDatabase db) =>
      db.contentItems.createAlias('words__content_item_id__content_items__id');

  $ContentItemsProcessedTableManager get contentItemId {
    final $_column = $_itemColumn<int>('content_item_id')!;

    final manager = $ContentItemsTableManager(
      $_db,
      $_db.contentItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contentItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $WordsFilterComposer extends Composer<_$AppDatabase, Words> {
  $WordsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get surfaceForm => $composableBuilder(
    column: $table.surfaceForm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reading => $composableBuilder(
    column: $table.reading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaningsRu => $composableBuilder(
    column: $table.meaningsRu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isKanaOnly => $composableBuilder(
    column: $table.isKanaOnly,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pitchAccent => $composableBuilder(
    column: $table.pitchAccent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );

  $ContentItemsFilterComposer get contentItemId {
    final $ContentItemsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsFilterComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $WordsOrderingComposer extends Composer<_$AppDatabase, Words> {
  $WordsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get surfaceForm => $composableBuilder(
    column: $table.surfaceForm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reading => $composableBuilder(
    column: $table.reading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaningsRu => $composableBuilder(
    column: $table.meaningsRu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isKanaOnly => $composableBuilder(
    column: $table.isKanaOnly,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pitchAccent => $composableBuilder(
    column: $table.pitchAccent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );

  $ContentItemsOrderingComposer get contentItemId {
    final $ContentItemsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsOrderingComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $WordsAnnotationComposer extends Composer<_$AppDatabase, Words> {
  $WordsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get surfaceForm => $composableBuilder(
    column: $table.surfaceForm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reading =>
      $composableBuilder(column: $table.reading, builder: (column) => column);

  GeneratedColumn<String> get meaningsRu => $composableBuilder(
    column: $table.meaningsRu,
    builder: (column) => column,
  );

  GeneratedColumn<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isKanaOnly => $composableBuilder(
    column: $table.isKanaOnly,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pitchAccent => $composableBuilder(
    column: $table.pitchAccent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  $ContentItemsAnnotationComposer get contentItemId {
    final $ContentItemsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsAnnotationComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $WordsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Words,
          Word,
          $WordsFilterComposer,
          $WordsOrderingComposer,
          $WordsAnnotationComposer,
          $WordsCreateCompanionBuilder,
          $WordsUpdateCompanionBuilder,
          (Word, $WordsReferences),
          Word,
          PrefetchHooks Function({bool contentItemId})
        > {
  $WordsTableManager(_$AppDatabase db, Words table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $WordsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $WordsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $WordsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> contentItemId = const Value.absent(),
                Value<String> surfaceForm = const Value.absent(),
                Value<String> reading = const Value.absent(),
                Value<String> meaningsRu = const Value.absent(),
                Value<String?> partOfSpeech = const Value.absent(),
                Value<int> isKanaOnly = const Value.absent(),
                Value<int?> pitchAccent = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
              }) => WordsCompanion(
                contentItemId: contentItemId,
                surfaceForm: surfaceForm,
                reading: reading,
                meaningsRu: meaningsRu,
                partOfSpeech: partOfSpeech,
                isKanaOnly: isKanaOnly,
                pitchAccent: pitchAccent,
                audioUrl: audioUrl,
              ),
          createCompanionCallback:
              ({
                Value<int> contentItemId = const Value.absent(),
                required String surfaceForm,
                required String reading,
                required String meaningsRu,
                Value<String?> partOfSpeech = const Value.absent(),
                Value<int> isKanaOnly = const Value.absent(),
                Value<int?> pitchAccent = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
              }) => WordsCompanion.insert(
                contentItemId: contentItemId,
                surfaceForm: surfaceForm,
                reading: reading,
                meaningsRu: meaningsRu,
                partOfSpeech: partOfSpeech,
                isKanaOnly: isKanaOnly,
                pitchAccent: pitchAccent,
                audioUrl: audioUrl,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Words, Word>(table),
                  $WordsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({contentItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (contentItemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.contentItemId,
                        referencedTable: $WordsReferences._contentItemIdTable(
                          db,
                        ),
                        referencedColumn: $WordsReferences
                            ._contentItemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $WordsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Words,
      Word,
      $WordsFilterComposer,
      $WordsOrderingComposer,
      $WordsAnnotationComposer,
      $WordsCreateCompanionBuilder,
      $WordsUpdateCompanionBuilder,
      (Word, $WordsReferences),
      Word,
      PrefetchHooks Function({bool contentItemId})
    >;
typedef $WordKanjiCreateCompanionBuilder = WordKanjiCompanion Function({
  required int wordContentItemId,
  required int kanjiContentItemId,
  required int position,
  Value<int> rowid,
});
typedef $WordKanjiUpdateCompanionBuilder = WordKanjiCompanion Function({
  Value<int> wordContentItemId,
  Value<int> kanjiContentItemId,
  Value<int> position,
  Value<int> rowid,
});

class $WordKanjiFilterComposer extends Composer<_$AppDatabase, WordKanji> {
  $WordKanjiFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $WordKanjiOrderingComposer extends Composer<_$AppDatabase, WordKanji> {
  $WordKanjiOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $WordKanjiAnnotationComposer extends Composer<_$AppDatabase, WordKanji> {
  $WordKanjiAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $WordKanjiTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          WordKanji,
          WordKanjiData,
          $WordKanjiFilterComposer,
          $WordKanjiOrderingComposer,
          $WordKanjiAnnotationComposer,
          $WordKanjiCreateCompanionBuilder,
          $WordKanjiUpdateCompanionBuilder,
          (
            WordKanjiData,
            BaseReferences<_$AppDatabase, WordKanji, WordKanjiData>,
          ),
          WordKanjiData,
          PrefetchHooks Function()
        > {
  $WordKanjiTableManager(_$AppDatabase db, WordKanji table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $WordKanjiFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $WordKanjiOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $WordKanjiAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> wordContentItemId = const Value.absent(),
                Value<int> kanjiContentItemId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WordKanjiCompanion(
                wordContentItemId: wordContentItemId,
                kanjiContentItemId: kanjiContentItemId,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int wordContentItemId,
                required int kanjiContentItemId,
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => WordKanjiCompanion.insert(
                wordContentItemId: wordContentItemId,
                kanjiContentItemId: kanjiContentItemId,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<WordKanji, WordKanjiData>(table),
                  BaseReferences<_$AppDatabase, WordKanji, WordKanjiData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $WordKanjiProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      WordKanji,
      WordKanjiData,
      $WordKanjiFilterComposer,
      $WordKanjiOrderingComposer,
      $WordKanjiAnnotationComposer,
      $WordKanjiCreateCompanionBuilder,
      $WordKanjiUpdateCompanionBuilder,
      (WordKanjiData, BaseReferences<_$AppDatabase, WordKanji, WordKanjiData>),
      WordKanjiData,
      PrefetchHooks Function()
    >;
typedef $WordKanaCreateCompanionBuilder = WordKanaCompanion Function({
  required int wordContentItemId,
  required int kanaContentItemId,
  required int position,
  Value<int> rowid,
});
typedef $WordKanaUpdateCompanionBuilder = WordKanaCompanion Function({
  Value<int> wordContentItemId,
  Value<int> kanaContentItemId,
  Value<int> position,
  Value<int> rowid,
});

class $WordKanaFilterComposer extends Composer<_$AppDatabase, WordKana> {
  $WordKanaFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $WordKanaOrderingComposer extends Composer<_$AppDatabase, WordKana> {
  $WordKanaOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $WordKanaAnnotationComposer extends Composer<_$AppDatabase, WordKana> {
  $WordKanaAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $WordKanaTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          WordKana,
          WordKanaData,
          $WordKanaFilterComposer,
          $WordKanaOrderingComposer,
          $WordKanaAnnotationComposer,
          $WordKanaCreateCompanionBuilder,
          $WordKanaUpdateCompanionBuilder,
          (WordKanaData, BaseReferences<_$AppDatabase, WordKana, WordKanaData>),
          WordKanaData,
          PrefetchHooks Function()
        > {
  $WordKanaTableManager(_$AppDatabase db, WordKana table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $WordKanaFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $WordKanaOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $WordKanaAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> wordContentItemId = const Value.absent(),
                Value<int> kanaContentItemId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WordKanaCompanion(
                wordContentItemId: wordContentItemId,
                kanaContentItemId: kanaContentItemId,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int wordContentItemId,
                required int kanaContentItemId,
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => WordKanaCompanion.insert(
                wordContentItemId: wordContentItemId,
                kanaContentItemId: kanaContentItemId,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<WordKana, WordKanaData>(table),
                  BaseReferences<_$AppDatabase, WordKana, WordKanaData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $WordKanaProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      WordKana,
      WordKanaData,
      $WordKanaFilterComposer,
      $WordKanaOrderingComposer,
      $WordKanaAnnotationComposer,
      $WordKanaCreateCompanionBuilder,
      $WordKanaUpdateCompanionBuilder,
      (WordKanaData, BaseReferences<_$AppDatabase, WordKana, WordKanaData>),
      WordKanaData,
      PrefetchHooks Function()
    >;
typedef $ParticlesCreateCompanionBuilder = ParticlesCompanion Function({
  Value<int> contentItemId,
  required String particle,
  Value<String?> category,
  Value<String?> shortDescription,
  Value<String?> longTheory,
  Value<String?> confusableWith,
});
typedef $ParticlesUpdateCompanionBuilder = ParticlesCompanion Function({
  Value<int> contentItemId,
  Value<String> particle,
  Value<String?> category,
  Value<String?> shortDescription,
  Value<String?> longTheory,
  Value<String?> confusableWith,
});

final class $ParticlesReferences
    extends BaseReferences<_$AppDatabase, Particles, Particle> {
  $ParticlesReferences(super.$_db, super.$_table, super.$_typedResult);

  static ContentItems _contentItemIdTable(_$AppDatabase db) => db.contentItems
      .createAlias('particles__content_item_id__content_items__id');

  $ContentItemsProcessedTableManager get contentItemId {
    final $_column = $_itemColumn<int>('content_item_id')!;

    final manager = $ContentItemsTableManager(
      $_db,
      $_db.contentItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contentItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $ParticlesFilterComposer extends Composer<_$AppDatabase, Particles> {
  $ParticlesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get particle => $composableBuilder(
    column: $table.particle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shortDescription => $composableBuilder(
    column: $table.shortDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get longTheory => $composableBuilder(
    column: $table.longTheory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confusableWith => $composableBuilder(
    column: $table.confusableWith,
    builder: (column) => ColumnFilters(column),
  );

  $ContentItemsFilterComposer get contentItemId {
    final $ContentItemsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsFilterComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $ParticlesOrderingComposer extends Composer<_$AppDatabase, Particles> {
  $ParticlesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get particle => $composableBuilder(
    column: $table.particle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shortDescription => $composableBuilder(
    column: $table.shortDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get longTheory => $composableBuilder(
    column: $table.longTheory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confusableWith => $composableBuilder(
    column: $table.confusableWith,
    builder: (column) => ColumnOrderings(column),
  );

  $ContentItemsOrderingComposer get contentItemId {
    final $ContentItemsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsOrderingComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $ParticlesAnnotationComposer extends Composer<_$AppDatabase, Particles> {
  $ParticlesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get particle =>
      $composableBuilder(column: $table.particle, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get shortDescription => $composableBuilder(
    column: $table.shortDescription,
    builder: (column) => column,
  );

  GeneratedColumn<String> get longTheory => $composableBuilder(
    column: $table.longTheory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get confusableWith => $composableBuilder(
    column: $table.confusableWith,
    builder: (column) => column,
  );

  $ContentItemsAnnotationComposer get contentItemId {
    final $ContentItemsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsAnnotationComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $ParticlesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Particles,
          Particle,
          $ParticlesFilterComposer,
          $ParticlesOrderingComposer,
          $ParticlesAnnotationComposer,
          $ParticlesCreateCompanionBuilder,
          $ParticlesUpdateCompanionBuilder,
          (Particle, $ParticlesReferences),
          Particle,
          PrefetchHooks Function({bool contentItemId})
        > {
  $ParticlesTableManager(_$AppDatabase db, Particles table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ParticlesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ParticlesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ParticlesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> contentItemId = const Value.absent(),
                Value<String> particle = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> shortDescription = const Value.absent(),
                Value<String?> longTheory = const Value.absent(),
                Value<String?> confusableWith = const Value.absent(),
              }) => ParticlesCompanion(
                contentItemId: contentItemId,
                particle: particle,
                category: category,
                shortDescription: shortDescription,
                longTheory: longTheory,
                confusableWith: confusableWith,
              ),
          createCompanionCallback:
              ({
                Value<int> contentItemId = const Value.absent(),
                required String particle,
                Value<String?> category = const Value.absent(),
                Value<String?> shortDescription = const Value.absent(),
                Value<String?> longTheory = const Value.absent(),
                Value<String?> confusableWith = const Value.absent(),
              }) => ParticlesCompanion.insert(
                contentItemId: contentItemId,
                particle: particle,
                category: category,
                shortDescription: shortDescription,
                longTheory: longTheory,
                confusableWith: confusableWith,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Particles, Particle>(table),
                  $ParticlesReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({contentItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (contentItemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.contentItemId,
                        referencedTable: $ParticlesReferences
                            ._contentItemIdTable(db),
                        referencedColumn: $ParticlesReferences
                            ._contentItemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $ParticlesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Particles,
      Particle,
      $ParticlesFilterComposer,
      $ParticlesOrderingComposer,
      $ParticlesAnnotationComposer,
      $ParticlesCreateCompanionBuilder,
      $ParticlesUpdateCompanionBuilder,
      (Particle, $ParticlesReferences),
      Particle,
      PrefetchHooks Function({bool contentItemId})
    >;
typedef $GrammarPointsCreateCompanionBuilder = GrammarPointsCompanion Function({
  Value<int> contentItemId,
  required String title,
  required String pattern,
  required String explanation,
  Value<String?> register,
  Value<String?> relatedGrammarIds,
});
typedef $GrammarPointsUpdateCompanionBuilder = GrammarPointsCompanion Function({
  Value<int> contentItemId,
  Value<String> title,
  Value<String> pattern,
  Value<String> explanation,
  Value<String?> register,
  Value<String?> relatedGrammarIds,
});

final class $GrammarPointsReferences
    extends BaseReferences<_$AppDatabase, GrammarPoints, GrammarPoint> {
  $GrammarPointsReferences(super.$_db, super.$_table, super.$_typedResult);

  static ContentItems _contentItemIdTable(_$AppDatabase db) => db.contentItems
      .createAlias('grammar_points__content_item_id__content_items__id');

  $ContentItemsProcessedTableManager get contentItemId {
    final $_column = $_itemColumn<int>('content_item_id')!;

    final manager = $ContentItemsTableManager(
      $_db,
      $_db.contentItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contentItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $GrammarPointsFilterComposer
    extends Composer<_$AppDatabase, GrammarPoints> {
  $GrammarPointsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get register => $composableBuilder(
    column: $table.register,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relatedGrammarIds => $composableBuilder(
    column: $table.relatedGrammarIds,
    builder: (column) => ColumnFilters(column),
  );

  $ContentItemsFilterComposer get contentItemId {
    final $ContentItemsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsFilterComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $GrammarPointsOrderingComposer
    extends Composer<_$AppDatabase, GrammarPoints> {
  $GrammarPointsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get register => $composableBuilder(
    column: $table.register,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relatedGrammarIds => $composableBuilder(
    column: $table.relatedGrammarIds,
    builder: (column) => ColumnOrderings(column),
  );

  $ContentItemsOrderingComposer get contentItemId {
    final $ContentItemsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsOrderingComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $GrammarPointsAnnotationComposer
    extends Composer<_$AppDatabase, GrammarPoints> {
  $GrammarPointsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get pattern =>
      $composableBuilder(column: $table.pattern, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get register =>
      $composableBuilder(column: $table.register, builder: (column) => column);

  GeneratedColumn<String> get relatedGrammarIds => $composableBuilder(
    column: $table.relatedGrammarIds,
    builder: (column) => column,
  );

  $ContentItemsAnnotationComposer get contentItemId {
    final $ContentItemsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsAnnotationComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $GrammarPointsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          GrammarPoints,
          GrammarPoint,
          $GrammarPointsFilterComposer,
          $GrammarPointsOrderingComposer,
          $GrammarPointsAnnotationComposer,
          $GrammarPointsCreateCompanionBuilder,
          $GrammarPointsUpdateCompanionBuilder,
          (GrammarPoint, $GrammarPointsReferences),
          GrammarPoint,
          PrefetchHooks Function({bool contentItemId})
        > {
  $GrammarPointsTableManager(_$AppDatabase db, GrammarPoints table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $GrammarPointsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $GrammarPointsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $GrammarPointsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> contentItemId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> pattern = const Value.absent(),
                Value<String> explanation = const Value.absent(),
                Value<String?> register = const Value.absent(),
                Value<String?> relatedGrammarIds = const Value.absent(),
              }) => GrammarPointsCompanion(
                contentItemId: contentItemId,
                title: title,
                pattern: pattern,
                explanation: explanation,
                register: register,
                relatedGrammarIds: relatedGrammarIds,
              ),
          createCompanionCallback:
              ({
                Value<int> contentItemId = const Value.absent(),
                required String title,
                required String pattern,
                required String explanation,
                Value<String?> register = const Value.absent(),
                Value<String?> relatedGrammarIds = const Value.absent(),
              }) => GrammarPointsCompanion.insert(
                contentItemId: contentItemId,
                title: title,
                pattern: pattern,
                explanation: explanation,
                register: register,
                relatedGrammarIds: relatedGrammarIds,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<GrammarPoints, GrammarPoint>(table),
                  $GrammarPointsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({contentItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (contentItemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.contentItemId,
                        referencedTable: $GrammarPointsReferences
                            ._contentItemIdTable(db),
                        referencedColumn: $GrammarPointsReferences
                            ._contentItemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $GrammarPointsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      GrammarPoints,
      GrammarPoint,
      $GrammarPointsFilterComposer,
      $GrammarPointsOrderingComposer,
      $GrammarPointsAnnotationComposer,
      $GrammarPointsCreateCompanionBuilder,
      $GrammarPointsUpdateCompanionBuilder,
      (GrammarPoint, $GrammarPointsReferences),
      GrammarPoint,
      PrefetchHooks Function({bool contentItemId})
    >;
typedef $SentencesCreateCompanionBuilder = SentencesCompanion Function({
  Value<int> id,
  required String textJp,
  Value<String?> textFurigana,
  required String textTranslationRu,
  Value<String?> audioUrl,
  Value<String?> jlptLevel,
});
typedef $SentencesUpdateCompanionBuilder = SentencesCompanion Function({
  Value<int> id,
  Value<String> textJp,
  Value<String?> textFurigana,
  Value<String> textTranslationRu,
  Value<String?> audioUrl,
  Value<String?> jlptLevel,
});

final class $SentencesReferences
    extends BaseReferences<_$AppDatabase, Sentences, Sentence> {
  $SentencesReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<SentenceContentItems, List<SentenceContentItem>>
  _sentenceContentItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.sentenceContentItems,
        aliasName: 'sentences__id__sentence_content_items__sentence_id',
      );

  $SentenceContentItemsProcessedTableManager get sentenceContentItemsRefs {
    final manager = $SentenceContentItemsTableManager(
      $_db,
      $_db.sentenceContentItems,
    ).filter((f) => f.sentenceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sentenceContentItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $SentencesFilterComposer extends Composer<_$AppDatabase, Sentences> {
  $SentencesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textJp => $composableBuilder(
    column: $table.textJp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textFurigana => $composableBuilder(
    column: $table.textFurigana,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textTranslationRu => $composableBuilder(
    column: $table.textTranslationRu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jlptLevel => $composableBuilder(
    column: $table.jlptLevel,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sentenceContentItemsRefs(
    Expression<bool> Function($SentenceContentItemsFilterComposer f) f,
  ) {
    final $SentenceContentItemsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sentenceContentItems,
      getReferencedColumn: (t) => t.sentenceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SentenceContentItemsFilterComposer(
            $db: $db,
            $table: $db.sentenceContentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $SentencesOrderingComposer extends Composer<_$AppDatabase, Sentences> {
  $SentencesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textJp => $composableBuilder(
    column: $table.textJp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textFurigana => $composableBuilder(
    column: $table.textFurigana,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textTranslationRu => $composableBuilder(
    column: $table.textTranslationRu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jlptLevel => $composableBuilder(
    column: $table.jlptLevel,
    builder: (column) => ColumnOrderings(column),
  );
}

class $SentencesAnnotationComposer extends Composer<_$AppDatabase, Sentences> {
  $SentencesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get textJp =>
      $composableBuilder(column: $table.textJp, builder: (column) => column);

  GeneratedColumn<String> get textFurigana => $composableBuilder(
    column: $table.textFurigana,
    builder: (column) => column,
  );

  GeneratedColumn<String> get textTranslationRu => $composableBuilder(
    column: $table.textTranslationRu,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<String> get jlptLevel =>
      $composableBuilder(column: $table.jlptLevel, builder: (column) => column);

  Expression<T> sentenceContentItemsRefs<T extends Object>(
    Expression<T> Function($SentenceContentItemsAnnotationComposer a) f,
  ) {
    final $SentenceContentItemsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sentenceContentItems,
      getReferencedColumn: (t) => t.sentenceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SentenceContentItemsAnnotationComposer(
            $db: $db,
            $table: $db.sentenceContentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $SentencesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Sentences,
          Sentence,
          $SentencesFilterComposer,
          $SentencesOrderingComposer,
          $SentencesAnnotationComposer,
          $SentencesCreateCompanionBuilder,
          $SentencesUpdateCompanionBuilder,
          (Sentence, $SentencesReferences),
          Sentence,
          PrefetchHooks Function({bool sentenceContentItemsRefs})
        > {
  $SentencesTableManager(_$AppDatabase db, Sentences table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $SentencesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $SentencesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $SentencesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> textJp = const Value.absent(),
                Value<String?> textFurigana = const Value.absent(),
                Value<String> textTranslationRu = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<String?> jlptLevel = const Value.absent(),
              }) => SentencesCompanion(
                id: id,
                textJp: textJp,
                textFurigana: textFurigana,
                textTranslationRu: textTranslationRu,
                audioUrl: audioUrl,
                jlptLevel: jlptLevel,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String textJp,
                Value<String?> textFurigana = const Value.absent(),
                required String textTranslationRu,
                Value<String?> audioUrl = const Value.absent(),
                Value<String?> jlptLevel = const Value.absent(),
              }) => SentencesCompanion.insert(
                id: id,
                textJp: textJp,
                textFurigana: textFurigana,
                textTranslationRu: textTranslationRu,
                audioUrl: audioUrl,
                jlptLevel: jlptLevel,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Sentences, Sentence>(table),
                  $SentencesReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sentenceContentItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sentenceContentItemsRefs) db.sentenceContentItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sentenceContentItemsRefs)
                    await $_getPrefetchedData<
                      Sentence,
                      Sentences,
                      SentenceContentItem
                    >(
                      currentTable: table,
                      referencedTable: $SentencesReferences
                          ._sentenceContentItemsRefsTable(db),
                      managerFromTypedResult: (p0) => $SentencesReferences(
                        db,
                        table,
                        p0,
                      ).sentenceContentItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sentenceId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $SentencesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Sentences,
      Sentence,
      $SentencesFilterComposer,
      $SentencesOrderingComposer,
      $SentencesAnnotationComposer,
      $SentencesCreateCompanionBuilder,
      $SentencesUpdateCompanionBuilder,
      (Sentence, $SentencesReferences),
      Sentence,
      PrefetchHooks Function({bool sentenceContentItemsRefs})
    >;
typedef $SentenceContentItemsCreateCompanionBuilder =
    SentenceContentItemsCompanion Function({
      required int sentenceId,
      required int contentItemId,
      Value<String?> usageNote,
      Value<int> rowid,
    });
typedef $SentenceContentItemsUpdateCompanionBuilder =
    SentenceContentItemsCompanion Function({
      Value<int> sentenceId,
      Value<int> contentItemId,
      Value<String?> usageNote,
      Value<int> rowid,
    });

final class $SentenceContentItemsReferences
    extends
        BaseReferences<
          _$AppDatabase,
          SentenceContentItems,
          SentenceContentItem
        > {
  $SentenceContentItemsReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static Sentences _sentenceIdTable(_$AppDatabase db) => db.sentences
      .createAlias('sentence_content_items__sentence_id__sentences__id');

  $SentencesProcessedTableManager get sentenceId {
    final $_column = $_itemColumn<int>('sentence_id')!;

    final manager = $SentencesTableManager(
      $_db,
      $_db.sentences,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sentenceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static ContentItems _contentItemIdTable(_$AppDatabase db) =>
      db.contentItems.createAlias(
        'sentence_content_items__content_item_id__content_items__id',
      );

  $ContentItemsProcessedTableManager get contentItemId {
    final $_column = $_itemColumn<int>('content_item_id')!;

    final manager = $ContentItemsTableManager(
      $_db,
      $_db.contentItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contentItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $SentenceContentItemsFilterComposer
    extends Composer<_$AppDatabase, SentenceContentItems> {
  $SentenceContentItemsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get usageNote => $composableBuilder(
    column: $table.usageNote,
    builder: (column) => ColumnFilters(column),
  );

  $SentencesFilterComposer get sentenceId {
    final $SentencesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sentenceId,
      referencedTable: $db.sentences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SentencesFilterComposer(
            $db: $db,
            $table: $db.sentences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ContentItemsFilterComposer get contentItemId {
    final $ContentItemsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsFilterComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $SentenceContentItemsOrderingComposer
    extends Composer<_$AppDatabase, SentenceContentItems> {
  $SentenceContentItemsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get usageNote => $composableBuilder(
    column: $table.usageNote,
    builder: (column) => ColumnOrderings(column),
  );

  $SentencesOrderingComposer get sentenceId {
    final $SentencesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sentenceId,
      referencedTable: $db.sentences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SentencesOrderingComposer(
            $db: $db,
            $table: $db.sentences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ContentItemsOrderingComposer get contentItemId {
    final $ContentItemsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsOrderingComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $SentenceContentItemsAnnotationComposer
    extends Composer<_$AppDatabase, SentenceContentItems> {
  $SentenceContentItemsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get usageNote =>
      $composableBuilder(column: $table.usageNote, builder: (column) => column);

  $SentencesAnnotationComposer get sentenceId {
    final $SentencesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sentenceId,
      referencedTable: $db.sentences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SentencesAnnotationComposer(
            $db: $db,
            $table: $db.sentences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ContentItemsAnnotationComposer get contentItemId {
    final $ContentItemsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsAnnotationComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $SentenceContentItemsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          SentenceContentItems,
          SentenceContentItem,
          $SentenceContentItemsFilterComposer,
          $SentenceContentItemsOrderingComposer,
          $SentenceContentItemsAnnotationComposer,
          $SentenceContentItemsCreateCompanionBuilder,
          $SentenceContentItemsUpdateCompanionBuilder,
          (SentenceContentItem, $SentenceContentItemsReferences),
          SentenceContentItem,
          PrefetchHooks Function({bool sentenceId, bool contentItemId})
        > {
  $SentenceContentItemsTableManager(
    _$AppDatabase db,
    SentenceContentItems table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $SentenceContentItemsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $SentenceContentItemsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $SentenceContentItemsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> sentenceId = const Value.absent(),
                Value<int> contentItemId = const Value.absent(),
                Value<String?> usageNote = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SentenceContentItemsCompanion(
                sentenceId: sentenceId,
                contentItemId: contentItemId,
                usageNote: usageNote,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int sentenceId,
                required int contentItemId,
                Value<String?> usageNote = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SentenceContentItemsCompanion.insert(
                sentenceId: sentenceId,
                contentItemId: contentItemId,
                usageNote: usageNote,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<SentenceContentItems, SentenceContentItem>(table),
                  $SentenceContentItemsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sentenceId = false, contentItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sentenceId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sentenceId,
                        referencedTable: $SentenceContentItemsReferences
                            ._sentenceIdTable(db),
                        referencedColumn: $SentenceContentItemsReferences
                            ._sentenceIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (contentItemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.contentItemId,
                        referencedTable: $SentenceContentItemsReferences
                            ._contentItemIdTable(db),
                        referencedColumn: $SentenceContentItemsReferences
                            ._contentItemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $SentenceContentItemsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      SentenceContentItems,
      SentenceContentItem,
      $SentenceContentItemsFilterComposer,
      $SentenceContentItemsOrderingComposer,
      $SentenceContentItemsAnnotationComposer,
      $SentenceContentItemsCreateCompanionBuilder,
      $SentenceContentItemsUpdateCompanionBuilder,
      (SentenceContentItem, $SentenceContentItemsReferences),
      SentenceContentItem,
      PrefetchHooks Function({bool sentenceId, bool contentItemId})
    >;
typedef $ExerciseTypesCreateCompanionBuilder = ExerciseTypesCompanion Function({
  required String code,
  required String pillar,
  required String labelRu,
  Value<int> rowid,
});
typedef $ExerciseTypesUpdateCompanionBuilder = ExerciseTypesCompanion Function({
  Value<String> code,
  Value<String> pillar,
  Value<String> labelRu,
  Value<int> rowid,
});

final class $ExerciseTypesReferences
    extends BaseReferences<_$AppDatabase, ExerciseTypes, ExerciseType> {
  $ExerciseTypesReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<SrsCards, List<SrsCard>> _srsCardsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.srsCards,
    aliasName: 'exercise_types__code__srs_cards__exercise_type',
  );

  $SrsCardsProcessedTableManager get srsCardsRefs {
    final manager = $SrsCardsTableManager($_db, $_db.srsCards).filter(
      (f) => f.exerciseType.code.sqlEquals($_itemColumn<String>('code')!),
    );

    final cache = $_typedResult.readTableOrNull(_srsCardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $ExerciseTypesFilterComposer
    extends Composer<_$AppDatabase, ExerciseTypes> {
  $ExerciseTypesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pillar => $composableBuilder(
    column: $table.pillar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get labelRu => $composableBuilder(
    column: $table.labelRu,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> srsCardsRefs(
    Expression<bool> Function($SrsCardsFilterComposer f) f,
  ) {
    final $SrsCardsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.srsCards,
      getReferencedColumn: (t) => t.exerciseType,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SrsCardsFilterComposer(
            $db: $db,
            $table: $db.srsCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $ExerciseTypesOrderingComposer
    extends Composer<_$AppDatabase, ExerciseTypes> {
  $ExerciseTypesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pillar => $composableBuilder(
    column: $table.pillar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get labelRu => $composableBuilder(
    column: $table.labelRu,
    builder: (column) => ColumnOrderings(column),
  );
}

class $ExerciseTypesAnnotationComposer
    extends Composer<_$AppDatabase, ExerciseTypes> {
  $ExerciseTypesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get pillar =>
      $composableBuilder(column: $table.pillar, builder: (column) => column);

  GeneratedColumn<String> get labelRu =>
      $composableBuilder(column: $table.labelRu, builder: (column) => column);

  Expression<T> srsCardsRefs<T extends Object>(
    Expression<T> Function($SrsCardsAnnotationComposer a) f,
  ) {
    final $SrsCardsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.srsCards,
      getReferencedColumn: (t) => t.exerciseType,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SrsCardsAnnotationComposer(
            $db: $db,
            $table: $db.srsCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $ExerciseTypesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          ExerciseTypes,
          ExerciseType,
          $ExerciseTypesFilterComposer,
          $ExerciseTypesOrderingComposer,
          $ExerciseTypesAnnotationComposer,
          $ExerciseTypesCreateCompanionBuilder,
          $ExerciseTypesUpdateCompanionBuilder,
          (ExerciseType, $ExerciseTypesReferences),
          ExerciseType,
          PrefetchHooks Function({bool srsCardsRefs})
        > {
  $ExerciseTypesTableManager(_$AppDatabase db, ExerciseTypes table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ExerciseTypesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ExerciseTypesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ExerciseTypesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> code = const Value.absent(),
                Value<String> pillar = const Value.absent(),
                Value<String> labelRu = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseTypesCompanion(
                code: code,
                pillar: pillar,
                labelRu: labelRu,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String code,
                required String pillar,
                required String labelRu,
                Value<int> rowid = const Value.absent(),
              }) => ExerciseTypesCompanion.insert(
                code: code,
                pillar: pillar,
                labelRu: labelRu,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<ExerciseTypes, ExerciseType>(table),
                  $ExerciseTypesReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({srsCardsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (srsCardsRefs) db.srsCards],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (srsCardsRefs)
                    await $_getPrefetchedData<
                      ExerciseType,
                      ExerciseTypes,
                      SrsCard
                    >(
                      currentTable: table,
                      referencedTable: $ExerciseTypesReferences
                          ._srsCardsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $ExerciseTypesReferences(db, table, p0).srsCardsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.exerciseType == item.code,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $ExerciseTypesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      ExerciseTypes,
      ExerciseType,
      $ExerciseTypesFilterComposer,
      $ExerciseTypesOrderingComposer,
      $ExerciseTypesAnnotationComposer,
      $ExerciseTypesCreateCompanionBuilder,
      $ExerciseTypesUpdateCompanionBuilder,
      (ExerciseType, $ExerciseTypesReferences),
      ExerciseType,
      PrefetchHooks Function({bool srsCardsRefs})
    >;
typedef $UnitsCreateCompanionBuilder = UnitsCompanion Function({
  Value<int> id,
  required String title,
  Value<String?> subtitle,
  required String kind,
  Value<String?> jlptLevel,
  required int sortOrder,
  Value<String?> description,
});
typedef $UnitsUpdateCompanionBuilder = UnitsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String?> subtitle,
  Value<String> kind,
  Value<String?> jlptLevel,
  Value<int> sortOrder,
  Value<String?> description,
});

final class $UnitsReferences
    extends BaseReferences<_$AppDatabase, Units, Unit> {
  $UnitsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<UnitItems, List<UnitItem>> _unitItemsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.unitItems,
    aliasName: 'units__id__unit_items__unit_id',
  );

  $UnitItemsProcessedTableManager get unitItemsRefs {
    final manager = $UnitItemsTableManager(
      $_db,
      $_db.unitItems,
    ).filter((f) => f.unitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_unitItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<UnitProgress, List<UnitProgressData>>
  _unitProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.unitProgress,
    aliasName: 'units__id__unit_progress__unit_id',
  );

  $UnitProgressProcessedTableManager get unitProgressRefs {
    final manager = $UnitProgressTableManager(
      $_db,
      $_db.unitProgress,
    ).filter((f) => f.unitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_unitProgressRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $UnitsFilterComposer extends Composer<_$AppDatabase, Units> {
  $UnitsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jlptLevel => $composableBuilder(
    column: $table.jlptLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> unitItemsRefs(
    Expression<bool> Function($UnitItemsFilterComposer f) f,
  ) {
    final $UnitItemsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.unitItems,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UnitItemsFilterComposer(
            $db: $db,
            $table: $db.unitItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> unitProgressRefs(
    Expression<bool> Function($UnitProgressFilterComposer f) f,
  ) {
    final $UnitProgressFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.unitProgress,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UnitProgressFilterComposer(
            $db: $db,
            $table: $db.unitProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $UnitsOrderingComposer extends Composer<_$AppDatabase, Units> {
  $UnitsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jlptLevel => $composableBuilder(
    column: $table.jlptLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $UnitsAnnotationComposer extends Composer<_$AppDatabase, Units> {
  $UnitsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get jlptLevel =>
      $composableBuilder(column: $table.jlptLevel, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  Expression<T> unitItemsRefs<T extends Object>(
    Expression<T> Function($UnitItemsAnnotationComposer a) f,
  ) {
    final $UnitItemsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.unitItems,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UnitItemsAnnotationComposer(
            $db: $db,
            $table: $db.unitItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> unitProgressRefs<T extends Object>(
    Expression<T> Function($UnitProgressAnnotationComposer a) f,
  ) {
    final $UnitProgressAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.unitProgress,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UnitProgressAnnotationComposer(
            $db: $db,
            $table: $db.unitProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $UnitsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Units,
          Unit,
          $UnitsFilterComposer,
          $UnitsOrderingComposer,
          $UnitsAnnotationComposer,
          $UnitsCreateCompanionBuilder,
          $UnitsUpdateCompanionBuilder,
          (Unit, $UnitsReferences),
          Unit,
          PrefetchHooks Function({bool unitItemsRefs, bool unitProgressRefs})
        > {
  $UnitsTableManager(_$AppDatabase db, Units table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $UnitsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $UnitsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $UnitsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> subtitle = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> jlptLevel = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> description = const Value.absent(),
              }) => UnitsCompanion(
                id: id,
                title: title,
                subtitle: subtitle,
                kind: kind,
                jlptLevel: jlptLevel,
                sortOrder: sortOrder,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> subtitle = const Value.absent(),
                required String kind,
                Value<String?> jlptLevel = const Value.absent(),
                required int sortOrder,
                Value<String?> description = const Value.absent(),
              }) => UnitsCompanion.insert(
                id: id,
                title: title,
                subtitle: subtitle,
                kind: kind,
                jlptLevel: jlptLevel,
                sortOrder: sortOrder,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Units, Unit>(table),
                  $UnitsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({unitItemsRefs = false, unitProgressRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (unitItemsRefs) db.unitItems,
                    if (unitProgressRefs) db.unitProgress,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (unitItemsRefs)
                        await $_getPrefetchedData<Unit, Units, UnitItem>(
                          currentTable: table,
                          referencedTable: $UnitsReferences._unitItemsRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $UnitsReferences(db, table, p0).unitItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.unitId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (unitProgressRefs)
                        await $_getPrefetchedData<
                          Unit,
                          Units,
                          UnitProgressData
                        >(
                          currentTable: table,
                          referencedTable: $UnitsReferences
                              ._unitProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $UnitsReferences(db, table, p0).unitProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.unitId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $UnitsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Units,
      Unit,
      $UnitsFilterComposer,
      $UnitsOrderingComposer,
      $UnitsAnnotationComposer,
      $UnitsCreateCompanionBuilder,
      $UnitsUpdateCompanionBuilder,
      (Unit, $UnitsReferences),
      Unit,
      PrefetchHooks Function({bool unitItemsRefs, bool unitProgressRefs})
    >;
typedef $UnitPrerequisitesCreateCompanionBuilder =
    UnitPrerequisitesCompanion Function({
      required int unitId,
      required int requiresUnitId,
      Value<int> rowid,
    });
typedef $UnitPrerequisitesUpdateCompanionBuilder =
    UnitPrerequisitesCompanion Function({
      Value<int> unitId,
      Value<int> requiresUnitId,
      Value<int> rowid,
    });

final class $UnitPrerequisitesReferences
    extends BaseReferences<_$AppDatabase, UnitPrerequisites, UnitPrerequisite> {
  $UnitPrerequisitesReferences(super.$_db, super.$_table, super.$_typedResult);

  static Units _unitIdTable(_$AppDatabase db) =>
      db.units.createAlias('unit_prerequisites__unit_id__units__id');

  $UnitsProcessedTableManager get unitId {
    final $_column = $_itemColumn<int>('unit_id')!;

    final manager = $UnitsTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_unitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Units _requiresUnitIdTable(_$AppDatabase db) =>
      db.units.createAlias('unit_prerequisites__requires_unit_id__units__id');

  $UnitsProcessedTableManager get requiresUnitId {
    final $_column = $_itemColumn<int>('requires_unit_id')!;

    final manager = $UnitsTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_requiresUnitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $UnitPrerequisitesFilterComposer
    extends Composer<_$AppDatabase, UnitPrerequisites> {
  $UnitPrerequisitesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $UnitsFilterComposer get unitId {
    final $UnitsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UnitsFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UnitsFilterComposer get requiresUnitId {
    final $UnitsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.requiresUnitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UnitsFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $UnitPrerequisitesOrderingComposer
    extends Composer<_$AppDatabase, UnitPrerequisites> {
  $UnitPrerequisitesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $UnitsOrderingComposer get unitId {
    final $UnitsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UnitsOrderingComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UnitsOrderingComposer get requiresUnitId {
    final $UnitsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.requiresUnitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UnitsOrderingComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $UnitPrerequisitesAnnotationComposer
    extends Composer<_$AppDatabase, UnitPrerequisites> {
  $UnitPrerequisitesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $UnitsAnnotationComposer get unitId {
    final $UnitsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UnitsAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UnitsAnnotationComposer get requiresUnitId {
    final $UnitsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.requiresUnitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UnitsAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $UnitPrerequisitesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          UnitPrerequisites,
          UnitPrerequisite,
          $UnitPrerequisitesFilterComposer,
          $UnitPrerequisitesOrderingComposer,
          $UnitPrerequisitesAnnotationComposer,
          $UnitPrerequisitesCreateCompanionBuilder,
          $UnitPrerequisitesUpdateCompanionBuilder,
          (UnitPrerequisite, $UnitPrerequisitesReferences),
          UnitPrerequisite,
          PrefetchHooks Function({bool unitId, bool requiresUnitId})
        > {
  $UnitPrerequisitesTableManager(_$AppDatabase db, UnitPrerequisites table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $UnitPrerequisitesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $UnitPrerequisitesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $UnitPrerequisitesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> unitId = const Value.absent(),
                Value<int> requiresUnitId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitPrerequisitesCompanion(
                unitId: unitId,
                requiresUnitId: requiresUnitId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int unitId,
                required int requiresUnitId,
                Value<int> rowid = const Value.absent(),
              }) => UnitPrerequisitesCompanion.insert(
                unitId: unitId,
                requiresUnitId: requiresUnitId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<UnitPrerequisites, UnitPrerequisite>(table),
                  $UnitPrerequisitesReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({unitId = false, requiresUnitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (unitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.unitId,
                        referencedTable: $UnitPrerequisitesReferences
                            ._unitIdTable(db),
                        referencedColumn: $UnitPrerequisitesReferences
                            ._unitIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (requiresUnitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.requiresUnitId,
                        referencedTable: $UnitPrerequisitesReferences
                            ._requiresUnitIdTable(db),
                        referencedColumn: $UnitPrerequisitesReferences
                            ._requiresUnitIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $UnitPrerequisitesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      UnitPrerequisites,
      UnitPrerequisite,
      $UnitPrerequisitesFilterComposer,
      $UnitPrerequisitesOrderingComposer,
      $UnitPrerequisitesAnnotationComposer,
      $UnitPrerequisitesCreateCompanionBuilder,
      $UnitPrerequisitesUpdateCompanionBuilder,
      (UnitPrerequisite, $UnitPrerequisitesReferences),
      UnitPrerequisite,
      PrefetchHooks Function({bool unitId, bool requiresUnitId})
    >;
typedef $UnitItemsCreateCompanionBuilder = UnitItemsCompanion Function({
  required int unitId,
  required int contentItemId,
  Value<String> role,
  Value<int> rowid,
});
typedef $UnitItemsUpdateCompanionBuilder = UnitItemsCompanion Function({
  Value<int> unitId,
  Value<int> contentItemId,
  Value<String> role,
  Value<int> rowid,
});

final class $UnitItemsReferences
    extends BaseReferences<_$AppDatabase, UnitItems, UnitItem> {
  $UnitItemsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Units _unitIdTable(_$AppDatabase db) =>
      db.units.createAlias('unit_items__unit_id__units__id');

  $UnitsProcessedTableManager get unitId {
    final $_column = $_itemColumn<int>('unit_id')!;

    final manager = $UnitsTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_unitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static ContentItems _contentItemIdTable(_$AppDatabase db) => db.contentItems
      .createAlias('unit_items__content_item_id__content_items__id');

  $ContentItemsProcessedTableManager get contentItemId {
    final $_column = $_itemColumn<int>('content_item_id')!;

    final manager = $ContentItemsTableManager(
      $_db,
      $_db.contentItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contentItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $UnitItemsFilterComposer extends Composer<_$AppDatabase, UnitItems> {
  $UnitItemsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  $UnitsFilterComposer get unitId {
    final $UnitsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UnitsFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ContentItemsFilterComposer get contentItemId {
    final $ContentItemsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsFilterComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $UnitItemsOrderingComposer extends Composer<_$AppDatabase, UnitItems> {
  $UnitItemsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  $UnitsOrderingComposer get unitId {
    final $UnitsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UnitsOrderingComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ContentItemsOrderingComposer get contentItemId {
    final $ContentItemsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsOrderingComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $UnitItemsAnnotationComposer extends Composer<_$AppDatabase, UnitItems> {
  $UnitItemsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  $UnitsAnnotationComposer get unitId {
    final $UnitsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UnitsAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ContentItemsAnnotationComposer get contentItemId {
    final $ContentItemsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsAnnotationComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $UnitItemsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          UnitItems,
          UnitItem,
          $UnitItemsFilterComposer,
          $UnitItemsOrderingComposer,
          $UnitItemsAnnotationComposer,
          $UnitItemsCreateCompanionBuilder,
          $UnitItemsUpdateCompanionBuilder,
          (UnitItem, $UnitItemsReferences),
          UnitItem,
          PrefetchHooks Function({bool unitId, bool contentItemId})
        > {
  $UnitItemsTableManager(_$AppDatabase db, UnitItems table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $UnitItemsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $UnitItemsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $UnitItemsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> unitId = const Value.absent(),
                Value<int> contentItemId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitItemsCompanion(
                unitId: unitId,
                contentItemId: contentItemId,
                role: role,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int unitId,
                required int contentItemId,
                Value<String> role = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitItemsCompanion.insert(
                unitId: unitId,
                contentItemId: contentItemId,
                role: role,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<UnitItems, UnitItem>(table),
                  $UnitItemsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({unitId = false, contentItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (unitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.unitId,
                        referencedTable: $UnitItemsReferences._unitIdTable(db),
                        referencedColumn: $UnitItemsReferences
                            ._unitIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (contentItemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.contentItemId,
                        referencedTable: $UnitItemsReferences
                            ._contentItemIdTable(db),
                        referencedColumn: $UnitItemsReferences
                            ._contentItemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $UnitItemsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      UnitItems,
      UnitItem,
      $UnitItemsFilterComposer,
      $UnitItemsOrderingComposer,
      $UnitItemsAnnotationComposer,
      $UnitItemsCreateCompanionBuilder,
      $UnitItemsUpdateCompanionBuilder,
      (UnitItem, $UnitItemsReferences),
      UnitItem,
      PrefetchHooks Function({bool unitId, bool contentItemId})
    >;
typedef $UsersCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  Value<String?> displayName,
  Value<String> createdAt,
  Value<int> rowid,
});
typedef $UsersUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String?> displayName,
  Value<String> createdAt,
  Value<int> rowid,
});

final class $UsersReferences
    extends BaseReferences<_$AppDatabase, Users, User> {
  $UsersReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<UserProfile, List<UserProfileData>>
  _userProfileRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userProfile,
    aliasName: 'users__id__user_profile__user_id',
  );

  $UserProfileProcessedTableManager get userProfileRefs {
    final manager = $UserProfileTableManager(
      $_db,
      $_db.userProfile,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_userProfileRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<SrsCards, List<SrsCard>> _srsCardsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.srsCards,
    aliasName: 'users__id__srs_cards__user_id',
  );

  $SrsCardsProcessedTableManager get srsCardsRefs {
    final manager = $SrsCardsTableManager(
      $_db,
      $_db.srsCards,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_srsCardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<ReviewLog, List<ReviewLogData>>
  _reviewLogRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reviewLog,
    aliasName: 'users__id__review_log__user_id',
  );

  $ReviewLogProcessedTableManager get reviewLogRefs {
    final manager = $ReviewLogTableManager(
      $_db,
      $_db.reviewLog,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reviewLogRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<UnitProgress, List<UnitProgressData>>
  _unitProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.unitProgress,
    aliasName: 'users__id__unit_progress__user_id',
  );

  $UnitProgressProcessedTableManager get unitProgressRefs {
    final manager = $UnitProgressTableManager(
      $_db,
      $_db.unitProgress,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_unitProgressRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<UserVocab, List<UserVocabData>>
  _userVocabRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userVocab,
    aliasName: 'users__id__user_vocab__user_id',
  );

  $UserVocabProcessedTableManager get userVocabRefs {
    final manager = $UserVocabTableManager(
      $_db,
      $_db.userVocab,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_userVocabRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<DailyActivity, List<DailyActivityData>>
  _dailyActivityRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dailyActivity,
    aliasName: 'users__id__daily_activity__user_id',
  );

  $DailyActivityProcessedTableManager get dailyActivityRefs {
    final manager = $DailyActivityTableManager(
      $_db,
      $_db.dailyActivity,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_dailyActivityRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    ComprehensionSnapshot,
    List<ComprehensionSnapshotData>
  >
  _comprehensionSnapshotRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.comprehensionSnapshot,
        aliasName: 'users__id__comprehension_snapshot__user_id',
      );

  $ComprehensionSnapshotProcessedTableManager get comprehensionSnapshotRefs {
    final manager = $ComprehensionSnapshotTableManager(
      $_db,
      $_db.comprehensionSnapshot,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _comprehensionSnapshotRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $UsersFilterComposer extends Composer<_$AppDatabase, Users> {
  $UsersFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> userProfileRefs(
    Expression<bool> Function($UserProfileFilterComposer f) f,
  ) {
    final $UserProfileFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userProfile,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UserProfileFilterComposer(
            $db: $db,
            $table: $db.userProfile,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> srsCardsRefs(
    Expression<bool> Function($SrsCardsFilterComposer f) f,
  ) {
    final $SrsCardsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.srsCards,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SrsCardsFilterComposer(
            $db: $db,
            $table: $db.srsCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reviewLogRefs(
    Expression<bool> Function($ReviewLogFilterComposer f) f,
  ) {
    final $ReviewLogFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewLog,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ReviewLogFilterComposer(
            $db: $db,
            $table: $db.reviewLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> unitProgressRefs(
    Expression<bool> Function($UnitProgressFilterComposer f) f,
  ) {
    final $UnitProgressFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.unitProgress,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UnitProgressFilterComposer(
            $db: $db,
            $table: $db.unitProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> userVocabRefs(
    Expression<bool> Function($UserVocabFilterComposer f) f,
  ) {
    final $UserVocabFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userVocab,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UserVocabFilterComposer(
            $db: $db,
            $table: $db.userVocab,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dailyActivityRefs(
    Expression<bool> Function($DailyActivityFilterComposer f) f,
  ) {
    final $DailyActivityFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyActivity,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DailyActivityFilterComposer(
            $db: $db,
            $table: $db.dailyActivity,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> comprehensionSnapshotRefs(
    Expression<bool> Function($ComprehensionSnapshotFilterComposer f) f,
  ) {
    final $ComprehensionSnapshotFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.comprehensionSnapshot,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ComprehensionSnapshotFilterComposer(
            $db: $db,
            $table: $db.comprehensionSnapshot,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $UsersOrderingComposer extends Composer<_$AppDatabase, Users> {
  $UsersOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $UsersAnnotationComposer extends Composer<_$AppDatabase, Users> {
  $UsersAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> userProfileRefs<T extends Object>(
    Expression<T> Function($UserProfileAnnotationComposer a) f,
  ) {
    final $UserProfileAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userProfile,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UserProfileAnnotationComposer(
            $db: $db,
            $table: $db.userProfile,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> srsCardsRefs<T extends Object>(
    Expression<T> Function($SrsCardsAnnotationComposer a) f,
  ) {
    final $SrsCardsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.srsCards,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SrsCardsAnnotationComposer(
            $db: $db,
            $table: $db.srsCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> reviewLogRefs<T extends Object>(
    Expression<T> Function($ReviewLogAnnotationComposer a) f,
  ) {
    final $ReviewLogAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewLog,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ReviewLogAnnotationComposer(
            $db: $db,
            $table: $db.reviewLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> unitProgressRefs<T extends Object>(
    Expression<T> Function($UnitProgressAnnotationComposer a) f,
  ) {
    final $UnitProgressAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.unitProgress,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UnitProgressAnnotationComposer(
            $db: $db,
            $table: $db.unitProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> userVocabRefs<T extends Object>(
    Expression<T> Function($UserVocabAnnotationComposer a) f,
  ) {
    final $UserVocabAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userVocab,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UserVocabAnnotationComposer(
            $db: $db,
            $table: $db.userVocab,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> dailyActivityRefs<T extends Object>(
    Expression<T> Function($DailyActivityAnnotationComposer a) f,
  ) {
    final $DailyActivityAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyActivity,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DailyActivityAnnotationComposer(
            $db: $db,
            $table: $db.dailyActivity,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> comprehensionSnapshotRefs<T extends Object>(
    Expression<T> Function($ComprehensionSnapshotAnnotationComposer a) f,
  ) {
    final $ComprehensionSnapshotAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.comprehensionSnapshot,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ComprehensionSnapshotAnnotationComposer(
            $db: $db,
            $table: $db.comprehensionSnapshot,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $UsersTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Users,
          User,
          $UsersFilterComposer,
          $UsersOrderingComposer,
          $UsersAnnotationComposer,
          $UsersCreateCompanionBuilder,
          $UsersUpdateCompanionBuilder,
          (User, $UsersReferences),
          User,
          PrefetchHooks Function({
            bool userProfileRefs,
            bool srsCardsRefs,
            bool reviewLogRefs,
            bool unitProgressRefs,
            bool userVocabRefs,
            bool dailyActivityRefs,
            bool comprehensionSnapshotRefs,
          })
        > {
  $UsersTableManager(_$AppDatabase db, Users table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $UsersFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $UsersOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $UsersAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                displayName: displayName,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> displayName = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                displayName: displayName,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Users, User>(table),
                  $UsersReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                userProfileRefs = false,
                srsCardsRefs = false,
                reviewLogRefs = false,
                unitProgressRefs = false,
                userVocabRefs = false,
                dailyActivityRefs = false,
                comprehensionSnapshotRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (userProfileRefs) db.userProfile,
                    if (srsCardsRefs) db.srsCards,
                    if (reviewLogRefs) db.reviewLog,
                    if (unitProgressRefs) db.unitProgress,
                    if (userVocabRefs) db.userVocab,
                    if (dailyActivityRefs) db.dailyActivity,
                    if (comprehensionSnapshotRefs) db.comprehensionSnapshot,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (userProfileRefs)
                        await $_getPrefetchedData<User, Users, UserProfileData>(
                          currentTable: table,
                          referencedTable: $UsersReferences
                              ._userProfileRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $UsersReferences(db, table, p0).userProfileRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (srsCardsRefs)
                        await $_getPrefetchedData<User, Users, SrsCard>(
                          currentTable: table,
                          referencedTable: $UsersReferences._srsCardsRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $UsersReferences(db, table, p0).srsCardsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (reviewLogRefs)
                        await $_getPrefetchedData<User, Users, ReviewLogData>(
                          currentTable: table,
                          referencedTable: $UsersReferences._reviewLogRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $UsersReferences(db, table, p0).reviewLogRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (unitProgressRefs)
                        await $_getPrefetchedData<
                          User,
                          Users,
                          UnitProgressData
                        >(
                          currentTable: table,
                          referencedTable: $UsersReferences
                              ._unitProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $UsersReferences(db, table, p0).unitProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (userVocabRefs)
                        await $_getPrefetchedData<User, Users, UserVocabData>(
                          currentTable: table,
                          referencedTable: $UsersReferences._userVocabRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $UsersReferences(db, table, p0).userVocabRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (dailyActivityRefs)
                        await $_getPrefetchedData<
                          User,
                          Users,
                          DailyActivityData
                        >(
                          currentTable: table,
                          referencedTable: $UsersReferences
                              ._dailyActivityRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $UsersReferences(db, table, p0).dailyActivityRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (comprehensionSnapshotRefs)
                        await $_getPrefetchedData<
                          User,
                          Users,
                          ComprehensionSnapshotData
                        >(
                          currentTable: table,
                          referencedTable: $UsersReferences
                              ._comprehensionSnapshotRefsTable(db),
                          managerFromTypedResult: (p0) => $UsersReferences(
                            db,
                            table,
                            p0,
                          ).comprehensionSnapshotRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $UsersProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Users,
      User,
      $UsersFilterComposer,
      $UsersOrderingComposer,
      $UsersAnnotationComposer,
      $UsersCreateCompanionBuilder,
      $UsersUpdateCompanionBuilder,
      (User, $UsersReferences),
      User,
      PrefetchHooks Function({
        bool userProfileRefs,
        bool srsCardsRefs,
        bool reviewLogRefs,
        bool unitProgressRefs,
        bool userVocabRefs,
        bool dailyActivityRefs,
        bool comprehensionSnapshotRefs,
      })
    >;
typedef $UserProfileCreateCompanionBuilder = UserProfileCompanion Function({
  required String userId,
  Value<int> weightListening,
  Value<int> weightSpeaking,
  Value<int> weightReading,
  Value<int> weightWriting,
  Value<int> dailyMinutesGoal,
  Value<int?> comprehensionGoalPct,
  Value<String?> targetJlptLevel,
  Value<String?> placementLevel,
  Value<String> updatedAt,
  Value<int> rowid,
});
typedef $UserProfileUpdateCompanionBuilder = UserProfileCompanion Function({
  Value<String> userId,
  Value<int> weightListening,
  Value<int> weightSpeaking,
  Value<int> weightReading,
  Value<int> weightWriting,
  Value<int> dailyMinutesGoal,
  Value<int?> comprehensionGoalPct,
  Value<String?> targetJlptLevel,
  Value<String?> placementLevel,
  Value<String> updatedAt,
  Value<int> rowid,
});

final class $UserProfileReferences
    extends BaseReferences<_$AppDatabase, UserProfile, UserProfileData> {
  $UserProfileReferences(super.$_db, super.$_table, super.$_typedResult);

  static Users _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('user_profile__user_id__users__id');

  $UsersProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $UsersTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $UserProfileFilterComposer extends Composer<_$AppDatabase, UserProfile> {
  $UserProfileFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get weightListening => $composableBuilder(
    column: $table.weightListening,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weightSpeaking => $composableBuilder(
    column: $table.weightSpeaking,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weightReading => $composableBuilder(
    column: $table.weightReading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weightWriting => $composableBuilder(
    column: $table.weightWriting,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyMinutesGoal => $composableBuilder(
    column: $table.dailyMinutesGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get comprehensionGoalPct => $composableBuilder(
    column: $table.comprehensionGoalPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetJlptLevel => $composableBuilder(
    column: $table.targetJlptLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placementLevel => $composableBuilder(
    column: $table.placementLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $UsersFilterComposer get userId {
    final $UsersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $UserProfileOrderingComposer
    extends Composer<_$AppDatabase, UserProfile> {
  $UserProfileOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get weightListening => $composableBuilder(
    column: $table.weightListening,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weightSpeaking => $composableBuilder(
    column: $table.weightSpeaking,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weightReading => $composableBuilder(
    column: $table.weightReading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weightWriting => $composableBuilder(
    column: $table.weightWriting,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyMinutesGoal => $composableBuilder(
    column: $table.dailyMinutesGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get comprehensionGoalPct => $composableBuilder(
    column: $table.comprehensionGoalPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetJlptLevel => $composableBuilder(
    column: $table.targetJlptLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placementLevel => $composableBuilder(
    column: $table.placementLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $UsersOrderingComposer get userId {
    final $UsersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $UserProfileAnnotationComposer
    extends Composer<_$AppDatabase, UserProfile> {
  $UserProfileAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get weightListening => $composableBuilder(
    column: $table.weightListening,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weightSpeaking => $composableBuilder(
    column: $table.weightSpeaking,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weightReading => $composableBuilder(
    column: $table.weightReading,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weightWriting => $composableBuilder(
    column: $table.weightWriting,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyMinutesGoal => $composableBuilder(
    column: $table.dailyMinutesGoal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get comprehensionGoalPct => $composableBuilder(
    column: $table.comprehensionGoalPct,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetJlptLevel => $composableBuilder(
    column: $table.targetJlptLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get placementLevel => $composableBuilder(
    column: $table.placementLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $UsersAnnotationComposer get userId {
    final $UsersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $UserProfileTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          UserProfile,
          UserProfileData,
          $UserProfileFilterComposer,
          $UserProfileOrderingComposer,
          $UserProfileAnnotationComposer,
          $UserProfileCreateCompanionBuilder,
          $UserProfileUpdateCompanionBuilder,
          (UserProfileData, $UserProfileReferences),
          UserProfileData,
          PrefetchHooks Function({bool userId})
        > {
  $UserProfileTableManager(_$AppDatabase db, UserProfile table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $UserProfileFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $UserProfileOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $UserProfileAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<int> weightListening = const Value.absent(),
                Value<int> weightSpeaking = const Value.absent(),
                Value<int> weightReading = const Value.absent(),
                Value<int> weightWriting = const Value.absent(),
                Value<int> dailyMinutesGoal = const Value.absent(),
                Value<int?> comprehensionGoalPct = const Value.absent(),
                Value<String?> targetJlptLevel = const Value.absent(),
                Value<String?> placementLevel = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfileCompanion(
                userId: userId,
                weightListening: weightListening,
                weightSpeaking: weightSpeaking,
                weightReading: weightReading,
                weightWriting: weightWriting,
                dailyMinutesGoal: dailyMinutesGoal,
                comprehensionGoalPct: comprehensionGoalPct,
                targetJlptLevel: targetJlptLevel,
                placementLevel: placementLevel,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                Value<int> weightListening = const Value.absent(),
                Value<int> weightSpeaking = const Value.absent(),
                Value<int> weightReading = const Value.absent(),
                Value<int> weightWriting = const Value.absent(),
                Value<int> dailyMinutesGoal = const Value.absent(),
                Value<int?> comprehensionGoalPct = const Value.absent(),
                Value<String?> targetJlptLevel = const Value.absent(),
                Value<String?> placementLevel = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfileCompanion.insert(
                userId: userId,
                weightListening: weightListening,
                weightSpeaking: weightSpeaking,
                weightReading: weightReading,
                weightWriting: weightWriting,
                dailyMinutesGoal: dailyMinutesGoal,
                comprehensionGoalPct: comprehensionGoalPct,
                targetJlptLevel: targetJlptLevel,
                placementLevel: placementLevel,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<UserProfile, UserProfileData>(table),
                  $UserProfileReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.userId,
                        referencedTable: $UserProfileReferences._userIdTable(
                          db,
                        ),
                        referencedColumn: $UserProfileReferences
                            ._userIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $UserProfileProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      UserProfile,
      UserProfileData,
      $UserProfileFilterComposer,
      $UserProfileOrderingComposer,
      $UserProfileAnnotationComposer,
      $UserProfileCreateCompanionBuilder,
      $UserProfileUpdateCompanionBuilder,
      (UserProfileData, $UserProfileReferences),
      UserProfileData,
      PrefetchHooks Function({bool userId})
    >;
typedef $SrsCardsCreateCompanionBuilder = SrsCardsCompanion Function({
  required String id,
  required String userId,
  required int contentItemId,
  required String exerciseType,
  Value<String> state,
  Value<String?> dueAt,
  Value<double?> stability,
  Value<double?> difficulty,
  Value<int> reps,
  Value<int> lapses,
  Value<String?> lastReviewedAt,
  Value<int> rowid,
});
typedef $SrsCardsUpdateCompanionBuilder = SrsCardsCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<int> contentItemId,
  Value<String> exerciseType,
  Value<String> state,
  Value<String?> dueAt,
  Value<double?> stability,
  Value<double?> difficulty,
  Value<int> reps,
  Value<int> lapses,
  Value<String?> lastReviewedAt,
  Value<int> rowid,
});

final class $SrsCardsReferences
    extends BaseReferences<_$AppDatabase, SrsCards, SrsCard> {
  $SrsCardsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Users _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('srs_cards__user_id__users__id');

  $UsersProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $UsersTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static ContentItems _contentItemIdTable(_$AppDatabase db) => db.contentItems
      .createAlias('srs_cards__content_item_id__content_items__id');

  $ContentItemsProcessedTableManager get contentItemId {
    final $_column = $_itemColumn<int>('content_item_id')!;

    final manager = $ContentItemsTableManager(
      $_db,
      $_db.contentItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contentItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static ExerciseTypes _exerciseTypeTable(_$AppDatabase db) => db.exerciseTypes
      .createAlias('srs_cards__exercise_type__exercise_types__code');

  $ExerciseTypesProcessedTableManager get exerciseType {
    final $_column = $_itemColumn<String>('exercise_type')!;

    final manager = $ExerciseTypesTableManager(
      $_db,
      $_db.exerciseTypes,
    ).filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseTypeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<ReviewLog, List<ReviewLogData>>
  _reviewLogRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reviewLog,
    aliasName: 'srs_cards__id__review_log__card_id',
  );

  $ReviewLogProcessedTableManager get reviewLogRefs {
    final manager = $ReviewLogTableManager(
      $_db,
      $_db.reviewLog,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reviewLogRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $SrsCardsFilterComposer extends Composer<_$AppDatabase, SrsCards> {
  $SrsCardsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stability => $composableBuilder(
    column: $table.stability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  $UsersFilterComposer get userId {
    final $UsersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ContentItemsFilterComposer get contentItemId {
    final $ContentItemsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsFilterComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ExerciseTypesFilterComposer get exerciseType {
    final $ExerciseTypesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseType,
      referencedTable: $db.exerciseTypes,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ExerciseTypesFilterComposer(
            $db: $db,
            $table: $db.exerciseTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> reviewLogRefs(
    Expression<bool> Function($ReviewLogFilterComposer f) f,
  ) {
    final $ReviewLogFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewLog,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ReviewLogFilterComposer(
            $db: $db,
            $table: $db.reviewLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $SrsCardsOrderingComposer extends Composer<_$AppDatabase, SrsCards> {
  $SrsCardsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stability => $composableBuilder(
    column: $table.stability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $UsersOrderingComposer get userId {
    final $UsersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ContentItemsOrderingComposer get contentItemId {
    final $ContentItemsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsOrderingComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ExerciseTypesOrderingComposer get exerciseType {
    final $ExerciseTypesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseType,
      referencedTable: $db.exerciseTypes,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ExerciseTypesOrderingComposer(
            $db: $db,
            $table: $db.exerciseTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $SrsCardsAnnotationComposer extends Composer<_$AppDatabase, SrsCards> {
  $SrsCardsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<double> get stability =>
      $composableBuilder(column: $table.stability, builder: (column) => column);

  GeneratedColumn<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);

  GeneratedColumn<String> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => column,
  );

  $UsersAnnotationComposer get userId {
    final $UsersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ContentItemsAnnotationComposer get contentItemId {
    final $ContentItemsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsAnnotationComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ExerciseTypesAnnotationComposer get exerciseType {
    final $ExerciseTypesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseType,
      referencedTable: $db.exerciseTypes,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ExerciseTypesAnnotationComposer(
            $db: $db,
            $table: $db.exerciseTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> reviewLogRefs<T extends Object>(
    Expression<T> Function($ReviewLogAnnotationComposer a) f,
  ) {
    final $ReviewLogAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewLog,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ReviewLogAnnotationComposer(
            $db: $db,
            $table: $db.reviewLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $SrsCardsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          SrsCards,
          SrsCard,
          $SrsCardsFilterComposer,
          $SrsCardsOrderingComposer,
          $SrsCardsAnnotationComposer,
          $SrsCardsCreateCompanionBuilder,
          $SrsCardsUpdateCompanionBuilder,
          (SrsCard, $SrsCardsReferences),
          SrsCard,
          PrefetchHooks Function({
            bool userId,
            bool contentItemId,
            bool exerciseType,
            bool reviewLogRefs,
          })
        > {
  $SrsCardsTableManager(_$AppDatabase db, SrsCards table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $SrsCardsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $SrsCardsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $SrsCardsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<int> contentItemId = const Value.absent(),
                Value<String> exerciseType = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String?> dueAt = const Value.absent(),
                Value<double?> stability = const Value.absent(),
                Value<double?> difficulty = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<String?> lastReviewedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrsCardsCompanion(
                id: id,
                userId: userId,
                contentItemId: contentItemId,
                exerciseType: exerciseType,
                state: state,
                dueAt: dueAt,
                stability: stability,
                difficulty: difficulty,
                reps: reps,
                lapses: lapses,
                lastReviewedAt: lastReviewedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required int contentItemId,
                required String exerciseType,
                Value<String> state = const Value.absent(),
                Value<String?> dueAt = const Value.absent(),
                Value<double?> stability = const Value.absent(),
                Value<double?> difficulty = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<String?> lastReviewedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrsCardsCompanion.insert(
                id: id,
                userId: userId,
                contentItemId: contentItemId,
                exerciseType: exerciseType,
                state: state,
                dueAt: dueAt,
                stability: stability,
                difficulty: difficulty,
                reps: reps,
                lapses: lapses,
                lastReviewedAt: lastReviewedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<SrsCards, SrsCard>(table),
                  $SrsCardsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                userId = false,
                contentItemId = false,
                exerciseType = false,
                reviewLogRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (reviewLogRefs) db.reviewLog],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (userId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable: $SrsCardsReferences._userIdTable(
                              db,
                            ),
                            referencedColumn: $SrsCardsReferences
                                ._userIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (contentItemId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.contentItemId,
                            referencedTable: $SrsCardsReferences
                                ._contentItemIdTable(db),
                            referencedColumn: $SrsCardsReferences
                                ._contentItemIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (exerciseType) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.exerciseType,
                            referencedTable: $SrsCardsReferences
                                ._exerciseTypeTable(db),
                            referencedColumn: $SrsCardsReferences
                                ._exerciseTypeTable(db)
                                .code,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (reviewLogRefs)
                        await $_getPrefetchedData<
                          SrsCard,
                          SrsCards,
                          ReviewLogData
                        >(
                          currentTable: table,
                          referencedTable: $SrsCardsReferences
                              ._reviewLogRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $SrsCardsReferences(db, table, p0).reviewLogRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cardId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $SrsCardsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      SrsCards,
      SrsCard,
      $SrsCardsFilterComposer,
      $SrsCardsOrderingComposer,
      $SrsCardsAnnotationComposer,
      $SrsCardsCreateCompanionBuilder,
      $SrsCardsUpdateCompanionBuilder,
      (SrsCard, $SrsCardsReferences),
      SrsCard,
      PrefetchHooks Function({
        bool userId,
        bool contentItemId,
        bool exerciseType,
        bool reviewLogRefs,
      })
    >;
typedef $ReviewLogCreateCompanionBuilder = ReviewLogCompanion Function({
  required String id,
  required String userId,
  required String cardId,
  required String rating,
  required String reviewedAt,
  Value<int?> responseTimeMs,
  Value<String?> device,
  Value<int> rowid,
});
typedef $ReviewLogUpdateCompanionBuilder = ReviewLogCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> cardId,
  Value<String> rating,
  Value<String> reviewedAt,
  Value<int?> responseTimeMs,
  Value<String?> device,
  Value<int> rowid,
});

final class $ReviewLogReferences
    extends BaseReferences<_$AppDatabase, ReviewLog, ReviewLogData> {
  $ReviewLogReferences(super.$_db, super.$_table, super.$_typedResult);

  static Users _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('review_log__user_id__users__id');

  $UsersProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $UsersTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static SrsCards _cardIdTable(_$AppDatabase db) =>
      db.srsCards.createAlias('review_log__card_id__srs_cards__id');

  $SrsCardsProcessedTableManager get cardId {
    final $_column = $_itemColumn<String>('card_id')!;

    final manager = $SrsCardsTableManager(
      $_db,
      $_db.srsCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $ReviewLogFilterComposer extends Composer<_$AppDatabase, ReviewLog> {
  $ReviewLogFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get responseTimeMs => $composableBuilder(
    column: $table.responseTimeMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get device => $composableBuilder(
    column: $table.device,
    builder: (column) => ColumnFilters(column),
  );

  $UsersFilterComposer get userId {
    final $UsersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $SrsCardsFilterComposer get cardId {
    final $SrsCardsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.srsCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SrsCardsFilterComposer(
            $db: $db,
            $table: $db.srsCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $ReviewLogOrderingComposer extends Composer<_$AppDatabase, ReviewLog> {
  $ReviewLogOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get responseTimeMs => $composableBuilder(
    column: $table.responseTimeMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get device => $composableBuilder(
    column: $table.device,
    builder: (column) => ColumnOrderings(column),
  );

  $UsersOrderingComposer get userId {
    final $UsersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $SrsCardsOrderingComposer get cardId {
    final $SrsCardsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.srsCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SrsCardsOrderingComposer(
            $db: $db,
            $table: $db.srsCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $ReviewLogAnnotationComposer extends Composer<_$AppDatabase, ReviewLog> {
  $ReviewLogAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get responseTimeMs => $composableBuilder(
    column: $table.responseTimeMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get device =>
      $composableBuilder(column: $table.device, builder: (column) => column);

  $UsersAnnotationComposer get userId {
    final $UsersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $SrsCardsAnnotationComposer get cardId {
    final $SrsCardsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.srsCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SrsCardsAnnotationComposer(
            $db: $db,
            $table: $db.srsCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $ReviewLogTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          ReviewLog,
          ReviewLogData,
          $ReviewLogFilterComposer,
          $ReviewLogOrderingComposer,
          $ReviewLogAnnotationComposer,
          $ReviewLogCreateCompanionBuilder,
          $ReviewLogUpdateCompanionBuilder,
          (ReviewLogData, $ReviewLogReferences),
          ReviewLogData,
          PrefetchHooks Function({bool userId, bool cardId})
        > {
  $ReviewLogTableManager(_$AppDatabase db, ReviewLog table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ReviewLogFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ReviewLogOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ReviewLogAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> cardId = const Value.absent(),
                Value<String> rating = const Value.absent(),
                Value<String> reviewedAt = const Value.absent(),
                Value<int?> responseTimeMs = const Value.absent(),
                Value<String?> device = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReviewLogCompanion(
                id: id,
                userId: userId,
                cardId: cardId,
                rating: rating,
                reviewedAt: reviewedAt,
                responseTimeMs: responseTimeMs,
                device: device,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String cardId,
                required String rating,
                required String reviewedAt,
                Value<int?> responseTimeMs = const Value.absent(),
                Value<String?> device = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReviewLogCompanion.insert(
                id: id,
                userId: userId,
                cardId: cardId,
                rating: rating,
                reviewedAt: reviewedAt,
                responseTimeMs: responseTimeMs,
                device: device,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<ReviewLog, ReviewLogData>(table),
                  $ReviewLogReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, cardId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.userId,
                        referencedTable: $ReviewLogReferences._userIdTable(db),
                        referencedColumn: $ReviewLogReferences
                            ._userIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (cardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cardId,
                        referencedTable: $ReviewLogReferences._cardIdTable(db),
                        referencedColumn: $ReviewLogReferences
                            ._cardIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $ReviewLogProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      ReviewLog,
      ReviewLogData,
      $ReviewLogFilterComposer,
      $ReviewLogOrderingComposer,
      $ReviewLogAnnotationComposer,
      $ReviewLogCreateCompanionBuilder,
      $ReviewLogUpdateCompanionBuilder,
      (ReviewLogData, $ReviewLogReferences),
      ReviewLogData,
      PrefetchHooks Function({bool userId, bool cardId})
    >;
typedef $UnitProgressCreateCompanionBuilder = UnitProgressCompanion Function({
  required String userId,
  required int unitId,
  Value<String> status,
  Value<String?> startedAt,
  Value<String?> completedAt,
  Value<int> rowid,
});
typedef $UnitProgressUpdateCompanionBuilder = UnitProgressCompanion Function({
  Value<String> userId,
  Value<int> unitId,
  Value<String> status,
  Value<String?> startedAt,
  Value<String?> completedAt,
  Value<int> rowid,
});

final class $UnitProgressReferences
    extends BaseReferences<_$AppDatabase, UnitProgress, UnitProgressData> {
  $UnitProgressReferences(super.$_db, super.$_table, super.$_typedResult);

  static Users _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('unit_progress__user_id__users__id');

  $UsersProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $UsersTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Units _unitIdTable(_$AppDatabase db) =>
      db.units.createAlias('unit_progress__unit_id__units__id');

  $UnitsProcessedTableManager get unitId {
    final $_column = $_itemColumn<int>('unit_id')!;

    final manager = $UnitsTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_unitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $UnitProgressFilterComposer
    extends Composer<_$AppDatabase, UnitProgress> {
  $UnitProgressFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $UsersFilterComposer get userId {
    final $UsersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UnitsFilterComposer get unitId {
    final $UnitsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UnitsFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $UnitProgressOrderingComposer
    extends Composer<_$AppDatabase, UnitProgress> {
  $UnitProgressOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $UsersOrderingComposer get userId {
    final $UsersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UnitsOrderingComposer get unitId {
    final $UnitsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UnitsOrderingComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $UnitProgressAnnotationComposer
    extends Composer<_$AppDatabase, UnitProgress> {
  $UnitProgressAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<String> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $UsersAnnotationComposer get userId {
    final $UsersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UnitsAnnotationComposer get unitId {
    final $UnitsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UnitsAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $UnitProgressTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          UnitProgress,
          UnitProgressData,
          $UnitProgressFilterComposer,
          $UnitProgressOrderingComposer,
          $UnitProgressAnnotationComposer,
          $UnitProgressCreateCompanionBuilder,
          $UnitProgressUpdateCompanionBuilder,
          (UnitProgressData, $UnitProgressReferences),
          UnitProgressData,
          PrefetchHooks Function({bool userId, bool unitId})
        > {
  $UnitProgressTableManager(_$AppDatabase db, UnitProgress table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $UnitProgressFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $UnitProgressOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $UnitProgressAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<int> unitId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> startedAt = const Value.absent(),
                Value<String?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitProgressCompanion(
                userId: userId,
                unitId: unitId,
                status: status,
                startedAt: startedAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required int unitId,
                Value<String> status = const Value.absent(),
                Value<String?> startedAt = const Value.absent(),
                Value<String?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitProgressCompanion.insert(
                userId: userId,
                unitId: unitId,
                status: status,
                startedAt: startedAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<UnitProgress, UnitProgressData>(table),
                  $UnitProgressReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, unitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.userId,
                        referencedTable: $UnitProgressReferences._userIdTable(
                          db,
                        ),
                        referencedColumn: $UnitProgressReferences
                            ._userIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (unitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.unitId,
                        referencedTable: $UnitProgressReferences._unitIdTable(
                          db,
                        ),
                        referencedColumn: $UnitProgressReferences
                            ._unitIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $UnitProgressProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      UnitProgress,
      UnitProgressData,
      $UnitProgressFilterComposer,
      $UnitProgressOrderingComposer,
      $UnitProgressAnnotationComposer,
      $UnitProgressCreateCompanionBuilder,
      $UnitProgressUpdateCompanionBuilder,
      (UnitProgressData, $UnitProgressReferences),
      UnitProgressData,
      PrefetchHooks Function({bool userId, bool unitId})
    >;
typedef $UserVocabCreateCompanionBuilder = UserVocabCompanion Function({
  required String userId,
  required int contentItemId,
  Value<String> addedAt,
  Value<String?> source,
  Value<int> rowid,
});
typedef $UserVocabUpdateCompanionBuilder = UserVocabCompanion Function({
  Value<String> userId,
  Value<int> contentItemId,
  Value<String> addedAt,
  Value<String?> source,
  Value<int> rowid,
});

final class $UserVocabReferences
    extends BaseReferences<_$AppDatabase, UserVocab, UserVocabData> {
  $UserVocabReferences(super.$_db, super.$_table, super.$_typedResult);

  static Users _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('user_vocab__user_id__users__id');

  $UsersProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $UsersTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static ContentItems _contentItemIdTable(_$AppDatabase db) => db.contentItems
      .createAlias('user_vocab__content_item_id__content_items__id');

  $ContentItemsProcessedTableManager get contentItemId {
    final $_column = $_itemColumn<int>('content_item_id')!;

    final manager = $ContentItemsTableManager(
      $_db,
      $_db.contentItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contentItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $UserVocabFilterComposer extends Composer<_$AppDatabase, UserVocab> {
  $UserVocabFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  $UsersFilterComposer get userId {
    final $UsersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ContentItemsFilterComposer get contentItemId {
    final $ContentItemsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsFilterComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $UserVocabOrderingComposer extends Composer<_$AppDatabase, UserVocab> {
  $UserVocabOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  $UsersOrderingComposer get userId {
    final $UsersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ContentItemsOrderingComposer get contentItemId {
    final $ContentItemsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsOrderingComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $UserVocabAnnotationComposer extends Composer<_$AppDatabase, UserVocab> {
  $UserVocabAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  $UsersAnnotationComposer get userId {
    final $UsersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ContentItemsAnnotationComposer get contentItemId {
    final $ContentItemsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contentItemId,
      referencedTable: $db.contentItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ContentItemsAnnotationComposer(
            $db: $db,
            $table: $db.contentItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $UserVocabTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          UserVocab,
          UserVocabData,
          $UserVocabFilterComposer,
          $UserVocabOrderingComposer,
          $UserVocabAnnotationComposer,
          $UserVocabCreateCompanionBuilder,
          $UserVocabUpdateCompanionBuilder,
          (UserVocabData, $UserVocabReferences),
          UserVocabData,
          PrefetchHooks Function({bool userId, bool contentItemId})
        > {
  $UserVocabTableManager(_$AppDatabase db, UserVocab table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $UserVocabFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $UserVocabOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $UserVocabAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<int> contentItemId = const Value.absent(),
                Value<String> addedAt = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserVocabCompanion(
                userId: userId,
                contentItemId: contentItemId,
                addedAt: addedAt,
                source: source,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required int contentItemId,
                Value<String> addedAt = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserVocabCompanion.insert(
                userId: userId,
                contentItemId: contentItemId,
                addedAt: addedAt,
                source: source,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<UserVocab, UserVocabData>(table),
                  $UserVocabReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, contentItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.userId,
                        referencedTable: $UserVocabReferences._userIdTable(db),
                        referencedColumn: $UserVocabReferences
                            ._userIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (contentItemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.contentItemId,
                        referencedTable: $UserVocabReferences
                            ._contentItemIdTable(db),
                        referencedColumn: $UserVocabReferences
                            ._contentItemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $UserVocabProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      UserVocab,
      UserVocabData,
      $UserVocabFilterComposer,
      $UserVocabOrderingComposer,
      $UserVocabAnnotationComposer,
      $UserVocabCreateCompanionBuilder,
      $UserVocabUpdateCompanionBuilder,
      (UserVocabData, $UserVocabReferences),
      UserVocabData,
      PrefetchHooks Function({bool userId, bool contentItemId})
    >;
typedef $DailyActivityCreateCompanionBuilder = DailyActivityCompanion Function({
  required String userId,
  required String activityDate,
  Value<int> reviewsDone,
  Value<int> newItemsLearned,
  Value<int> minutesSpent,
  Value<int> goalMet,
  Value<int> rowid,
});
typedef $DailyActivityUpdateCompanionBuilder = DailyActivityCompanion Function({
  Value<String> userId,
  Value<String> activityDate,
  Value<int> reviewsDone,
  Value<int> newItemsLearned,
  Value<int> minutesSpent,
  Value<int> goalMet,
  Value<int> rowid,
});

final class $DailyActivityReferences
    extends BaseReferences<_$AppDatabase, DailyActivity, DailyActivityData> {
  $DailyActivityReferences(super.$_db, super.$_table, super.$_typedResult);

  static Users _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('daily_activity__user_id__users__id');

  $UsersProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $UsersTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $DailyActivityFilterComposer
    extends Composer<_$AppDatabase, DailyActivity> {
  $DailyActivityFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get activityDate => $composableBuilder(
    column: $table.activityDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewsDone => $composableBuilder(
    column: $table.reviewsDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get newItemsLearned => $composableBuilder(
    column: $table.newItemsLearned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutesSpent => $composableBuilder(
    column: $table.minutesSpent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalMet => $composableBuilder(
    column: $table.goalMet,
    builder: (column) => ColumnFilters(column),
  );

  $UsersFilterComposer get userId {
    final $UsersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $DailyActivityOrderingComposer
    extends Composer<_$AppDatabase, DailyActivity> {
  $DailyActivityOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get activityDate => $composableBuilder(
    column: $table.activityDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewsDone => $composableBuilder(
    column: $table.reviewsDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get newItemsLearned => $composableBuilder(
    column: $table.newItemsLearned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutesSpent => $composableBuilder(
    column: $table.minutesSpent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalMet => $composableBuilder(
    column: $table.goalMet,
    builder: (column) => ColumnOrderings(column),
  );

  $UsersOrderingComposer get userId {
    final $UsersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $DailyActivityAnnotationComposer
    extends Composer<_$AppDatabase, DailyActivity> {
  $DailyActivityAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get activityDate => $composableBuilder(
    column: $table.activityDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reviewsDone => $composableBuilder(
    column: $table.reviewsDone,
    builder: (column) => column,
  );

  GeneratedColumn<int> get newItemsLearned => $composableBuilder(
    column: $table.newItemsLearned,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minutesSpent => $composableBuilder(
    column: $table.minutesSpent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get goalMet =>
      $composableBuilder(column: $table.goalMet, builder: (column) => column);

  $UsersAnnotationComposer get userId {
    final $UsersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $DailyActivityTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          DailyActivity,
          DailyActivityData,
          $DailyActivityFilterComposer,
          $DailyActivityOrderingComposer,
          $DailyActivityAnnotationComposer,
          $DailyActivityCreateCompanionBuilder,
          $DailyActivityUpdateCompanionBuilder,
          (DailyActivityData, $DailyActivityReferences),
          DailyActivityData,
          PrefetchHooks Function({bool userId})
        > {
  $DailyActivityTableManager(_$AppDatabase db, DailyActivity table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $DailyActivityFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $DailyActivityOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $DailyActivityAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> activityDate = const Value.absent(),
                Value<int> reviewsDone = const Value.absent(),
                Value<int> newItemsLearned = const Value.absent(),
                Value<int> minutesSpent = const Value.absent(),
                Value<int> goalMet = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyActivityCompanion(
                userId: userId,
                activityDate: activityDate,
                reviewsDone: reviewsDone,
                newItemsLearned: newItemsLearned,
                minutesSpent: minutesSpent,
                goalMet: goalMet,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String activityDate,
                Value<int> reviewsDone = const Value.absent(),
                Value<int> newItemsLearned = const Value.absent(),
                Value<int> minutesSpent = const Value.absent(),
                Value<int> goalMet = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyActivityCompanion.insert(
                userId: userId,
                activityDate: activityDate,
                reviewsDone: reviewsDone,
                newItemsLearned: newItemsLearned,
                minutesSpent: minutesSpent,
                goalMet: goalMet,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<DailyActivity, DailyActivityData>(table),
                  $DailyActivityReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.userId,
                        referencedTable: $DailyActivityReferences._userIdTable(
                          db,
                        ),
                        referencedColumn: $DailyActivityReferences
                            ._userIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $DailyActivityProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      DailyActivity,
      DailyActivityData,
      $DailyActivityFilterComposer,
      $DailyActivityOrderingComposer,
      $DailyActivityAnnotationComposer,
      $DailyActivityCreateCompanionBuilder,
      $DailyActivityUpdateCompanionBuilder,
      (DailyActivityData, $DailyActivityReferences),
      DailyActivityData,
      PrefetchHooks Function({bool userId})
    >;
typedef $ComprehensionSnapshotCreateCompanionBuilder =
    ComprehensionSnapshotCompanion Function({
      required String userId,
      required String snapshotDate,
      Value<double?> readingPct,
      Value<double?> listeningPct,
      Value<double?> speakingScore,
      Value<double?> writingScore,
      Value<double?> overallPct,
      Value<int> rowid,
    });
typedef $ComprehensionSnapshotUpdateCompanionBuilder =
    ComprehensionSnapshotCompanion Function({
      Value<String> userId,
      Value<String> snapshotDate,
      Value<double?> readingPct,
      Value<double?> listeningPct,
      Value<double?> speakingScore,
      Value<double?> writingScore,
      Value<double?> overallPct,
      Value<int> rowid,
    });

final class $ComprehensionSnapshotReferences
    extends
        BaseReferences<
          _$AppDatabase,
          ComprehensionSnapshot,
          ComprehensionSnapshotData
        > {
  $ComprehensionSnapshotReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static Users _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('comprehension_snapshot__user_id__users__id');

  $UsersProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $UsersTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $ComprehensionSnapshotFilterComposer
    extends Composer<_$AppDatabase, ComprehensionSnapshot> {
  $ComprehensionSnapshotFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get snapshotDate => $composableBuilder(
    column: $table.snapshotDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get readingPct => $composableBuilder(
    column: $table.readingPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get listeningPct => $composableBuilder(
    column: $table.listeningPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speakingScore => $composableBuilder(
    column: $table.speakingScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get writingScore => $composableBuilder(
    column: $table.writingScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get overallPct => $composableBuilder(
    column: $table.overallPct,
    builder: (column) => ColumnFilters(column),
  );

  $UsersFilterComposer get userId {
    final $UsersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $ComprehensionSnapshotOrderingComposer
    extends Composer<_$AppDatabase, ComprehensionSnapshot> {
  $ComprehensionSnapshotOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get snapshotDate => $composableBuilder(
    column: $table.snapshotDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get readingPct => $composableBuilder(
    column: $table.readingPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get listeningPct => $composableBuilder(
    column: $table.listeningPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speakingScore => $composableBuilder(
    column: $table.speakingScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get writingScore => $composableBuilder(
    column: $table.writingScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get overallPct => $composableBuilder(
    column: $table.overallPct,
    builder: (column) => ColumnOrderings(column),
  );

  $UsersOrderingComposer get userId {
    final $UsersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $ComprehensionSnapshotAnnotationComposer
    extends Composer<_$AppDatabase, ComprehensionSnapshot> {
  $ComprehensionSnapshotAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get snapshotDate => $composableBuilder(
    column: $table.snapshotDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get readingPct => $composableBuilder(
    column: $table.readingPct,
    builder: (column) => column,
  );

  GeneratedColumn<double> get listeningPct => $composableBuilder(
    column: $table.listeningPct,
    builder: (column) => column,
  );

  GeneratedColumn<double> get speakingScore => $composableBuilder(
    column: $table.speakingScore,
    builder: (column) => column,
  );

  GeneratedColumn<double> get writingScore => $composableBuilder(
    column: $table.writingScore,
    builder: (column) => column,
  );

  GeneratedColumn<double> get overallPct => $composableBuilder(
    column: $table.overallPct,
    builder: (column) => column,
  );

  $UsersAnnotationComposer get userId {
    final $UsersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $ComprehensionSnapshotTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          ComprehensionSnapshot,
          ComprehensionSnapshotData,
          $ComprehensionSnapshotFilterComposer,
          $ComprehensionSnapshotOrderingComposer,
          $ComprehensionSnapshotAnnotationComposer,
          $ComprehensionSnapshotCreateCompanionBuilder,
          $ComprehensionSnapshotUpdateCompanionBuilder,
          (ComprehensionSnapshotData, $ComprehensionSnapshotReferences),
          ComprehensionSnapshotData,
          PrefetchHooks Function({bool userId})
        > {
  $ComprehensionSnapshotTableManager(
    _$AppDatabase db,
    ComprehensionSnapshot table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ComprehensionSnapshotFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ComprehensionSnapshotOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ComprehensionSnapshotAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> snapshotDate = const Value.absent(),
                Value<double?> readingPct = const Value.absent(),
                Value<double?> listeningPct = const Value.absent(),
                Value<double?> speakingScore = const Value.absent(),
                Value<double?> writingScore = const Value.absent(),
                Value<double?> overallPct = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComprehensionSnapshotCompanion(
                userId: userId,
                snapshotDate: snapshotDate,
                readingPct: readingPct,
                listeningPct: listeningPct,
                speakingScore: speakingScore,
                writingScore: writingScore,
                overallPct: overallPct,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String snapshotDate,
                Value<double?> readingPct = const Value.absent(),
                Value<double?> listeningPct = const Value.absent(),
                Value<double?> speakingScore = const Value.absent(),
                Value<double?> writingScore = const Value.absent(),
                Value<double?> overallPct = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComprehensionSnapshotCompanion.insert(
                userId: userId,
                snapshotDate: snapshotDate,
                readingPct: readingPct,
                listeningPct: listeningPct,
                speakingScore: speakingScore,
                writingScore: writingScore,
                overallPct: overallPct,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<ComprehensionSnapshot, ComprehensionSnapshotData>(
                    table,
                  ),
                  $ComprehensionSnapshotReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.userId,
                        referencedTable: $ComprehensionSnapshotReferences
                            ._userIdTable(db),
                        referencedColumn: $ComprehensionSnapshotReferences
                            ._userIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $ComprehensionSnapshotProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      ComprehensionSnapshot,
      ComprehensionSnapshotData,
      $ComprehensionSnapshotFilterComposer,
      $ComprehensionSnapshotOrderingComposer,
      $ComprehensionSnapshotAnnotationComposer,
      $ComprehensionSnapshotCreateCompanionBuilder,
      $ComprehensionSnapshotUpdateCompanionBuilder,
      (ComprehensionSnapshotData, $ComprehensionSnapshotReferences),
      ComprehensionSnapshotData,
      PrefetchHooks Function({bool userId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $ContentItemsTableManager get contentItems =>
      $ContentItemsTableManager(_db, _db.contentItems);
  $KanaTableManager get kana => $KanaTableManager(_db, _db.kana);
  $RadicalsTableManager get radicals =>
      $RadicalsTableManager(_db, _db.radicals);
  $KanjiTableManager get kanji => $KanjiTableManager(_db, _db.kanji);
  $KanjiRadicalsTableManager get kanjiRadicals =>
      $KanjiRadicalsTableManager(_db, _db.kanjiRadicals);
  $WordsTableManager get words => $WordsTableManager(_db, _db.words);
  $WordKanjiTableManager get wordKanji =>
      $WordKanjiTableManager(_db, _db.wordKanji);
  $WordKanaTableManager get wordKana =>
      $WordKanaTableManager(_db, _db.wordKana);
  $ParticlesTableManager get particles =>
      $ParticlesTableManager(_db, _db.particles);
  $GrammarPointsTableManager get grammarPoints =>
      $GrammarPointsTableManager(_db, _db.grammarPoints);
  $SentencesTableManager get sentences =>
      $SentencesTableManager(_db, _db.sentences);
  $SentenceContentItemsTableManager get sentenceContentItems =>
      $SentenceContentItemsTableManager(_db, _db.sentenceContentItems);
  $ExerciseTypesTableManager get exerciseTypes =>
      $ExerciseTypesTableManager(_db, _db.exerciseTypes);
  $UnitsTableManager get units => $UnitsTableManager(_db, _db.units);
  $UnitPrerequisitesTableManager get unitPrerequisites =>
      $UnitPrerequisitesTableManager(_db, _db.unitPrerequisites);
  $UnitItemsTableManager get unitItems =>
      $UnitItemsTableManager(_db, _db.unitItems);
  $UsersTableManager get users => $UsersTableManager(_db, _db.users);
  $UserProfileTableManager get userProfile =>
      $UserProfileTableManager(_db, _db.userProfile);
  $SrsCardsTableManager get srsCards =>
      $SrsCardsTableManager(_db, _db.srsCards);
  $ReviewLogTableManager get reviewLog =>
      $ReviewLogTableManager(_db, _db.reviewLog);
  $UnitProgressTableManager get unitProgress =>
      $UnitProgressTableManager(_db, _db.unitProgress);
  $UserVocabTableManager get userVocab =>
      $UserVocabTableManager(_db, _db.userVocab);
  $DailyActivityTableManager get dailyActivity =>
      $DailyActivityTableManager(_db, _db.dailyActivity);
  $ComprehensionSnapshotTableManager get comprehensionSnapshot =>
      $ComprehensionSnapshotTableManager(_db, _db.comprehensionSnapshot);
}
