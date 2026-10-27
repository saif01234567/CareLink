# CareLink

CareLink is our BSCS Final Year Project: an ML-assisted medication-adherence and chronic-care coordination system focused on hypertension and diabetes.

The planned system combines a patient Android app with a web portal for authorised caregivers, care coordinators, and administrators.

## Current progress

**Last updated: 27 October 2026**

The project idea is approved by our supervisor and faculty. Some detailed requirements remain open.

A working Flutter patient prototype runs on an Android emulator. It supports dose reporting, local phone storage, an editable demo profile, and report history.

A separate synthetic-data ML experiment has been completed. The model is not connected to the app.

## Completed features

### Planning and design

- Documented initial scope, medication reporting, caregiver connections, patient consent/removal, and intended offline behaviour.
- Created Figma concepts with a minimal patient interface and additional caregiver options.
- Selected the teal colour scheme used in the patient prototype.

Documented or designed features are not necessarily implemented.

### Patient Android prototype

- Created and ran the Flutter app on an Android emulator.
- Organised code into separate models, storage, screens, widgets, theme, and navigation files.
- Built the Today screen with a fictional medicine card.
- Added Taken and Skipped reporting, taken-time selection, and an approximate-time option.
- Kept taken time separate from report-entry time.
- Added cancellation without changing the saved report.
- Added SQLite storage so reports survive app restarts and stay separate by scheduled day.
- Added visible loading and saving error handling.
- Added an editable demo profile with a name saved on the phone.
- Connected the saved profile name to the Today greeting.
- Added Today, History, and Profile navigation.
- Added a History page displaying saved reports and a refresh action.

### Verification

- Flutter code analysis passed with no issues.
- All 12 existing patient-app automated tests passed.
- Dose reporting, cancellation, restart persistence, profile editing, and history display were manually checked on the Android emulator.

Automated tests cover dose/profile storage and interactions. History was manually checked; dedicated automated History-page coverage remains to be added.

## Current prototype limitations

- Uses fictional data and one sample medicine dose at 08:00 per day.
- Reports are self-reported; they do not prove medicine was swallowed.
- Records and profile details are stored locally without database encryption.
- Clearing app data or uninstalling may remove local records.
- No login, cloud backup, or caregiver upload is implemented.
- The displayed patient ID is an example, not a unique account identifier.
- QR invitations and caregiver permissions are not implemented.
- Notifications, snooze, and automatic follow-up reminders are not implemented.
- Saved-report correction and a configurable multi-dose schedule are not implemented.
- The web portal and backend are not yet connected to the patient app.

Use fictional details only in this prototype.

## Machine-learning progress

### Completed

- Reviewed questionnaire, claims, and BETTER-BP research data. None of the inspected downloads provided the daily records needed for the proposed next-day prediction.
- Generated reproducible synthetic data for 120 fictional patients over 90 days, containing 16,380 scheduled doses.
- Prepared 9,120 daily examples using 14 days of history and a reporting deadline 48 hours after the target day ends.
- Excluded 2,072 unknown outcomes rather than treating them as taken or skipped, leaving 7,048 eligible examples.
- Trained majority and logistic-regression baselines on 4,842 eligible training examples.
- Evaluated on 1,081 eligible validation examples, separating patients across splits and excluding future uploads from earlier prediction inputs.
- Passed eight preparation/training tests for the baseline milestone.
- Reproduced training in Google Colab and saved the notebook, validation report, and model parameters as evidence.

### Synthetic validation results

| Metric | Majority baseline | Logistic regression |
| --- | ---: | ---: |
| Accuracy | 66.6% | 71.3% |
| Reported-skip days detected | 0 of 361 | 108 of 361 |
| False alerts | 0 | 57 |

The logistic-regression threshold was fixed at 0.5. It missed 253 reported-skip days.

These results demonstrate a training pipeline on invented data. They do not establish real-world accuracy or clinical usefulness.

Threshold review and final held-out test evaluation have not been completed. No model is deployed in the app.

### Training files and evidence

