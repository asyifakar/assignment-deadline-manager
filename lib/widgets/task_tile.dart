import 'package:flutter/material.dart';
import '../models/assignment.dart';

/// Reusable assignment card used in Dashboard, Calendar and task lists.
class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, required this.onTap});

  final Assignment task;
  final VoidCallback onTap;

  String get _deadlineLabel {
    if (task.isCompleted) return 'Completed';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
    final days = due.difference(today).inDays;
    if (days == 0) return 'Due today';
    if (days == 1) return 'Tomorrow';
    if (days > 1) return '$days days left';
    if (days == -1) return '1 day overdue';
    return '${-days} days overdue';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isUrgent = !task.isCompleted &&
        task.dueDate.isBefore(DateTime.now().add(const Duration(days: 1)));
    final accent = task.isCompleted
        ? const Color(0xFF27825D)
        : isUrgent
            ? const Color(0xFFC45B48)
            : colors.primary;
    final date = '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: <Widget>[
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  task.isCompleted ? Icons.check_circle_outline : Icons.assignment_outlined,
                  color: accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${task.subject}  •  Due $date',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    _deadlineLabel,
                    style: TextStyle(color: accent, fontWeight: FontWeight.w700, fontSize: 11),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(task.priority.label,
                          style: TextStyle(color: colors.onSurfaceVariant, fontSize: 11)),
                      Icon(Icons.chevron_right, size: 18, color: colors.onSurfaceVariant),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
