import 'package:coding_app/components/progress_bar.dart';
import 'package:coding_app/model/question.dart';
import 'package:coding_app/screens/points_screen.dart';
import 'package:coding_app/services/db.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int index = 0;
  String points = "0";
  String selected = "";
  Color? responseColor;
  bool allowSelect = true;
  double progressBarLength = 0;
  final Db db = Db();
  late Question question;

  @override
  void initState() {
    fetchPoints();
    super.initState();
  }

  void fetchPoints() async {
    String userPoints = await db.getUserPoints();
    if (mounted) {
      setState(() {
        points = userPoints;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: db.getQuestions(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Question> questions = snapshot.data!;
              question = questions[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ProgressBar(
                          length: progressBarLength,
                        ),
                        Text(
                          '${points}x',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      question.question,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: question.options.length,
                          itemBuilder: (context, index) {
                            String option = question.options[index];
                            bool isSelected = selected == option;
                            bool isCorrect = option == question.answer;

                            return GestureDetector(
                              onTap: () => allowSelect
                                  ? _checkAnswer(option, isCorrect,
                                      questions.length.toDouble())
                                  : null,
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 30),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? responseColor
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  question.options[index],
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    if (selected != '')
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Theme.of(context).indicatorColor,
                        ),
                        onPressed: () {
                          if (index < questions.length - 1) {
                            setState(() {
                              index++;
                              // print(index);
                              question = questions[index];
                              allowSelect = true;
                              selected = '';
                            });
                          } else {
                            // Navigate to score screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PointsScreen(
                                  points: points,
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Continue",
                        ),
                      )
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  void _checkAnswer(String option, bool isCorrect, double totalLength) {
    setState(() {
      // Get the current value selected by the user.
      selected = option;

      // update the response color
      responseColor = isCorrect ? Colors.green.shade200 : Colors.red[200];

      // disable selection of answer
      allowSelect = false;

      // set the progressBarLength
      progressBarLength += 250 * (1 / totalLength);

      // track score
      if (isCorrect) {
        // calculate the score
        points = (int.parse(points) + 1 * 50).toString();

        // update the database the score
        db.updatePoints(db.user.uid, points);
      }
    });
  }
}
