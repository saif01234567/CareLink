import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../models/dose_record.dart';

class MedicineCard extends StatelessWidget {
  const MedicineCard({super.key, required this.record, required this.onRecord});

  final DoseRecord? record;
  final VoidCallback onRecord;

  @override
  Widget build(BuildContext context) {
    final taken = record?.outcome == DoseOutcome.taken;
    final label = record == null
        ? 'Not confirmed'
        : taken
        ? 'Reported taken'
        : 'Reported skipped';
    final takenAt = record?.takenAt;

    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '08:00 AM',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            const Icon(
              Icons.medication_outlined,
              size: 36,
              color: AppTheme.teal,
            ),
            const SizedBox(height: 12),
            Text(
              'Medicine A',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '1 tablet • Sample schedule',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Chip(
              label: Text(label),
              backgroundColor: taken
                  ? const Color(0xFFDCFCE7)
                  : const Color(0xFFFEF3C7),
              labelStyle: TextStyle(
                color: taken
                    ? const Color(0xFF166534)
                    : const Color(0xFF92400E),
              ),
            ),
            if (takenAt != null) ...[
              const SizedBox(height: 8),
              Text(
                'Taken today at ${TimeOfDay.fromDateTime(takenAt).format(context)}'
                '${record!.isApproximate ? ' (approximate)' : ''}',
              ),
            ],
            const SizedBox(height: 16),
            if (record == null)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onRecord,
                  child: const Text(
                    'Record dose',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            else
              const Text('Saved on this phone. Not uploaded.'),
          ],
        ),
      ),
    );
  }
}
