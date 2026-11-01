import 'package:flutter/material.dart';
import '../data/task_store.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.userName, required this.store});
  final String userName;
  final TaskStore store;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Profile')),
    body: Center(child: Padding(padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 38)),
        const SizedBox(height: 16),
        Text(userName, style: Theme.of(context).textTheme.headlineSmall),
        const Text('Your tasks are stored locally on this browser/device.'),
        const SizedBox(height: 20),
        OutlinedButton(onPressed: () {
          store.signOut();
          Navigator.of(context).popUntil((route) => route.isFirst);
        }, child: const Text('LOG OUT')),
      ]))),
  );
}
