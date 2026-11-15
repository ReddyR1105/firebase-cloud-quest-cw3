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

## Connect an approved model and live Firebase

Install the course-approved Genkit plugin in `functions/` once the course supplies its gateway details. Set these variables in the ignored `functions/.env.local` file and restart the emulators.

| Variable | Value |
|---|---|
| `QUEST_MODEL_PLUGIN` | The approved plugin's npm package name or a trusted adapter path relative to `functions/index.js` |
| `QUEST_MODEL_PLUGIN_FACTORY` | The plugin factory export, defaulting to `default` |
| `QUEST_MODEL_NAME` | The plugin's full Genkit model reference |
| `QUEST_MODEL_OPTIONS` | JSON object with the plugin's non-secret options, such as the approved gateway URL if required |
| `QUEST_LOCAL_MODEL_API_KEY` | The credential for local emulator testing when the gateway requires it |

The factory receives the options and the key as `apiKey`. Use a server-side adapter returning a Genkit plugin if the approved gateway takes a different configuration shape. The expected model output is a JSON object with a single integer `hintIndex`. [Genkit model setup](https://genkit.dev/docs/js/models/)

For deployment, first enable email/password Auth and create Firestore in an authorized Firebase project. Seed `challenges/today` with the data in [functions/challenge.json](functions/challenge.json) using authorized admin access. Set the four non-secret gateway variables in `functions/.env.<project-id>` and create the bound secret with `firebase functions:secrets:set QUEST_MODEL_API_KEY --project <project-id>`. Deploy the functions and rules with `firebase deploy --only functions,firestore:rules --project <project-id>`. Register the Flutter app with Firebase for the target platform and run with `USE_EMULATORS=false` and the platform-specific `FIREBASE_PROJECT_ID`, `FIREBASE_APP_ID`, `FIREBASE_API_KEY`, and `FIREBASE_SENDER_ID` Dart defines. Live Firebase and model calls require separate verification.

## Tests and evidence

```powershell
flutter analyze
flutter test
$env:FIRESTORE_EMULATOR_HOST = '127.0.0.1:8080'
npm --prefix functions test
flutter drive -d emulator-5554 --driver=test_driver/integration_test.dart --target=integration_test/signal_check_test.dart
```

- Seven [backend tests](evidence/backend-tests.txt) passed. The log includes the saved 10-point reward and timestamp, an idempotent retry, a rejected direct client write, and unchanged Firestore records for the caller and a second test learner.
- [Static analysis](evidence/flutter-analyze.txt) reported zero issues, and all four [Flutter tests](evidence/flutter-tests.txt) passed.
- [Emulator startup](evidence/firebase-emulators.txt) records the local Auth, Firestore, and Cloud Functions run.
- The [Android integration test](evidence/android-integration.txt) passed on an Android 17 emulator. It covered registration, both coach requests, first and repeat completion, sign-out, and signing back in. The [Android screenshots](evidence/android/) show the challenge, responses, and reward. The test driver supplies keyboard input while the app uses the Firebase emulators.

## Limitations

Local verification uses a deterministic emulator model. The course gateway settings were unavailable, so cloud deployment and live model output remain unverified. The Android build uses a Kotlin non-incremental compile setting to support a Windows project and package cache on different drives. The dependency audit reported 62 moderate and 9 high findings for the installed Functions dependencies. [Audit output](evidence/dependency-audit.txt)
