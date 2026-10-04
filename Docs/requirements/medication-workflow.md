# Medication workflow: Step 1 draft

Recorded: 2026-10-04

Status: reviewable requirements draft. Patient schedule editing, fixed daily times, caregiver/coordinator viewing and follow-up permissions, QR/ID caregiver connections with confirmation and immediate removal, the caregiver access list, and the reminder/reporting flow including a 30-minute follow-up are accepted for the first version. Late-dose thresholds, coordinator assignment and detailed permissions, and other unresolved items in the decision register remain proposals.

## Vocabulary

- **Medication record:** the medicine and instructions entered from an existing prescription; CareLink does not recommend a dose.
- **Schedule:** the intended recurrence, effective dates, and relevant timezone for a medication.
- **Scheduled dose:** one expected occurrence generated from a schedule.
- **Medication event:** a patient's report associated with a scheduled dose, with both reported occurrence time and system recording time.
- **Pending:** a scheduled dose whose reporting window has not closed and has no report.
- **Taken:** a patient report of taking the dose.
- **Delayed:** a timing classification of a taken report, using an agreed timing policy. It is not an additional dose.
- **Missed:** an explicit patient report that the dose was skipped; use "Skipped" in the patient interface.
- **Unconfirmed:** no patient report; use "Not confirmed" in the patient interface and "No response recorded" for caregivers. This is not proof of a missed dose. The reporting window that determines when a pending dose becomes unconfirmed is still to be chosen.

Do not count taken and delayed as two separate events for the same dose. Do not convert unconfirmed events into confirmed missed doses without a documented reporting policy.

## Proposed workflow

### WF-01: Enter a medication schedule

The authenticated patient enters the medication name, prescribed dose description, schedule, effective dates, and any recorded instructions. The app displays the proposed schedule for review before saving.

For the first version, only the patient can add or change their own medication schedules through the application. Caregivers and care coordinators cannot add or change those schedules, even when allowed to view that patient's records. The backend must enforce this rule on every schedule-writing request; hiding edit buttons is not sufficient. Any future delegated editing requires a separate recorded decision.

The first demonstration supports one or more explicit daily clock times per medication, such as 08:00 or 08:00 and 20:00. These are scheduling examples, not treatment recommendations. Weekly, interval-based (such as every eight hours), and as-needed schedules are outside this first demonstration; their place in the final requirements will be assessed separately.

Each distinct selected time produces one expected dose per applicable day within the schedule's effective dates. Duplicate clock times within the same schedule must be rejected. The interface must show supported scheduling choices explicitly rather than silently translating unsupported patterns into daily times.

The backend validates required values, ownership, and consistency. Timezone behavior remains to be decided before implementation. The system preserves schedule versions so future edits do not rewrite historical expectations.

### WF-02: Present reminders

The app presents reminders for expected doses. Reminders refer to the recorded schedule and do not advise taking an extra or compensating dose.

Accepted flow on 2026-10-04:

1. At the scheduled time, show a reminder for the specific dose.
2. Offer "Taken", "Skipped", and "Remind me later". Taken and Skipped open or submit the associated dose-reporting flow; opening a notification alone is not a dose report.
3. "Remind me later" snoozes that dose's notification for 10 minutes. It does not change the original schedule, create another expected dose, or mark the dose taken/skipped. This is a notification delay, not advice about safe medicine timing.
4. If no Taken or Skipped report is available, schedule one automatic gentle follow-up for 30 minutes after the original scheduled reminder: "Already taken your medicine? Record it here." For an 08:00 reminder, this follow-up is due at 08:30. Do not repeatedly send automatic follow-ups or instruct the patient to take another dose. The 30-minute delay is only a recording prompt: it does not define a medically late dose, mark a dose skipped, or close the reporting window. It is separate from the patient-selected 10-minute snooze.
5. If there is still no report, keep the outcome unconfirmed rather than inferring a skipped dose. Caregivers see "No response recorded".

Before delivering a pending follow-up or snoozed notification, check whether a report is already available and cancel/suppress unnecessary reminders. A user-requested snooze and the single automatic follow-up are separate actions; their collision handling and repeated-snooze limits remain to be designed. No automatic caregiver escalation timing is selected by this flow.

Notification permission, app restart, device restart, and offline behavior require an implementation design and physical Android testing. Reminder delivery and user reports are different events; notification delivery does not establish adherence.

### WF-03: Record a dose report

The patient reports taken or explicitly skipped. A taken report includes the time the patient says they took the medicine, with an option to mark that time approximate if unsure. The backend links the report to the expected dose and separately retains when the report was entered. Preserve the approximate-time flag rather than presenting it as exact.

