import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_lite_crud/app.dart';
import 'package:sql_lite_crud/bloc/detail_cubit/detail_cubit.dart';
import 'package:sql_lite_crud/bloc/home_cubit/home_cubit.dart';
import 'package:sql_lite_crud/bloc/home_cubit/home_state.dart';
import 'package:sql_lite_crud/main.dart';
import 'package:sql_lite_crud/models/todo/todo.dart';
import 'package:sql_lite_crud/presentation/widgets/change_theme_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    homeCubit.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    detailCubit.stream.listen((value) {
      if (value is DetailCreateSuccess || value is DetailDeleteSuccess) {
        homeCubit.fetchData();
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Todo App",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
            onPressed: () {
              themeCubit.changeTheme();
            },
            icon: const ChangeThemeIcon()),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        bloc: homeCubit,
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (_, index) {
              return ListTile(
                title: Text(state.todos[index].task),
                subtitle: Text(state.todos[index].deadline),
                trailing: IconButton(
                  icon: const Icon(CupertinoIcons.trash),
                  onPressed: () {
                    detailCubit.delete(state.todos[index]);
                    state.todos.removeAt(index);
                  },
                ),
                onLongPress: () {
                  showUpdateDialog(state.todos[index], context);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: MaterialButton(
        color: Colors.amber,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        shape: const ContinuousRectangleBorder(
            side:
                BorderSide(color: Color.fromARGB(255, 237, 224, 48), width: 3)),
        onPressed: () {
          showCreateDialog(context);
          setState(() {});
        },
        child: const SizedBox(
            height: 60, width: 60, child: Icon(CupertinoIcons.plus)),
      ),
    );
  }
}

void showCreateDialog(BuildContext context) {
  final formKey = GlobalKey<FormState>();

  TextEditingController taskController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();
  showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "add",
      context: context,
      pageBuilder: (context, _, __) {
        return AlertDialog(
          title: const Text(
            "Add Task",
            style: TextStyle(fontSize: 20),
          ),
          contentPadding: const EdgeInsets.all(20),
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
                        detailCubit.create(taskController.value.text,
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

void showUpdateDialog(Todo todo, BuildContext context) {
  final formKey = GlobalKey<FormState>();

  TextEditingController taskController = TextEditingController(text: todo.task);
  TextEditingController deadlineController =
      TextEditingController(text: todo.deadline);
  showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "update",
      context: context,
      pageBuilder: (context, _, __) {
        return AlertDialog(
          title: const Text(
            "Update The Task",
            style: TextStyle(fontSize: 20),
          ),
          contentPadding: const EdgeInsets.all(20),
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
                    detailCubit.edit(todo, taskController.value.text,
                        deadlineController.value.text);
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
