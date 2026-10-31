import 'package:flutter/material.dart';
import '../data/task_store.dart';
import '../models/assignment.dart';
import '../widgets/task_tile.dart';
import 'task_view_screen.dart';

// Asyifa — Calendar wireframe; clickable days and assignment previews.
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key, required this.store, required this.userName});
  final TaskStore store;
  final String userName;
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _month;
  late DateTime _selected;
  @override
  void initState() {
    super.initState();
    _selected = DateTime.now();
    _month = DateTime(_selected.year, _selected.month);
  }

  void _changeMonth(int offset) {
    setState(() {
      _month = DateTime(_month.year, _month.month + offset);
      _selected = DateTime(_month.year, _month.month, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstWeekday = _month.weekday - 1;
    final days = DateUtils.getDaysInMonth(_month.year, _month.month);
    final count = ((firstWeekday + days + 6) ~/ 7) * 7;
    return Scaffold(appBar: AppBar(title: const Text('Calendar')),
      body: AnimatedBuilder(animation: widget.store, builder: (context, child) {
        final selectedTasks = widget.store.tasks.where((t) => sameDay(t.dueDate, _selected)).toList();
        return ListView(padding: const EdgeInsets.all(16), children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            IconButton(onPressed: () => _changeMonth(-1), icon: const Icon(Icons.chevron_left)),
            Text('${_month.year} / ${_month.month}', style: Theme.of(context).textTheme.titleLarge),
            IconButton(onPressed: () => _changeMonth(1), icon: const Icon(Icons.chevron_right)),
          ]),
          Row(children: <Widget>[
            for (final name in <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'])
              Expanded(child: Center(child: Text(name, style: TextStyle(fontWeight: FontWeight.bold)))),
          ]),
          const SizedBox(height: 6),
          GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, childAspectRatio: 1),
            itemCount: count, itemBuilder: (context, index) {
              final number = index - firstWeekday + 1;
              if (number < 1 || number > days) return const SizedBox.shrink();
              final date = DateTime(_month.year, _month.month, number);
              final hasTask = widget.store.tasks.any((t) => sameDay(t.dueDate, date));
              final selected = sameDay(date, _selected);
              return InkWell(onTap: () => setState(() => _selected = date), child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(color: selected ? Theme.of(context).colorScheme.primaryContainer : null,
                  borderRadius: BorderRadius.circular(10)),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  Text('$number', style: TextStyle(fontWeight: selected ? FontWeight.bold : null)),
                  if (hasTask) const Icon(Icons.circle, size: 6, color: Colors.deepPurple),
                ]),
              ));
            }),
          const SizedBox(height: 20),
          Text('${_selected.day}/${_selected.month}/${_selected.year}', style: Theme.of(context).textTheme.titleLarge),
          if (selectedTasks.isEmpty) const ListTile(title: Text('No deadlines on this day.')),
          ...selectedTasks.map((t) => TaskTile(task: t, onTap: () => Navigator.push(context,
            MaterialPageRoute<void>(builder: (_) => TaskViewScreen(
              store: widget.store, task: t, userName: widget.userName))))),
        ]);
      }),
    );
  }
}
