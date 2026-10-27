import 'dose_record.dart';

// Connects a saved report to its scheduled day and dose.
class DoseHistoryEntry {
  const DoseHistoryEntry({
    required this.scheduledDay,
    required this.doseId,
    required this.record,
  });

  // The scheduled date, for example: 2026-10-27.
  final String scheduledDay;

  // Identifies which scheduled dose this report belongs to.
  final String doseId;

  // Contains Taken/Skipped, taken time, and report-entry time.
  final DoseRecord record;
}