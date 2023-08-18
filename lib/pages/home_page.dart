import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sql_lite_crud/models/todo/todo.dart';
import 'package:sql_lite_crud/pages/loading_page.dart';
import 'package:sql_lite_crud/services/todo_db.dart';

class HomePageController extends StatefulWidget {
  const HomePageController({super.key});

  @override
  State<HomePageController> createState() => _HomePageControllerState();
}

class _HomePageControllerState extends State<HomePageController> {
  List<Todo> todos = [];
  TodoDB? db;

  @override
  void initState() {
    db = TodoDB(dbName: "todo2.sqlite");
    db!.open();
  }

  @override
  void dispose() {
    super.dispose();
    db!.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todo>>(
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
            if (snapshot.data == null) {
              return LoadingPage();
            }
            todos = snapshot.data!;
            return HomePage(todos: todos, db: db!);
          default:
            return const LoadingPage();
        }
      },
      stream: db!.all(),
    );
  }
}

class HomePage extends StatefulWidget {
  final List<Todo> todos;
  final TodoDB db;

  const HomePage({super.key, required this.todos, required this.db});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App1"),
        leading: ThemeSwitcher.withTheme(
          builder: (_, switcher, theme) {
            return IconButton(
              splashRadius: 1,
              onPressed: () => switcher.changeTheme(
                theme: theme.brightness == Brightness.light
                    ? ThemeData.dark(useMaterial3: true)
                    : ThemeData.light(useMaterial3: true),
              ),
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? CupertinoIcons.moon_fill
                    : CupertinoIcons.sun_max_fill,
                size: 30,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.yellow,
              ),
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: widget.todos.length,
        itemBuilder: (_, index) {
          return ListTile(
            title: Text(widget.todos[index].task),
            subtitle: Text(widget.todos[index].deadline),
            trailing: IconButton(
              icon: Icon(CupertinoIcons.trash),
              onPressed: () {
                widget.db.delete(widget.todos[index]);
                widget.todos.removeAt(index);
                widget.db.streamController.add(widget.todos);
              },
            ),
            onLongPress: (){
              showUpdateDialog(widget.todos[index], context, widget.db);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreateDialog(context, widget.db);
        },
        child: const Icon(CupertinoIcons.plus),
      ),
    );
  }
}

void showCreateDialog(BuildContext context, TodoDB db) {
  final formKey = GlobalKey<FormState>();

  TextEditingController taskController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();
  showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "add",
      context: context,
      pageBuilder: (context, _, __) {
        return AlertDialog(
          title: Text("Add Task", style: TextStyle(fontSize: 20),),
          contentPadding: EdgeInsets.all(20),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: taskController,
                  validator: (value) {
                    if (value?.trim() == "" || value == null) {
                      return "Error";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Task",
                  ),
                ),
                TextFormField(
                  controller: deadlineController,
                  validator: (value) {
                    if (value?.trim() == "" || value == null) {
                      return "Error";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Deadline",
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        db.create(taskController.value.text,
                            deadlineController.value.text);
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text("Save"))
              ],
            ),
          ),
        );
      });
}

void  showUpdateDialog(Todo todo, BuildContext context, TodoDB db) {
  final formKey = GlobalKey<FormState>();

  TextEditingController taskController = TextEditingController(text: todo.task);
  TextEditingController deadlineController = TextEditingController(text: todo.deadline);
  showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "update",
      context: context,
      pageBuilder: (context, _, __) {
        return AlertDialog(
          title: Text("Update The Task", style: TextStyle(fontSize: 20),),
          contentPadding: EdgeInsets.all(20),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  autofocus: true,
                  controller: taskController,
                  validator: (value) {
                    if (value?.trim() == "" || value == null) {
                      return "Error";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Task",
                  ),
                ),
                TextFormField(
                  controller: deadlineController,
                  validator: (value) {
                    if (value?.trim() == "" || value == null) {
                      return "Error";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Deadline",
                  ),
                  keyboardType: TextInputType.datetime,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    db.update(todo.id,taskController.value.text, deadlineController.value.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text("Complete edit")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Discard Changes"))
          ],
        );
      });
}