import 'package:flutter/widgets.dart';
import 'package:new_app/domain/models/task/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseService {
  static Database? _database;

  Future<void> init() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'tasks.db');

    _database = await openDatabase(
      dbPath,
      version: 3,
      onCreate: (db, version) {
        debugPrint("Banco de dados criado!");
        db.execute("""CREATE TABLE tasks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT,
          category TEXT,
          isCompleted INTEGER DEFAULT 0
          )""");
        debugPrint("TABELA CRIADA");
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print('new version:$newVersion');
        if (oldVersion == 1 && newVersion == 2) {
          db.execute('ALTER TABLE tasks ADD COLUMN priority TEXT');
        }

        if (oldVersion < 3) {
          await db.execute("""CREATE TABLE responsibles (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL)""");
          db.execute(
            'ALTER TABLE tasks ADD COLUMN responsibleId INTEGER REFERENCES responsibles(id)',
          );
        }
      },
    );
  }

  // cria a atividade no bd
  Future<int?> createTask(Task task) async {
    int? responsibleId;
    if (task.responsibleName != null) {
      final responsibles = await _database?.query(
        'responsible',
        where: ' name LIKE = ?',
        whereArgs: [task.responsibleName],
      );

      if (responsibles != null && responsibles.isNotEmpty) {
        responsibleId = responsibles.first['id'] as int;
      } else {
        responsibleId = await _database?.insert('responsible', {
          'name': task.responsibleName,
        });
      }
    }
    final id = _database?.insert(
      'tasks',
      task.toMap(responsibleId: responsibleId),
    );
    debugPrint('TAREFA FOI CRIADA: $id');
    return id;
  }

  Future<int?> updateTask(Task task) async {
    final result = await _database?.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    return result;
  }

  Future<int?> deleteTask(int taskId) async {
    final result = await _database?.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );
    return result;
  }

  Future<List<Task>> getTask({bool? isCompleted}) async {
    List<String> where = [];
    List<dynamic> whereArgs = [];

    if (isCompleted != null) {
      where.add('isCompleted = ?');
      whereArgs.add(isCompleted ? 1 : 0);
    }
    final whereString = where.isNotEmpty ? where.join(' AND ') : null;
    // final result = await _database?.query(
    //   'tasks',
    //   where: whereString,
    //   whereArgs: whereArgs,
    // );

    final result = await _database?.rawQuery("""
      SELECT tasks.*, responsibles.name
      FROM tasks
      LEFT JOIN responsibles ON tasks.responsibleId = responsibles.id
      ${whereString ?? ''}
 """, whereArgs);
    final tasks = result?.map((e) => Task.fromMap(e)).toList();
    return tasks ?? [];
  }
}
