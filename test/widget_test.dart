import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assignment_deadline_manager/main.dart';

void main() {
  testWidgets('Login validates blank inputs and navigates to dashboard', (tester) async {
    await tester.pumpWidget(const AssignmentApp());
    expect(find.text('Welcome Back!'), findsOneWidget);
    await tester.tap(find.text('LOGIN'));
    await tester.pump();
    expect(find.text('Please enter your email and password.'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'Moly@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'demo123');
    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Hi, Moly!'), findsOneWidget);
  });
}
