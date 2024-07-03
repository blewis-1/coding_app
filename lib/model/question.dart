import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  String question;
  List<String> options;
  String answer;

  Question({
    required this.answer,
    required this.options,
    required this.question,
  });

  factory Question.fromDocument(QueryDocumentSnapshot<Object?> doc) {
    return Question(
        answer: doc['answer'] as String,
        options: List<String>.from(doc['options']),
        question: doc['question'] as String);
  }
}
