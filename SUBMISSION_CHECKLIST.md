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
- [x] README, [final reflection](REFLECTION.md), [final submission audit](FINAL_SUBMISSION_AUDIT.md), and this checklist.
- [x] [Student reflection guide](STUDENT_REFLECTION_GUIDE.md), [student walkthrough guide](STUDENT_WALKTHROUGH_GUIDE.md), and [updated rubric audit](RUBRIC_AUDIT.md).
- [x] Confirmed submission name and added it to the README and checklist.
- [ ] Confirm the grader's GitHub account, arrange private repository access, and verify it works. GitHub showed zero non-owner direct collaborators and zero pending invitations. [Access check](evidence/repository-access.txt)

## Evidence

- [x] Backend and rules tests, including signed-out requests, cross-user denial, client reward write denial, fixed reward, retry, and concurrent completion. [Backend log](evidence/backend-tests.txt)
- [x] Real ordinary and adversarial emulator coach outputs and matching Firestore state before and after. [Backend log](evidence/backend-tests.txt)
- [x] Provisional Gemini 3.6 Flash adapter tested against a local provider fixture. It requested the intended model ID, sent no learner IDs or badge values, and preserved both progress records. [Backend log](evidence/backend-tests.txt)
- [x] Static analysis with zero issues and four passing Flutter tests. [Analysis log](evidence/flutter-analyze.txt) · [Test log](evidence/flutter-tests.txt)
- [x] Local emulator startup, package resolution, and authorized coach tool logs. [Emulators](evidence/firebase-emulators.txt) · [Flutter dependencies](evidence/flutter-pub-get.txt) · [Tool events](evidence/quest-coach-tool.txt)
- [x] Functions dependency audit reviewed. [Dependency audit and automatic-fix dry run](evidence/dependency-audit.txt)
- [x] Android emulator user journey, including registration, sign-in, protected content, hint requests, first completion, unchanged retry, and sign-out. [Android test log](evidence/android-integration.txt)
- [x] Quest Coach service failure and retry, failed sign-in and recovery, and cleared private state after sign-out. [Service-error screenshot](evidence/android/08-coach-service-error.png)
- [x] Empty challenge and disabled completion and hints in the Android app. [Empty-state screenshot](evidence/android/09-empty-challenge.png) · [Empty-state log](evidence/android-empty-challenge.txt)
- [x] Android screenshots of [sign-in](evidence/android/01-signed-out.png), [daily challenge](evidence/android/02-daily-challenge.png), [grounded hint](evidence/android/03-grounded-hint.png), [Signal Check refusal](evidence/android/04-signal-check-refusal.png), [10 points and First Quest badge](evidence/android/05-first-completion.png), [duplicate completion](evidence/android/06-duplicate-completion.png), and [protected state after sign-out](evidence/android/07-protected-after-sign-out.png).
- [x] Confirm Gemini 3.6 Flash appears on the Standard Free Tier. [Google Gemini pricing](https://ai.google.dev/gemini-api/docs/pricing#gemini-3.6-flash)
- [ ] Use a Free Tier key to run the live Gemini Signal Check, then retain the ordinary model response, the adversarial refusal, and both learners' Firestore snapshots. Compare the agent setup with the earlier course instructions if available. [Provider verification status](evidence/gemini-verification.txt)
- [ ] Verify deployment and the coach account's effective read-only permissions in an authorized Firebase project.

## Portal submission

1. Include any course-required engagement evidence or assistance disclosure in the portal. The source archive contains the finalized reflection.
2. Open the CW3 assignment in the course portal and confirm the required files, link permissions, and any additional deliverables. The attachment does not specify the portal's exact upload fields.
3. Provide the GitHub URL. For a source-file upload, use `firebase_cloud_quest_cw3_submission.zip`. For separate attachments, use `README.md`, `REFLECTION.md`, `FINAL_SUBMISSION_AUDIT.md`, `SUBMISSION_CHECKLIST.md`, and the requested files under `evidence/`. Verify the submission receipt.

**Portal status:** Pending.
