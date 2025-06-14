import 'package:new_app/data/repositories/local_task_repository.dart';
import 'package:new_app/data/repositories/mock_task_repository.dart';
import 'package:new_app/data/repositories/services/local_database_service.dart';
import 'package:new_app/data/repositories/task_repository.dart';
import 'package:new_app/domain/models/task/use_cases/task/add_task_use_case.dart';
import 'package:new_app/domain/models/task/use_cases/task/delete_task_use_case.dart';
import 'package:new_app/domain/models/task/use_cases/task/get_task_use_case.dart';
import 'package:new_app/domain/models/task/use_cases/task/update_task_use_case.dart';
import 'package:new_app/ui/view_models/task/task_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get providersLocal {
  return [
    Provider<LocalDatabaseService>(create: (context) => LocalDatabaseService()),
    Provider<TaskRepository>(
      create: (context) =>
          LocalTaskRepository(localDatabaseService: context.read()),
    ),
    Provider<AddTaskUseCase>(
      lazy: true,
      create: (context) => AddTaskUseCase(context.read()),
    ),
    Provider<UpdateTaskUseCase>(
      lazy: true,
      create: (context) => UpdateTaskUseCase(context.read()),
    ),
    Provider<DeleteTaskUseCase>(
      lazy: true,
      create: (context) => DeleteTaskUseCase(context.read()),
    ),
    Provider<GetTasksUseCase>(
      lazy: true,
      create: (context) => GetTasksUseCase(context.read()),
    ),
    ChangeNotifierProvider(
      lazy: true,
      create: (context) => TaskViewModel(
        addTaskUseCase: context.read(),
        getTasksUseCase: context.read(),
        updateTaskUseCase: context.read(),
        deleteTaskUseCase: context.read(),
      ),
    ),
  ];
}
