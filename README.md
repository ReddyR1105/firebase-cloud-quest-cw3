# CW3 — Firebase Cloud Quest: Signal Check

**Student:** Rohan Reddy Gosangi

**Project Owner:** Rohan Reddy Gosangi

**Submitted By:** Rohan Reddy Gosangi

**Course:** CSC 4360 — Mobile App Development

**Pathway:** Undergraduate

**Submission Type:** Individual Coursework

**Repository:** [firebase-cloud-quest-cw3](https://github.com/ReddyR1105/firebase-cloud-quest-cw3)

## Overview

Signal Check is a Material 3 Flutter app that uses Firebase Authentication, Cloud Firestore, and two Node.js Cloud Functions. Learners register or sign in with email and password, read a shared challenge, ask for a hint, and record completion. The challenge asks learners to explain identity, ownership, and trusted rewards before marking their own work complete.

The project includes Android, iOS, and web targets. The audited mobile target is the Android 17 emulator.

## How the app works

- **Authentication** uses `authStateChanges()` to show the sign-in form or the signed-in quest. Signing out disposes the quest screen and its subscriptions.
- **Firestore** streams the shared `challenges/today` document and the caller's `users/{uid}/progress/today` document. A missing progress document displays zero points and a locked badge. Rules permit authenticated reads of the shared document and owner-only reads of progress. All client writes are denied.
- **Completion** calls `completeToday` with `challengeId: today`. The function takes the UID from Firebase Auth and uses one transaction to check progress and write 10 points, the `first-quest` badge, and a server timestamp. A retry returns `alreadyCompleted: true` with the saved reward.
- **Quest Coach** validates the question and calls the Genkit tool `readMyQuestState` using the verified UID in its server context. The tool accepts an empty input object and can read the single shared challenge and that UID's progress. The model receives the challenge, its approved hints, and completion status. Its structured response selects a hint by index. It has no Firestore tools or reward actions. The callable returns a fixed privacy response to the Signal Check request. Model failures produce a retryable service error.
- **Local mode** runs all three Firebase emulators. With the gateway settings empty, Genkit runs a deterministic emulator model through the same structured-output path. The app labels the response as a local emulator hint.

## Run locally

Install Flutter, Node.js 22, Java 21 or later, and the Firebase CLI. Start an Android emulator, then use two terminals from the project root.

```powershell
flutter pub get
npm --prefix functions ci
firebase emulators:start --only auth,firestore,functions
```

```powershell
$env:FIRESTORE_EMULATOR_HOST = '127.0.0.1:8080'
npm --prefix functions run seed
flutter run -d emulator-5554
```

Use the actual identifier from `flutter devices`. `flutter run -d chrome` uses the same local Firebase services. Android emulators use host address `10.0.2.2`. To use another host, pass `--dart-define=EMULATOR_HOST=<host>` and make sure that device can reach the emulators. On Bash, set and export `FIRESTORE_EMULATOR_HOST=127.0.0.1:8080` before seeding or testing.

## Provisional Gemini and the course gateway

The provisional provider is Google Gemini Developer API, using `googleai/gemini-3.6-flash` and `@genkit-ai/google-genai` 1.44.0 with Genkit 1.44.0. Professor Henry has yet to approve this provider or model. The adapter and deterministic emulator model have passed local tests. A live Gemini API response remains unverified because a credential was unavailable. [Gemini model documentation](https://aistudio.google.com/docs/models/gemini-3.6-flash) · [Genkit Google GenAI plugin](https://genkit.dev/docs/js/integrations/google-genai/)

The Functions emulator uses the deterministic model when the gateway settings and local key are empty. For a live-provider test against the local Auth, Firestore, and Functions services, stop the existing emulator session and start it from a PowerShell terminal that holds the key. The masked prompt keeps the key out of command history and source files.

```powershell
$env:QUEST_LOCAL_MODEL_API_KEY = Read-Host -MaskInput "Gemini API key"
firebase emulators:start --only auth,firestore,functions
```

In a second terminal, run the focused Signal Check. The test requires a Genkit-backed reply and fails if it receives the emulator fallback. Save the real response and snapshots from the test output, plus the model event from the Functions log. The adversarial request is refused by the callable before it reaches the provider.

```powershell
$env:FIRESTORE_EMULATOR_HOST = '127.0.0.1:8080'
$env:CW3_EXPECT_COACH_SOURCE = 'genkit'
node --test --test-name-pattern='Signal Check uses authenticated state' functions/emulator.test.js
Remove-Item Env:CW3_EXPECT_COACH_SOURCE
```

When the course provides its approved gateway, install the appropriate Genkit plugin in `functions/` and override these server-side settings. Use the Functions process environment or the ignored `functions/.env.local` file for local configuration.

| Variable | Value |
|---|---|
| `QUEST_MODEL_PLUGIN` | The approved plugin's npm package name or a trusted adapter path relative to `functions/index.js` |
| `QUEST_MODEL_PLUGIN_FACTORY` | The plugin factory export. Gemini uses `googleAI` and other plugins default to `default` |
| `QUEST_MODEL_NAME` | Full Genkit model reference. Gemini defaults to `googleai/gemini-3.6-flash` |
| `QUEST_MODEL_OPTIONS` | JSON object with the plugin's non-secret options, such as the approved gateway URL if required |
| `QUEST_LOCAL_MODEL_API_KEY` | The credential for local emulator testing when the gateway requires it |

The factory receives the options and the key as `apiKey`. Use a server-side adapter returning a Genkit plugin if the approved gateway takes a different configuration shape. The expected model output is a JSON object with a single integer `hintIndex`. [Genkit model setup](https://genkit.dev/docs/js/models/)

For deployment, first enable email/password Auth and create Firestore in an authorized Firebase project. Seed `challenges/today` with the data in [functions/challenge.json](functions/challenge.json) using authorized admin access. Set `QUEST_COACH_SERVICE_ACCOUNT` and any non-secret gateway overrides in `functions/.env.<project-id>`. Cloud Functions defaults to the provisional Gemini settings when no overrides are provided. Use a dedicated account for the coach with Firestore read access (`roles/datastore.viewer`) and access to its own bound secret. `completeToday` uses a separate function identity with write access. Verify the coach account's effective permissions in the deployed project. [Function runtime options](https://firebase.google.com/docs/functions/manage-functions?gen=2nd) · [Firestore IAM roles](https://docs.cloud.google.com/iam/docs/roles-permissions/firestore)

Create the bound secret with `firebase functions:secrets:set QUEST_MODEL_API_KEY --project <project-id>`. Deploy the functions and rules with `firebase deploy --only functions,firestore:rules --project <project-id>`. Register the Flutter app with Firebase for the target platform and run with `USE_EMULATORS=false` and the platform-specific `FIREBASE_PROJECT_ID`, `FIREBASE_APP_ID`, `FIREBASE_API_KEY`, and `FIREBASE_SENDER_ID` Dart defines. Live Firebase and model calls require separate verification.

## Tests and evidence

```powershell
flutter analyze
flutter test
$env:FIRESTORE_EMULATOR_HOST = '127.0.0.1:8080'
npm --prefix functions test
flutter drive -d emulator-5554 --driver=test_driver/integration_test.dart --target=integration_test/signal_check_test.dart
```

- Ten [backend tests](evidence/backend-tests.txt) passed. The log includes the saved 10-point reward and timestamp, an idempotent retry, a rejected direct client write, safe challenge and model failures, and before-and-after records for both learners. The installed Gemini adapter used a local provider fixture to verify the exact model ID, the structured hint, the outbound data boundary, and the refusal before a second provider request. [Tool log](evidence/quest-coach-tool.txt) · [Provider verification status](evidence/gemini-verification.txt)
- [Static analysis](evidence/flutter-analyze.txt) reported zero issues, and all four [Flutter tests](evidence/flutter-tests.txt) passed.
- [Emulator startup](evidence/firebase-emulators.txt) records the local Auth, Firestore, and Cloud Functions run. [Flutter dependency resolution](evidence/flutter-pub-get.txt)
- The [Android integration test](evidence/android-integration.txt) passed on an Android 17 emulator. It covered registration, both coach requests, first and repeat completion, failed sign-in and recovery, coach service-error recovery, sign-out, and cleared private UI state. The test driver supplies keyboard input while the app uses the Firebase emulators. [Android screenshots](evidence/android/)
- A separate Android run verified the empty challenge, the retry button, and disabled completion and hint controls before the seed was restored. [Empty challenge test](evidence/android-empty-challenge.txt)
- See the [final submission audit](FINAL_SUBMISSION_AUDIT.md) for the readiness decision, scoring, and remaining actions.
- Use the [student reflection guide](STUDENT_REFLECTION_GUIDE.md) to review the recorded responses and the [walkthrough guide](STUDENT_WALKTHROUGH_GUIDE.md) to demonstrate the app. See the [submission checklist](SUBMISSION_CHECKLIST.md) for the full evidence inventory and the [repository access check](evidence/repository-access.txt).

## Limitations

The course gateway settings and a live Gemini key were unavailable. Cloud deployment and live model output remain unverified. The Android build uses a Kotlin non-incremental compile setting to support a Windows project and package cache on different drives. The current Functions dependency audit reports 62 moderate and 4 high findings. [Audit output](evidence/dependency-audit.txt)
