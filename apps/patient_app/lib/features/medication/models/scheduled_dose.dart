// Describes one dose in the daily medicine schedule.
class ScheduledDose {
  const ScheduledDose({
    required this.id,
    required this.medicineName,
    required this.doseDescription,
    required this.hour,
    required this.minute,
  }) : assert(hour >= 0 && hour <= 23),
        assert(minute >= 0 && minute <= 59);

  final String id;
  final String medicineName;
  final String doseDescription;

  // Uses a 24-hour clock: 20 means 8 PM.
  final int hour;
  final int minute;
}