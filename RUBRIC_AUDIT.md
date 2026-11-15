# CW3 rubric audit

| Category | Available points | Implementation and evidence | Remaining verification |
|---|---:|---|---|
| Engagement and learning process | 5 | Fresh repository history and the automated workflow documented in the README and test logs | Student should review the architecture and supply any process evidence required by the course. |
| Conceptual understanding | 15 | README explains UID ownership, server authorization, and the reward transaction. The challenge asks the learner to explain each part. | Student should be prepared to explain these decisions independently. |
| Core application | 30 | Flutter auth, challenge stream, private progress, completion, error and loading states in `lib/`. Seven Firebase emulator scenarios cover rules, the reward callable, and the coach. | Live Firebase and iOS execution are unverified. |
| AI agent | 15 | `functions/index.js` defines `readMyQuestState`, verified UID context, a configurable Genkit plugin, a deterministic emulator model, structured hint selection, and a model error response. The backend log records local hints and Signal Check snapshots. | Verify course gateway compatibility and repeat both requests against it. |
| Reasoning and reflection | 10 | `REFLECTION.md` links the observed hint and refusal behavior to the data access design. | Student should review and finalize the reflection. |
| Testing and evidence | 15 | Seven passing backend scenarios, four passing Flutter tests, clean static analysis, and a passing Android journey. The evidence directory contains seven Android screenshots and the before-and-after Firestore records. | Course gateway and live Firebase verification remain open. |
| Communication and delivery | 10 | README and checklist identify Rohan Reddy Gosangi and include the repository URL. Source, logs, and reflection draft are included. | Confirm portal deliverables, ensure the grader has access, and submit. |
| **Total** | **100** | | |

The point values are the rubric weights.