Patients may report an unanswered dose later from their history. Update that scheduled dose's outcome; do not create an extra dose. For example, a patient can enter a report at 09:00 saying they took the scheduled 08:00 medicine at 08:10. Keep the scheduled time, reported medicine time, and entry time separately. A late report does not by itself prove late medicine-taking.

Repeated taps or retried requests must not create duplicate dose outcomes. Corrections must preserve an audit trail. Later reporting of unanswered doses is accepted; any retrospective reporting limit, corrections to existing reports, conflicting updates, and offline synchronization remain open.

### WF-04: Classify and summarize

Once a reporting window closes, an unanswered dose can be shown as unconfirmed. Taken reports may be classified as delayed using the agreed timing policy.

Reports must distinguish confirmed taken, confirmed skipped, and not confirmed. Here "confirmed" means reported by the patient, not verified ingestion. A later patient report updates the displayed outcome and summaries while retaining when the report was entered. Do not count an unanswered dose as skipped or count both its former unconfirmed state and its new taken state as separate dose outcomes. Do not classify delayed medication-taking solely from a late entry timestamp; late-dose thresholds and treatment of approximate times remain unresolved.

Display explicit counts and reporting coverage. The adherence-rate formula, denominator, exclusions, and treatment of delayed/unconfirmed doses must be documented before presenting a percentage. Future doses must not enter an elapsed-period adherence denominator.

### WF-05: Review authorized patients

A caregiver with a valid patient relationship can view only the permitted records for that patient. A coordinator can review assigned patients under defined access rules. The backend enforces access regardless of what the interface displays.

Caregivers and care coordinators may view authorized records and add follow-up notes in the first version. They cannot change medication schedules. The caregiver access list is defined in WF-05b. Coordinator assignment and detailed coordinator permissions remain separate and unresolved; caregiver permission decisions do not automatically grant coordinator access.

Patients can remove caregivers at any time after a clear confirmation. Caregivers can also leave a connection after confirmation. There is no compulsory waiting period. Once the server confirms removal or departure, it must deny further access through that connection; hiding records in the interface is insufficient.

### WF-05a: Connect using a QR code or Patient ID

Accepted direction on 2026-10-04:

- A patient profile has a QR code and a Patient ID that can be used to connect with a caregiver.
- The user referenced the Nusuk profile as inspiration. This records the user's description, not a verified reproduction of Nusuk's interface or permission rules.
- Patients can remove caregivers at any time after confirmation. This replaces the earlier waiting-period decision.

Accepted flow:

1. The patient shows their connection QR code or shares their Patient ID.
2. A signed-in caregiver scans the code or enters the ID and sends a connection request.
3. The patient sees the caregiver's name, role, and the sharing list in WF-05b, then accepts or declines. Sending the request is the caregiver's agreement to connect; patient acceptance supplies the other party's agreement.
4. Only an accepted, active connection allows access to the agreed patient records and follow-up notes. It does not allow medicine schedule editing.
5. The patient can select a connected caregiver and choose removal at any time. Before removal, show the person's name and explain: "This person will lose access to your records and will no longer receive your alerts." The patient must explicitly confirm; cancelling keeps the connection active.
6. After the server confirms removal, access through the connection ends immediately. The caregiver may also choose to leave, with confirmation and the same access-ending effect.
7. Reconnecting requires a new request and acceptance by the patient. Neither party can restore the previous connection alone.

The exact confirmation security method (for example, device authentication or an app PIN) will be selected during authentication design. Clear confirmation is required; a specific PIN or biometric implementation is not yet chosen.

Removal must also stop future patient alerts and follow-up-note writes through that connection. Background notification delivery must recheck the connection before sending pending patient information. Previously delivered messages or information already seen cannot be recalled. Keep historical care notes and connection activity for authorized reporting; removing access does not delete those records or grant the former caregiver continued access to them.

Connection approval, removal, and leaving require server confirmation. If the device is offline or the request fails, show that the action has not completed and allow a retry; do not claim access has ended based only on a local screen change.

The QR code and ID identify a connection request; they must not serve as passwords or grant immediate access to medical records. Do not encode health records or login credentials in the QR code. The detailed design should limit repeated ID guesses and connection-request spam and define QR validity separately from relationship duration.

This flow supports caregiver-initiated requests using a patient's QR/ID. Whether patients should also scan a caregiver profile to send an invitation remains open. No new role is introduced for the word "caretaker" until the user clarifies whether it differs from caregiver or care coordinator.

The connection stays active until removed or left; no automatic 7/14-day expiry is part of this flow. A periodic connection-review reminder is only a possible future enhancement, not an accepted first-version requirement. Guardian-managed access is also not introduced by this decision.

