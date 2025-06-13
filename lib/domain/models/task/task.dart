class Task {
  final int? id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final String? responsibleName;

  final bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.isCompleted,
    this.responsibleName,
  });

  factory Task.fromMap(Map<String, dynamic> data) {
    return Task(
      title: data['title'],
      description: data['description'],
      category: data['category'],
      priority: data['priority'] ?? '',
      id: data['id'],
      isCompleted: data['isCompleted'] == 1,
      responsibleName: data['name'],
    );
  }

  Map<String, dynamic> toMap({int? responsibleId}) {
    return {
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'isCompleted': isCompleted ? 1 : 0,
      'responsibleId': responsibleId,
    };
  }
}
