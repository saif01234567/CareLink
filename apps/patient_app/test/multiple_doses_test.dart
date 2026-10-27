import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:carelink_patient/features/medication/data/sqlite_dose_repository.dart';
import 'package:carelink_patient/features/medication/models/dose_record.dart';

void main() {
  sqfliteFfiInit();

  test('Morning and evening doses keep separate reports', () async {
    final repository = SqliteDoseRepository(
      factory: databaseFactoryFfi,
      databasePath: inMemoryDatabasePath,
    );

    const day = '2026-10-27';
    const morningId = 'demo-medicine-a-0800';
    const eveningId = 'demo-medicine-a-2000';
    const afternoonId = 'demo-medicine-b-1400';

    try {
      await repository.save(
        day,
        DoseRecord(
          outcome: DoseOutcome.taken,
          recordedAt: DateTime(2026, 10, 27, 8, 10),
          takenAt: DateTime(2026, 10, 27, 8, 5),
        ),
        doseId: morningId,
      );

      await repository.save(
        day,
        DoseRecord(
          outcome: DoseOutcome.skipped,
          recordedAt: DateTime(2026, 10, 27, 20, 10),
        ),
        doseId: eveningId,
      );

      final morning = await repository.read(
        day,
        doseId: morningId,
      );

      final evening = await repository.read(
        day,
        doseId: eveningId,
      );

      final afternoon = await repository.read(
        day,
        doseId: afternoonId,
      );

      expect(morning?.outcome, DoseOutcome.taken);
      expect(evening?.outcome, DoseOutcome.skipped);
      expect(afternoon, isNull);

      final history = await repository.readHistory();

      expect(history.length, 2);
      expect(
        history.map((entry) => entry.doseId),
        unorderedEquals([morningId, eveningId]),
      );
      expect(
        history.every((entry) => entry.scheduledDay == day),
        isTrue,
      );
    } finally {
      await repository.close();
    }
  });
}