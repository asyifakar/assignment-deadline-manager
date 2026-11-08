import 'package:flutter/material.dart';

import '../data/task_store.dart';
import '../models/assignment.dart';
import '../widgets/task_tile.dart';
import 'add_assignment_screen.dart';
import 'task_view_screen.dart';

// Assignment list with all Week 15 CRUD actions.
class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({
    super.key,
    required this.store,
    required this.userName,
  });

  final TaskStore store;
  final String userName;

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  bool _showCompleted = false;

  Future<void> _editAssignment(Assignment task) async {
    final formKey = GlobalKey<FormState>();
    String editedTitle = task.title;
    String editedNotes = task.notes;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Assignment'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: task.title,
                  decoration: const InputDecoration(
                    labelText: 'Assignment Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Title is required'
                      : null,
                  onSaved: (value) => editedTitle = value?.trim() ?? '',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: task.notes,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onSaved: (value) => editedNotes = value?.trim() ?? '',
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              formKey.currentState!.save();
              setState(() {
                widget.store.updateAssignment(
                  task,
                  title: editedTitle,
                  notes: editedNotes,
                );
              });
              Navigator.pop(dialogContext);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Assignment updated')),
                );
              }
            },
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAssignment(Assignment task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Assignment?'),
        content: Text('Delete "${task.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(dialogContext, true),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;
    setState(() {
      widget.store.deleteAssignment(task);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Assignment deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => AddAssignmentScreen(store: widget.store),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add Assignment'),
      ),
      body: Column(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Show completed assignments'),
            value: _showCompleted,
            onChanged: (value) => setState(() => _showCompleted = value),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: widget.store,
              builder: (context, child) {
                final tasks = widget.store.tasks
                    .where((task) => _showCompleted || !task.isCompleted)
                    .toList();
                tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));

                if (tasks.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        _showCompleted
                            ? 'No assignments yet. Tap Add Assignment to get started.'
                            : 'No active assignments. Turn on Show completed assignments to view finished tasks.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TaskTile(
                            task: task,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => TaskViewScreen(
                                  store: widget.store,
                                  task: task,
                                  userName: widget.userName,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () => _editAssignment(task),
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Edit'),
                              ),
                              const SizedBox(width: 8),
                              TextButton.icon(
                                onPressed: () => _deleteAssignment(task),
                                icon: const Icon(Icons.delete_outline),
                                label: const Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
