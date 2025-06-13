import 'package:new_app/data/repositories/services/local_database_service.dart';
import 'package:new_app/data/repositories/task_repository.dart';
import 'package:new_app/domain/models/task/task.dart';

class LocalTaskRepository implements TaskRepository {
  final LocalDatabaseService localDatabaseService;
  // construtor
  LocalTaskRepository({required this.localDatabaseService});

  @override
  Future<int> addTask(Task task) async {
    final id = await localDatabaseService.createTask(task);
    // se nao tiver id retorna 0
    return id ?? 0;
  }

  @override
  Future<bool> deleteTask(int id) async {
    final result = await localDatabaseService.deleteTask(id);
    return result != null;
  }

  @override
  Future<List<Task>> getTasks({bool? isCompleted}) async {
    final result = await localDatabaseService.getTask(isCompleted: isCompleted);
    return result;
  }

  @override
  Future<bool> updateTask(Task task) async {
    final result = await localDatabaseService.updateTask(task);
    return result != null;
  }
}
