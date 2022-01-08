// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Folder extends DataClass implements Insertable<Folder> {
  final int id;
  final String title;
  final int? colorHexCode;
  final int iconCodePoint;
  final int createdAt;
  final int updatedAt;
  Folder(
      {required this.id,
      required this.title,
      this.colorHexCode,
      required this.iconCodePoint,
      required this.createdAt,
      required this.updatedAt});
  factory Folder.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Folder(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      colorHexCode: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}colorHexCode']),
      iconCodePoint: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}iconCodePoint'])!,
      createdAt: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}createdAt'])!,
      updatedAt: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updatedAt'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || colorHexCode != null) {
      map['colorHexCode'] = Variable<int?>(colorHexCode);
    }
    map['iconCodePoint'] = Variable<int>(iconCodePoint);
    map['createdAt'] = Variable<int>(createdAt);
    map['updatedAt'] = Variable<int>(updatedAt);
    return map;
  }

  FoldersCompanion toCompanion(bool nullToAbsent) {
    return FoldersCompanion(
      id: Value(id),
      title: Value(title),
      colorHexCode: colorHexCode == null && nullToAbsent
          ? const Value.absent()
          : Value(colorHexCode),
      iconCodePoint: Value(iconCodePoint),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Folder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Folder(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      colorHexCode: serializer.fromJson<int?>(json['colorHexCode']),
      iconCodePoint: serializer.fromJson<int>(json['iconCodePoint']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'colorHexCode': serializer.toJson<int?>(colorHexCode),
      'iconCodePoint': serializer.toJson<int>(iconCodePoint),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Folder copyWith(
          {int? id,
          String? title,
          int? colorHexCode,
          int? iconCodePoint,
          int? createdAt,
          int? updatedAt}) =>
      Folder(
        id: id ?? this.id,
        title: title ?? this.title,
        colorHexCode: colorHexCode ?? this.colorHexCode,
        iconCodePoint: iconCodePoint ?? this.iconCodePoint,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Folder(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('colorHexCode: $colorHexCode, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, colorHexCode, iconCodePoint, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Folder &&
          other.id == this.id &&
          other.title == this.title &&
          other.colorHexCode == this.colorHexCode &&
          other.iconCodePoint == this.iconCodePoint &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FoldersCompanion extends UpdateCompanion<Folder> {
  final Value<int> id;
  final Value<String> title;
  final Value<int?> colorHexCode;
  final Value<int> iconCodePoint;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const FoldersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.colorHexCode = const Value.absent(),
    this.iconCodePoint = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FoldersCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.colorHexCode = const Value.absent(),
    required int iconCodePoint,
    required int createdAt,
    required int updatedAt,
  })  : title = Value(title),
        iconCodePoint = Value(iconCodePoint),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Folder> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int?>? colorHexCode,
    Expression<int>? iconCodePoint,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (colorHexCode != null) 'colorHexCode': colorHexCode,
      if (iconCodePoint != null) 'iconCodePoint': iconCodePoint,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    });
  }

  FoldersCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<int?>? colorHexCode,
      Value<int>? iconCodePoint,
      Value<int>? createdAt,
      Value<int>? updatedAt}) {
    return FoldersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      colorHexCode: colorHexCode ?? this.colorHexCode,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (colorHexCode.present) {
      map['colorHexCode'] = Variable<int?>(colorHexCode.value);
    }
    if (iconCodePoint.present) {
      map['iconCodePoint'] = Variable<int>(iconCodePoint.value);
    }
    if (createdAt.present) {
      map['createdAt'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updatedAt'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoldersCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('colorHexCode: $colorHexCode, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class Folders extends Table with TableInfo<Folders, Folder> {
  final GeneratedDatabase _db;
  final String? _alias;
  Folders(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      typeName: 'TEXT',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _colorHexCodeMeta =
      const VerificationMeta('colorHexCode');
  late final GeneratedColumn<int?> colorHexCode = GeneratedColumn<int?>(
      'colorHexCode', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false, $customConstraints: '');
  final VerificationMeta _iconCodePointMeta =
      const VerificationMeta('iconCodePoint');
  late final GeneratedColumn<int?> iconCodePoint = GeneratedColumn<int?>(
      'iconCodePoint', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  late final GeneratedColumn<int?> createdAt = GeneratedColumn<int?>(
      'createdAt', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  late final GeneratedColumn<int?> updatedAt = GeneratedColumn<int?>(
      'updatedAt', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, colorHexCode, iconCodePoint, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? 'folders';
  @override
  String get actualTableName => 'folders';
  @override
  VerificationContext validateIntegrity(Insertable<Folder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('colorHexCode')) {
      context.handle(
          _colorHexCodeMeta,
          colorHexCode.isAcceptableOrUnknown(
              data['colorHexCode']!, _colorHexCodeMeta));
    }
    if (data.containsKey('iconCodePoint')) {
      context.handle(
          _iconCodePointMeta,
          iconCodePoint.isAcceptableOrUnknown(
              data['iconCodePoint']!, _iconCodePointMeta));
    } else if (isInserting) {
      context.missing(_iconCodePointMeta);
    }
    if (data.containsKey('createdAt')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['createdAt']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updatedAt')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updatedAt']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Folder map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Folder.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  Folders createAlias(String alias) {
    return Folders(_db, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Task extends DataClass implements Insertable<Task> {
  final int id;
  final String name;
  final String? description;
  final int isDone;
  final int folderId;
  final int createdAt;
  final int updatedAt;
  Task(
      {required this.id,
      required this.name,
      this.description,
      required this.isDone,
      required this.folderId,
      required this.createdAt,
      required this.updatedAt});
  factory Task.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Task(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      isDone: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}isDone'])!,
      folderId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}folder_id'])!,
      createdAt: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}createdAt'])!,
      updatedAt: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updatedAt'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String?>(description);
    }
    map['isDone'] = Variable<int>(isDone);
    map['folder_id'] = Variable<int>(folderId);
    map['createdAt'] = Variable<int>(createdAt);
    map['updatedAt'] = Variable<int>(updatedAt);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isDone: Value(isDone),
      folderId: Value(folderId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Task.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      isDone: serializer.fromJson<int>(json['isDone']),
      folderId: serializer.fromJson<int>(json['folder_id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'isDone': serializer.toJson<int>(isDone),
      'folder_id': serializer.toJson<int>(folderId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Task copyWith(
          {int? id,
          String? name,
          String? description,
          int? isDone,
          int? folderId,
          int? createdAt,
          int? updatedAt}) =>
      Task(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        isDone: isDone ?? this.isDone,
        folderId: folderId ?? this.folderId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('isDone: $isDone, ')
          ..write('folderId: $folderId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, description, isDone, folderId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.isDone == this.isDone &&
          other.folderId == this.folderId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> isDone;
  final Value<int> folderId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.isDone = const Value.absent(),
    this.folderId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.isDone = const Value.absent(),
    required int folderId,
    required int createdAt,
    required int updatedAt,
  })  : name = Value(name),
        folderId = Value(folderId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Task> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String?>? description,
    Expression<int>? isDone,
    Expression<int>? folderId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (isDone != null) 'isDone': isDone,
      if (folderId != null) 'folder_id': folderId,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    });
  }

  TasksCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<int>? isDone,
      Value<int>? folderId,
      Value<int>? createdAt,
      Value<int>? updatedAt}) {
    return TasksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      folderId: folderId ?? this.folderId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String?>(description.value);
    }
    if (isDone.present) {
      map['isDone'] = Variable<int>(isDone.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<int>(folderId.value);
    }
    if (createdAt.present) {
      map['createdAt'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updatedAt'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('isDone: $isDone, ')
          ..write('folderId: $folderId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class Tasks extends Table with TableInfo<Tasks, Task> {
  final GeneratedDatabase _db;
  final String? _alias;
  Tasks(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false, $customConstraints: '');
  final VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  late final GeneratedColumn<int?> isDone = GeneratedColumn<int?>(
      'isDone', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT 0',
      defaultValue: const CustomExpression<int>('0'));
  final VerificationMeta _folderIdMeta = const VerificationMeta('folderId');
  late final GeneratedColumn<int?> folderId = GeneratedColumn<int?>(
      'folder_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  late final GeneratedColumn<int?> createdAt = GeneratedColumn<int?>(
      'createdAt', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  late final GeneratedColumn<int?> updatedAt = GeneratedColumn<int?>(
      'updatedAt', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, description, isDone, folderId, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? 'tasks';
  @override
  String get actualTableName => 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<Task> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('isDone')) {
      context.handle(_isDoneMeta,
          isDone.isAcceptableOrUnknown(data['isDone']!, _isDoneMeta));
    }
    if (data.containsKey('folder_id')) {
      context.handle(_folderIdMeta,
          folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta));
    } else if (isInserting) {
      context.missing(_folderIdMeta);
    }
    if (data.containsKey('createdAt')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['createdAt']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updatedAt')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updatedAt']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Task.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  Tasks createAlias(String alias) {
    return Tasks(_db, alias);
  }

  @override
  List<String> get customConstraints => const [
        'FOREIGN KEY (folder_id) REFERENCES folders (id) ON DELETE CASCADE'
      ];
  @override
  bool get dontWriteConstraints => true;
}

abstract class _$MyDb extends GeneratedDatabase {
  _$MyDb(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final Folders folders = Folders(this);
  late final Tasks tasks = Tasks(this);
  Selectable<Folder> allFolders() {
    return customSelect('SELECT * FROM folders', variables: [], readsFrom: {
      folders,
    }).map(folders.mapFromRow);
  }

  Selectable<Task> allTasks() {
    return customSelect('SELECT * FROM tasks', variables: [], readsFrom: {
      tasks,
    }).map(tasks.mapFromRow);
  }

  Selectable<Task> getTasksById(int id) {
    return customSelect('SELECT * FROM tasks WHERE folder_id = :id',
        variables: [
          Variable<int>(id)
        ],
        readsFrom: {
          tasks,
        }).map(tasks.mapFromRow);
  }

  Future<int> deleteTaskById(int id) {
    return customUpdate(
      'DELETE FROM tasks WHERE id = :id',
      variables: [Variable<int>(id)],
      updates: {tasks},
      updateKind: UpdateKind.delete,
    );
  }

  Future<int> deleteFolderById(int id) {
    return customUpdate(
      'DELETE FROM folders WHERE id = :id',
      variables: [Variable<int>(id)],
      updates: {folders},
      updateKind: UpdateKind.delete,
    );
  }

  Future<int> createFolder(
      String title, int iconCodePoint, int createdAt, int updatedAt) {
    return customInsert(
      'INSERT INTO folders (title, iconCodePoint, createdAt, updatedAt) VALUES (:title, :iconCodePoint, :createdAt, :updatedAt)',
      variables: [
        Variable<String>(title),
        Variable<int>(iconCodePoint),
        Variable<int>(createdAt),
        Variable<int>(updatedAt)
      ],
      updates: {folders},
    );
  }

  Future<int> createTask(String name, String? description, int isDone,
      int folder_id, int createdAt, int updatedAt) {
    return customInsert(
      'INSERT INTO tasks (name, description, isDone, folder_id, createdAt, updatedAt) VALUES (:name, :description, :isDone, :folder_id, :createdAt, :updatedAt)',
      variables: [
        Variable<String>(name),
        Variable<String?>(description),
        Variable<int>(isDone),
        Variable<int>(folder_id),
        Variable<int>(createdAt),
        Variable<int>(updatedAt)
      ],
      updates: {tasks},
    );
  }

  Future<int> updateTaskById(
      String name, String? description, int isDone, int updatedAt, int id) {
    return customUpdate(
      'UPDATE tasks SET name = :name, description = :description, isDone = :isDone, updatedAt = :updatedAt WHERE id = :id',
      variables: [
        Variable<String>(name),
        Variable<String?>(description),
        Variable<int>(isDone),
        Variable<int>(updatedAt),
        Variable<int>(id)
      ],
      updates: {tasks},
      updateKind: UpdateKind.update,
    );
  }

  Future<int> updateFolderById(String title, int iconCodePoint, int updatedAt) {
    return customUpdate(
      'UPDATE folders SET title = :title, iconCodePoint = :iconCodePoint, updatedAt = :updatedAt',
      variables: [
        Variable<String>(title),
        Variable<int>(iconCodePoint),
        Variable<int>(updatedAt)
      ],
      updates: {folders},
      updateKind: UpdateKind.update,
    );
  }

  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [folders, tasks];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('folders',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('tasks', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}