- [Synthetic data and training instructions](ML/synthetic/README.md)
- [Baseline results and limitations](ML/synthetic/baseline-results.md)
- [Google Colab training notebook](ML/notebooks/CareLink_Synthetic_Model_Training.ipynb)
- [Colab validation report](ML/evidence/colab-synthetic-baseline/validation_report.json)
- [Saved synthetic model parameters](ML/evidence/colab-synthetic-baseline/model_parameters_SYNTHETIC.json)
- [Daily prediction data options](Docs/planning/daily-prediction-data-options.md)

The active Git folder is `C:/CareLink-Repo`. Generated local datasets/results are under `C:/CareLink-FYP/Datasets/CareLink-Synthetic-v1*`; the isolated Python environment is under `C:/CareLink-FYP/ML-Environments/baseline`. These local outputs and the environment are outside the repository. Reproducible scripts and selected training evidence are versioned.

## Technology direction

| Component | Technology | Status |
| --- | --- | --- |
| Patient Android app | Flutter / Dart | Working local prototype |
| Phone storage | SQLite / sqflite | Implemented for demo reports and profile |
| Web portal | Angular / TypeScript | Planned; repository placeholder exists |
| Backend API | Python / FastAPI | Planned |
| Server database | PostgreSQL | Planned |
| Machine learning | Python / scikit-learn | Synthetic baseline experiment completed |

SQLite stores data on the phone. PostgreSQL is the planned server database; they serve different purposes. The planned mobile app and web portal will communicate through one modular backend API.

## Project organisation

```text
apps/patient_app/
  lib/
    main.dart
    app.dart
    core/
      theme/
      navigation/
    features/
      medication/
        data/
        models/
        screens/
        widgets/
      profile/
        data/
        models/
        screens/
  test/

web-portal/
ML/
  synthetic/
  notebooks/
  evidence/
Docs/
```

## Next steps

1. Add multiple scheduled doses, each with its own identity and saved report.
2. Add automated coverage for History and multi-dose behaviour.
3. Implement reminders, 10-minute snooze, and the agreed recording follow-up.
4. Define and implement saved-report corrections.
5. Build account authentication, backend APIs, and server storage.
6. Connect the caregiver portal with patient-approved access.
7. Implement QR invitations and connection removal.
8. Add upload handling with clear pending, successful, and failed states.
9. Continue real-data feasibility work, then validation-threshold review and a final held-out evaluation before making real-world ML claims.
10. Review and commit earlier local design and dataset-audit documentation separately.

We will complete and verify one milestone at a time. Inspect data samples and usage rights before purchasing or incorporating datasets.

## Development workflow

- `main` contains merged, reviewed milestones.
- `saleem` is Saleem's ongoing working branch.
- Other team members use their own agreed working branches.
- Each member commits using their own Git identity.
- Changes reach `main` through pull requests after appropriate checks.
- Keep ongoing member branches after merging and update them with changes from `main`.
- Record actual contributions through commits, pull requests, and assigned tasks.

For the guided development process, Saleem makes application-code changes using explained instructions. The assistant may update Markdown and text documentation directly.

Do not commit secrets, identifiable patient records, generated builds, or temporary troubleshooting logs. Review dataset licences and usage rights before adding or redistributing data.

## Project documents and existing material

- [Project scope](Docs/planning/project-scope.md)
- [Medication workflow](Docs/requirements/medication-workflow.md)
- [ML feasibility](Docs/planning/ml-feasibility.md)
- [Planning progress and open decisions](Docs/planning/progress.md)
- [Local storage implementation](apps/patient_app/README_LOCAL_STORAGE.md)
- [Profile implementation](apps/patient_app/README_PROFILE.md)

`Docs/` preserves proposal, architecture, and defence material. Existing research material in `Datasets/` still requires suitability and licensing review. The discussed Template #4 PDF was supplied outside the repository; older documents may describe earlier directions.

Some earlier documents describe previous milestones and need updating as implementation progresses.

CareLink records reported medication events. It does not diagnose conditions, prescribe medicines, verify ingestion, or change treatment plans.
