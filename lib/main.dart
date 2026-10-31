import 'package:flutter/material.dart';
import 'data/task_store.dart';
import 'screens/login_screen.dart';

void main() => runApp(const AssignmentApp());

class AssignmentApp extends StatefulWidget {
  const AssignmentApp({super.key});

  @override
  State<AssignmentApp> createState() => _AssignmentAppState();
}

class _AssignmentAppState extends State<AssignmentApp> {
  final TaskStore _store = TaskStore();

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment & Deadline Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        scaffoldBackgroundColor: const Color(0xFFFAF9FE),
        appBarTheme: const AppBarTheme(centerTitle: true, backgroundColor: Color(0xFFFAF9FE)),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: LoginScreen(store: _store),
    );
  }
}
