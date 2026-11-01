import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Account registration and sign-in work locally on this browser/device.
/// This is NOT server-backed authentication and should not protect sensitive data.
class LocalAccount {
  const LocalAccount({required this.name, required this.email});
  final String name;
  final String email;
  String get firstName => name.trim().split(RegExp(r'\s+')).first;
}

class LocalAuthService {
  static const String _accountsKey = 'assignment_manager_accounts_v1';
  static const String _rememberedEmailKey = 'assignment_manager_remembered_email_v1';
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static bool validEmail(String email) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());

  String _hash(String salt, String password) =>
      sha256.convert(utf8.encode('$salt:$password')).toString();

  String _newSalt() {
    final random = Random.secure();
    return base64UrlEncode(List<int>.generate(24, (_) => random.nextInt(256)));
  }

  Future<List<Map<String, dynamic>>> _accounts() async {
    final raw = await _prefs.getString(_accountsKey);
    if (raw == null) return <Map<String, dynamic>>[];
    final decoded = jsonDecode(raw);
    if (decoded is! List) throw const FormatException('Invalid account storage.');
    return decoded.map((entry) => Map<String, dynamic>.from(entry as Map)).toList();
  }

  Future<LocalAccount> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final safeName = name.trim();
    final safeEmail = email.trim().toLowerCase();
    if (safeName.isEmpty || !validEmail(safeEmail) || password.length < 8) {
      throw const FormatException('Enter your name, a valid email and 8+ character password.');
    }
    final accounts = await _accounts();
    if (accounts.any((item) => item['email'] == safeEmail)) {
      throw const FormatException('This email already has a local account. Please log in.');
    }
    final salt = _newSalt();
    accounts.add(<String, dynamic>{
      'name': safeName,
      'email': safeEmail,
      'salt': salt,
      'passwordHash': _hash(salt, password),
    });
    await _prefs.setString(_accountsKey, jsonEncode(accounts));
    return LocalAccount(name: safeName, email: safeEmail);
  }

  Future<LocalAccount?> signIn({required String email, required String password}) async {
    final safeEmail = email.trim().toLowerCase();
    final accounts = await _accounts();
    for (final item in accounts) {
      if (item['email'] == safeEmail &&
          item['passwordHash'] == _hash(item['salt']?.toString() ?? '', password)) {
        return LocalAccount(name: item['name'].toString(), email: safeEmail);
      }
    }
    return null;
  }

  Future<String?> rememberedEmail() => _prefs.getString(_rememberedEmailKey);

  Future<void> rememberEmail(String? email) async {
    if (email == null) {
      await _prefs.remove(_rememberedEmailKey);
    } else {
      await _prefs.setString(_rememberedEmailKey, email);
    }
  }
}
