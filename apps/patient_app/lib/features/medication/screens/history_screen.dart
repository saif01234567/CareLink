import 'package:flutter/material.dart';

import '../data/dose_repository.dart';
import '../models/dose_history_entry.dart';
import '../models/dose_record.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    super.key,
    required this.repository,
  });

  final DoseRepository repository;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<DoseHistoryEntry> _entries = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final entries = await widget.repository.readHistory();

      if (!mounted) return;

      setState(() {
        _entries = entries;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = 'Could not load your history. Please try again.';
      });
    }
  }

  String _formatTime(DateTime value) {
    final local = value.toLocal();
    final date = MaterialLocalizations.of(context).formatMediumDate(local);
    final time = TimeOfDay.fromDateTime(local).format(context);

    return '$date at $time';
  }

  Widget _buildEntry(DoseHistoryEntry entry) {
    final record = entry.record;
    final taken = record.outcome == DoseOutcome.taken;
    final takenAt = record.takenAt;

    final medicineName = entry.doseId == 'demo-medicine-a-0800'
        ? 'Medicine A'
        : entry.doseId;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              medicineName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Scheduled day: ${entry.scheduledDay}'),
            const SizedBox(height: 12),
            Chip(
              label: Text(
                taken ? 'Reported taken' : 'Reported skipped',
              ),
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
              Text('Taken: ${_formatTime(takenAt)}'),
              if (record.isApproximate)
                const Text('Taken time is approximate.'),
            ],
            const SizedBox(height: 8),
            Text('Reported: ${_formatTime(record.recordedAt)}'),
            const SizedBox(height: 8),
            const Text('Saved on this phone. Not uploaded.'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dose history'),
        actions: [
          IconButton(
            tooltip: 'Refresh history',
            onPressed: _loading ? null : _loadHistory,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              'Demo history • Reports saved on this phone',
            ),
            const SizedBox(height: 16),
            if (_error != null) ...[
              Text(_error!),
              TextButton(
                onPressed: _loadHistory,
                child: const Text('Retry'),
              ),
            ] else if (_entries.isEmpty)
              const Text(
                'No saved reports yet. Record a dose from Today '
                    'to see it here.',
              )
            else
              ..._entries.map(_buildEntry),
          ],
        ),
      ),
    );
  }
}