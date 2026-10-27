import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:carelink_patient/features/medication/data/sqlite_dose_repository.dart';
import 'package:carelink_patient/features/medication/models/dose_record.dart';

void main() {
  sqfliteFfiInit();

  test('Disk records survive reopening and remain separate by date', () async {
    final directory = await Directory.systemTemp.createTemp(
      'carelink-storage-test-',
    );
    final file = '${directory.path}/demo.db';
    SqliteDoseRepository open() =>
        SqliteDoseRepository(factory: databaseFactoryFfi, databasePath: file);
    var repository = open();
    try {
      final record = DoseRecord(
        outcome: DoseOutcome.taken,
        recordedAt: DateTime.utc(2026, 10, 27, 9),
        takenAt: DateTime.utc(2026, 10, 27, 8, 5),
        isApproximate: true,
      );
      await repository.save('2026-10-27', record);
      await repository.close();
      repository = open();
      final restored = await repository.read('2026-10-27');
      expect(restored!.outcome, DoseOutcome.taken);
      expect(restored.recordedAt.toUtc(), record.recordedAt);
      expect(restored.takenAt!.toUtc(), record.takenAt);
      expect(restored.isApproximate, isTrue);
      expect(await repository.read('2026-10-28'), isNull);
      await repository.save(
        '2026-10-28',
        DoseRecord(
          outcome: DoseOutcome.skipped,
          recordedAt: DateTime.utc(2026, 10, 28, 8),
        ),
      );
      expect((await repository.read('2026-10-27'))!.outcome, DoseOutcome.taken);
      expect(
        (await repository.read('2026-10-28'))!.outcome,
        DoseOutcome.skipped,
      );
    } finally {
      await repository.close();
      await directory.delete(recursive: true);
    }
  });

  test('Duplicate report cannot silently replace the original', () async {
    final repository = SqliteDoseRepository(
      factory: databaseFactoryFfi,
      databasePath: inMemoryDatabasePath,
    );
    try {
      final now = DateTime.now();
      await repository.save(
        '2026-10-27',
        DoseRecord(outcome: DoseOutcome.taken, recordedAt: now, takenAt: now),
      );
      await expectLater(
        repository.save(
          '2026-10-27',
          DoseRecord(outcome: DoseOutcome.skipped, recordedAt: now),
        ),
        throwsA(isA<DatabaseException>()),
      );
      expect((await repository.read('2026-10-27'))!.outcome, DoseOutcome.taken);
    } finally {
      await repository.close();
    }
  });
}
