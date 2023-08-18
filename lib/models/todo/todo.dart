import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
class Todo with _$Todo implements Comparable<Todo> {
  @JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
  const factory Todo(
      {required int id,
      required String task,
      required String deadline}) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  @override
  int compareTo(Todo other) {
    return other.id.compareTo(id);
  }

  factory Todo.fromSql(Map<String, dynamic> json) => Todo(
        id: json['ID'] as int,
        task: json['TASK'] as String,
        deadline: json['DEADLINE'] as String,
      );
}
