import 'dart:async';

import 'package:cannuck_app_flutter/business_logic/models/questions_answers.dart';
import 'package:cannuck_app_flutter/utilities/constant.dart';
import 'package:cannuck_app_flutter/views/components/timer.dart';
import 'package:cannuck_app_flutter/views/screens/resultscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestScreen extends StatefulWidget {
  static const String id1 = 'practice_screen';
  static const String id2 = 'test_screen';

  final bool isTimed;

  TestScreen({this.isTimed = false});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> with TickerProviderStateMixin {
  AnimationController _controller;
  int countdown30Mins = 1800;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.isTimed) {
      _controller = AnimationController(
        vsync: this,
        duration: Duration(
          seconds: countdown30Mins,
        ), // gameData.levelClock is a user entered number elsewhere in the applciation
      );
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Call the result functions when time's up or user submit
          print("Time's up!");
          //Submit answer to get results
          _showResults(context);
        }
      });
      _controller.forward();
    }
  }

  // Navigation row for questions
  // List<Widget> _buildNavigationRow(BuildContext context, int rowNumber) {
  //   QuestionList ql = context.watch<QuestionList>();
  //   AnswerList al = context.watch<AnswerList>();
  //   if (rowNumber == 1) {
  //     return List<Widget>.generate(
  //       10,
  //       (index) => CircularButton(
  //         title: "${index + 1}",
  //         isCurrent: ql.currentQuestion == index,
  //         isAnswered: al.list[index] != -1,
  //       ),
  //     );
  //   } else {
  //     return List<Widget>.generate(
  //       10,
  //       (index) => CircularButton(
  //         title: "${index + 11}",
  //         isCurrent: ql.currentQuestion == index + 10,
  //         isAnswered: al.list[index + 10] != -1,
  //       ),
  //     );
  //   }
  // }

  // Display question and answers text
  List<Widget> _buildQuestionText(BuildContext context) {
    QuestionList ql = context.watch<QuestionList>();
    AnswerList al = context.watch<AnswerList>();
    return [
      Container(
        child: Text(
          ql.list[ql.currentQuestion].question,
          style: Theme.of(context).accentTextTheme.subtitle1,
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(4, (index) {
          return IntrinsicHeight(
                      child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: TextButton(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    ql.list[ql.currentQuestion].answers[index],
                    style: Theme.of(context).accentTextTheme.subtitle1,
                  ),
                ),
                style: TextButton.styleFrom(
                    minimumSize: Size.fromHeight(20),
                    padding: EdgeInsets.all(5),
                    backgroundColor: (al.list[ql.currentQuestion] == -1)
                        ? Colors.white
                        : (index == al.list[ql.currentQuestion]
                            ? Colors.green
                            : (!widget.isTimed &&
                                    index + 1 ==
                                        ql.list[ql.currentQuestion]
                                            .correctAnswer
                                ? Colors.red
                                : Colors.white))),
                onPressed: () {
                  context
                      .read<AnswerList>()
                      .setAnswer(ql.currentQuestion, index);
                },
              ),
            ),
          );
        }),
      ),
    ];

    // List<Widget>.generate(6, (index) {
    //   if (index == 0) {
    //     return Text(
    //       ql.list[ql.currentQuestion].question,
    //       style: Theme.of(context).accentTextTheme.subtitle1,
    //     );
    //   } else if (index == 1) {
    //     return SizedBox(
    //       height: 25,
    //     );
    //   } else {
    //     return Container(
    //       margin: EdgeInsets.symmetric(vertical: 5),
    //       child: TextButton(
    //         child: Align(
    //           alignment: Alignment.topLeft,
    //           child: Text(
    //             ql.list[ql.currentQuestion].answers[index - 2],
    //             style: Theme.of(context).accentTextTheme.subtitle1,
    //           ),
    //         ),
    //         style: TextButton.styleFrom(
    //             minimumSize: Size.fromHeight(20),
    //             padding: EdgeInsets.all(5),
    //             backgroundColor: (al.list[ql.currentQuestion] == -1)
    //                 ? Colors.white
    //                 : (index == al.list[ql.currentQuestion]
    //                     ? Colors.green
    //                     : (!widget.isTimed &&
    //                             index - 1 ==
    //                                 ql.list[ql.currentQuestion].correctAnswer
    //                         ? Colors.red
    //                         : Colors.white))),
    //         onPressed: () {
    //           context.read<AnswerList>().setAnswer(ql.currentQuestion, index);
    //         },
    //       ),
    //     );
    //   }
    // });
  }

  // Submit answer to get results
  _showResults(BuildContext context) async {
    QuestionList ql = context.read<QuestionList>();
    AnswerList al = context.read<AnswerList>();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget.isTimed) {
      var counter = (prefs.getInt('noTestDone') ?? 0) + 1;
      await prefs.setInt('noTestDone', counter);
    } else {
      var counter = (prefs.getInt('noPracticeDone') ?? 0) + 1;
      await prefs.setInt('noPracticeDone', counter);
    }

    // Calculate number of correct answers
    var noOfCorrectAnswer = 0;
    for (var i = 0; i < numberOfTestQuestions; i++) {
      if (ql.list[i].correctAnswer == al.list[i]) {
        noOfCorrectAnswer++;
      }
    }

    Navigator.pushNamed(
      context,
      ResultScreen.id,
      arguments: {
        'noOfCorrectAnswers': noOfCorrectAnswer,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    QuestionList ql = context.watch<QuestionList>();
    //AnswerList al = context.watch<AnswerList>();

    return ql.isInitializing
        ? CircularProgressIndicator()
        : WillPopScope(
            onWillPop: () async {
              return (await showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                      title: new Text('End Test'),
                      content: new Text('Do you want to exit test?'),
                      titleTextStyle:
                          Theme.of(context).accentTextTheme.headline6,
                      contentTextStyle:
                          Theme.of(context).accentTextTheme.bodyText2,
                      actions: <Widget>[
                        new TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: new Text('No'),
                        ),
                        new TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: new Text('Yes'),
                        ),
                      ],
                    ),
                  )) ??
                  Future.value(false);
            },
            child: Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                title: widget.isTimed
                    ? Countdown(
                        animation: StepTween(
                          begin: countdown30Mins,
                          end: 0,
                        ).animate(_controller),
                      )
                    : Text("Practice Test"),
                backgroundColor:
                    widget.isTimed ? testMainColor : practiceMainColor,
                textTheme: Theme.of(context).primaryTextTheme,
                iconTheme: //Theme.of(context).iconTheme,
                    Theme.of(context).iconTheme.copyWith(color: Colors.white),
              ),
              body: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        "Question ${ql.currentQuestion + 1}/20",
                        style: Theme.of(context)
                            .accentTextTheme
                            .subtitle1
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _buildQuestionText(context),
                      ),
                    ),
                    Container(
                      //constraints: BoxConstraints(maxHeight: 70),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.navigate_before),
                                iconSize: 50,
                                color: Colors.black,
                                onPressed: () {
                                  context
                                      .read<QuestionList>()
                                      .moveToPreviousQuestion();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.check),
                                iconSize: 50,
                                color: Colors.black,
                                onPressed: () => _showResults(context),
                              ),
                              IconButton(
                                icon: Icon(Icons.navigate_next),
                                iconSize: 50,
                                color: Colors.black,
                                onPressed: () {
                                  context
                                      .read<QuestionList>()
                                      .moveToNextQuestion();
                                },
                              )
                            ],
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //   children: _buildNavigationRow(context, 1),
                          // ),
                          // Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //     children: _buildNavigationRow(context, 2))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
