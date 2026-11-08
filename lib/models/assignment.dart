enum TaskPriority { low, medium, high }

extension TaskPriorityLabel on TaskPriority {
  String get label {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }
}

class Assignment {
  Assignment({
    required this.id,
    required this.title,
    required this.subject,
    required this.source,
    required this.dueDate,
    required this.priority,
    required this.notes,
    this.isCompleted = false,
    List<String>? subtasks,
  }) : subtasks =
           subtasks ??
           <String>['Start assignment', 'Review work', 'Submit assignment'],
       checkedSubtasks = List<bool>.filled(
         (subtasks ??
                 <String>[
                   'Start assignment',
                   'Review work',
                   'Submit assignment',
                 ])
             .length,
         false,
       );

  final String id;
  String title;
  final String subject;
  final String source;
  final DateTime dueDate;
  final TaskPriority priority;
  String notes;
  bool isCompleted;
  final List<String> subtasks;
  final List<bool> checkedSubtasks;
}

bool sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
