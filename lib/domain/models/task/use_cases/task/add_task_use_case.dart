import 'package:flutter/foundation.dart';
import 'package:new_app/data/repositories/task_repository.dart';
import 'package:new_app/domain/models/task/task.dart';

/// Use Case para adicionar uma tarefa
class AddTaskUseCase {
  AddTaskUseCase(this._repository);

  final TaskRepository _repository;

  Future<int> call(Task task) async {
    try {
      return await _repository.addTask(task);
    } catch (e) {
      debugPrint('Erro ao adicionar tarefa: $e');
      rethrow;
    }
  }
}
