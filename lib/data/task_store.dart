import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/assignment.dart';

/// Tasks saved per locally registered account on this device/browser.
class TaskStore extends ChangeNotifier {
  TaskStore();

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();
  final List<Assignment> _tasks = <Assignment>[];
  Future<void> _writeQueue = Future<void>.value();
  String? _activeKey;
  bool _disposed = false;

  List<Assignment> get tasks => List<Assignment>.unmodifiable(_tasks);
  List<Assignment> get pending {
    final result = _tasks.where((task) => !task.isCompleted).toList();
    result.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return result;
  }

  /// Loads a registered account's own assignments before opening its dashboard.
  Future<void> loadForAccount(String email) async {
    await _writeQueue;
    final normalized = email.trim().toLowerCase();
    final key =
        'assignment_manager_user_tasks_v1_${base64UrlEncode(utf8.encode(normalized))}';
    _activeKey = key;
    _tasks.clear();
    try {
      final raw = await _preferences.getString(key);
      if (raw != null) {
        final decoded = jsonDecode(raw);
        if (decoded is! List) {
          throw const FormatException('Invalid saved assignment data.');
        }
        _tasks.addAll(
          decoded.map(
            (item) => _fromJson(Map<String, dynamic>.from(item as Map)),
          ),
        );
      }
    } catch (error) {
      _activeKey = null;
      _tasks.clear();
      notifyListeners();
      throw StateError('Could not load saved tasks: $error');
    }
    if (!_disposed) notifyListeners();
  }

  void signOut() {
    _activeKey = null;
    _tasks.clear();
    if (!_disposed) notifyListeners();
  }

  Map<String, dynamic> _toJson(Assignment task) => <String, dynamic>{
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

  Assignment _fromJson(Map<String, dynamic> json) {
    final rawSubtasks = json['subtasks'];
    final subtasks = rawSubtasks is List
        ? rawSubtasks.map((value) => value.toString()).toList()
        : <String>['Start assignment', 'Review work', 'Submit assignment'];
    final task = Assignment(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
      dueDate:
          DateTime.tryParse(json['dueDate']?.toString() ?? '') ??
          DateTime.now(),
      priority: TaskPriority.values.firstWhere(
        (priority) => priority.name == json['priority'],
        orElse: () => TaskPriority.medium,
      ),
      notes: json['notes']?.toString() ?? '',
      isCompleted: json['isCompleted'] == true,
      subtasks: subtasks,
    );
    final flags = json['checkedSubtasks'];
    if (flags is List) {
      for (
        var i = 0;
        i < flags.length && i < task.checkedSubtasks.length;
        i++
      ) {
        task.checkedSubtasks[i] = flags[i] == true;
      }
    }
    return task;
  }

  void _persistChanges() {
    final key = _activeKey;
    if (key == null) {
      throw StateError('Please log in before editing assignments.');
    }
    // Capture an immutable snapshot now, rather than when the queued write starts.
    final snapshot = jsonEncode(_tasks.map(_toJson).toList());
    notifyListeners();
    _writeQueue = _writeQueue
        .then((_) => _preferences.setString(key, snapshot))
        .catchError((Object error) {
          debugPrint('Unable to save assignments: $error');
        });
  }

  Future<void> waitForPendingSaves() => _writeQueue;

  void addAssignment(Assignment task) {
    _tasks.add(task);
    _persistChanges();
  }

  void updateAssignment(
    Assignment task, {
    required String title,
    required String notes,
  }) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1 || title.trim().isEmpty) return;

    _tasks[index].title = title.trim();
    _tasks[index].notes = notes.trim();
    _persistChanges();
  }

  void deleteAssignment(Assignment task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;

    _tasks.removeAt(index);
    _persistChanges();
  }

  void toggleSubtask(Assignment task, int index, bool value) {
    if (index < 0 || index >= task.checkedSubtasks.length) return;
    task.checkedSubtasks[index] = value;
    _persistChanges();
  }

  void complete(Assignment task) {
    if (task.isCompleted) return;
    task.isCompleted = true;
    _persistChanges();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
