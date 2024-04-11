import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class TestScreen extends StatefulWidget {
  final numberOfQuestions;

  const TestScreen({required this.numberOfQuestions});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int numberOfRemaining = 0;
  int numberOfCorrect = 0;
  int correctRate = 0;

  int questionLeft = 0;
  int questionRight = 0;
  String operator = "";
  String answer = "";

  bool isCalcButtonEnabled = false;
  bool isAnswerCheckButtonEnabled = false;
  bool isBackButtonEnabled = false;
  bool isCorrectIncorrectImageEnabled = false;
  bool isEndMessageEnabled = false;
  bool isCorrect = false;

  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    numberOfCorrect = 0;
    correctRate = 0;
    numberOfRemaining = widget.numberOfQuestions;

    _audioPlayer = AudioPlayer();
    setQuestion();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                // スコア表示部分
                _scorePart(),
                // 問題表示部分
                _questionPart(),
                // 電卓ボタン部分
                _calcButtons(),
                // 答え合わせボタン
                _answerCheckButton(),
                // 戻るボタン
                _backButton(),
              ],
            ),
            // ○×画像
            _correctIncorrectImage(),
            // テスト終了メッセージ
            _endMessage(),
          ],
        ),
      ),
    );
  }

  Widget _scorePart() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: Table(
        children: [
          TableRow(
            children: [
              Center(
                  child: Text(
                "のこり問題数",
                style: TextStyle(fontSize: 10.0),
              )),
              Center(
                  child: Text(
                "正解数",
                style: TextStyle(fontSize: 10.0),
              )),
              Center(
                  child: Text(
                "正答率",
                style: TextStyle(fontSize: 10.0),
              )),
            ],
          ),
          TableRow(
            children: [
              Center(
                  child: Text(
                numberOfRemaining.toString(),
                style: TextStyle(fontSize: 18.0),
              )),
              Center(
                  child: Text(
                numberOfCorrect.toString(),
                style: TextStyle(fontSize: 18.0),
              )),
              Center(
                  child: Text(
                correctRate.toString(),
                style: TextStyle(fontSize: 18.0),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _questionPart() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 80.0),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Center(
                  child: Text(
                questionLeft.toString(),
                style: TextStyle(fontSize: 36.0),
              ))),
          Expanded(
              flex: 1,
              child: Center(
                  child: Text(
                operator,
                style: TextStyle(fontSize: 30.0),
              ))),
          Expanded(
              flex: 2,
              child: Center(
                  child: Text(
                questionRight.toString(),
                style: TextStyle(fontSize: 36.0),
              ))),
          Expanded(
              flex: 1,
              child: Center(
                  child: Text(
                "=",
                style: TextStyle(fontSize: 30.0),
              ))),
          Expanded(
              flex: 3,
              child: Center(
                  child: Text(
                answer,
                style: TextStyle(fontSize: 60.0),
              ))),
        ],
      ),
    );
  }

  Widget _calcButtons() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 50.0),
        child: Table(
          children: [
            TableRow(
              children: [
                _calcButton("7"),
                _calcButton("8"),
                _calcButton("9"),
              ],
            ),
            TableRow(
              children: [
                _calcButton("4"),
                _calcButton("5"),
                _calcButton("6"),
              ],
            ),
            TableRow(
              children: [
                _calcButton("1"),
                _calcButton("2"),
                _calcButton("3"),
              ],
            ),
            TableRow(
              children: [
                _calcButton("0"),
                _calcButton("-"),
                _calcButton("c"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _calcButton(String numString) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
        ),
        onPressed: isCalcButtonEnabled ? () => inputButton(numString) : null,
        child: Text(
          numString,
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }

  Widget _answerCheckButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isAnswerCheckButtonEnabled ? () => answerCheck(): null,
          child: Text(
            "答え合わせ",
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );
  }

  Widget _backButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isBackButtonEnabled ? () => closeTestScreen() : null,
          child: Text(
            "戻る",
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );
  }

  Widget _correctIncorrectImage() {
    if (isCorrectIncorrectImageEnabled) {
      if (isCorrect) {
        return Center(child: Image.asset("assets/images/pic_correct.png"));
      }
      return Center(child: Image.asset("assets/images/pic_incorrect.png"));
    }
    return Container();
  }

  Widget _endMessage() {
    if (isEndMessageEnabled) {
      return Center(
        child: Text(
          "テスト終了",
          style: TextStyle(fontSize: 60.0),
        ),
      );
    }
    return Container();
  }

  void setQuestion() {
    isCalcButtonEnabled = true;
    isAnswerCheckButtonEnabled = true;
    isBackButtonEnabled = false;
    isCorrectIncorrectImageEnabled = false;
    isEndMessageEnabled = false;
    answer = "";

    Random random = Random();
    questionLeft = random.nextInt(100) + 1;
    questionRight = random.nextInt(100) + 1;

    if (random.nextInt(2) == 0) {
      operator = "+";
    } else {
      operator = "-";
    }
    setState(() {
    });
  }

  inputButton(String numString) {
    setState(() {
      if (numString == "c") {
        answer = "";
        return;
      }
      if (numString == "-") {
        if (answer == "") {
          answer = "-";
        }
        return;
      }
      if (numString == "0") {
        if (answer != "0" && answer != "-") {
          answer += numString;
        }
        return;
      }
      if (answer == "0") {
        answer = numString;
        return;
      }
      answer += numString;
    });
  }

  answerCheck() {
    if (answer == "" || answer == "-") {
      return;
    }
    isCalcButtonEnabled = false;
    isAnswerCheckButtonEnabled = false;
    isBackButtonEnabled = false;
    isCorrectIncorrectImageEnabled = true;
    isEndMessageEnabled = false;

    var myAnswer = int.parse(answer).toInt();
    var realAnswer = 0;
    if (operator == "+") {
      realAnswer = questionLeft + questionRight;
    } else {
      realAnswer = questionLeft - questionRight;
    }

    numberOfRemaining--;

    if (myAnswer == realAnswer) {
      isCorrect = true;
      numberOfCorrect++;
    } else {
      isCorrect = false;
    }
    _playSound();

    correctRate = (numberOfCorrect / (widget.numberOfQuestions - numberOfRemaining) * 100).toInt();

    if (numberOfRemaining == 0) {
      isCalcButtonEnabled = false;
      isAnswerCheckButtonEnabled = false;
      isBackButtonEnabled = true;
      isCorrectIncorrectImageEnabled = true;
      isEndMessageEnabled = true;
    } else {
      Timer(Duration(seconds: 1), () => setQuestion());
    }

    setState(() {
    });
  }

  void _playSound() async {
    if (isCorrect) {
      await _audioPlayer.setAsset("assets/sounds/sound_correct.mp3");
    } else {
      await _audioPlayer.setAsset("assets/sounds/sound_incorrect.mp3");
    }
    _audioPlayer.play();
  }

  closeTestScreen() {
    Navigator.pop(context);
  }
}
