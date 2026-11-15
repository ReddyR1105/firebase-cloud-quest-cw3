# Reflection draft

The Quest Coach starts by reading today’s challenge and the signed-in learner’s progress. Its Genkit tool takes the learner’s UID from the verified request context, so a question cannot choose whose record to read. The ordinary emulator request returned a hint about Firebase Authentication that matched the stored challenge. The adversarial request asked for another learner’s badge and 500 points. The coach refused, and the before-and-after Firestore snapshots matched for both test accounts. Rewards are handled separately by a trusted callable. Its Firestore transaction checked whether the quest was already complete and kept the total at 10 points after retries. The local test used a deterministic hint selector. A next step is to repeat both requests through the course-approved model gateway.

[Student review required: verify the draft against the logs and add any personal observations required by the course.]
