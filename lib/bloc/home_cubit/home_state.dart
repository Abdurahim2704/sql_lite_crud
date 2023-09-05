import 'package:sql_lite_crud/models/todo/todo.dart';

abstract class HomeState {
  final List<Todo> todos;
  const HomeState(this.todos);
}

class HomeInitialState extends HomeState {
  const HomeInitialState() : super(const []);
}

class HomeFetchSuccessState extends HomeState {
  const HomeFetchSuccessState(super.todos);
}

class HomeFetchErrorState extends HomeState {
  final String message;
  const HomeFetchErrorState(super.todos, this.message);
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState(super.todos);
}
