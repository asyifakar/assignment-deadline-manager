import 'package:flutter/material.dart';
import '../data/task_store.dart';
import '../models/assignment.dart';
import 'completed_screen.dart';

// Seyna — Open Assignment: dynamically shows details, checkable subtasks.
class TaskViewScreen extends StatefulWidget {
  const TaskViewScreen({super.key, required this.store, required this.task, required this.userName});
  final TaskStore store;
  final Assignment task;
  final String userName;

  @override
  State<TaskViewScreen> createState() => _TaskViewScreenState();
}

class _TaskViewScreenState extends State<TaskViewScreen> {
  void _complete() {
    if (widget.task.isCompleted) return;
    setState(() => widget.store.complete(widget.task));
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => CompletedScreen(
      store: widget.store, task: widget.task, userName: widget.userName)));
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    return Scaffold(appBar: AppBar(title: const Text('Assignment')),
      body: ListView(padding: const EdgeInsets.all(18), children: <Widget>[
        Card(child: ListTile(leading: const Icon(Icons.assignment),
          title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('Due ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}'),
          trailing: Text(task.priority.label))),
        const SizedBox(height: 18),
        Text('Description', style: Theme.of(context).textTheme.titleMedium),
        Card(child: Padding(padding: const EdgeInsets.all(16),
          child: Text(task.notes.isEmpty ? 'No description provided.' : task.notes))),
        const SizedBox(height: 18),
        Text('Platform / Source', style: Theme.of(context).textTheme.titleMedium),
        Card(child: ListTile(title: Text(task.source), subtitle: const Text('Attachments are not connected in this demo.'))),
        const SizedBox(height: 18),
        Text('Subtasks', style: Theme.of(context).textTheme.titleMedium),
        for (int i = 0; i < task.subtasks.length; i++)
          CheckboxListTile(title: Text(task.subtasks[i]), value: task.checkedSubtasks[i],
            onChanged: task.isCompleted ? null : (value) => setState(() =>
              widget.store.toggleSubtask(task, i, value ?? false))),
        const SizedBox(height: 18),
        if (task.isCompleted) const Card(child: ListTile(leading: Icon(Icons.check_circle, color: Colors.green),
          title: Text('Completed')))
        else FilledButton.icon(onPressed: _complete, icon: const Icon(Icons.done),
          label: const Text('MARK AS COMPLETED')),
      ]),
    );
  }
}
