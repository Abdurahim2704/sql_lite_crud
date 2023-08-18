import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/todo/todo.dart';

class TodoDB {
  String dbName;
  Database? _db;
  List<Todo> todos = [];
  final streamController = StreamController<List<Todo>>.broadcast();

  TodoDB({required this.dbName});

  Future<List<Todo>> _fetchTodo() async {
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
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/$dbName";
    _db = await openDatabase(path);
    const create = '''CREATE TABLE IF NOT EXISTS TODO (
  ID INTEGER PRIMARY KEY,
  TASK TEXT NOT NULL,
  DEADLINE TEXT NOT NULL
);''';

    await _db!.execute(create);
    print("I am here");
    todos = await _fetchTodo();
    print("hello");
    streamController.add(todos);
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

  Stream<List<Todo>> all() =>
      streamController.stream.map((event) => event..sort());

  Future<bool> create(String task, String deadline) async {
    if (_db == null) {
      return false;
    }
    final int id = await _db!.insert("TODO", {
      "TASK": task,
      "DEADLINE": deadline,
    });
    final todo = Todo(id: id, task: task, deadline: deadline);
    todos.add(todo);
    streamController.add(todos);

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
    todos.removeWhere((element) => element.id == id);
    todos.add(Todo(id: id, task: newTask, deadline: newDeadline));
    streamController.add(todos);
    return true;
  }
}
