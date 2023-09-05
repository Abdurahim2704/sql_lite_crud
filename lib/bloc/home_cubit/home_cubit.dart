import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_lite_crud/bloc/home_cubit/home_state.dart';
import 'package:sql_lite_crud/main.dart';
import 'package:sql_lite_crud/models/todo/todo.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeInitialState());

  void fetchData() async {
    emit(HomeLoadingState(state.todos));
    try {
      final List<Todo> todos = await sql.fetchTodo();
      emit(HomeFetchSuccessState(todos));
    } catch (e) {
      emit(HomeFetchErrorState(state.todos, "Error fetching data"));
    }
  }
}
