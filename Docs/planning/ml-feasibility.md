# ML feasibility: current evidence and next work

Recorded: 2026-10-04

Status: initial gap assessment, not a completed dataset audit or validated model design.

## Required task

The current proposal calls for medication-adherence risk estimation. Disease diagnosis/prediction and drug-interaction lookup are different tasks and do not substitute for the required adherence model.

## Existing repository evidence

The initial review inspected the two CSV headers and sample records. It did not audit every row, notebook, dataset license, or source publication.

| Material | Observed content | Current assessment |
| --- | --- | --- |
| `Datasets/Chronic_Disease_Indicators.csv` | Year, geographic location, population topic/question, demographic strata, aggregate values | No individual medication-event sequence or future adherence outcome identified in the inspected schema |
| `Datasets/db_drug_interactions.csv` | Drug 1, Drug 2, interaction description | Does not directly supply adherence prediction labels |
| Diabetes-related notebooks in `Datasets/` | Present in the repository listing | Training content, provenance, and relevance still require inspection |

Retain existing material. Do not represent its presence as proof that the adherence dataset problem is solved. Record source, license, access restrictions, and intended use before reusing or redistributing data.

## Candidate research question, not a commitment

Can a preceding observation window of reported medication events help predict missed scheduled doses during a subsequent window? The previously discussed 14-day history and 7-day prediction period are examples only.

Define the target, available labels, unit of prediction, observation window, prediction horizon, and handling of unconfirmed reports based on actual data. If the available dataset supports only cross-sectional adherence classification, do not describe the result as validated forecasting.

## Dataset acceptance checklist

- Document source, rights, population, conditions, collection method, and de-identification.
- Establish whether records represent individuals, aggregate groups, or simulated patients.
- Confirm that required inputs would also be available to the running app at prediction time.
- Identify labels and whether they reflect self-report, an instrument, dispensing records, or another measure.
- Check patient identifiers, timestamps, missingness, class balance, and enough independent examples for defensible evaluation.
- Document domain mismatch if the population or conditions differ from CareLink's intended scope.

## Evaluation plan to refine after data selection

1. Specify labels before choosing algorithms. Do not create labels directly from the same input threshold and present recovery of that threshold as independent predictive evidence.
2. Establish a simple non-ML or majority-class baseline.
3. Compare suitable models; Logistic Regression and Random Forest are candidates, not predetermined winners.
4. Split according to the intended use. Avoid patient overlap where evaluating new-patient generalization; use chronological separation where evaluating future outcomes. Avoid overlapping windows leaking outcomes across splits.
5. Fit preprocessing and model selection only on training data. Keep a final evaluation set untouched until selection is complete.
6. Report class counts, confusion matrix, precision, recall, and F1; use probability metrics such as ROC-AUC only where appropriate. Do not rely on accuracy alone.
7. Version data preparation, model configuration, evaluation outputs, and integrated model artifacts. Record reproducible seeds/environment information.

## If suitable data is unavailable

Synthetic event histories can test software flows and illustrate model integration, but synthetic-only results do not establish performance on real patients. Keep their provenance visible. Do not collect or publish identifiable patient data as an informal workaround.

Discuss a documented research-data or simulation-based evaluation approach with the supervisor before committing to claims. Rules can support the application workflow but do not fulfill the project-specific ML requirement by themselves.

## Feasibility completion condition

Record either a justified, usable dataset and target with an evaluation design, or an explicitly accepted alternative with limitations. This condition is currently unmet. Dataset discovery and detailed audit are next work, not completed work.
