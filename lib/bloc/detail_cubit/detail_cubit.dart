import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_lite_crud/main.dart';
import 'package:sql_lite_crud/models/todo/todo.dart';
part 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  DetailCubit() : super(DetailInitial());

  void create(String title, String description) async {
    if (title.isEmpty || description.isEmpty) {
      emit(const DetailFailure(message: "Please fill in all the fields"));
      return;
    }
    try {
      await sql.create(title, description);
      emit(DetailCreateSuccess());
    } catch (e) {
      debugPrint("Error: $e");
      emit(DetailFailure(message: "DETAIL ERROR:$e"));
    }
  }

  void delete(Todo todo) async {
    emit(DetailLoading());
    try {
      await sql.delete(todo);
      emit(DetailDeleteSuccess());
    } catch (e) {
      debugPrint("Error: $e");
      emit(DetailFailure(message: "DETAIL ERROR:$e"));
    }
  }

  void edit(Todo todo, String title, String description) async {
    if (title.isEmpty || description.isEmpty) {
      emit(const DetailFailure(message: "Please fill in all the fields"));
      return;
    }
    emit(DetailLoading());
    try {
      sql.update(todo.id, title, description);
      emit(DetailUpdateSuccess());
    } catch (e) {
      debugPrint("Error: $e");
      emit(DetailFailure(message: "DETAIL ERROR:$e"));
    }
  }
}
