import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import '../models/dose_history_entry.dart';
import '../models/dose_record.dart';
import 'dose_repository.dart';

// This database contains fictional demo data only, isolated from future accounts.
class SqliteDoseRepository implements DoseRepository {
  SqliteDoseRepository({this.factory, this.databasePath});

  final DatabaseFactory? factory;
  final String? databasePath;
  Database? _database;

  Future<Database> _open() async {
    if (_database != null) return _database!;
    final selectedFactory = factory ?? databaseFactory;
    final file =
        databasePath ??
        path.join(
          await selectedFactory.getDatabasesPath(),
          'carelink_demo_v1.db',
        );
    _database = await selectedFactory.openDatabase(
      file,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE dose_reports (
            day TEXT NOT NULL,
            dose_id TEXT NOT NULL,
            outcome TEXT NOT NULL CHECK(outcome IN ('taken', 'skipped')),
            recorded_at TEXT NOT NULL,
            taken_at TEXT,
            approximate INTEGER NOT NULL CHECK(approximate IN (0, 1)),
            PRIMARY KEY(day, dose_id)
          )
        ''');
        },
      ),
    );
    return _database!;
  }

  @override
  Future<DoseRecord?> read(String day) async {
    final db = await _open();
    final rows = await db.query(
      'dose_reports',
      where: 'day = ? AND dose_id = ?',
      whereArgs: [day, 'demo-medicine-a-0800'],
    );
    if (rows.isEmpty) return null;
    final row = rows.single;
    return DoseRecord(
      outcome: DoseOutcome.values.byName(row['outcome'] as String),
      recordedAt: DateTime.parse(row['recorded_at'] as String).toLocal(),
      takenAt: row['taken_at'] == null
          ? null
          : DateTime.parse(row['taken_at'] as String).toLocal(),
      isApproximate: row['approximate'] == 1,
    );
  }

  @override
  Future<void> save(String day, DoseRecord record) async {
    final db = await _open();
    // Do not silently replace an existing report or create duplicate dose rows.
    await db.insert('dose_reports', {
      'day': day,
      'dose_id': 'demo-medicine-a-0800',
      'outcome': record.outcome.name,
      'recorded_at': record.recordedAt.toUtc().toIso8601String(),
      'taken_at': record.takenAt?.toUtc().toIso8601String(),
      'approximate': record.isApproximate ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.abort);
  }

  @override
  Future<List<DoseHistoryEntry>> readHistory() async {
    final db = await _open();

    final rows = await db.query(
      'dose_reports',
      orderBy: 'day DESC, dose_id ASC',
    );

    return rows.map((row) {
      final savedTakenTime = row['taken_at'] as String?;

      return DoseHistoryEntry(
        scheduledDay: row['day'] as String,
        doseId: row['dose_id'] as String,
        record: DoseRecord(
          outcome: DoseOutcome.values.byName(
            row['outcome'] as String,
          ),
          recordedAt: DateTime.parse(
            row['recorded_at'] as String,
          ).toLocal(),
          takenAt: savedTakenTime == null
              ? null
              : DateTime.parse(savedTakenTime).toLocal(),
          isApproximate: row['approximate'] == 1,
        ),
      );
    }).toList();
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
