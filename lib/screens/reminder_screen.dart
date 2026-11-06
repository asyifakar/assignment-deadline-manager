
import 'package:flutter/material.dart';
import '../data/task_store.dart';
import '../widgets/task_tile.dart';
import 'task_view_screen.dart';

// Moza — Deadline Reminder wireframe; reminders shown INSIDE the app only.
class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key, required this.store, required this.userName});
  final TaskStore store;
  final String userName;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Deadline Reminders')),
    body: AnimatedBuilder(animation: store, builder: (context, child) {
      final today = DateTime.now();
      final start = DateTime(today.year, today.month, today.day);
     if (near.isEmpty) {
  return const Center(
    child: Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_none_outlined, size: 48),
          SizedBox(height: 12),
          Text('No urgent deadlines right now.'),
          SizedBox(height: 6),
          Text(
            'Tasks with approaching deadlines will appear here.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
      return ListView(padding: const EdgeInsets.all(18), children: <Widget>[
        const Icon(Icons.notifications_active_outlined, size: 60, color: Colors.deepPurple),
        const SizedBox(height: 12),
        const Text('Keep going! Here are your closest deadlines.', textAlign: TextAlign.center),
        const SizedBox(height: 18),
        ...near.map((t) => TaskTile(task: t, onTap: () => Navigator.push(context,
          MaterialPageRoute<void>(builder: (_) => TaskViewScreen(store: store, task: t, userName: userName))))),
        const SizedBox(height: 20),
        const Text('Note: reminders appear inside this offline app. Device push notifications are not implemented.',
          textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
      ]);
    }),
  );
}
