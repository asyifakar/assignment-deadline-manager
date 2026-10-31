import 'package:flutter/material.dart';
import '../data/task_store.dart';
import '../models/assignment.dart';
import 'assignment_details_screen.dart';

// Seyna — Add Assignment wireframe. Form + controller + validation.
class AddAssignmentScreen extends StatefulWidget {
  const AddAssignmentScreen({super.key, required this.store});
  final TaskStore store;
  @override
  State<AddAssignmentScreen> createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  String _subject = 'Mathematics';
  String _source = 'Google Classroom';
  TaskPriority _priority = TaskPriority.medium;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _chooseDate() async {
    final date = await showDatePicker(context: context, initialDate: _dueDate,
      firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (date != null && mounted) setState(() => _dueDate = date);
  }

  Future<void> _next() async {
    if (_title.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter an assignment title.'), backgroundColor: Colors.red));
      return;
    }
    final draft = Assignment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _title.text.trim(), subject: _subject, source: _source,
      dueDate: _dueDate, priority: _priority, notes: _notes.text.trim());
    final saved = await Navigator.push<bool>(context, MaterialPageRoute<bool>(
      builder: (_) => AssignmentDetailsScreen(store: widget.store, draft: draft)));
    if (saved == true && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Add Assignment')),
      body: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 600),
        child: ListView(padding: const EdgeInsets.all(20), children: <Widget>[
          TextField(controller: _title, decoration: const InputDecoration(
            labelText: 'Assignment Title', hintText: 'e.g. Math Homework')),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(initialValue: _subject, decoration: const InputDecoration(labelText: 'Subject'),
            items: <String>['Mathematics', 'English', 'Biology', 'Economics', 'Sociology', 'IT', 'Other']
              .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => _subject = v ?? _subject)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(initialValue: _source, decoration: const InputDecoration(labelText: 'Platform / Source'),
            items: <String>['Google Classroom', 'WhatsApp', 'Email', 'Other']
              .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => _source = v ?? _source)),
          const SizedBox(height: 16),
          OutlinedButton.icon(onPressed: _chooseDate, icon: const Icon(Icons.calendar_today),
            label: Text('Due Date: ${_dueDate.day}/${_dueDate.month}/${_dueDate.year}')),
          const SizedBox(height: 16),
          const Text('Priority'),
          SegmentedButton<TaskPriority>(segments: TaskPriority.values
            .map((p) => ButtonSegment<TaskPriority>(value: p, label: Text(p.label))).toList(),
            selected: <TaskPriority>{_priority}, onSelectionChanged: (values) => setState(() => _priority = values.first)),
          const SizedBox(height: 16),
          TextField(controller: _notes, maxLines: 4, decoration: const InputDecoration(
            labelText: 'Notes (Optional)', hintText: 'Add notes here...')),
          const SizedBox(height: 22),
          FilledButton(onPressed: _next, child: const Text('NEXT')),
        ]))),
    );
  }
}
