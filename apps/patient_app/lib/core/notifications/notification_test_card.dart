import 'package:flutter/material.dart';

import 'notification_service.dart';

class NotificationTestCard extends StatefulWidget {
  const NotificationTestCard({super.key});

  @override
  State<NotificationTestCard> createState() => _NotificationTestCardState();
}

class _NotificationTestCardState extends State<NotificationTestCard> {
  bool _busy = false;
  String? _message;

  Future<void> _test() async {
    if (_busy) return;

    setState(() {
      _busy = true;
      _message = null;
    });

    try {
      final allowed =
      await NotificationService.instance.showTestNotification();

      if (!mounted) return;

      setState(() {
        _message = allowed
            ? 'Test sent to Android. Check your notification panel.'
            : 'Notifications are not allowed. You can enable them in '
            'Android Settings → Apps → CareLink → Notifications.';
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _message = 'Could not send the test notification. '
            'Check the app console for setup problems and try again.';
      });
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Notification setup',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Send a test notification. Medicine reminders '
                  'are not scheduled yet.',
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _busy ? null : _test,
              icon: const Icon(Icons.notifications_outlined),
              label: Text(_busy ? 'Please wait...' : 'Test notification'),
            ),
            if (_message != null) ...[
              const SizedBox(height: 12),
              Text(_message!),
            ],
          ],
        ),
      ),
    );
  }
}