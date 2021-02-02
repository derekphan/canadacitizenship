import 'package:cannuck_app_flutter/business_logic/models/questions_answers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainButton extends StatelessWidget {
  final String title;
  final String description;
  final Function action;
  final Color color;

  MainButton({this.title, this.description, this.action, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        width: double.infinity,
        child: RaisedButton(
          color: color,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          ),
          onPressed: action,
        ),
      ),
    );
  }
}

class CircularButton extends StatelessWidget {
  final bool isCurrent;
  final bool isAnswered;
  final String title;
  CircularButton({this.title, this.isCurrent = false, this.isAnswered = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MaterialButton(
        onPressed: () {
          context.read<QuestionList>().currentQuestion = int.parse(title) - 1;
        },
        elevation: 1.0,
        color: isCurrent
            ? Colors.amber
            : (isAnswered ? Colors.green : Colors.white),
        child: Text(title),
        padding: EdgeInsets.all(1.0),
        shape: CircleBorder(),
      ),
    );
  }
}
