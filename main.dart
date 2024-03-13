import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(BalloonPopGame());
}

class BalloonPopGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wanna Try Balloon Pop Game',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  int balloonsPopped = 0;
  int balloonsMissed = 0;
  int gameDurationInSeconds = 120;
  late Timer timer;
  Random random = Random();
  List<bool> balloons = List.filled(15, false); // Simulate 15 balloons
  late OverlayEntry overlayEntry;

  @override
  void initState() {
    super.initState();
    startGameTimer();
    generateBalloons();
  }

  void startGameTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (gameDurationInSeconds < 1) {
          timer.cancel();
          // Game over
          showGameOverDialog();
        } else {
          gameDurationInSeconds--;
        }
      });
    });
  }

  void generateBalloons() {
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (gameDurationInSeconds > 0) {
        setState(() {
          int index = random.nextInt(balloons.length);
          balloons[index] = true;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text(
              "Score: $score\nBalloons Popped: $balloonsPopped\nBalloons Missed: $balloonsMissed"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: Text("Play Again"),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      score = 0;
      balloonsPopped = 0;
      balloonsMissed = 0;
      gameDurationInSeconds = 120;
      balloons.fillRange(0, balloons.length, false);
    });
    startGameTimer();
    generateBalloons();
  }

  void popBalloon(int index) {
    setState(() {
      if (balloons[index]) {
        balloonsPopped++;
        score += 2;
      } else {
        balloonsMissed++;
        score -= 1;
      }
      balloons[index] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wanna Try Balloon Pop Game"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "Time Left: ${Duration(seconds: gameDurationInSeconds).toString().split('.').first}",
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Text("Score: $score", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: balloons.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      popBalloon(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: balloons[index]
                            ? Colors.orange
                            : Colors.transparent,
                      ),
                      child: Center(
                        child: Text(
                          balloons[index] ? " ❤" : "",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
