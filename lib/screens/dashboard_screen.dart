import 'package:flutter/material.dart';
import '../data/task_store.dart';
import '../widgets/task_tile.dart';
import 'add_assignment_screen.dart';
import 'assignment_list_screen.dart';
import 'calendar_screen.dart';
import 'profile_screen.dart';
import 'reminder_screen.dart';
import 'task_view_screen.dart';

// Moza — Home Dashboard wireframe.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.store, required this.userName});
  final TaskStore store;
  final String userName;

  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), actions: <Widget>[
        IconButton(tooltip: 'Reminders', icon: const Icon(Icons.notifications_outlined),
          onPressed: () => _open(context, ReminderScreen(store: store, userName: userName))),
      ]),
      body: AnimatedBuilder(animation: store, builder: (context, child) {
        final upcoming = store.pending;
        return ListView(padding: const EdgeInsets.all(18), children: <Widget>[
          Text('Hi, $userName!', style: Theme.of(context).textTheme.headlineSmall),
          const Text("Let's stay organized today."),
          const SizedBox(height: 22),
          Row(children: <Widget>[
            Expanded(child: _SummaryCard(label: 'Total Tasks', number: store.tasks.length)),
            const SizedBox(width: 10),
            Expanded(child: _SummaryCard(label: 'To Do', number: upcoming.length)),
            const SizedBox(width: 10),
            Expanded(child: _SummaryCard(label: 'Done', number: store.tasks.where((t) => t.isCompleted).length)),
          ]),
          const SizedBox(height: 18),
          Text('Upcoming Deadlines', style: Theme.of(context).textTheme.titleLarge),
          if (upcoming.isEmpty) const Padding(padding: EdgeInsets.all(16), child: Text('All assignments completed!')),
          ...upcoming.take(3).map((t) => TaskTile(task: t,
            onTap: () => _open(context, TaskViewScreen(store: store, task: t, userName: userName)))),
          const SizedBox(height: 16),
          Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Wrap(spacing: 10, runSpacing: 10, children: <Widget>[
            FilledButton.icon(icon: const Icon(Icons.add), label: const Text('Add Assignment'),
              onPressed: () => _open(context, AddAssignmentScreen(store: store))),
            OutlinedButton.icon(icon: const Icon(Icons.calendar_month), label: const Text('View Calendar'),
              onPressed: () => _open(context, CalendarScreen(store: store, userName: userName))),
            OutlinedButton.icon(icon: const Icon(Icons.list), label: const Text('All Assignments'),
              onPressed: () => _open(context, AssignmentListScreen(store: store, userName: userName))),
            OutlinedButton.icon(icon: const Icon(Icons.notifications_active_outlined), label: const Text('Reminders'),
              onPressed: () => _open(context, ReminderScreen(store: store, userName: userName))),
          ]),
        ]);
      }),
      bottomNavigationBar: NavigationBar(selectedIndex: 0,
        onDestinationSelected: (i) {
          if (i == 1) _open(context, CalendarScreen(store: store, userName: userName));
          if (i == 2) _open(context, AssignmentListScreen(store: store, userName: userName));
          if (i == 3) _open(context, ProfileScreen(userName: userName));
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: 'Calendar'),
          NavigationDestination(icon: Icon(Icons.assignment_outlined), label: 'Assignments'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.label, required this.number});
  final String label;
  final int number;
  @override
  Widget build(BuildContext context) => Card(child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 6),
    child: Column(children: <Widget>[
      Text('$number', style: Theme.of(context).textTheme.headlineMedium),
      Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
    ]),
  ));
}
