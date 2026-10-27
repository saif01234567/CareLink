import 'dart:async';

import 'package:flutter/material.dart';

import '../data/dose_repository.dart';
import '../models/dose_record.dart';
import '../widgets/medicine_card.dart';
import 'record_dose_screen.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key, required this.repository, this.displayName});
  final String? displayName;
  final DoseRepository repository;

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> with WidgetsBindingObserver {
  DoseRecord? _record;
  String _day = doseDayKey(DateTime.now());
  bool _busy = true;
  bool _formOpen = false;
  String? _error;
  Timer? _dayTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
    _dayTimer = Timer.periodic(const Duration(seconds: 30), (_) => _checkDay());
  }

  @override
  void dispose() {
    _dayTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkDay();
  }

  void _checkDay() {
    if (!_busy && !_formOpen && doseDayKey(DateTime.now()) != _day) _load();
  }

  Future<void> _load() async {
    final day = doseDayKey(DateTime.now());
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final record = await widget.repository.read(day);
      if (!mounted) return;
      setState(() {
        _day = day;
        _record = record;
        _busy = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = 'Could not read phone storage. Retry before recording a dose.';
      });
    }
  }

  Future<void> _recordDose() async {
    if (_busy || _formOpen || _error != null) return;
    if (doseDayKey(DateTime.now()) != _day) {
      await _load();
      return;
    }
    final day = _day;
    _formOpen = true;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) =>
            RecordDoseScreen(repository: widget.repository, day: day),
      ),
    );
    _formOpen = false;
    if (!mounted) return;
    await _load();
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
              widget.displayName == null
                  ? 'Hello'
                  : 'Hello, ${widget.displayName}',
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
            if (_busy)
              const Center(child: CircularProgressIndicator())
            else if (_error != null) ...[
              Text(_error!),
              TextButton(onPressed: _load, child: const Text('Retry loading')),
            ] else
              MedicineCard(record: _record, onRecord: _recordDose),
            const SizedBox(height: 16),
            const Text(
              'Fictional patient and medicine. Demo reports are saved on this '
              'phone. Caregiver upload is not available yet. Clearing app data '
              'or uninstalling may remove these records.',
              style: TextStyle(fontSize: 14, color: Color(0xFF475569)),
            ),
          ],
        ),
      ),
    );
  }
}
