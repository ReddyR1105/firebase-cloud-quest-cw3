import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class DailyChallenge {
  const DailyChallenge(this.title, this.prompt);
  final String title;
  final String prompt;
}

class QuestProgress {
  const QuestProgress(this.completed, this.points, this.badge);

  factory QuestProgress.fromMap(Map<String, dynamic>? data) => QuestProgress(
    data?['completed'] == true,
    (data?['points'] as num?)?.toInt() ?? 0,
    data?['badgeId'] == 'first-quest' ? 'First Quest' : 'Locked',
  );

  final bool completed;
  final int points;
  final String badge;
}

class QuestService {
  Stream<DailyChallenge?> challenge() =>
      FirebaseFirestore.instance.doc('challenges/today').snapshots().map((doc) {
        final data = doc.data();
        return data == null
            ? null
            : DailyChallenge(data['title'] as String, data['prompt'] as String);
      });

  Stream<QuestProgress> progress(String uid) => FirebaseFirestore.instance
      .doc('users/$uid/progress/today')
      .snapshots()
      .map((doc) => QuestProgress.fromMap(doc.data()));

  Future<bool> complete() async {
    final result = await FirebaseFunctions.instance
        .httpsCallable('completeToday')
        .call<Map<Object?, Object?>>({'challengeId': 'today'});
    return result.data['alreadyCompleted'] == true;
  }

  Future<({String hint, String source})> ask(String question) async {
    final result = await FirebaseFunctions.instance
        .httpsCallable('askQuestCoach')
        .call<Map<Object?, Object?>>({'question': question.trim()});
    return (
      hint: result.data['hint'] as String,
      source: result.data['source'] as String,
    );
  }
}
