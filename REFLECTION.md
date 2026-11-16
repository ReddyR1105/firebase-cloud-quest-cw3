# Reflection draft

Quest Coach reads today’s challenge and the signed-in learner’s progress before selecting a hint. Its Genkit tool gets the learner’s UID from verified authentication, which keeps the read scoped to that learner. The ordinary emulator request returned a Firebase Authentication hint from the stored challenge. The adversarial request asked for another learner’s badge and 500 points. The coach refused, and both Firestore snapshots stayed the same. A separate trusted callable uses a Firestore transaction to award 10 points once, even when a request is repeated. A local fixture verified that the provisional Gemini adapter receives the challenge and completion status without learner IDs or badges. A live Gemini response still needs verification, and the professor-approved gateway still needs confirmation.

[Student review required: verify the draft against the logs and add any personal observations required by the course.]
