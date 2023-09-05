import 'package:flutter/material.dart';
import 'package:sql_lite_crud/bloc/theme_cubit/theme_cubit.dart';
import 'package:sql_lite_crud/presentation/home_page.dart';

final themeCubit = ThemeCubit();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeData>(
        stream: themeCubit.stream,
        initialData: themeCubit.state,
        builder: (context, snapshot) {
          return MaterialApp(
            theme: snapshot.data,
            home: const HomePage(),
          );
        });
  }
}
