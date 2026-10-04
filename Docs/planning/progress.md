# CareLink progress and working agreement

Last updated: 2026-10-04

## Current milestone

Step 1: requirements and feasibility. Initial documentation is prepared; the full milestone remains open until workflow decisions and ML feasibility are resolved.

## Decision record

| Date | Decision or fact | Basis |
| --- | --- | --- |
| 2026-10-04 | CareLink idea approved by supervisor and faculty | User confirmation |
| 2026-10-04 | No submission deadline communicated | User confirmation |
| 2026-10-04 | Saleem Aman expects to do most coding; teammates help with UI/UX and selected tasks | User confirmation |
| 2026-10-04 | Flutter, Angular, FastAPI, PostgreSQL, Python/scikit-learn direction accepted | User accepted recommendation |
| 2026-10-04 | Patients enter existing prescribed schedules | User accepted recommendation |
| 2026-10-04 | First demonstration uses one or more fixed daily times; weekly, interval-based, and as-needed schedules are outside that milestone | User accepted recommendation; workflow D-01 resolved |
| 2026-10-04 | For the first version, patients add/change their own schedules; caregivers and coordinators view authorized records and add notes but cannot add/change schedules | User confirmation; workflow D-03 resolved |
| 2026-10-04 | Add QR code/Patient ID connections and patient ability to remove caregivers, initially with a requested one- or two-week rule | QR/ID direction retained; timing request superseded below |
| 2026-10-04 | Initially selected a wait before removing a caregiver | Superseded by the user's later acceptance of confirmation-based immediate removal |
| 2026-10-04 | Confirm connections before sharing; patients may remove caregivers at any time with confirmation; caregivers may leave; reconnecting needs a new request and patient acceptance | Current accepted rule; replaces compulsory waiting to avoid trapping mistaken connections |
| 2026-10-04 | Caregiver sharing list accepted: identity, recorded conditions, medicines/schedules, dose reports, adherence summaries/alerts, health readings, and own relationship notes; show list before connection acceptance | User confirmation; no patient-record editing, private account information, or another caregiver's relationship notes |
| 2026-10-04 | Scheduled reminder with Taken/Skipped/Remind me later and 10-minute snooze | User accepted recommended reminder flow; snooze changes only the notification |
| 2026-10-04 | One gentle recording follow-up; unanswered doses remain not confirmed; later reporting with actual/approximate medicine time and separate entry time | User accepted response to taking medicine without tapping a button; follow-up delay later settled below; dose-timing thresholds remain open |
| 2026-10-04 | Send the single automatic recording follow-up 30 minutes after the original scheduled reminder if no Taken/Skipped report is available | User confirmation; this is not a late-dose threshold or an instruction to take medicine |

## Completed in this documentation increment

- Preserved existing proposal, dataset, and presentation files.
- Added scope, medication workflow, acceptance criteria, and initial ML feasibility notes.
- Added README navigation and implementation direction.
- Separated accepted decisions from proposed behavior and unresolved requirements.
- Recorded D-01 as accepted and specified daily scheduling, duplicate-time validation, and unsupported-pattern handling in the workflow acceptance criteria.
- Recorded D-03 as accepted and added checks for denied caregiver/coordinator schedule writes, denied writes to another patient's schedule, and authorized follow-up notes.
- Updated WF-05a with the accepted QR/ID request-and-confirm flow, immediate removal after confirmation, caregiver departure, and new agreement for reconnection. Replaced old waiting-period criteria with cancellation, access-revocation, pending-alert, and failed-request criteria. Preserved superseded decisions above for history.
- Added WF-05b with the accepted caregiver access list and verification criteria for the sharing explanation, forbidden patient-record edits, and separation of different caregivers' notes. These are documented requirements, not implemented or executed application tests.
- Updated WF-02 through WF-04 for accepted reminders, snooze, one recording follow-up, honest no-response labels, and later reports. Added criteria for timestamps, approximate times, suppressing unnecessary reminders, and avoiding double counting.
- Set the recording follow-up to 30 minutes and updated AC-32 with an 08:00-to-08:30 example. This is a checked documentation change, not an implemented notification or executed application test.

## Still open in Step 1

- Settle workflow decisions D-02 and D-04 through D-08 in the medication workflow. D-01 and D-03 are resolved for the first version.
- D-02 and D-07 are partly resolved: basic reminders, the 30-minute follow-up, and later reporting are accepted. Pending-to-unconfirmed timing, late-dose thresholds, snooze interaction, and correction rules still need definition.
- D-04's main connection/removal flow and caregiver access list are accepted. Remaining details: confirmation security method, reverse invitations, coordinator permissions/assignment, historical-note access after reconnection, and whether "caretaker" names a separate role. No waiting-period length or start point needs choosing.
- Find and audit data that supports the adherence target, or document an accepted alternative.
- Agree concrete teammate contributions and reconcile older responsibility tables.
- Decide how to include the current Template #4 source in versioned documentation.

## Roadmap

| Step | Deliverable | Exit condition |
| --- | --- | --- |
| 1 | Scope, workflow, data feasibility | Unresolved requirements have decisions; ML approach is feasible or an alternative is explicitly accepted |
| 2 | Design and stack detail | Screens, entity relationships, API contracts, and a small Angular feasibility exercise are reviewed |
| 3 | Project foundation | Team can run initial components with documented setup and basic checks |
| 4 | Core medication workflow | First demonstration acceptance criteria pass |
| 5 | Remaining modules and ML integration | Approved scope implemented with evaluated model, reporting, health readings, alerts, and access controls |
| 6 | Final verification and defense | Reproducible demonstration, documented limitations, and requirements-to-test evidence |

Do not automatically advance to another milestone simply because documentation was drafted.

## Repository state

The active Git working folder is now `C:/CareLink-Repo`, cloned from `https://github.com/saif01234567/CareLink`. The original `C:/CareLink-FYP` folder remains a separate copy and should no longer be used for ongoing edits.

The initial planning documents were committed as `383d899` on branch `docs/initial-planning` and pushed to GitHub. Pull request #1 was opened for review: https://github.com/saif01234567/CareLink/pull/1. The planning milestone remains in progress.

## Files for this documentation commit

- `README.md`
- `Docs/planning/project-scope.md`
- `Docs/planning/ml-feasibility.md`
- `Docs/planning/progress.md`
- `Docs/requirements/medication-workflow.md`

Suggested message: `docs: define CareLink scope and initial medication workflow`

Stage only the listed changes after verifying them in a proper checkout. Existing datasets and historical documents are not part of this change. Commit as a draft requirements increment; do not claim that Step 1 or the ML feasibility investigation is complete.

## Reporting convention

For each completed increment, report what changed, exact files, verification performed, unresolved issues, and suggested commit message. Commit and push only when the user requests it. Keep contributions attributed to their actual authors and preserve meaningful incremental history.
