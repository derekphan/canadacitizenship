import 'package:cannuck_app_flutter/utilities/constant.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:cannuck_app_flutter/services/question_database_nosql.dart';

class Question {
  final int id;
  final String question;
  final List<String> answers;
  final int correctAnswer;
  final int category;

  Question(
      {this.id,
      this.question,
      this.answers,
      this.correctAnswer,
      this.category = 0});

  //construction create Question object from map
  Question.fromMap(int id, Map<String, dynamic> map)
      : this.id = id,
        this.question = map['question'],
        this.answers = [
          map['answer1'],
          map['answer2'],
          map['answer3'],
          map['answer4']
        ],
        this.correctAnswer = map['correctAnswer'],
        this.category = map['category'];

  //construction create Question object from json
  Question.fromJson(Map<String, dynamic> map)
      : this.id = map['_id'],
        this.question = map['question'],
        this.answers = [
          map['answer1'],
          map['answer2'],
          map['answer3'],
          map['answer4']
        ],
        this.correctAnswer = map['correctAnswer'],
        this.category = map['category'];

  // create Map from Question object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      //No need to set ID, ID set automatically by the nosql db engine
      'question': question,
      'answer1': answers[0],
      'answer2': answers[1],
      'answer3': answers[2],
      'answer4': answers[3],
      'correctAnswer': correctAnswer,
      'category': category,
    };

    return map;
  }
}

class QuestionList with ChangeNotifier {
  List<Question> _questionList = [];
  bool _isInitializing = false;
  int _currentQuestion = 0;

  QuestionList();
  bool get isInitializing => _isInitializing;
  int get currentQuestion => _currentQuestion;
  // Change current question ID, notify all listener
  set currentQuestion(int newValue) {
    if ((newValue >= 0) & (newValue < numberOfTestQuestions)) {
      _currentQuestion = newValue;
      notifyListeners();
    }
  }

  void moveToNextQuestion() {
    if (_currentQuestion < numberOfTestQuestions - 1) {
      _currentQuestion++;
      notifyListeners();
    }
  }

  void moveToPreviousQuestion() {
    if (_currentQuestion >= 1) {
      _currentQuestion--;
      notifyListeners();
    }
  }

  Future init() async {
    _isInitializing = true;
    notifyListeners();

    // Query 20 random questions from db
    DatabaseProvider db = DatabaseProvider();
    _questionList = await db.queryRandomNQuestions(20);

    // Set current question to 0
    _currentQuestion = 0;

    _isInitializing = false;
    notifyListeners();
  }

  UnmodifiableListView<Question> get list =>
      UnmodifiableListView(_questionList);
}

class AnswerList with ChangeNotifier {
  List<int> _answerList = List<int>.filled(20, -1, growable: false);

  void init() {
    _answerList.fillRange(0, 20, -1);
  }

  setAnswer(int index, int answer) {
    // set the answer
    _answerList[index] = answer;
    notifyListeners();
  }

  UnmodifiableListView<int> get list => UnmodifiableListView(_answerList);
}