### WF-05b: What a connected caregiver can see and do

Accepted by the user on 2026-10-04 for the first version. Show this sharing list to the patient before they accept the connection.

| Information | Caregiver access |
| --- | --- |
| Patient's name and chosen profile photo | View |
| Recorded diabetes or hypertension condition | View |
| Medicine names, doses, and schedules | View |
| Taken, skipped, late, and unconfirmed dose records | View |
| Adherence summaries and alerts | View |
| Blood-pressure and glucose readings entered in CareLink | View |
| Follow-up notes for this patient-caregiver relationship | View and add their own notes |
| Notes belonging to another caregiver's relationship | No access |
| Passwords, login codes, and private account settings | No access |

Caregivers cannot add, change, or delete the patient's medicines, schedules, dose reports, or health readings. Adding a follow-up note is the permitted care-record write; it does not change the underlying patient records. Editing or deleting existing follow-up notes is not granted by this decision and requires a separate rule if needed.

The backend must enforce both the active patient-caregiver connection and the allowed fields/actions. Apply the same boundaries to detail pages, lists, summaries, reports, and any exports. Do not include another caregiver's notes in shared reports or summaries. Showing a hidden button or field is not the access control: forbidden data must not be returned to the caregiver.

This list does not settle access to historical notes across a removed-and-recreated connection, detailed coordinator/admin permissions, or the patient's view of follow-up notes. Those rules remain to be designed separately.

### WF-06: Record follow-up

An authorized user records a permitted follow-up action, its timestamp, and author. Where relevant, link it to an alert. Follow-up notes must not silently modify a medication schedule.

A caregiver's note must be linked to the specific patient-caregiver relationship as well as its patient and author. A caregiver cannot create or read notes under a different caregiver's relationship by supplying its identifier.

### WF-07: Add ML and alert rules later

The evaluated ML component estimates the agreed adherence-risk target. A separate, documented rule layer determines notifications or human follow-up. Risk estimates must carry model/version and prediction-time information.

Lack of adequate history must be represented explicitly rather than automatically labeling a new patient low risk. Alert repetition, acknowledgement, and escalation policies remain to be designed.

## First demonstration acceptance criteria

These are verification requirements, not claims of tests already performed.

