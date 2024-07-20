import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_app/colors/colors.dart';
import 'package:quiz_app/screens/results.dart';
import 'package:quiz_app/services/api.dart';

class QuizScreen1 extends StatefulWidget {
  const QuizScreen1({super.key});

  @override
  State<QuizScreen1> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen1> {
  late Future quiz;
  int seconds = 60;
  var currentIndexQuestion = 0;
  Timer? timer;
  bool isLoaded = false;
  var optionList = [];
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  @override
  void initState() {
    super.initState();
    quiz = getQuizData();
    startTimer();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  var optionColor = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];

  resetColor() {
    optionColor = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
    ];
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          gotoNextQuestion();
        }
      });
    });
  }

  gotoNextQuestion() {
    isLoaded = false;
    currentIndexQuestion++;
    resetColor();
    timer!.cancel();
    seconds = 60;
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter, colors: [Colors.blue, darkblue]),
        ),
        child: FutureBuilder(
          future: quiz,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error:${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (snapshot.hasData) {
              var data = snapshot.data["results"];
              if (isLoaded == false) {
                optionList = data[currentIndexQuestion]['incorrect_answers'];
                optionList.add(data[currentIndexQuestion]['correct_answer']);
                optionList.shuffle();
                isLoaded = true;
              }
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.red, width: 3),
                            ),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 30,
                                )),
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                "$seconds",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: CircularProgressIndicator(
                                    value: seconds / 60,
                                    valueColor: const AlwaysStoppedAnimation(
                                        Colors.white),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Center(
                        child: Image.asset(
                          'assets/images/ideas.png',
                          width: 200,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Question ${currentIndexQuestion + 1} of ${data.length}',
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        data[currentIndexQuestion]['question'],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: optionList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var correctAnswer =
                                data[currentIndexQuestion]['correct_answer'];

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (correctAnswer.toString() ==
                                      optionList[index].toString()) {
                                    optionColor[index] = Colors.green;
                                    correctAnswers++;
                                  } else {
                                    optionColor[index] = Colors.red;
                                    incorrectAnswers++;
                                  }

                                  if (currentIndexQuestion < data.length - 1) {
                                    Future.delayed(
                                        const Duration(milliseconds: 50), () {
                                      gotoNextQuestion();
                                    });
                                  } else {
                                    timer!.cancel();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ResultsScreen(
                                            correctAnswers,
                                            incorrectAnswers,
                                            currentIndexQuestion + 1),
                                      ),
                                    );
                                  }
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width - 100,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: optionColor[index],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  optionList[index].toString(),
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No Data Found'));
            }
          },
        ),
      ),
    );
  }
}
