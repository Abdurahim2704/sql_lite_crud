import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(ThemeData.light(useMaterial3: true));

  void changeTheme() {
    if (state == ThemeData.light(useMaterial3: true)) {
      emit(ThemeData.dark(useMaterial3: true));
      return;
    }
    emit(ThemeData.light(useMaterial3: true));
  }
}
