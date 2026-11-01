import 'package:assignment_deadline_manager/data/local_auth_service.dart';
import 'package:assignment_deadline_manager/data/task_store.dart';
import 'package:assignment_deadline_manager/main.dart';
import 'package:assignment_deadline_manager/models/assignment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Each test gets a fresh, in-memory implementation of the async storage API.
  // SharedPreferences.setMockInitialValues() only mocks the older legacy API.
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('Login rejects empty details', (tester) async {
    await tester.pumpWidget(const AssignmentApp());
    await tester.pump();

    expect(find.text('Welcome Back!'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'LOGIN'));
    await tester.pump();

    expect(find.text('Please enter your email and password.'), findsOneWidget);
  });

  testWidgets('Sign Up checks password confirmation', (tester) async {
    await tester.pumpWidget(const AssignmentApp());
    await tester.pump();

    await tester.tap(find.widgetWithText(OutlinedButton, 'SIGN UP'));
    await tester.pumpAndSettle();
    expect(find.text('Create Your Account'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Asyifa Example');
    await tester.enterText(fields.at(1), 'student@example.com');
    await tester.enterText(fields.at(2), 'password123');
    await tester.enterText(fields.at(3), 'notmatching');
    await tester.ensureVisible(find.text('CREATE ACCOUNT'));
    await tester.tap(find.text('CREATE ACCOUNT'));
    await tester.pump();

    expect(find.text('Passwords do not match.'), findsOneWidget);
  });

  test('Local registration accepts valid login and rejects wrong password', () async {
    final auth = LocalAuthService();
    final account = await auth.signUp(
      name: 'Asyifa Example',
      email: 'student@example.com',
      password: 'password123',
    );

    expect(account.firstName, 'Asyifa');
    expect(
      await auth.signIn(email: 'student@example.com', password: 'password123'),
      isNotNull,
    );
    expect(
      await auth.signIn(email: 'student@example.com', password: 'wrongpassword'),
      isNull,
    );
  });

  test('Tasks persist across stores and are isolated by account', () async {
    final store = TaskStore();
    await store.loadForAccount('student@example.com');
    store.addAssignment(Assignment(
      id: 'storage-test-1',
      title: 'Storage Test',
      subject: 'IT',
      source: 'Google Classroom',
      dueDate: DateTime(2026, 11, 15),
      priority: TaskPriority.high,
      notes: 'Check saving and reloading',
    ));
    await store.waitForPendingSaves();

    final reopened = TaskStore();
    await reopened.loadForAccount('student@example.com');
    expect(reopened.tasks.length, 1);
    expect(reopened.tasks.single.title, 'Storage Test');
    expect(reopened.tasks.single.priority, TaskPriority.high);

    reopened.complete(reopened.tasks.single);
    await reopened.waitForPendingSaves();
    final reopenedAgain = TaskStore();
    await reopenedAgain.loadForAccount('student@example.com');
    expect(reopenedAgain.tasks.single.isCompleted, isTrue);

    final otherAccount = TaskStore();
    await otherAccount.loadForAccount('other@example.com');
    expect(otherAccount.tasks, isEmpty);

    store.dispose();
    reopened.dispose();
    reopenedAgain.dispose();
    otherAccount.dispose();
  });
}
