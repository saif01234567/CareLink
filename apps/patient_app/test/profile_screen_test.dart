import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carelink_patient/app.dart';

import 'fake_profile_repository.dart';
import 'widget_test.dart' show FakeRepository, press;

Future<void> openProfile(
  WidgetTester tester,
  FakeProfileRepository profiles,
) async {
  await tester.pumpWidget(
    CareLinkApp(repository: FakeRepository(), profiles: profiles),
  );
  await tester.pumpAndSettle();
  await press(tester, 'Profile');
}

void main() {
  testWidgets('Profile save updates Today and restores after app recreation', (
    tester,
  ) async {
    final profiles = FakeProfileRepository();
    await openProfile(tester, profiles);
    await press(tester, 'Edit profile');
    await tester.enterText(find.byType(TextFormField), 'Demo Sam');
    await press(tester, 'Save profile');
    expect(find.text('Demo Sam'), findsOneWidget);
    await press(tester, 'Today');
    expect(find.text('Hello, Demo Sam'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await openProfile(tester, profiles);
    expect(find.text('Demo Sam'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Blank name is blocked and cancellation keeps original', (
    tester,
  ) async {
    final profiles = FakeProfileRepository();
    await openProfile(tester, profiles);
    await press(tester, 'Edit profile');
    await tester.enterText(find.byType(TextFormField), '   ');
    await press(tester, 'Save profile');
    expect(find.text('Enter a demo name.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'Unsaved');
    await press(tester, 'Cancel changes');
    expect(find.text('Amina'), findsOneWidget);
    expect(profiles.profile.displayName, 'Amina');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Failed save keeps edits and supports retry', (tester) async {
    final profiles = FakeProfileRepository()..failSave = true;
    await openProfile(tester, profiles);
    await press(tester, 'Edit profile');
    await tester.enterText(find.byType(TextFormField), 'Demo Alex');
    await press(tester, 'Save profile');
    expect(
      find.text('Not saved. Your changes are still here. Please try again.'),
      findsOneWidget,
    );
    expect(profiles.profile.displayName, 'Amina');
    profiles.failSave = false;
    await press(tester, 'Save profile');
    expect(find.text('Demo Alex'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Read failure can be retried without overwriting profile', (
    tester,
  ) async {
    final profiles = FakeProfileRepository()..failRead = true;
    await openProfile(tester, profiles);
    expect(find.text('Edit profile'), findsNothing);
    profiles.failRead = false;
    await press(tester, 'Retry profile');
    expect(find.text('Amina'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
