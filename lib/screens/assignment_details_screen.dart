import 'package:flutter/material.dart';
import '../data/task_store.dart';
import '../models/assignment.dart';

// Sheika — Assignment Details / review-before-save wireframe.
class AssignmentDetailsScreen extends StatelessWidget {
  const AssignmentDetailsScreen({super.key, required this.store, required this.draft});
  final TaskStore store;
  final Assignment draft;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Assignment Details')),
      body: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 600),
        child: ListView(padding: const EdgeInsets.all(20), children: <Widget>[
          _detail('Assignment Title', draft.title),
          _detail('Subject', draft.subject),
          _detail('Platform / Source', draft.source),
          _detail('Due Date', '${draft.dueDate.day}/${draft.dueDate.month}/${draft.dueDate.year}'),
          _detail('Priority', draft.priority.label),
          _detail('Notes (Optional)', draft.notes.isEmpty ? 'No notes' : draft.notes),
          const SizedBox(height: 18),
          FilledButton(onPressed: () {
            store.addAssignment(draft);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Assignment saved.')));
            Navigator.pop(context, true);
          }, child: const Text('SAVE ASSIGNMENT')),
        ]))),
    );
  }

  Widget _detail(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 5),
      Card(child: ListTile(title: Text(value))),
    ]),
  );
}
