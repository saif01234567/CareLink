import 'package:flutter/material.dart';
import '../../features/medication/screens/history_screen.dart';
import '../../features/medication/data/dose_repository.dart';
import '../../features/medication/screens/today_screen.dart';
import '../../features/profile/data/profile_repository.dart';
import '../../features/profile/models/patient_profile.dart';
import '../../features/profile/screens/profile_screen.dart';

class PatientShell extends StatefulWidget {
  const PatientShell({super.key, required this.doses, required this.profiles});
  final DoseRepository doses;
  final ProfileRepository profiles;

  @override
  State<PatientShell> createState() => _PatientShellState();
}

class _PatientShellState extends State<PatientShell> {
  int _selected = 0;
  PatientProfile? _profile;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(
      index: _selected,
      children: [
        TodayScreen(
          repository: widget.doses,
          displayName: _profile?.displayName,
        ),
        HistoryScreen(
          key: ValueKey(_selected == 1),
          repository: widget.doses,
        ),
        ProfileScreen(
          repository: widget.profiles,
          onProfileChanged: (profile) => setState(() => _profile = profile),
        ),
      ],
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _selected,
      onDestinationSelected: (index) => setState(() => _selected = index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Today',
        ),
        NavigationDestination(
          icon: Icon(Icons.history_outlined),
          selectedIcon: Icon(Icons.history),
          label: 'History',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    ),
  );
}