| ID | Scenario | Expected evidence |
| --- | --- | --- |
| AC-01 | Patient creates a daily schedule at 08:00 and 20:00 | Saved schedule belongs to that patient and generates exactly two expected doses per applicable day within its effective dates |
| AC-02 | A dose becomes due under supported device conditions | One correctly associated reminder is observed on a physical Android device |
| AC-03 | Patient reports taken | One outcome records reported time and recording time; caregiver sees the same event |
| AC-04 | Patient explicitly skips a dose | Dose shows missed with provenance as a patient report |
| AC-05 | Reporting window closes without response | Dose shows unconfirmed, not an asserted missed dose |
| AC-06 | A report falls outside the chosen on-time window | Agreed timing classification is applied without double counting |
| AC-07 | User repeats submission or request is retried | One effective outcome exists for the scheduled dose |
| AC-08 | Unrelated caregiver requests a patient record | Backend denies access without exposing that record |
| AC-09 | Patient confirms caregiver removal, including immediately after connecting | Once the server confirms removal, subsequent record reads and note writes through the connection are denied; no minimum age is required |
| AC-10 | Authorized caregiver records follow-up | Author, time, patient, and permitted content are retained |
| AC-11 | Patient edits future scheduling | Historical dose expectations and reports remain unchanged |
| AC-12 | A history summary is compared with known demo events | Counts match; displayed percentages follow the documented formula |
| AC-13 | Patient submits the same daily time twice in one schedule | Validation rejects the duplicate time without creating duplicate dose occurrences |
| AC-14 | An unsupported weekly, interval-based, or as-needed pattern is submitted | The interface explains the supported patterns and the backend rejects unsupported patterns; no silent conversion occurs |
| AC-15 | A caregiver or care coordinator with viewing access tries to create or change a patient's schedule, including by a direct API request | Backend denies the write and the schedule remains unchanged |
| AC-16 | A patient tries to create or change a schedule for another patient | Backend denies the write and the other patient's records remain unchanged |
| AC-17 | A caregiver or care coordinator adds a follow-up note for an authorized patient | The note records its author and time; the medication schedule remains unchanged |
| AC-18 | A signed-in caregiver scans a connection QR code or enters a Patient ID | A pending request is created; no health records are shared before patient acceptance |
| AC-19 | Patient declines a connection request | The requester remains without access |
| AC-20 | Patient accepts a connection request after reviewing name, role, and permissions | Only agreed viewing/note permissions are granted; medicine schedules cannot be changed |
| AC-21 | Patient opens removal confirmation and cancels | The named caregiver's connection remains active; opening the dialog alone changes nothing |
| AC-22 | A connection remains active for 7 or 14 days without removal or departure | Access continues; no automatic expiry or removal lock applies |
| AC-23 | Caregiver confirms leaving a connection | Server ends the connection and denies further access through it |
| AC-24 | Either person tries to restore a removed connection | A new request and patient acceptance are required; old requests and repeated scans cannot reactivate access |
| AC-25 | Patient information is queued for a caregiver whose connection has ended | Delivery checks the active relationship and does not send the pending patient information through that connection |
| AC-26 | Connection approval, removal, or departure cannot reach the server | Interface reports the action is incomplete and allows retry; it does not falsely show success |
| AC-27 | Patient reviews a caregiver connection request | The screen explains all shared categories in WF-05b and the caregiver's viewing/note permissions before acceptance |
| AC-28 | Connected caregiver requests patient information | Only the agreed categories are returned; credentials, login codes, private account settings, and other caregivers' relationship notes are excluded |
| AC-29 | Caregiver tries to add, change, or delete a patient's medication, dose report, or health reading directly through the API | Backend denies the write and the patient record remains unchanged |
| AC-30 | Caregiver tries to read or add a note using another caregiver's relationship identifier, including for the same patient | Backend denies access; reports and summaries also exclude that other relationship's notes |
| AC-31 | Patient chooses "Remind me later" | Notification is snoozed for 10 minutes; scheduled time, expected dose count, and dose outcome do not change |
| AC-32 | An 08:00 scheduled reminder has no Taken or Skipped report | Under supported device conditions, one automatic recording follow-up is due at 08:30; it does not repeat automatically, assert a skipped dose, or label the medicine medically late |
| AC-33 | At 09:00 patient reports taking an 08:00 dose at 08:10 | One dose outcome is updated; scheduled, reported medicine, and entry times are retained separately; entry time alone does not determine late medicine-taking |
| AC-34 | Patient marks a reported medicine time approximate | Stored record and displayed history preserve that uncertainty |
| AC-35 | Patient reports taken or skipped before a queued reminder/follow-up is delivered | Available report is checked and the unnecessary pending reminder is cancelled or suppressed |
| AC-36 | History contains taken, skipped, and unanswered doses, then an unanswered dose is reported taken | Categories stay separate, caregiver text says "No response recorded" for unanswered doses, and summaries update without double counting |

## Decision register

| ID | Decision | Current position |
| --- | --- | --- |
| D-01 | Initial schedule patterns | Accepted by user on 2026-10-04: one or more fixed daily times for the first demonstration; weekly, interval-based, and as-needed schedules excluded from that milestone |
| D-02 | Reminder and dose-timing rules | Accepted: scheduled reminder, Taken/Skipped/Remind me later, 10-minute snooze, one gentle automatic recording follow-up 30 minutes after the original scheduled reminder if unanswered, and no-response labels. Reporting window, late-dose thresholds, and snooze/follow-up interaction remain open; do not invent universal medical timing thresholds |
| D-03 | Schedule entry/edit permissions | Accepted by user on 2026-10-04 for the first version: patients add and change their own schedules; caregivers and coordinators view authorized records and add follow-up notes, without schedule editing |
| D-04 | Caregiver connection and removal | Accepted on 2026-10-04: QR/ID request, patient confirmation, removal at any time with confirmation, caregiver departure, new mutual agreement to reconnect, and caregiver access list WF-05b. Replaces waiting-period rule. Confirmation security method, reverse invitations, role terminology, coordinator permissions/assignment, and historical-note access after reconnection remain open |
| D-05 | Timezone, travel, and clock changes | Open; preserve original timestamps and define schedule interpretation |
| D-06 | Offline reporting and reminder support | Open; define supported behavior and duplicate/conflict handling |
| D-07 | Corrections and retrospective reports | Accepted: later reporting of unanswered doses, separate reported medicine/entry times, and approximate-time flag. Reporting limits, corrections to existing reports, and conflict handling remain open; preserve history |
| D-08 | Adherence formula and reporting coverage | Open; distinguish unknown reports from explicit missed events |

## Traceability

WF-01 supports medication management. WF-02 supports reminders. WF-03 and WF-04 support tracking and analysis. WF-05 supports access controls and the caregiver portal. WF-06 supports care coordination and reporting. WF-07 supports ML and predefined intervention rules. Other approved modules remain in the project scope even when outside this first demonstration.
