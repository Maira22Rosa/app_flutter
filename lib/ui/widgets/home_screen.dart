import 'package:flutter/material.dart';
import 'package:new_app/data/repositories/services/local_database_service.dart';
import 'package:new_app/domain/models/task/task.dart';
import 'package:new_app/ui/widgets/header_widget.dart';
import 'package:provider/provider.dart';

import '../view_models/task/task_view_model.dart';
import 'add_task_button_widget.dart';
import 'task_card_widget.dart';
import 'task_header_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> showTaskModal({
    required BuildContext context,
    Task? existingTask, // Caso seja uma edição, a tarefa será passada aqui
    required void Function(
      String title,
      String description,
      String category,
      String priority,
      String? responsibleName,
    )
    onSubmit,
  }) async {
    final formKey = GlobalKey<FormState>();
    final TextEditingController titleController = TextEditingController(
      text: existingTask?.title ?? '',
    );
    final TextEditingController descriptionController = TextEditingController(
      text: existingTask?.description ?? '',
    );
    final TextEditingController categoryController = TextEditingController(
      text: existingTask?.category ?? '',
    );

    final TextEditingController priorityController = TextEditingController(
      text: existingTask?.priority ?? '',
    );

    final TextEditingController responsibleNameController =
        TextEditingController(text: existingTask?.responsibleName ?? '');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  existingTask == null ? 'Adicionar Tarefa' : 'Editar Tarefa',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12.0),

                // Campo Título
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),

                // Campo Descrição
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a descrição';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),

                // Campo Categoria
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a categoria';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Campo Responsible
                TextFormField(
                  controller: responsibleNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do responsável',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Campo Prioridade
                TextFormField(
                  controller: priorityController,
                  decoration: const InputDecoration(
                    labelText: 'Prioridade',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a prioridade';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Botão de Salvar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 12.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        onSubmit(
                          titleController.text,
                          descriptionController.text,
                          categoryController.text,
                          priorityController.text,
                          responsibleNameController.text,
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Salvar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
              ],
            ),
          ),
        );
      },
    );
  }

  void initDatabase() async {
    final service = Provider.of<LocalDatabaseService>(context, listen: false);

    await service.init();
    taskViewModel.loadTasks();
  }

  late final taskViewModel = Provider.of<TaskViewModel>(context, listen: true);

  bool? filterIsCompleted;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      taskViewModel.loadTasks();
    });
    initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const HeaderWidget(),
          const SliverToBoxAdapter(child: TaskHeader()),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: AddTaskButton(
              onPressed: () {
                showTaskModal(
                  context: context,
                  onSubmit:
                      (
                        title,
                        description,
                        category,
                        priority,
                        responsibleName,
                      ) {
                        taskViewModel.addTask(
                          title,
                          description,
                          category,
                          priority,
                          responsibleName,
                        );
                      },
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          SliverToBoxAdapter(
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    if (filterIsCompleted == true) {
                      // diseleciona o filtro e recarrega a pg
                      filterIsCompleted = null;
                      taskViewModel.loadTasks();
                    } else {
                      filterIsCompleted = true;
                      taskViewModel.loadTasks(isCompleted: true);
                    }
                  },
                  child: Text(
                    'Finalizadas',
                    style: TextStyle(
                      color: filterIsCompleted == true
                          ? Colors.amber
                          : Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (filterIsCompleted == false) {
                      // diseleciona o filtro e recarrega a pg
                      filterIsCompleted = null;
                      taskViewModel.loadTasks();
                    } else {
                      filterIsCompleted = false;
                      taskViewModel.loadTasks(isCompleted: false);
                    }
                  },
                  child: Text(
                    'Não Finalizadas',
                    style: TextStyle(
                      color: filterIsCompleted == false
                          ? Colors.amber
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (taskViewModel.tasks == null)
            const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (taskViewModel.tasks!.isEmpty)
            const SliverFillRemaining(
              child: Center(child: Text('Sem dados cadastrados')),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList.builder(
                itemCount: taskViewModel.tasks!.length,
                itemBuilder: (context, index) {
                  final task = taskViewModel.tasks![index];
                  return TaskCard(
                    task: task,
                    onToggleStatus: () => taskViewModel.toggleTaskStatus(
                      task,
                      isCompleted: filterIsCompleted,
                    ),
                    onEdit: () {
                      showTaskModal(
                        context: context,
                        existingTask: task,
                        onSubmit:
                            (
                              title,
                              description,
                              category,
                              priority,
                              responsibleName,
                            ) {
                              final updatedTask = Task(
                                id: task.id,
                                title: title,
                                description: description,
                                category: category,
                                isCompleted: task.isCompleted,
                                priority: task.priority,
                                responsibleName: task.responsibleName,
                              );
                              taskViewModel.updateTask(
                                updatedTask,
                                isCompleted: filterIsCompleted,
                              );
                            },
                      );
                    },
                    onDelete: () => taskViewModel.deleteTask(task.id!),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
