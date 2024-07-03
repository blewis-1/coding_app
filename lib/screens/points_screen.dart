import 'package:coding_app/screens/dashboard_screen.dart';
import 'package:coding_app/screens/game_screen.dart';
import 'package:flutter/material.dart';

class PointsScreen extends StatelessWidget {
  final String points;
  const PointsScreen({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Image(
                width: 350,
                image: AssetImage('assets/trophy.png'),
              ),
              Text(
                "You earned ${points}pts.",
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Keep up the great work.",
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).indicatorColor,
                ),
                onPressed: () async {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DashboardScreen()));
                },
                child: const Text("Practice again!"),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
