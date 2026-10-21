enum DoseOutcome { taken, skipped }

// A self-report, not proof that medicine was swallowed.
// Taken time and the time the report was entered are kept separately.
class DoseRecord {
  const DoseRecord({
    required this.outcome,
    required this.recordedAt,
    this.takenAt,
    this.isApproximate = false,
  });

  final DoseOutcome outcome;
  final DateTime recordedAt;
  final DateTime? takenAt;
  final bool isApproximate;
}
