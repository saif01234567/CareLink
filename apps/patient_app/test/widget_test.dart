import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carelink_patient/app.dart';

void main() {
  testWidgets('Cancel leaves the dose unconfirmed', (tester) async {
    await tester.pumpWidget(const CareLinkApp());
    await tester.tap(find.text('Record dose'));
    await tester.pumpAndSettle();
    final save = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Save demo record'),
    );
    expect(save.onPressed, isNull);
    await tester.tap(find.text('Taken'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Cancel'));
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Not confirmed'), findsOneWidget);
  });

  for (final choice in ['Taken', 'Skipped']) {
    testWidgets('Save $choice updates the card once', (tester) async {
      await tester.pumpWidget(const CareLinkApp());
      await tester.tap(find.text('Record dose'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(choice));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Save demo record'));
      await tester.tap(find.text('Save demo record'));
      await tester.pumpAndSettle();
      expect(
        find.text(choice == 'Taken' ? 'Reported taken' : 'Reported skipped'),
        findsOneWidget,
      );
      expect(find.text('Record dose'), findsNothing);
      expect(find.text('Not confirmed'), findsNothing);
    });
  }
}
