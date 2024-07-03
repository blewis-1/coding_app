import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_app/model/question.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Db {
  late User user;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<Question>> getQuestions() async {
    try {
      QuerySnapshot snapshot = await db.collection("questions").get();
      return snapshot.docs.map((doc) => Question.fromDocument(doc)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<String> getUserPoints() async {
    // Get the currents user points

    if (FirebaseAuth.instance.currentUser != null) {
      user = FirebaseAuth.instance.currentUser!;
    }
    try {
      QuerySnapshot snapshot = await db
          .collection("points")
          .where("user_id", isEqualTo: user.uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first["points"];
      }
      return "0";
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<void> updatePoints(String userId, String currentPoints) async {
    try {
      await db.collection("points").doc(userId).set({
        'points': currentPoints,
        "user_id": userId,
      });
      print('Points updated successfully.');
    } catch (e) {
      print('Error updating points: $e');
    }
  }
}
