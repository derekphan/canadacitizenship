import 'package:cannuck_app_flutter/business_logic/models/questions_answers.dart';
import 'package:cannuck_app_flutter/services/question_database_nosql.dart';
import 'package:cannuck_app_flutter/views/screens/homescreen.dart';
import 'package:cannuck_app_flutter/views/screens/learnscreen.dart';
import 'package:cannuck_app_flutter/views/screens/resultscreen.dart';
import 'package:cannuck_app_flutter/views/screens/testscreen.dart';
import 'package:cannuck_app_flutter/utilities/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize database
  DatabaseProvider db = DatabaseProvider();
  await db.database;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<QuestionList>(
            create: (_) => QuestionList(),
          ),
          ChangeNotifierProvider<AnswerList>(
            create: (_) => AnswerList(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            //primarySwatch: Colors.grey,
            brightness: Brightness.light,
            // primaryColor: backgroundColor,
            //accentColor: accentColor,
            buttonColor: buttonColor,
            backgroundColor: backgroundColor,
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            // Define the default font family.
            fontFamily: 'Roboto Mono',

            // Define the default TextTheme. Use this to specify the default
            // text styling for headlines, titles, bodies of text, and more.
            textTheme: primaryTextTheme,
            accentTextTheme: accentTextTheme,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: HomeScreen.id,
          routes: {
            HomeScreen.id: (context) => HomeScreen(),
            LearnScreen.id: (context) => LearnScreen(),
            TestScreen.id1: (context) => TestScreen(),
            TestScreen.id2: (context) => TestScreen(isTimed: true),
            ResultScreen.id: (context) => ResultScreen(),
          },
        ));
  }
}
