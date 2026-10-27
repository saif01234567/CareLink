import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:carelink_patient/features/profile/data/sqlite_profile_repository.dart';
import 'package:carelink_patient/features/profile/models/patient_profile.dart';

void main() {
  sqfliteFfiInit();
  test('Profile survives database close, reopen and update', () async {
    final directory = await Directory.systemTemp.createTemp(
      'carelink-profile-test-',
    );
    final file = '${directory.path}/profile.db';
    SqliteProfileRepository open() => SqliteProfileRepository(
      factory: databaseFactoryFfi,
      databasePath: file,
    );
    var repository = open();
    try {
      expect((await repository.read()).displayName, 'Amina');
      await repository.save(const PatientProfile(displayName: 'Demo Sam'));
      await repository.close();
      repository = open();
      expect((await repository.read()).displayName, 'Demo Sam');
      await repository.save(const PatientProfile(displayName: 'Demo Alex'));
      expect((await repository.read()).displayName, 'Demo Alex');
      await expectLater(
        repository.save(const PatientProfile(displayName: '  ')),
        throwsArgumentError,
      );
      expect((await repository.read()).displayName, 'Demo Alex');
    } finally {
      await repository.close();
      await directory.delete(recursive: true);
    }
  });
}
