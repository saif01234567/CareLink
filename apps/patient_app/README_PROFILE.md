# Demo Profile milestone

Work branch: saleem. This adds a working local Profile page, not account registration.

## Organisation
- lib/core/navigation/patient_shell.dart: Today/Profile tabs and shared saved name.
- lib/features/profile/models/patient_profile.dart: demo profile and name validation.
- lib/features/profile/data/profile_repository.dart: storage interface.
- lib/features/profile/data/sqlite_profile_repository.dart: separate local demo profile database.
- lib/features/profile/screens/profile_screen.dart: view, edit, save, cancel, and retry UI.

## Behaviour
- Name edits are trimmed and checked (required, maximum 60 characters).
- The greeting updates only after successful saving.
- Saved name survives restarting on the same installation.
- Failed reads show retry; failed saves retain the editor and do not claim success.
- Existing medication reports stay in their existing database.
- CL-DEMO-024 is a fixed, fictional display ID, not a unique account identifier.
- There is no functioning QR invitation, caregiver access, login or cloud backup yet.
- Only fictional names should be used in this unencrypted demo database.

## Emulator check
1. Stop and rerun the app.
2. Open Profile, choose Edit profile, enter a fictional name and save.
3. Open Today and check the greeting.
4. Restart the app and check the name and the existing dose report.
5. Try cancelling an edit; the saved name must stay unchanged.

Tests cover profile persistence, update, validation, cancellation and storage failures.
