import 'package:flutter/material.dart';

import '../data/dose_repository.dart';
import '../models/dose_record.dart';

class RecordDoseScreen extends StatefulWidget {
  const RecordDoseScreen({
    super.key,
    required this.repository,
    required this.day,
  });
  final DoseRepository repository;
  final String day;

  @override
  State<RecordDoseScreen> createState() => _RecordDoseScreenState();
}

class _RecordDoseScreenState extends State<RecordDoseScreen> {
  DoseOutcome? _outcome;
  TimeOfDay _time = TimeOfDay.now();
  bool _approximate = false;
  bool _saving = false;
  String? _error;

  Future<void> _chooseTime() async {
    final selected = await showTimePicker(context: context, initialTime: _time);
    if (!mounted || selected == null) return;
    setState(() {
      _time = selected;
      _error = null;
    });
  }

  Future<void> _save() async {
    final outcome = _outcome;
    if (outcome == null || _saving) return;
    final now = DateTime.now();
    final day = DateTime.parse(widget.day);
    final takenAt = outcome == DoseOutcome.taken
        ? DateTime(day.year, day.month, day.day, _time.hour, _time.minute)
        : null;
    if (takenAt != null && takenAt.isAfter(now)) {
      setState(
        () =>
            _error = 'Choose the time you already took it, not a future time.',
      );
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.repository.save(
        widget.day,
        DoseRecord(
          outcome: outcome,
          recordedAt: now,
          takenAt: takenAt,
          isApproximate: outcome == DoseOutcome.taken && _approximate,
        ),
      );
      if (mounted) {
        setState(() => _saving = false);
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Not saved. Please try again. Your choices are still here.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: AbsorbPointer(
      absorbing: _saving,
      child: Scaffold(
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
              Text('Demo • ${widget.day} at 08:00 AM • 1 tablet'),
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
                Text('When did you take it on ${widget.day}?'),
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
                'Demo report: saved on this phone only. Caregiver upload is not available yet.',
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _outcome == null || _saving ? null : _save,
                child: Text(_saving ? 'Saving...' : 'Save demo record'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
