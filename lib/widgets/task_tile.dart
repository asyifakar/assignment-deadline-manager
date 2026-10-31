import 'package:flutter/material.dart';
import '../models/assignment.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, required this.onTap});
  final Assignment task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final date = '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(task.isCompleted ? Icons.check_circle : Icons.assignment_outlined,
          color: task.isCompleted ? Colors.green : Theme.of(context).colorScheme.primary),
        title: Text(task.title, style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          fontWeight: FontWeight.w600)),
        subtitle: Text('${task.subject} • Due $date'),
        trailing: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: <Widget>[
          Text(task.priority.label, style: const TextStyle(fontSize: 12)),
          const Icon(Icons.chevron_right, size: 18),
        ]),
        onTap: onTap,
      ),
    );
  }
}
