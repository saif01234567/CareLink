import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../models/patient_profile.dart';
import 'profile_repository.dart';

// A separate demo profile database leaves existing dose storage unchanged.
class SqliteProfileRepository implements ProfileRepository {
  SqliteProfileRepository({this.factory, this.databasePath});
  final DatabaseFactory? factory;
  final String? databasePath;
  Future<Database>? _opening;

  Future<Database> _database() => _opening ??= _open();

  Future<Database> _open() async {
    try {
      final selected = factory ?? databaseFactory;
      final file =
          databasePath ??
          path.join(
            await selected.getDatabasesPath(),
            'carelink_demo_profile_v1.db',
          );
      return await selected.openDatabase(
        file,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute(
              'CREATE TABLE profile (id INTEGER PRIMARY KEY CHECK(id = 1), display_name TEXT NOT NULL)',
            );
          },
        ),
      );
    } catch (_) {
      _opening = null;
      rethrow;
    }
  }

  @override
  Future<PatientProfile> read() async {
    final db = await _database();
    final rows = await db.query('profile', where: 'id = ?', whereArgs: [1]);
    if (rows.isEmpty) return PatientProfile.initial;
    final name = rows.single['display_name'] as String;
    if (PatientProfile.validateName(name) != null) {
      throw const FormatException('Invalid saved demo profile');
    }
    return PatientProfile(displayName: name);
  }

  @override
  Future<void> save(PatientProfile profile) async {
    final error = PatientProfile.validateName(profile.displayName);
    if (error != null) throw ArgumentError(error);
    final db = await _database();
    await db.insert('profile', {
      'id': 1,
      'display_name': profile.displayName.trim(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> close() async {
    final opening = _opening;
    if (opening != null) await (await opening).close();
    _opening = null;
  }
}
