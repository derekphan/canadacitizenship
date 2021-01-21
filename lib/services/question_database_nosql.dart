import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:cannuck_app_flutter/services/encrypt_codec.dart';
import 'package:cannuck_app_flutter/utilities/constant.dart';
import 'package:cannuck_app_flutter/business_logic/models/questions_answers.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart';

// database table and column names
final String dbName = 'questions';
final int dbVersion = 1;

class DatabaseProvider {
  // DatabaseProvider singleton pattern
  DatabaseProvider._internal();
  static final DatabaseProvider _instance = DatabaseProvider._internal();

  factory DatabaseProvider() {
    return _instance;
  }

  // Static database object
  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  static final _databaseName = dbName;
  static final _databaseVersion = dbVersion;
  static final _dbStore = intMapStoreFactory.store(_databaseName);

  // Initialize db
  Future<Database> _initDB() async {
    //The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    var codec = getEncryptSembastCodec(password: encryptionK);

    return databaseFactoryIo.openDatabase(
      path,
      version: _databaseVersion,
      codec: codec,
      onVersionChanged: (db, oldVersion, newVersion) async {
        //Populate database
        if (oldVersion == 0) {
          //Populate data from encrypted json file
          String encryptedData =
              await rootBundle.loadString("assets/data/questions.json.aes");
          if (encryptedData != null) {
            final key = Key.fromUtf8(encryptionK);
            final iv = IV.fromLength(16);
            final encrypter = Encrypter(AES(key));
            final String data = encrypter.decrypt64(encryptedData, iv: iv);
            final parsedData = jsonDecode(data).cast<Map<String, dynamic>>();
            List<Question> questions = parsedData
                .map<Question>((item) => Question.fromJson(item))
                .toList();

            for (Question item in questions) {
              final int id = await _dbStore.add(db, item.toMap());
              print('Added $id');
            }
          }
        }
      },
    );
  }

  // Database helper methods:
  // INSERT
  Future<int> insert(Question question) async {
    Database db = await database;
    int id = await _dbStore.add(db, question.toMap());
    return id;
  }

  // DELETE
  Future<int> deleteByID(int id) async {
    Database db = await database;
    final finder = Finder(filter: Filter.byKey(id));
    return await _dbStore.delete(
      db,
      finder: finder,
    );
  }

  // UPDATE
  Future<int> update(Question question) async {
    Database db = await database;
    final finder = Finder(filter: Filter.byKey(question.id));
    return await _dbStore.update(
      db,
      question.toMap(),
      finder: finder,
    );
  }

  // QUERY by ID
  Future<Question> queryQuestionByID(int id) async {
    Database db = await database;
    final finder = Finder(filter: Filter.byKey(id));
    final recordSnapshot = await _dbStore.find(db, finder: finder);
    if (recordSnapshot.length > 0) {
      return Question.fromMap(
          recordSnapshot.first.key, recordSnapshot.first.value);
    }
    return null;
  }

  // QUERY ALL
  Future<List<Question>> queryALL() async {
    Database db = await database;
    final recordSnapshot = await _dbStore.find(db);
    if (recordSnapshot.length > 0) {
      return recordSnapshot.map((snapshot) {
        final question = Question.fromMap(snapshot.key, snapshot.value);
        return question;
      }).toList();
    }
    return null;
  }

  // QUERY random n questions
  Future<List<Question>> queryRandomNQuestions(int noOfQuestions) async {
    Database db = await database;
    // get all the questions
    final recordSnapshot = await _dbStore.find(db);
    final int length = recordSnapshot.length;
    if (length > 0) {
      // shuffle the recordSnapshot randomly
      recordSnapshot.shuffle();
      return recordSnapshot
          .sublist(0, (noOfQuestions <= length ? noOfQuestions : length))
          .map((snapshot) {
        final question = Question.fromMap(snapshot.key, snapshot.value);
        return question;
      }).toList();
    }

    return null;
  }
}
