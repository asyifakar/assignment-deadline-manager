import 'package:flutter/material.dart';
import '../data/task_store.dart';
import '../models/assignment.dart';
import 'add_assignment_screen.dart';

// Sheika — Mark As Completed confirmation wireframe.
class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key, required this.store, required this.task, required this.userName});
  final TaskStore store;
  final Assignment task;
  final String userName;

  void _returnHome(BuildContext context) {
    Navigator.popUntil(context, (route) => route.settings.name == '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Assignment Completed')),
      body: Center(child: Padding(padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const Icon(Icons.check_circle_outline, size: 110, color: Colors.green),
          const SizedBox(height: 18),
          const Text('Great Job!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text('You have completed ${task.title}.', textAlign: TextAlign.center),
          const SizedBox(height: 30),
          FilledButton(onPressed: () => _returnHome(context), child: const Text('VIEW DASHBOARD')),
          OutlinedButton(onPressed: () {
            final navigator = Navigator.of(context);
            navigator.popUntil((route) => route.settings.name == '/dashboard');
            navigator.push(MaterialPageRoute<void>(
              builder: (_) => AddAssignmentScreen(store: store)));
          }, child: const Text('ADD ANOTHER ASSIGNMENT')),
        ]))),
    );
  }
}
