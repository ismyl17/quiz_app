import 'package:flutter/material.dart';
import 'package:quiz_app/colors/colors.dart';
import 'package:quiz_app/screens/quiz_screen.dart';

class ResultsScreen extends StatelessWidget {
  final int correctAnswer;
  final int incorrectAnswer;
  final int totalQuestion;
  const ResultsScreen(
      this.correctAnswer, this.incorrectAnswer, this.totalQuestion,
      {super.key});

  @override
  Widget build(BuildContext context) {
    double correctPercentage = (correctAnswer / totalQuestion * 100);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter, colors: [Colors.blue, darkblue]),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Congratulations',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                '${correctPercentage.toStringAsFixed(1)}%',
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                'Correct Answer: $correctAnswer',
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              Text(
                'Incorrect Anser: $incorrectAnswer',
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuizScreen1(),
                      ),
                    );
                  },
                  child: const Text(
                    'Play Again',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
