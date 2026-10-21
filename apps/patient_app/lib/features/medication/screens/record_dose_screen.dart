import 'package:flutter/material.dart';

import '../models/dose_record.dart';

class RecordDoseScreen extends StatefulWidget {
  const RecordDoseScreen({super.key});

  @override
  State<RecordDoseScreen> createState() => _RecordDoseScreenState();
}

class _RecordDoseScreenState extends State<RecordDoseScreen> {
  DoseOutcome? _outcome;
  TimeOfDay _time = TimeOfDay.now();
  bool _approximate = false;
  String? _error;

  Future<void> _chooseTime() async {
    final selected = await showTimePicker(context: context, initialTime: _time);
    if (!mounted || selected == null) return;
    setState(() {
      _time = selected;
      _error = null;
    });
  }

  void _save() {
    final outcome = _outcome;
    if (outcome == null) return;
    final now = DateTime.now();
    final takenAt = outcome == DoseOutcome.taken
        ? DateTime(now.year, now.month, now.day, _time.hour, _time.minute)
        : null;
    if (takenAt != null && takenAt.isAfter(now)) {
      setState(
        () =>
            _error = 'Choose the time you already took it, not a future time.',
      );
      return;
    }
    Navigator.of(context).pop(
      DoseRecord(
        outcome: outcome,
        recordedAt: now,
        takenAt: takenAt,
        isApproximate: outcome == DoseOutcome.taken && _approximate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record a dose')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Medicine A',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Demo • Today at 08:00 AM • 1 tablet'),
            const SizedBox(height: 24),
            Text(
              'What happened?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Taken'),
                  selected: _outcome == DoseOutcome.taken,
                  onSelected: (_) => setState(() {
                    _outcome = DoseOutcome.taken;
                    _error = null;
                  }),
                ),
                ChoiceChip(
                  label: const Text('Skipped'),
                  selected: _outcome == DoseOutcome.skipped,
                  onSelected: (_) => setState(() {
                    _outcome = DoseOutcome.skipped;
                    _error = null;
                  }),
                ),
              ],
            ),
            if (_outcome == DoseOutcome.taken) ...[
              const SizedBox(height: 24),
              const Text('When did you take it today?'),
              TextButton.icon(
                onPressed: _chooseTime,
                icon: const Icon(Icons.access_time),
                label: Text(_time.format(context)),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('This time is approximate'),
                value: _approximate,
                onChanged: (value) =>
                    setState(() => _approximate = value ?? false),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'Record what happened. This does not change your schedule. '
              'Demo only: this report is not stored on the phone or sent to a caregiver.',
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _outcome == null ? null : _save,
              child: const Text('Save demo record'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
