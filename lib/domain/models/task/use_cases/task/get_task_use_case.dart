import 'package:flutter/foundation.dart';
import 'package:new_app/data/repositories/task_repository.dart';
import 'package:new_app/domain/models/task/task.dart';

/// Use Case para obter todas as tarefas
class GetTasksUseCase {
  GetTasksUseCase(this._repository);

  final TaskRepository _repository;

  Future<List<Task>> call({bool? isCompleted}) async {
    try {
      return await _repository.getTasks(isCompleted: isCompleted);
    } catch (e) {
      debugPrint('Erro ao buscar tarefas: $e');
      rethrow;
    }
  }
}
