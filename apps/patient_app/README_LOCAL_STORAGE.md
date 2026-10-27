# Patient app: demo phone storage

The patient app stores fictional dose reports in a local SQLite database.
This is a prototype milestone, not a production patient-record system.

## Files
- lib/features/medication/data/dose_repository.dart: storage interface and local date key.
- lib/features/medication/data/sqlite_dose_repository.dart: SQLite opening, schema, reading and saving.
- lib/features/medication/screens/today_screen.dart: loads the current day's report; refreshes after returning to the app or a day change.
- lib/features/medication/screens/record_dose_screen.dart: waits for saving; retains choices on failure.
- test/sqlite_dose_repository_test.dart: real SQLite reopen, day separation and duplicate protection.
- test/widget_test.dart: reporting, cancellation and storage failures.

## Behaviour
- One fictional Medicine A dose at 08:00 per local calendar day.
- Each report is keyed by day and demo dose ID.
- Taken time, approximate flag and report-entry time are stored separately.
- Yesterday's record stays in the database; it is not shown as today's report.
- A form opened before midnight remains attached to its displayed date.
- Saving and loading failures are visible; the app never claims a failed write succeeded.
- History is available. Caregiver upload, authentication, correction workflow and reminders are not implemented yet.
- UI says "Saved on this phone. Not uploaded." No automatic upload is promised.
- The demo database is not encrypted. Use fictional data only.
- Clearing app data or uninstalling may remove records.

## Manual check
1. Stop and run again after installing the new native SQLite plugin.
2. Record Taken, select time, optionally mark approximate, and save.
3. Stop the app completely and reopen it on the same emulator.
4. Confirm the same report is restored.
5. Cancellation and error states are covered by widget tests.

Git branch: saleem. Commit only this milestone's app files; unrelated planning/design files are separate.
