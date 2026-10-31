import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.userName});
  final String userName;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Profile')),
    body: Center(child: Padding(padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 38)),
        const SizedBox(height: 16),
        Text(userName, style: Theme.of(context).textTheme.headlineSmall),
        const Text('Assignment & Deadline Manager • Local prototype'),
        const SizedBox(height: 20),
        OutlinedButton(onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
          child: const Text('Log Out')),
      ]))),
  );
}
