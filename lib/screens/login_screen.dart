import 'package:flutter/material.dart';
import '../data/task_store.dart';
import 'dashboard_screen.dart';

// Designed from Asyifa's Login / Sign Up wireframe.
// This is a LOCAL DEMO login, not an authenticated account system.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.store});
  final TaskStore store;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _showPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter your email and password.'),
        backgroundColor: Colors.red,
      ));
    } else {
      final userName = email.split('@').first;
      Navigator.push(context, MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/dashboard'),
        builder: (context) => DashboardScreen(store: widget.store, userName: userName),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log In')),
      body: Center(child: SingleChildScrollView(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(padding: const EdgeInsets.all(24), child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(Icons.school_outlined, size: 68, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            const Text('Welcome Back!', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text('Stay organized and never miss a deadline.', textAlign: TextAlign.center),
            const SizedBox(height: 30),
            TextField(controller: _emailController, keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email', hintText: 'moly@example.com', prefixIcon: Icon(Icons.mail_outline))),
            const SizedBox(height: 12),
            TextField(controller: _passwordController, obscureText: !_showPassword,
              decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(onPressed: () => setState(() => _showPassword = !_showPassword),
                  icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility)))),
            CheckboxListTile(contentPadding: EdgeInsets.zero, value: _rememberMe, title: const Text('Remember me'),
              onChanged: (value) => setState(() => _rememberMe = value ?? false)),
            const SizedBox(height: 6),
            FilledButton(onPressed: _login, child: const Text('LOGIN')),
            const SizedBox(height: 16),
            const Row(children: <Widget>[
              Expanded(child: Divider()),
              Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('or')),
              Expanded(child: Divider()),
            ]),
            const SizedBox(height: 8),
            const Text("Don't have an account? Sign up", textAlign: TextAlign.center),
            OutlinedButton(onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Sign up is not connected in this local prototype. Please use demo login.'),
              ));
            }, child: const Text('SIGN UP')),
            const SizedBox(height: 12),
            const Text('Demo only: enter any non-empty email and password. No account is created.',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
          ],
        )),
      ))),
    );
  }
}
