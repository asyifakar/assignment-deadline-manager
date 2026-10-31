import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/assignment.dart';

/// Local persistence for the Assignment & Deadline Manager prototype.
/// On Flutter web, preferences are stored in the browser's local storage.
class TaskStore extends ChangeNotifier {
  TaskStore() {
    final today = DateTime.now();
    _tasks.addAll(<Assignment>[
      Assignment(
        id: 'demo-math',
        title: 'Math Homework',
        subject: 'Mathematics',
        source: 'Google Classroom',
        dueDate: DateTime(today.year, today.month, today.day),
        priority: TaskPriority.high,
        notes: 'Complete questions 1–10 from pages 45–47.',
        subtasks: <String>['Questions 1–5', 'Questions 6–10', 'Review answers'],
      ),
      Assignment(
        id: 'demo-english',
        title: 'English Essay',
        subject: 'English',
        source: 'Google Classroom',
        dueDate: DateTime(today.year, today.month, today.day + 2),
        priority: TaskPriority.medium,
        notes: 'Finish the writing assignment.',
      ),
      Assignment(
        id: 'demo-biology',
        title: 'Biology Worksheet',
        subject: 'Biology',
        source: 'Email',
        dueDate: DateTime(today.year, today.month, today.day + 5),
        priority: TaskPriority.low,
        notes: 'Review the worksheet and submit it on time.',
      ),
    ]);
    _initialLoad = _loadSavedTasks();
  }

  static const String _storageKey = 'assignment_manager_tasks_v1';
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();
  final List<Assignment> _tasks = <Assignment>[];
  late final Future<void> _initialLoad;
  Future<void> _writeQueue = Future<void>.value();
  bool _disposed = false;
  int _editsDuringLoad = 0;

  List<Assignment> get tasks => List<Assignment>.unmodifiable(_tasks);

  List<Assignment> get pending {
    final result = _tasks.where((task) => !task.isCompleted).toList();
    result.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return result;
  }

  Future<void> _loadSavedTasks() async {
    try {
      final savedJson = await _preferences.getString(_storageKey);
      if (savedJson == null) return; // First launch: show original demo data.
      final decoded = jsonDecode(savedJson);
      if (decoded is! List) return;

      final restored = <Assignment>[];
      for (final entry in decoded) {
        if (entry is Map) {
          restored.add(_assignmentFromJson(Map<String, dynamic>.from(entry)));
        }
      }

      if (_editsDuringLoad == 0) {
        _tasks
          ..clear()
          ..addAll(restored);
      } else {
        // Preserve any user changes made while the async read was pending.
        final current = List<Assignment>.of(_tasks);
        final currentIds = current.map((task) => task.id).toSet();
        _tasks
          ..clear()
          ..addAll(current)
          ..addAll(restored.where((task) => !currentIds.contains(task.id)));
      }
      if (!_disposed) notifyListeners();
    } catch (error) {
      // Never remove visible assignments because local storage was unavailable.
      debugPrint('Unable to load saved assignments: $error');
    }
  }

  Map<String, dynamic> _assignmentToJson(Assignment task) => <String, dynamic>{
        'id': task.id,
        'title': task.title,
        'subject': task.subject,
        'source': task.source,
        'dueDate': task.dueDate.toIso8601String(),
        'priority': task.priority.name,
        'notes': task.notes,
        'isCompleted': task.isCompleted,
        'subtasks': task.subtasks,
        'checkedSubtasks': task.checkedSubtasks,
      };

  Assignment _assignmentFromJson(Map<String, dynamic> json) {
    final rawSubtasks = json['subtasks'];
    final subtasks = rawSubtasks is List
        ? rawSubtasks.map((value) => value.toString()).toList()
        : <String>['Start assignment', 'Review work', 'Submit assignment'];
    final task = Assignment(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
      dueDate: DateTime.tryParse(json['dueDate']?.toString() ?? '') ?? DateTime.now(),
      priority: TaskPriority.values.firstWhere(
        (value) => value.name == json['priority'],
        orElse: () => TaskPriority.medium,
      ),
      notes: json['notes']?.toString() ?? '',
      isCompleted: json['isCompleted'] == true,
      subtasks: subtasks,
    );
    final savedChecks = json['checkedSubtasks'];
    if (savedChecks is List) {
      for (var i = 0; i < task.checkedSubtasks.length && i < savedChecks.length; i++) {
        task.checkedSubtasks[i] = savedChecks[i] == true;
      }
    }
    return task;
  }

  void _saveChanges() {
    _editsDuringLoad++;
    notifyListeners();
    _writeQueue = _writeQueue.then((_) async {
      // Avoid letting the initial storage read overwrite the first edit.
      await _initialLoad;
      try {
        final savedJson = jsonEncode(_tasks.map(_assignmentToJson).toList());
        await _preferences.setString(_storageKey, savedJson);
      } catch (error) {
        debugPrint('Unable to save assignments: $error');
      }
    });
  }

  void addAssignment(Assignment task) {
    _tasks.add(task);
    _saveChanges();
  }

  void toggleSubtask(Assignment task, int index, bool value) {
    if (index < 0 || index >= task.checkedSubtasks.length) return;
    task.checkedSubtasks[index] = value;
    _saveChanges();
  }

  void complete(Assignment task) {
    task.isCompleted = true;
    _saveChanges();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
