# CareLink
This is the official Repository for our Final Year Project ( CareLink ), it encompasses our entire journey from Ideation to the final capstone project. 

CareLink is an ML-assisted medication-adherence and chronic-care coordination FYP focused on hypertension and diabetes. It combines a patient Android app with a web portal for authorized caregivers, care coordinators, and administrators.

## Current stage

Requirements and feasibility. The project idea is approved by the supervisor and faculty. Application implementation has not started. Current planning documents contain accepted directions and explicitly marked proposals/open decisions; they are not evidence of separate faculty approval for every implementation detail.

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
