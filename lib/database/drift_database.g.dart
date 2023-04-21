// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $SchedulesTable extends Schedules
    with TableInfo<$SchedulesTable, Schedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<int> startTime = GeneratedColumn<int>(
      'start_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<int> endTime = GeneratedColumn<int>(
      'end_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _emojiIdMeta =
      const VerificationMeta('emojiId');
  @override
  late final GeneratedColumn<int> emojiId = GeneratedColumn<int>(
      'emoji_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns =>
      [id, content, date, startTime, endTime, emojiId, createdAt];
  @override
  String get aliasedName => _alias ?? 'schedules';
  @override
  String get actualTableName => 'schedules';
  @override
  VerificationContext validateIntegrity(Insertable<Schedule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('emoji_id')) {
      context.handle(_emojiIdMeta,
          emojiId.isAcceptableOrUnknown(data['emoji_id']!, _emojiIdMeta));
    } else if (isInserting) {
      context.missing(_emojiIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Schedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Schedule(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_time'])!,
      emojiId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}emoji_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SchedulesTable createAlias(String alias) {
    return $SchedulesTable(attachedDatabase, alias);
  }
}

class Schedule extends DataClass implements Insertable<Schedule> {
  final int id;
  final String content;
  final DateTime date;
  final int startTime;
  final int endTime;
  final int emojiId;
  final DateTime createdAt;
  const Schedule(
      {required this.id,
      required this.content,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.emojiId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    map['date'] = Variable<DateTime>(date);
    map['start_time'] = Variable<int>(startTime);
    map['end_time'] = Variable<int>(endTime);
    map['emoji_id'] = Variable<int>(emojiId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SchedulesCompanion toCompanion(bool nullToAbsent) {
    return SchedulesCompanion(
      id: Value(id),
      content: Value(content),
      date: Value(date),
      startTime: Value(startTime),
      endTime: Value(endTime),
      emojiId: Value(emojiId),
      createdAt: Value(createdAt),
    );
  }

  factory Schedule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Schedule(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      date: serializer.fromJson<DateTime>(json['date']),
      startTime: serializer.fromJson<int>(json['startTime']),
      endTime: serializer.fromJson<int>(json['endTime']),
      emojiId: serializer.fromJson<int>(json['emojiId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
      'date': serializer.toJson<DateTime>(date),
      'startTime': serializer.toJson<int>(startTime),
      'endTime': serializer.toJson<int>(endTime),
      'emojiId': serializer.toJson<int>(emojiId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Schedule copyWith(
          {int? id,
          String? content,
          DateTime? date,
          int? startTime,
          int? endTime,
          int? emojiId,
          DateTime? createdAt}) =>
      Schedule(
        id: id ?? this.id,
        content: content ?? this.content,
        date: date ?? this.date,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        emojiId: emojiId ?? this.emojiId,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('Schedule(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('date: $date, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('emojiId: $emojiId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, content, date, startTime, endTime, emojiId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Schedule &&
          other.id == this.id &&
          other.content == this.content &&
          other.date == this.date &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.emojiId == this.emojiId &&
          other.createdAt == this.createdAt);
}

class SchedulesCompanion extends UpdateCompanion<Schedule> {
  final Value<int> id;
  final Value<String> content;
  final Value<DateTime> date;
  final Value<int> startTime;
  final Value<int> endTime;
  final Value<int> emojiId;
  final Value<DateTime> createdAt;
  const SchedulesCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.date = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.emojiId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SchedulesCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    required DateTime date,
    required int startTime,
    required int endTime,
    required int emojiId,
    this.createdAt = const Value.absent(),
  })  : content = Value(content),
        date = Value(date),
        startTime = Value(startTime),
        endTime = Value(endTime),
        emojiId = Value(emojiId);
  static Insertable<Schedule> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<DateTime>? date,
    Expression<int>? startTime,
    Expression<int>? endTime,
    Expression<int>? emojiId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (date != null) 'date': date,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (emojiId != null) 'emoji_id': emojiId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SchedulesCompanion copyWith(
      {Value<int>? id,
      Value<String>? content,
      Value<DateTime>? date,
      Value<int>? startTime,
      Value<int>? endTime,
      Value<int>? emojiId,
      Value<DateTime>? createdAt}) {
    return SchedulesCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      emojiId: emojiId ?? this.emojiId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<int>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<int>(endTime.value);
    }
    if (emojiId.present) {
      map['emoji_id'] = Variable<int>(emojiId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchedulesCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('date: $date, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('emojiId: $emojiId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CategoryEmojisTable extends CategoryEmojis
    with TableInfo<$CategoryEmojisTable, CategoryEmoji> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryEmojisTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _hexCodeMeta =
      const VerificationMeta('hexCode');
  @override
  late final GeneratedColumn<String> hexCode = GeneratedColumn<String>(
      'hex_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, hexCode];
  @override
  String get aliasedName => _alias ?? 'category_emojis';
  @override
  String get actualTableName => 'category_emojis';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryEmoji> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hex_code')) {
      context.handle(_hexCodeMeta,
          hexCode.isAcceptableOrUnknown(data['hex_code']!, _hexCodeMeta));
    } else if (isInserting) {
      context.missing(_hexCodeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryEmoji map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryEmoji(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      hexCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hex_code'])!,
    );
  }

  @override
  $CategoryEmojisTable createAlias(String alias) {
    return $CategoryEmojisTable(attachedDatabase, alias);
  }
}

class CategoryEmoji extends DataClass implements Insertable<CategoryEmoji> {
  final int id;
  final String hexCode;
  const CategoryEmoji({required this.id, required this.hexCode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['hex_code'] = Variable<String>(hexCode);
    return map;
  }

  CategoryEmojisCompanion toCompanion(bool nullToAbsent) {
    return CategoryEmojisCompanion(
      id: Value(id),
      hexCode: Value(hexCode),
    );
  }

  factory CategoryEmoji.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryEmoji(
      id: serializer.fromJson<int>(json['id']),
      hexCode: serializer.fromJson<String>(json['hexCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'hexCode': serializer.toJson<String>(hexCode),
    };
  }

  CategoryEmoji copyWith({int? id, String? hexCode}) => CategoryEmoji(
        id: id ?? this.id,
        hexCode: hexCode ?? this.hexCode,
      );
  @override
  String toString() {
    return (StringBuffer('CategoryEmoji(')
          ..write('id: $id, ')
          ..write('hexCode: $hexCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, hexCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryEmoji &&
          other.id == this.id &&
          other.hexCode == this.hexCode);
}

class CategoryEmojisCompanion extends UpdateCompanion<CategoryEmoji> {
  final Value<int> id;
  final Value<String> hexCode;
  const CategoryEmojisCompanion({
    this.id = const Value.absent(),
    this.hexCode = const Value.absent(),
  });
  CategoryEmojisCompanion.insert({
    this.id = const Value.absent(),
    required String hexCode,
  }) : hexCode = Value(hexCode);
  static Insertable<CategoryEmoji> custom({
    Expression<int>? id,
    Expression<String>? hexCode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hexCode != null) 'hex_code': hexCode,
    });
  }

  CategoryEmojisCompanion copyWith({Value<int>? id, Value<String>? hexCode}) {
    return CategoryEmojisCompanion(
      id: id ?? this.id,
      hexCode: hexCode ?? this.hexCode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (hexCode.present) {
      map['hex_code'] = Variable<String>(hexCode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryEmojisCompanion(')
          ..write('id: $id, ')
          ..write('hexCode: $hexCode')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  late final $SchedulesTable schedules = $SchedulesTable(this);
  late final $CategoryEmojisTable categoryEmojis = $CategoryEmojisTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [schedules, categoryEmojis];
}
