import 'package:flutter/material.dart';

import '../data/profile_repository.dart';
import '../models/patient_profile.dart';
import '../../../core/notifications/notification_test_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.repository,
    required this.onProfileChanged,
  });
  final ProfileRepository repository;
  final ValueChanged<PatientProfile> onProfileChanged;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  PatientProfile? _profile;
  bool _loading = true;
  bool _editing = false;
  bool _saving = false;
  String? _loadError;
  String? _saveError;
  String? _notice;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final profile = await widget.repository.read();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _loading = false;
      });
      widget.onProfileChanged(profile);
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _loadError = 'Could not load your demo profile. Please retry.';
        });
      }
    }
  }

  void _edit() {
    _name.text = _profile!.displayName;
    setState(() {
      _editing = true;
      _saveError = null;
      _notice = null;
    });
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    final profile = PatientProfile(displayName: _name.text.trim());
    setState(() {
      _saving = true;
      _saveError = null;
    });
    try {
      await widget.repository.save(profile);
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _saving = false;
        _editing = false;
        _notice = 'Demo profile saved on this phone.';
      });
      widget.onProfileChanged(profile);
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _saveError =
              'Not saved. Your changes are still here. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Your profile')),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              avatar: Icon(Icons.science_outlined, size: 18),
              label: Text('Demo profile'),
            ),
          ),
          const SizedBox(height: 16),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_loadError != null) ...[
            Text(_loadError!),
            TextButton(onPressed: _load, child: const Text('Retry profile')),
          ] else ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.person_outline, size: 32),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_editing)
                      Form(
                        key: _form,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _name,
                              enabled: !_saving,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                labelText: 'Demo name',
                                helperText:
                                    'Use a fictional name for this prototype.',
                                border: OutlineInputBorder(),
                              ),
                              validator: PatientProfile.validateName,
                            ),
                            if (_saveError != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                _saveError!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: _saving ? null : _save,
                              child: Text(
                                _saving ? 'Saving profile...' : 'Save profile',
                              ),
                            ),
                            TextButton(
                              onPressed: _saving
                                  ? null
                                  : () => setState(() {
                                      _editing = false;
                                      _saveError = null;
                                    }),
                              child: const Text('Cancel changes'),
                            ),
                          ],
                        ),
                      )
                    else ...[
                      Text(
                        _profile!.displayName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      const Text('Patient • Demo'),
                      const SizedBox(height: 16),
                      const Text('Demo patient ID'),
                      const SelectableText(PatientProfile.demoId),
                      const SizedBox(height: 8),
                      const Text(
                        'Example ID only. It cannot connect to a caregiver.',
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: _edit,
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit profile'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (_notice != null) ...[
              const SizedBox(height: 12),
              Text(_notice!, semanticsLabel: _notice),
            ],
          ],
          const SizedBox(height: 20),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Caregiver connections',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Not available in this demo yet. QR invitations and patient approval will be added when accounts are connected.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const NotificationTestCard(),
          const SizedBox(height: 16),
          const Text(
            'Saved on this phone only. No account or cloud backup is connected. '
            'Use fictional details. Clearing app data or uninstalling may remove them.',
          ),
        ],
      ),
    ),
  );
}
