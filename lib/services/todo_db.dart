import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/todo/todo.dart';

class TodoDB {
  String dbName;
  Database? _db;
  TodoDB({required this.dbName});

  Future<List<Todo>> fetchTodo() async {
    if (_db == null) {
      return [];
    }

    final data = await _db!.query("TODO",
        distinct: true,
        columns: [
          "ID",
          "TASK",
          "DEADLINE",
        ],
        orderBy: "ID");

    final todos = data.map((e) => Todo.fromSql(e)).toList();
    return todos;
  }

  Future<bool> open() async {
    if (_db != null) {
      return true;
    }

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "TodoApp.db");
    _db = await openDatabase(path);
    const create = '''CREATE TABLE IF NOT EXISTS TODO (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  TASK TEXT NOT NULL,
  DEADLINE TEXT NOT NULL
);''';

    await _db!.execute(create);
    return true;
  }

  Future<bool> delete(Todo todo) async {
    if (_db == null) {
      return false;
    }
    final result =
        await _db!.delete("TODO", where: "ID=?", whereArgs: [todo.id]);
    if (result >= 1) {
      return true;
    }
    return false;
  }

  Future<bool> close() async {
    if (_db == null) {
      return true;
    }
    await _db!.close();
    return true;
  }

  Future<bool> create(String task, String deadline) async {
    if (_db == null) {
      return false;
    }
    await _db!.insert("TODO", {
      "TASK": task,
      "DEADLINE": deadline,
    });

    return true;
  }

  Future<bool> update(int id, String newTask, String newDeadline) async {
    if (_db == null) {
      return false;
    }
    final count = await _db!.update(
      "TODO",
      {
        "TASK": newTask,
        "DEADLINE": newDeadline,
      },
      where: "ID=?",
      whereArgs: [id],
    );
    return true;
  }
}
