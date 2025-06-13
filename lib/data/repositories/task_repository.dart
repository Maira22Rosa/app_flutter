import 'package:new_app/domain/models/task/task.dart';

abstract class TaskRepository {
  Future<int> addTask(Task task);
  Future<List<Task>> getTasks({bool? isCompleted});
  Future<bool> updateTask(Task task);
  Future<bool> deleteTask(int id);
}
