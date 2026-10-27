import '../models/dose_record.dart';
import '../models/dose_history_entry.dart';

String doseDayKey(DateTime day) =>
    '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

// Keeps existing callers working while we connect the multi-dose screens.
const defaultDemoDoseId = 'demo-medicine-a-0800';

abstract class DoseRepository {
  Future<DoseRecord?> read(
      String day, {
        String doseId = defaultDemoDoseId,
      });

  Future<void> save(
      String day,
      DoseRecord record, {
        String doseId = defaultDemoDoseId,
      });

  Future<List<DoseHistoryEntry>> readHistory();
}