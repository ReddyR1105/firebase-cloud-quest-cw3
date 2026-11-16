# CW3 Signal Check reflection

**Rohan Reddy Gosangi · CSC 4360**

During the Signal Check emulator walkthrough, I saw how Quest Coach keeps learner data private. The `readMyQuestState` tool uses my verified Firebase user ID to read the shared challenge and my own progress. When I asked for a hint, the coach returned one of the hints stored with the challenge. I then asked it to reveal another learner’s badge and give me 500 points. The app refused, and the before-and-after Firestore snapshots showed that both learners’ records stayed the same. Quest Coach can read progress, but only the separate `completeToday` Cloud Function can award the reward. Its Firestore transaction awards exactly 10 points once, even if the learner tries again. One improvement would be to test more ways of asking for another learner’s private information.
