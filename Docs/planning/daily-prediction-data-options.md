# Daily prediction data decision - 2026-10-08

## Decision for the prototype

Use clearly labeled synthetic data to build and demonstrate CareLink's daily recording and prediction pipeline. This does not resolve real-world ML feasibility. Do not claim clinical accuracy or that a model trained on invented behavior predicts real diabetes/hypertension adherence.

A reproducible v1 generator and data dictionary are in ML/synthetic/. Output is C:/CareLink-FYP/Datasets/CareLink-Synthetic-v1. It contains 120 fictional patients, 90 days and 16,380 scheduled doses. No real downloaded records were used. No model has been trained.

## Verified options

1. BETTER-BP hypertension public release: https://zenodo.org/records/18683103 . All six local XLSX files match published MD5 checksums. Site A has 4,974 data rows (381 distinct record IDs), Site B 1,485 (111), Site C 3 (1). These include screening/visit/repeating forms and should not be interpreted as 493 randomized participants or daily dose records. No daily bottle-opening log was found. Dictionaries describe visit forms and bottle assignment. Seek the underlying daily monitoring export, not another copy of this release.
2. REINFORCE diabetes: https://www.nature.com/articles/s41746-024-01028-5 . The paper describes 60 participants and six months of bottle monitoring. Its data statement links to Harvard Dataverse generally; medication-use dates require a reasonable request and data use agreement. A directly usable public daily file has not been verified. Ask for anonymous IDs and relative day numbers if exact dates cannot be shared.
3. ASCENT tuberculosis: https://datacompass.lshtm.ac.uk/id/eprint/4695/ . Explicit dose-day table, restricted access under a sharing agreement. Useful methodological alternative if access approved; not diabetes/hypertension validation. Digital engagement is an adherence proxy. Reporting delays must be handled when constructing historical features.
4. Medisafe paid candidate: https://aws.amazon.com/marketplace/pp/prodview-vnb4ane5dggp4 . Vendor describes scheduled reminders and self-reported doses for US users of DPP-4 inhibitors/combinations. Listed price checked 2026-10-08: USD 36,000 per 12-month contract, possible additional AWS costs, no refunds. The page lists neither a sample nor a dictionary. This is a commercial lead, NOT a verified suitable dataset. Stable patient links, daily granularity, completeness, delayed reporting fields, permitted ML use and student eligibility need confirmation. Listing last-update text is December 2019; confirm current availability directly. Do not buy for this FYP at list price. A small academic extract/discount might be requested, but availability and price are unknown.

No suitable unrestricted real daily diabetes/hypertension dataset has been verified in this search. This does not establish that none exists. Paid generic diabetes classification, claims, questionnaires or synthetic bundles do not solve the missing daily-label problem.

## Request students can send themselves

Supervisor participation is not automatically required to make an initial inquiry. Data owners decide eligibility and may require institutional sponsorship or an agreement. No email has been sent by the assistant.

Subject: Student research request - anonymized daily medication adherence data

Hello,

We are BSCS final-year students developing CareLink, a medication reminder and caregiver support prototype. We are investigating whether previous daily medication records can predict the next day's reported non-adherence.

Do you offer an academic dataset or small research extract with a stable anonymous patient ID, relative day/time, scheduled doses, recorded dose outcomes or bottle openings, reporting/upload time where available, missing-data/device-status indicators, and intervention assignment? We do not need names, addresses or exact calendar dates. Please include a data dictionary and a de-identified or fabricated sample demonstrating the format.

Could you confirm whether undergraduate students may apply directly, any institutional agreement needed, the price or academic waiver, and permission to train models and report aggregate results in a public FYP? We can keep restricted raw data out of GitHub. We are interested in at least several weeks of consecutive observations per person rather than annual adherence totals.

Thank you.

For Medisafe, the listing provides dataaws@medisafe.com. For research studies, use the corresponding-author contact on the publication or the repository's request form. We have not promised any provider approval.

## Next learning step

Review the synthetic event columns together, then define next-day outcome timing and unknown handling before writing feature extraction or training. The three timestamps are different: scheduled_at (when due), recorded_at (when patient entered it), uploaded_at (when server knew it). Future uploaded reports cannot be used as past inputs. Training and testing against our own simulator measures the simulator only.

## Suggested separate commit

Commit only ML/synthetic/generate_demo.py, ML/synthetic/README.md and this document after review. Suggested message: feat: add reproducible synthetic adherence demo dataset. Generated CSVs stay outside the repository and can be recreated. Do not stage unrelated design or earlier dataset-audit changes accidentally.
