import 'package:flutter/material.dart';

import '../models/dose_record.dart';
import '../widgets/medicine_card.dart';
import 'record_dose_screen.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  // One demo dose. Storage and upload are not implemented yet.
  DoseRecord? _record;

  Future<void> _recordDose() async {
    final result = await Navigator.of(context).push<DoseRecord>(
      MaterialPageRoute(builder: (_) => const RecordDoseScreen()),
    );
    if (!mounted || result == null) return;
    setState(() => _record = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CareLink')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                avatar: Icon(Icons.science_outlined, size: 18),
                label: Text('Demo data'),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Hello, Amina',
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your day, one dose at a time.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            Text(
              'Today’s schedule',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            MedicineCard(record: _record, onRecord: _recordDose),
            const SizedBox(height: 16),
            const Text(
              'Fictional patient and medicine. Demo records stay only in this '
              'session and reset when the app restarts. Nothing is uploaded.',
              style: TextStyle(fontSize: 14, color: Color(0xFF475569)),
            ),
          ],
        ),
      ),
    );
  }
}
