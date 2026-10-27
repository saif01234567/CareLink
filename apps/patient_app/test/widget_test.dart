import 'package:flutter/material.dart';
import 'package:carelink_patient/features/medication/models/dose_history_entry.dart';
import 'fake_profile_repository.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:carelink_patient/app.dart';
import 'package:carelink_patient/features/medication/data/dose_repository.dart';
import 'package:carelink_patient/features/medication/models/dose_record.dart';

class FakeRepository implements DoseRepository {
  final records = <String, DoseRecord>{};
  bool failRead = false;
  bool failSave = false;
  @override
  Future<DoseRecord?> read(String day) async {
    if (failRead) throw StateError('read failed');
    return records[day];
  }

  @override
  Future<void> save(String day, DoseRecord record) async {
    if (failSave) throw StateError('write failed');
    records[day] = record;
  }

  @override
  Future<List<DoseHistoryEntry>> readHistory() async {
    if (failRead) throw StateError('read failed');

    final entries = records.entries.map((entry) {
      return DoseHistoryEntry(
        scheduledDay: entry.key,
        doseId: 'demo-medicine-a-0800',
        record: entry.value,
      );
    }).toList();

    entries.sort(
          (a, b) => b.scheduledDay.compareTo(a.scheduledDay),
    );

    return entries;
  }
}

Future<void> launch(WidgetTester tester, FakeRepository repository) async {
  await tester.pumpWidget(
    CareLinkApp(repository: repository, profiles: FakeProfileRepository()),
  );
  await tester.pumpAndSettle();
}

Future<void> press(WidgetTester tester, String label) async {
  await Scrollable.ensureVisible(
    tester.element(find.text(label)),
    alignment: 0.5,
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Cancel leaves storage unchanged', (tester) async {
    final repository = FakeRepository();
    await launch(tester, repository);
    await press(tester, 'Record dose');
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Save demo record'),
          )
          .onPressed,
      isNull,
    );
    await press(tester, 'Taken');
    await press(tester, 'Cancel');
    expect(find.text('Not confirmed'), findsOneWidget);
    expect(repository.records, isEmpty);
    await tester.pumpWidget(const SizedBox());
  });

  for (final choice in ['Taken', 'Skipped']) {
    testWidgets('$choice is restored when screen is recreated', (tester) async {
      final repository = FakeRepository();
      await launch(tester, repository);
      await press(tester, 'Record dose');
      await press(tester, choice);
      await press(tester, 'Save demo record');
      final label = choice == 'Taken' ? 'Reported taken' : 'Reported skipped';
      expect(find.text(label), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await launch(tester, repository);
      expect(find.text(label), findsOneWidget);
      expect(find.text('Record dose'), findsNothing);
      expect(repository.records.length, 1);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('Save failure retains form and can retry', (tester) async {
    final repository = FakeRepository()..failSave = true;
    await launch(tester, repository);
    await press(tester, 'Record dose');
    await press(tester, 'Skipped');
    await press(tester, 'Save demo record');
    expect(
      find.text('Not saved. Please try again. Your choices are still here.'),
      findsOneWidget,
    );
    expect(repository.records, isEmpty);
    repository.failSave = false;
    await press(tester, 'Save demo record');
    expect(find.text('Reported skipped'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Read failure blocks new reporting until retry succeeds', (
    tester,
  ) async {
    final repository = FakeRepository()..failRead = true;
    await launch(tester, repository);
    expect(find.text('Record dose'), findsNothing);
    repository.failRead = false;
    await press(tester, 'Retry loading');
    expect(find.text('Record dose'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
