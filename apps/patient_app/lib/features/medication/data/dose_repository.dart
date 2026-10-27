import '../models/dose_record.dart';
import '../models/dose_history_entry.dart';

String doseDayKey(DateTime day) =>
    '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

abstract class DoseRepository {
  Future<DoseRecord?> read(String day);
  Future<void> save(String day, DoseRecord record);
  Future<List<DoseHistoryEntry>> readHistory();
}
