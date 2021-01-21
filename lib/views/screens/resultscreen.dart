import 'package:cannuck_app_flutter/business_logic/models/questions_answers.dart';
import 'package:cannuck_app_flutter/utilities/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'homescreen.dart';

class ResultScreen extends StatelessWidget {
  static const String id = 'result_screen';
  // final bool isPassed;
  // final int noOfCorrectAnswers;

  // ResultScreen({this.isPassed, this.noOfCorrectAnswers});

  @override
  Widget build(BuildContext context) {
    QuestionList ql = context.watch<QuestionList>();
    AnswerList al = context.watch<AnswerList>();
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    final int noOfCorrectAnswers = arguments['noOfCorrectAnswers'] ?? 0;
    final isPassed = noOfCorrectAnswers >= 15;

    return WillPopScope(
      onWillPop: () {
        //Return to home screen, skip the test screen
        Navigator.pushNamed(context, HomeScreen.id);
        return new Future.value(true);
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: isPassed ? Colors.green : Colors.red,
                  alignment: Alignment.center,
                  child: Text(
                    isPassed ? "Passed" : "Failed",
                    style: Theme.of(context).primaryTextTheme.headline3,
                  ),
                ),
                Text(
                  '$noOfCorrectAnswers/20',
                  style: Theme.of(context).accentTextTheme.headline3,
                ),
                IconButton(
                  icon: Icon(Icons.home),
                  iconSize: 60,
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pushNamed(context, HomeScreen.id);
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      child: ListView.builder(
                        itemCount: numberOfTestQuestions,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ql.list[index].question,
                                    style: Theme.of(context)
                                        .accentTextTheme
                                        .bodyText2,
                                  ),
                                  for (var i = 0; i < 4; i++)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        (ql.list[index].correctAnswer == i + 1)
                                            ? Icon(Icons.check,
                                                color: Colors.green)
                                            : (al.list[index] !=
                                                        ql.list[index]
                                                            .correctAnswer &&
                                                    al.list[index] == i + 1)
                                                ? Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                  )
                                                : Icon(
                                                    Icons.close,
                                                    color: Colors.black,
                                                  ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Flexible(
                                          child: Text(
                                            ql.list[index].answers[i],
                                            style: Theme.of(context)
                                                .accentTextTheme
                                                .bodyText2,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
