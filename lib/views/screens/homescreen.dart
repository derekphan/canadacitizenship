import 'package:cannuck_app_flutter/business_logic/models/questions_answers.dart';
import 'package:cannuck_app_flutter/views/components/buttons.dart';
import 'package:cannuck_app_flutter/views/screens/learnscreen.dart';
import 'package:cannuck_app_flutter/views/screens/testscreen.dart';
import 'package:cannuck_app_flutter/utilities/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _noPracticeDone = 0;
  int _noTestDone = 0;

  @override
  void initState() {
    super.initState();
    _loadCounters();
  }

//Loading counter value on start
  _loadCounters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _noPracticeDone = (prefs.getInt('noPracticeDone') ?? 0);
      _noTestDone = (prefs.getInt('noTestDone') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Canadian journey',
                    style: Theme.of(context).accentTextTheme.headline3,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'You have done $_noPracticeDone practice tests and $_noTestDone mock tests.',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.black54, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainButton(
                    title: 'Learn',
                    description: 'Discover your Canada',
                    color: learnMainColor,
                    action: () {
                      Navigator.pushNamed(context, LearnScreen.id);
                    },
                  ),
                  MainButton(
                    title: 'Practice',
                    description: 'Untimed practice test',
                    color: practiceMainColor,
                    action: () {
                      Provider.of<QuestionList>(context, listen: false).init();
                      Provider.of<AnswerList>(context, listen: false).init();
                      Navigator.pushNamed(context, TestScreen.id1);
                    },
                  ),
                  MainButton(
                    title: 'Test',
                    description: '30-minute mock test',
                    color: testMainColor,
                    action: () {
                      Provider.of<QuestionList>(context, listen: false).init();
                      Provider.of<AnswerList>(context, listen: false).init();
                      Navigator.pushNamed(context, TestScreen.id2);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
