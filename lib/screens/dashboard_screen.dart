import 'package:flutter/material.dart';
import '../data/task_store.dart';
import '../widgets/task_tile.dart';
import 'add_assignment_screen.dart';
import 'assignment_list_screen.dart';
import 'calendar_screen.dart';
import 'profile_screen.dart';
import 'reminder_screen.dart';
import 'task_view_screen.dart';

/// Home Dashboard: inspired by the group's Figma wireframe.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.store, required this.userName});

  final TaskStore store;
  final String userName;

  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.w700)),
        actions: <Widget>[
          IconButton(
            tooltip: 'Deadline reminders',
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _open(
              context,
              ReminderScreen(store: store, userName: userName),
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, child) {
          final upcoming = store.pending;
          final completed = store.tasks.where((t) => t.isCompleted).length;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 940),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[Color(0xFF6B5798), Color(0xFF8875B5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.auto_awesome_outlined,
                            color: Colors.white, size: 34),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Hi, $userName!',
                                  style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  )),
                              const SizedBox(height: 5),
                              const Text("Let's stay organized today.",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _SummaryCard(
                          label: 'Total Tasks', number: store.tasks.length,
                          icon: Icons.assignment_outlined,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _SummaryCard(
                          label: 'To Do', number: upcoming.length,
                          icon: Icons.schedule_outlined,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _SummaryCard(
                          label: 'Done', number: completed,
                          icon: Icons.task_alt_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 23),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Upcoming Deadlines',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              )),
                      TextButton(
                        onPressed: () => _open(
                          context,
                          AssignmentListScreen(store: store, userName: userName),
                        ),
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (upcoming.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: Text('All assignments completed! 🎉')),
                      ),
                    )
                  else
                    ...upcoming.take(3).map(
                      (task) => TaskTile(
                        task: task,
                        onTap: () => _open(
                          context,
                          TaskViewScreen(
                            store: store,
                            task: task,
                            userName: userName,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 19),
                  Text('Quick Actions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          )),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 700 ? 4 : 2;
                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: columns,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: columns == 4 ? 2.0 : 1.55,
                        children: <Widget>[
                          _ActionCard(
                            icon: Icons.add_circle_outline,
                            label: 'Add Assignment',
                            onTap: () => _open(context, AddAssignmentScreen(store: store)),
                          ),
                          _ActionCard(
                            icon: Icons.calendar_month_outlined,
                            label: 'View Calendar',
                            onTap: () => _open(context,
                                CalendarScreen(store: store, userName: userName)),
                          ),
                          _ActionCard(
                            icon: Icons.list_alt_outlined,
                            label: 'All Assignments',
                            onTap: () => _open(context,
                                AssignmentListScreen(store: store, userName: userName)),
                          ),
                          _ActionCard(
                            icon: Icons.notifications_active_outlined,
                            label: 'Reminders',
                            onTap: () => _open(context,
                                ReminderScreen(store: store, userName: userName)),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        indicatorColor: colors.primaryContainer,
        onDestinationSelected: (index) {
          if (index == 1) {
            _open(context, CalendarScreen(store: store, userName: userName));
          } else if (index == 2) {
            _open(context, AssignmentListScreen(store: store, userName: userName));
          } else if (index == 3) {
            _open(context, ProfileScreen(userName: userName));
          }
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: 'Calendar'),
          NavigationDestination(icon: Icon(Icons.assignment_outlined), label: 'Assignments'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.label, required this.number, required this.icon});

  final String label;
  final int number;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 4),
        child: Column(
          children: <Widget>[
            Icon(icon, size: 20, color: colors.primary),
            const SizedBox(height: 5),
            Text('$number',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 3),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: colors.primary, size: 27),
              const SizedBox(height: 7),
              Text(label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
