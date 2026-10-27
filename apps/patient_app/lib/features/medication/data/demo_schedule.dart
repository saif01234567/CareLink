import '../models/scheduled_dose.dart';

// Fictional examples for testing the app.
// These are not treatment recommendations.
const demoSchedule = <ScheduledDose>[
  ScheduledDose(
    id: 'demo-medicine-a-0800',
    medicineName: 'Medicine A',
    doseDescription: '1 tablet',
    hour: 8,
    minute: 0,
  ),
  ScheduledDose(
    id: 'demo-medicine-b-1400',
    medicineName: 'Medicine B',
    doseDescription: '1 tablet',
    hour: 14,
    minute: 0,
  ),
  ScheduledDose(
    id: 'demo-medicine-a-2000',
    medicineName: 'Medicine A',
    doseDescription: '1 tablet',
    hour: 20,
    minute: 0,
  ),
];