import 'package:coding_app/screens/game_screen.dart';
import 'package:coding_app/services/db.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Db _db = Db();
  String points = "0";

  @override
  void initState() {
    fetchPoints();
    super.initState();
  }

  void fetchPoints() async {
    String userPoints = await _db.getUserPoints();
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome to Coding Minds",
                style: TextStyle(fontSize: 24, color: Colors.blueAccent),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Points $points X",
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.green,
                ),
              ),
              Container(
                width: double.infinity,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.cyan, borderRadius: BorderRadius.circular(8)),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Courses 💻",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.green,
                ),
              ),
              const Text(
                "Select a course to start practicing. 💻",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const GameScreen(),
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Python 🐍",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
