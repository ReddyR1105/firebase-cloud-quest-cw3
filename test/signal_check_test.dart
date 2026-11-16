import 'package:firebase_cloud_quest_cw3/quest.dart';
import 'package:firebase_cloud_quest_cw3/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('email validation handles whitespace and invalid addresses', () {
    expect(validateEmail(' learner@example.test '), isNull);
    expect(validateEmail('learner@'), isNotNull);
    expect(validateEmail(null), isNotNull);
  });

  test('question validation enforces blank and length boundaries', () {
    expect(validateQuestion('   '), isNotNull);
    expect(validateQuestion(List.filled(300, 'a').join()), isNull);
    expect(validateQuestion(List.filled(301, 'a').join()), isNotNull);
    expect(validateQuestion(List.filled(300, '👩‍💻').join()), isNull);
    expect(validateQuestion(List.filled(301, '👩‍💻').join()), isNotNull);
  });

  test('progress represents missing and completed documents', () {
    final empty = QuestProgress.fromMap(null);
    expect((empty.completed, empty.points, empty.badge), (false, 0, 'Locked'));
    final saved = QuestProgress.fromMap({
      'completed': true,
      'points': 10,
      'badgeId': 'first-quest',
    });
    expect(
      (saved.completed, saved.points, saved.badge),
      (true, 10, 'First Quest'),
    );
  });

  testWidgets(
    'sign-in validates inputs and opens registration on a small viewport',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 650));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const MaterialApp(home: SignInScreen()));
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid email address.'), findsOneWidget);
      expect(find.text('Enter at least 6 characters.'), findsOneWidget);
      final register = find.text('Create an account');
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();
      await tester.tap(register);
      await tester.pumpAndSettle();
      expect(find.text('Register'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
