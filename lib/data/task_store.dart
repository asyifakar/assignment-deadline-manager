import 'package:flutter/foundation.dart';
import '../models/assignment.dart';

class TaskStore extends ChangeNotifier {
  TaskStore() {
    final today = DateTime.now();
    _tasks.addAll(<Assignment>[
      Assignment(id: 'demo-math', title: 'Math Homework', subject: 'Mathematics', source: 'Google Classroom',
        dueDate: DateTime(today.year, today.month, today.day), priority: TaskPriority.high,
        notes: 'Complete questions 1–10 from pages 45–47.',
        subtasks: <String>['Questions 1–5', 'Questions 6–10', 'Review answers']),
      Assignment(id: 'demo-english', title: 'English Essay', subject: 'English', source: 'Google Classroom',
        dueDate: DateTime(today.year, today.month, today.day + 2), priority: TaskPriority.medium,
        notes: 'Finish the writing assignment.'),
      Assignment(id: 'demo-biology', title: 'Biology Worksheet', subject: 'Biology', source: 'Email',
        dueDate: DateTime(today.year, today.month, today.day + 5), priority: TaskPriority.low,
        notes: 'Review the worksheet and submit it on time.'),
    ]);
  }

  final List<Assignment> _tasks = <Assignment>[];
  List<Assignment> get tasks => List<Assignment>.unmodifiable(_tasks);

  List<Assignment> get pending {
    final result = _tasks.where((t) => !t.isCompleted).toList();
    result.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return result;
  }

  void addAssignment(Assignment task) {
    _tasks.add(task);
    notifyListeners();
  }

  void toggleSubtask(Assignment task, int index, bool value) {
    if (index < 0 || index >= task.checkedSubtasks.length) return;
    task.checkedSubtasks[index] = value;
    notifyListeners();
  }

  void complete(Assignment task) {
    task.isCompleted = true;
    notifyListeners();
  }
}
