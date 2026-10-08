# CareLink
This is the official Repository for our Final Year Project ( CareLink ), it encompasses our entire journey from Ideation to the final capstone project. 

CareLink is an ML-assisted medication-adherence and chronic-care coordination FYP focused on hypertension and diabetes. It combines a patient Android app with a web portal for authorized caregivers, care coordinators, and administrators.

## Current stage

Progress updated: 8 October 2026.

The idea is approved by the supervisor and faculty. Requirements, visual prototyping, and a synthetic ML experiment are underway. The first baseline experiment is merged into main through PR #4. The patient app, web portal, API and database have not been implemented. Planning documents still contain open decisions; project approval does not imply approval of every implementation detail.

### Completed so far

- Defined initial scope, medication reporting, caregiver connections and offline behavior (PRs #1 and #2).
- Created Figma concept screens, with a simple patient experience and additional caregiver options. These are visual prototypes, not a working app.
- Reviewed questionnaire, claims and BETTER-BP research data. None of the inspected downloads provides the daily records needed for the proposed next-day prediction.
- Created reproducible synthetic data: 120 fictional patients, 90 days each, and 16,380 scheduled doses (PR #3).
- Prepared 9,120 daily examples using 14 days of history and a reporting deadline 48 hours after the target day ends. There are 7,048 eligible examples; 2,072 unknown outcomes remain excluded rather than being treated as missed or taken.
- Trained a majority baseline and logistic regression on 4,842 eligible training examples, then evaluated on 1,081 validation examples (PR #4). All eight preparation/training tests passed. Future uploads are excluded from earlier prediction inputs, and patients remain separate across splits.

### First model results: synthetic validation only

| Result | Majority baseline | Logistic regression |
| --- | ---: | ---: |
| Accuracy | 66.6% | 71.3% |
| Reported-skip days caught | 0 of 361 | 108 of 361 |
| False alerts | 0 | 57 |

The logistic regression threshold was fixed at 0.5. It missed 253 reported-skip days. These results demonstrate the pipeline on invented data; they do not establish real-world accuracy or clinical usefulness. The held-out test set has not been evaluated. No model is deployed in an app.

### Next steps

1. Compare thresholds on validation data and review missed reports versus false alerts. Threshold review has not started.
2. Fix the demo model settings before a final held-out test evaluation. Preserve the first baseline results for comparison.
3. Continue seeking suitable real daily data. Synthetic data does not resolve the real-world feasibility gap; inspect any sample and its usage rights before purchasing data.
4. Finish remaining requirements and turn the approved visual direction into a small working patient/caregiver prototype, then connect the API and database step by step.
5. Review and commit the earlier local design and dataset-audit documentation separately. Keep each milestone in its own branch, commit and pull request.

### ML files and local outputs

- [Synthetic data, preparation and model instructions](ML/synthetic/README.md)
- [Baseline validation results and limitations](ML/synthetic/baseline-results.md)
- [Data options and an unsent access-request template](Docs/planning/daily-prediction-data-options.md)

The active Git folder is `C:/CareLink-Repo`. Generated datasets/results are in `C:/CareLink-FYP/Datasets/CareLink-Synthetic-v1*`; the isolated Python environment is in `C:/CareLink-FYP/ML-Environments/baseline`. These generated outputs and the environment are outside the repository. Commit the reproducible scripts, dependency list and documentation.

Start with these documents:

- [Project scope and technology direction](Docs/planning/project-scope.md)
- [Medication workflow and acceptance criteria](Docs/requirements/medication-workflow.md)
- [ML feasibility and dataset gap](Docs/planning/ml-feasibility.md)
- [Progress, open decisions, and commit guidance](Docs/planning/progress.md)

## Technology direction

| Component | Selected direction |
| --- | --- |
| Patient app | Flutter / Dart, Android first |
| Web portal | Angular / TypeScript |
| Backend API | Python / FastAPI |
| Database | PostgreSQL |
| Machine learning | Python / scikit-learn; final model follows evaluation |

Use one repository, one modular backend application, and one primary database. The mobile app and web portal communicate through the backend API. Package versions, detailed designs, and setup instructions will be recorded when implementation begins.

## Existing material

- `Docs/` preserves proposal, architecture, and defense material.
- `Datasets/` contains existing research material whose suitability and licensing require review; presence here does not establish suitability for adherence prediction.
- The latest discussed reference is `CareLink_Template#4.pdf`, supplied from outside this repository. It has not been copied into `Docs/`; older documents may describe earlier directions.

## Working process

Complete and verify one agreed milestone before advancing. Each completed change should identify affected files, verification results, remaining limitations, and a meaningful commit message. Keep secrets, identifiable patient records, temporary outputs, and generated builds out of source control. Document data sources and usage rights before adding datasets.

CareLink records reported medication events. It does not verify ingestion, diagnose conditions, prescribe medicines, or change treatment plans.
