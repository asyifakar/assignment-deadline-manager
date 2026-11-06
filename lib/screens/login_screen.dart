import 'package:flutter/material.dart';

import '../data/local_auth_service.dart';
import '../data/task_store.dart';
import 'dashboard_screen.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.store});
  final TaskStore store;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthService _auth = LocalAuthService();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _rememberMe = false;
  bool _showPassword = false;
  bool _working = false;

  @override
  void initState() {
    super.initState();
    _restoreRememberedEmail();
  }

  Future<void> _restoreRememberedEmail() async {
    try {
      final email = await _auth.rememberedEmail();
      if (email != null && mounted && _email.text.isEmpty) {
        setState(() {
          _email.text = email;
          _rememberMe = true;
        });
      }
    } catch (_) { /* Remembering an email is optional. */ }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _email.text.trim();
    final password = _password.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email and password.')),
      );
      return;
    }
    if (!LocalAuthService.validEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email.')),
      );
      return;
    }
    setState(() => _working = true);
    try {
      final account = await _auth.signIn(email: email, password: password);
      if (account == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account not found or incorrect password. Please sign up first.')),
          );
        }
        return;
      }
      await widget.store.loadForAccount(account.email);
      await _auth.rememberEmail(_rememberMe ? account.email : null);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/dashboard'),
          builder: (_) => DashboardScreen(store: widget.store, userName: account.firstName),
        ),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not sign in: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(title: const Text('Log In')),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(Icons.school_outlined, size: 68, color: primary),
                  const SizedBox(height: 16),
                  const Text('Welcome Back!', textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const Text('Stay organized and never miss a deadline.', textAlign: TextAlign.center),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    textInputAction: TextInputAction.next,
                    enabled: !_working,
                    decoration: const InputDecoration(
                      labelText: 'Email', prefixIcon: Icon(Icons.mail_outline)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _password,
                    obscureText: !_showPassword,
                    autofillHints: const [AutofillHints.password],
                    enabled: !_working,
                    onSubmitted: (_) => _login(),
                    decoration: InputDecoration(
                      labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        tooltip: _showPassword ? 'Hide password' : 'Show password',
                        onPressed: () => setState(() => _showPassword = !_showPassword),
                        icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _rememberMe,
                    title: const Text('Remember email'),
                    onChanged: _working ? null : (v) => setState(() => _rememberMe = v ?? false),
                  ),
                  const SizedBox(height: 6),
                  FilledButton(
                    onPressed: _working ? null : _login,
                    child: _working
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('LOGIN'),
                  ),
                  const SizedBox(height: 16),
                  const Row(children: <Widget>[
                    Expanded(child: Divider()),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('or')),
                    Expanded(child: Divider()),
                  ]),
                  const SizedBox(height: 8),
                  const Text("Don't have an account? Sign up", textAlign: TextAlign.center),
                  OutlinedButton(
                    onPressed: _working ? null : () {
                      Navigator.of(context).push(MaterialPageRoute<void>(
                        settings: const RouteSettings(name: '/signup'),
                        builder: (_) => SignUpScreen(store: widget.store),
                      ));
                    },
                    child: const Text('SIGN UP'),
                  ),
                  const SizedBox(height: 14),
                  const Text('Accounts and assignments are saved locally in this browser/device.',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
