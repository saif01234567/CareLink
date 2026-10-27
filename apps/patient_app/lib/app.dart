import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/navigation/patient_shell.dart';
import 'features/medication/data/dose_repository.dart';
import 'features/medication/data/sqlite_dose_repository.dart';
import 'features/profile/data/profile_repository.dart';
import 'features/profile/data/sqlite_profile_repository.dart';

class CareLinkApp extends StatelessWidget {
  CareLinkApp({
    super.key,
    DoseRepository? repository,
    ProfileRepository? profiles,
  }) : repository = repository ?? SqliteDoseRepository(),
       profiles = profiles ?? SqliteProfileRepository();
  final DoseRepository repository;
  final ProfileRepository profiles;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'CareLink',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: PatientShell(doses: repository, profiles: profiles),
  );
}
