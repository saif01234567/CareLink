# CareLink project scope

Recorded: 2026-10-04

## Status and basis

The user confirmed that the supervisor and faculty approved the CareLink idea. The user accepted the technology recommendation and patient entry of existing prescribed medication schedules. Approval of the idea is distinct from approval of each detailed requirement below.

The scope reflects the supplied 27-page `CareLink_Template#4.pdf` and subsequent discussion. The PDF is outside the repository. Existing proposal files are preserved as historical material; differences should be recorded rather than silently overwritten.

No submission deadline has been communicated. Plan by completion criteria until a deadline is known.

## Purpose

Support reported medication adherence and human care coordination for hypertension and diabetes through a patient Android application and a web portal. Study whether suitable historical adherence data can support useful risk estimates.

## Approved proposal scope

1. Patient profiles and selected chronic conditions.
2. Medication records and schedules.
3. Reported medication events and adherence analysis.
4. Recording selected health readings, such as blood pressure and glucose.
5. Development and evaluation of a project-specific adherence-risk model.
6. Medication reminders and predefined support rules.
7. Caregiver and care-coordinator views of authorized patients.
8. Alerts and notifications with controls against unnecessary repetition.
9. Patient and care-team reports, including follow-up history.
10. Authentication, authorization, privacy controls, and relevant audit records.

The first demonstration is a development milestone within this scope, not a reduction of the final proposal commitments.

## Exclusions

- Autonomous diagnosis, prescribing, or treatment changes.
- Direct verification that medication was swallowed.
- AI-agent architecture, camera-based intake verification, and mandatory IoT or pill-box hardware.
- Hospital/EMR and pharmacy integration.
- Clinical deployment or claims of clinical validation.

## User roles

| Role | Intended responsibility | Permission status |
| --- | --- | --- |
| Patient | Maintain own profile, add and change own existing prescribed schedules, report events, view own history | Own schedule entry/editing accepted for first version; edit timing and correction details pending |
| Caregiver | View the agreed patient information and add notes for their own care relationship | Access list accepted in WF-05b; no editing patient medicines, schedules, dose reports, or readings; no other caregivers' notes; QR/ID connection and leaving accepted |
| Care coordinator | Review authorized assigned patients, alerts, and add follow-up notes | Viewing and notes accepted for first version; no schedule creation/editing; assignment flow and field visibility pending |
| Administrator | Manage accounts, roles, and system configuration | Proposed; clinical-data access must be explicitly limited |

A role alone must not grant access to every patient's records. Patient relationships and assignment must also be checked by the backend.

The accepted caregiver sharing list includes the patient's name/chosen profile photo, recorded diabetes or hypertension, medicines and schedules, dose reports, adherence summaries and alerts, recorded blood-pressure/glucose readings, and follow-up notes for that caregiver's relationship. Passwords, login codes, private account settings, and other caregivers' relationship notes are excluded. The patient sees this list before accepting a connection. This defines caregiver access only; detailed coordinator/admin permissions remain open.

The user accepted profile QR codes and Patient IDs for caregiver connection requests, inspired by their description of Nusuk. Patients review the caregiver's name, role, and permissions before accepting. Patients may remove caregivers at any time with clear confirmation; caregivers may also leave. Access and future patient alerts through that connection stop once the server confirms the action. Reconnecting requires a new request accepted by the patient. There is no compulsory waiting period or automatic expiry. This replaces the earlier waiting-period decision. See WF-05a in the medication workflow for details. Scanning a code or knowing an ID alone must not expose medical records. Whether "caretaker" is a separate role and how coordinator assignment works remain open.

## Accepted technology direction

| Component | Direction | Reason |
| --- | --- | --- |
| Patient app | Flutter / Dart, Android first | Uses the main developer's existing skills and matches the proposal |
| Web portal | Angular / TypeScript | Matches the proposal; developer knows TypeScript and will learn Angular as needed |
| API | Python / FastAPI | Keeps backend and ML integration in Python |
| Storage | PostgreSQL | Fits related schedules, patients, events, permissions, and reports |
| ML | Python / scikit-learn | Supports the proposed tabular supervised-learning investigation |

Use one modular backend and one database initially. Separate ML training code from application request handling; integrate only evaluated, versioned model artifacts. Do not introduce additional services without a demonstrated need.

## Team organization

Saleem Aman expects to perform most coding. Teammates will help with UI/UX and selected tasks. Exact assignments remain open; prior template responsibility tables should be reconciled with this current arrangement.

Useful teammate deliverables include reviewed screen designs, usability feedback, requirements review, test cases, literature summaries, and documentation. Attribute actual contributions accurately in Git history and project records.

## First implementation milestone

With fictional demonstration data, one patient can enter a schedule, receive a reminder, report a dose, and have that event appear in an authorized caregiver's portal. Include a minimal follow-up record and demonstrate that an unrelated user cannot access the patient.

See the medication workflow for acceptance criteria. Requirements and data feasibility precede implementation.

The user accepted fixed daily times for this milestone on 2026-10-04. Support one or more explicit times per medication per day. Weekly, interval-based, and as-needed schedules are outside the first demonstration; this decision does not by itself redefine the final approved project scope.
