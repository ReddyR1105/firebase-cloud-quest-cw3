# Final submission audit

**CW3 — Firebase Cloud Quest: Signal Check**

**Student, project owner, and submitter:** Rohan Reddy Gosangi

**Course:** CSC 4360 — Mobile App Development

**Pathway:** Undergraduate

**Submission type:** Individual coursework

**Repository:** [firebase-cloud-quest-cw3](https://github.com/ReddyR1105/firebase-cloud-quest-cw3)

Verified on November 15, 2026 against the assignment brief and the seven undergraduate rubric categories. The original root commit `6e3c878` introduced this standalone Flutter project in a new repository. The audit used Flutter 3.47.4, the Android 17 emulator, and the Firebase Auth, Firestore, and Functions emulators for `demo-firebase-cloud-quest-cw3`.

| Requirement | Status | Evidence | Remaining issue |
|---|---|---|---|
| Flutter app | PASS | Fresh project compiled and ran on Android. The device runs exercised sign-in, the daily challenge, points, badge, busy feedback, retry, and empty and error states. Small-screen form validation passed. [Android journey](evidence/android-integration.txt) · [Empty challenge](evidence/android-empty-challenge.txt) · [Flutter tests](evidence/flutter-tests.txt) | iOS and web were outside the tested device run. The Android run satisfies the mobile-device requirement. |
| Authentication | PASS | Firebase initialized. Registration, failed sign-in, successful sign-in, and sign-out were exercised on Android. Signing back in showed the saved progress with an empty coach form. Signed-out callable requests were denied. [Android journey](evidence/android-integration.txt) · [Backend results](evidence/backend-tests.txt) | Cloud Auth was outside the emulator verification. |
| Firestore | PASS | Android displayed the title, prompt, and live progress. An absent progress record showed 0 points and a locked badge. Removing the challenge fixture showed the empty state and disabled completion and hints. The backend separately returned a safe error for a missing challenge. Cross-learner reads were denied. [Challenge screen](evidence/android/02-daily-challenge.png) · [Empty state](evidence/android/09-empty-challenge.png) · [Backend results](evidence/backend-tests.txt) | Cloud Firestore was outside the emulator verification. |
| Reward function | PASS | Verified caller UID, challenge ID, fixed award, server timestamp, ignored client values, retry, and six simultaneous requests with one first award. The stored value remained exactly 10 points with badge ID `first-quest`. [Backend results](evidence/backend-tests.txt) · [Reward screen](evidence/android/05-first-completion.png) | None in the emulator scope. |
| Quest Coach | PASS | The authenticated callable ran `readMyQuestState` before the live Gemini 3.6 Flash model selected a grounded hint. The local adapter fixture confirmed that UIDs and badge values stay outside the provider request. [Live test log](evidence/gemini-live-signal-check.txt) · [Backend results](evidence/backend-tests.txt) | Verify effective permissions if the course requires Firebase cloud deployment. |
| Signal Check | PASS | The live Gemini run returned the Firebase Authentication hint. The callable refused the badge and 500-point request before model generation. Both Firestore records matched their before-test snapshots. [Live responses and snapshots](evidence/gemini-live-signal-check.txt) · [Android refusal](evidence/android/04-signal-check-refusal.png) | The Android walkthrough used the deterministic emulator model. |
| Security rules | PASS | The emulator allowed authenticated challenge reads and owner progress reads. It denied signed-out reads, cross-user reads, challenge writes, and all direct reward creates, updates, and deletes. [Rules](firestore.rules) · [Backend results](evidence/backend-tests.txt) | Deploy and check the same rules if live Firebase is required. |
| Emulator testing | PASS | Zero analyzer issues, four Flutter tests, ten backend tests, two Android runs, and one live Gemini Signal Check against local Firebase. [Analysis](evidence/flutter-analyze.txt) · [Flutter tests](evidence/flutter-tests.txt) · [Android journey](evidence/android-integration.txt) · [Empty challenge](evidence/android-empty-challenge.txt) · [Live test log](evidence/gemini-live-signal-check.txt) | Production Firebase IAM remains outside the emulator tests. |
| README | PASS | Covers student identity, course and pathway, target platforms, setup, architecture, rules, model configuration, actual test results, evidence, and known limitations. [README](README.md) | Add course gateway specifics when supplied. |
| Reflection | PASS | The final student reflection is one paragraph within the 100–150-word requirement. It covers the read-only tool, grounded hint, adversarial refusal, unchanged records, reward transaction, and a next step. [Reflection](REFLECTION.md) | Include any course-required assistance disclosure with the submission. |
| GitHub repository | PASS | The local repository uses a fresh root commit and the dedicated private remote is reachable. GitHub reported zero non-owner direct collaborators and zero pending invitations. [GitHub repository](https://github.com/ReddyR1105/firebase-cloud-quest-cw3) · [Access check](evidence/repository-access.txt) | Confirm the grader's GitHub account, arrange access, and verify it works. |
| Submission handoff | READY FOR UPLOAD | Source archive, evidence, repository URL, final student reflection, and submission documents are prepared. [Checklist](SUBMISSION_CHECKLIST.md) | Confirm grader access and the exact portal fields, then submit and save the receipt. |

## Repairs and regression results

- Matched the Flutter and backend character limits to the displayed count, including multi-code-point emoji. The tests accept 300 graphemes and reject 301.
- Replaced raw callable transport errors in the app with actionable feedback and sanitized unexpected tool and model errors on the backend. Verified Android service-error recovery, bad-password handling, and disabled actions when the challenge is missing.
- Added a production-only service account parameter so Quest Coach can run with Firestore read permissions while rewards use a separate identity. Verified the authorized tool invocation in emulator logs without recording questions, UIDs, or progress in those events.
- Added the provisional Google GenAI plugin pinned to 1.44.0, matching the installed Genkit version. Cloud Functions defaults to Gemini 3.6 Flash with a server-side key. The emulator uses the deterministic model when the gateway and key are absent. Server-side settings can select a different provider and model.
- The earlier Firebase Admin and gRPC updates reduced the dependency audit from nine high findings to four. The current lockfile reports 62 moderate and four high findings. The current in-range audit-fix dry run proposed zero changes. Review the remaining findings before a live deployment. [Dependency audit](evidence/dependency-audit.txt)
- Checked the staged files and committed history for common credential patterns. Local environment overrides and generated dependencies are ignored.

## Estimated undergraduate rubric score

| Category | Estimate | Basis for score |
|---|---:|---|
| Engagement and learning process | 4 / 5 | The reproducible seven-step walkthrough ties actual screenshots and logs to the separate read and reward design. The student reflection is included. Additional personally recorded evidence depends on the instructor's requirements. [Engagement evidence](ENGAGEMENT_EVIDENCE.md) · [Reflection](REFLECTION.md) |
| Conceptual understanding | 15 / 15 | The README explains verified identity, rules, trusted transactions, and the model boundary. Ownership and reward assumptions were tested. [README](README.md) · [Backend results](evidence/backend-tests.txt) |
| Core application | 30 / 30 | Android app, Auth, Firestore, protected progress, one-time rewards, and service-error recovery ran successfully. [Android journey](evidence/android-integration.txt) · [Backend results](evidence/backend-tests.txt) |
| AI agent | 15 / 15 | The live model selected a stored hint after the authenticated read-only tool ran. The adversarial request was refused and both records remained unchanged. [Live test log](evidence/gemini-live-signal-check.txt) |
| Reasoning and reflection | 10 / 10 | The final student reflection ties the evidence to the security design and identifies a next step. [Reflection](REFLECTION.md) |
| Testing and evidence | 15 / 15 | The local regressions, nine screenshots, and credential-backed live test with before-and-after records are included. [Evidence](evidence/) |
| Communication and delivery | 9 / 10 | Named package and complete documentation are present. Grader access and portal requirements remain unconfirmed. [Checklist](SUBMISSION_CHECKLIST.md) |
| **Total** | **98 / 100** | Estimate based on the supplied category weights. The instructor determines the grade. |

## Submission handoff

- GitHub URL field: use [the dedicated repository](https://github.com/ReddyR1105/firebase-cloud-quest-cw3) after confirming grader access.
- Source upload field: use `firebase_cloud_quest_cw3_submission.zip`. It contains the tracked project, lockfiles, Firebase configuration and rules, tests, evidence, and documentation.
- Separate document fields, if present: attach `README.md`, the student-reviewed `REFLECTION.md`, `FINAL_SUBMISSION_AUDIT.md`, and `SUBMISSION_CHECKLIST.md`. For a separate evidence field, attach the requested files under `evidence/`.
- Verify the actual portal field names and file requirements before upload. The supplied assignment brief does not give those fields. Portal submission is pending.

**READY FOR UPLOAD · PORTAL SUBMISSION PENDING**

Confirm instructor access to the private repository and include any required engagement evidence or assistance disclosure. Verify cloud deployment and effective coach IAM if the course requires cloud Firebase.
