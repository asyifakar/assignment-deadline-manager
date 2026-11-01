import 'package:flutter/material.dart';

import '../data/local_auth_service.dart';
import '../data/task_store.dart';
import 'dashboard_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.store});
  final TaskStore store;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = LocalAuthService();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  bool _working = false;
  bool _showPassword = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _working = true);
    try {
      final account = await _auth.signUp(
        name: _name.text, email: _email.text, password: _password.text,
      );
      await widget.store.loadForAccount(account.email);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/dashboard'),
          builder: (_) => DashboardScreen(store: widget.store, userName: account.firstName),
        ),
      );
    } on FormatException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to create a local account: $error')),
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
      appBar: AppBar(title: const Text('Sign Up')),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(Icons.school_outlined, size: 68, color: primary),
                    const SizedBox(height: 12),
                    const Text('Create Your Account', textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('Organize your own assignments and deadlines.', textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      enabled: !_working,
                      decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Full name is required.' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      enabled: !_working,
                      decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline)),
                      validator: (v) => !LocalAuthService.validEmail(v ?? '') ? 'Enter a valid email.' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _password,
                      obscureText: !_showPassword,
                      textInputAction: TextInputAction.next,
                      enabled: !_working,
                      decoration: InputDecoration(
                        labelText: 'Password (8+ characters)', prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: _showPassword ? 'Hide password' : 'Show password',
                          onPressed: () => setState(() => _showPassword = !_showPassword),
                          icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                        ),
                      ),
                      validator: (v) => (v ?? '').length < 8 ? 'Use at least 8 characters.' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _confirmation,
                      obscureText: !_showPassword,
                      enabled: !_working,
                      onFieldSubmitted: (_) => _signUp(),
                      decoration: const InputDecoration(labelText: 'Confirm Password',
                          prefixIcon: Icon(Icons.verified_user_outlined)),
                      validator: (v) => v != _password.text ? 'Passwords do not match.' : null,
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _working ? null : _signUp,
                      child: _working
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('CREATE ACCOUNT'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _working ? null : () => Navigator.of(context).pop(),
                      child: const Text('BACK TO LOGIN'),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Local offline account: it works on this browser/device only. '
                      'Do not use a password from your real email or other accounts.',
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
