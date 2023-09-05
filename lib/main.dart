import 'package:flutter/material.dart';
import 'package:sql_lite_crud/app.dart';
import 'package:sql_lite_crud/bloc/detail_cubit/detail_cubit.dart';
import 'package:sql_lite_crud/bloc/home_cubit/home_cubit.dart';
import 'package:sql_lite_crud/services/todo_db.dart';

final sql = TodoDB(
  dbName: "todo-db",
);
final homeCubit = HomeCubit();
final detailCubit = DetailCubit();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sql.open();
  print("Salomon");
  runApp(const MyApp());
}
