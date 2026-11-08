import 'package:flutter/material.dart';

import '../data/task_store.dart';
import '../widgets/task_tile.dart';
import 'task_view_screen.dart';
import 'add_assignment_screen.dart';

// Seyna — Open Assignment / list navigation.
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
            onChanged: (v) => setState(() => _showCompleted = v),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: widget.store,
              builder: (context, child) {
                final tasks = widget.store.tasks
                    .where((t) => _showCompleted || !t.isCompleted)
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskTile(
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
