# CW3 — Firebase Cloud Quest: Signal Check

**Student:** Rohan Reddy Gosangi

**Project Owner:** Rohan Reddy Gosangi

**Submitted By:** Rohan Reddy Gosangi

**Course:** CSC 4360 — Mobile App Development

**Pathway:** Undergraduate

**Submission Type:** Individual Coursework

**Repository:** [firebase-cloud-quest-cw3](https://github.com/ReddyR1105/firebase-cloud-quest-cw3)

## Repository and package

- [x] Fresh Flutter project, Android and iOS templates, local Git repository, and a newly created private GitHub repository.
- [x] Firebase config, security rules, callable source, challenge seed, and automated test source.
- [x] README, reflection draft, [final submission audit](FINAL_SUBMISSION_AUDIT.md), and this checklist.
- [x] Confirmed submission name and added it to the README and checklist.
- [ ] Check repository access for Professor Henry or the grader under the course's instructions.

## Evidence

- [x] Backend and rules tests, including signed-out requests, cross-user denial, client reward write denial, fixed reward, retry, and concurrent completion. [Backend log](evidence/backend-tests.txt)
- [x] Real ordinary and adversarial emulator coach outputs and matching Firestore state before and after. [Backend log](evidence/backend-tests.txt)
- [x] Provisional Gemini 3.6 Flash adapter tested against a local provider fixture. It requested the intended model ID, sent no learner IDs or badge values, and preserved both progress records. [Backend log](evidence/backend-tests.txt)
- [x] Static analysis with zero issues and four passing Flutter tests. [Analysis log](evidence/flutter-analyze.txt) · [Test log](evidence/flutter-tests.txt)
- [x] Android emulator user journey, including registration, sign-in, protected content, hint requests, first completion, unchanged retry, and sign-out. [Android test log](evidence/android-integration.txt)
- [x] Quest Coach service failure and retry, failed sign-in and recovery, and cleared private state after sign-out. [Service-error screenshot](evidence/android/08-coach-service-error.png)
- [x] Empty challenge and disabled completion and hints in the Android app. [Empty-state screenshot](evidence/android/09-empty-challenge.png) · [Empty-state log](evidence/android-empty-challenge.txt)
- [x] Android screenshots of [sign-in](evidence/android/01-signed-out.png), [daily challenge](evidence/android/02-daily-challenge.png), [grounded hint](evidence/android/03-grounded-hint.png), [Signal Check refusal](evidence/android/04-signal-check-refusal.png), [10 points and First Quest badge](evidence/android/05-first-completion.png), [duplicate completion](evidence/android/06-duplicate-completion.png), and [protected state after sign-out](evidence/android/07-protected-after-sign-out.png).
- [ ] Confirm course-approved model gateway and retain the ordinary and adversarial live-model verification.
- [ ] Run the credential-backed provisional Gemini Signal Check if a key becomes available. Gemini remains provisional until Professor Henry approves it. [Provider verification status](evidence/gemini-verification.txt)
- [ ] Verify deployment and the coach account's effective read-only permissions in an authorized Firebase project.

## Portal submission

1. Review the reflection and rubric audit. Finalize any required personal observations and assistance disclosure.
2. Open the CW3 assignment in the course portal and confirm the required files, link permissions, and any additional deliverables. The attachment does not specify the portal's exact upload fields.
3. Provide the GitHub URL. For a source-file upload, use `firebase_cloud_quest_cw3_submission.zip`. For separate attachments, use `README.md`, the reviewed `REFLECTION.md`, `FINAL_SUBMISSION_AUDIT.md`, `SUBMISSION_CHECKLIST.md`, and the requested files under `evidence/`. Verify the submission receipt.

**Portal status:** Pending.
