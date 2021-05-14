import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlite_crud/models/student-model.dart';

class DatabaseHelper {

  static const DB_FILE_NAME = 'sqlite_crud.db';
  static const DB_CURRENT_VERSION = 1;
  static DatabaseHelper _databaseHelper = new DatabaseHelper.internal();
  static Database _database;

  DatabaseHelper.internal();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper.internal();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory applicationDocumentDirectory =
    await getApplicationDocumentsDirectory();

    String path =
    join(applicationDocumentDirectory.path, DB_FILE_NAME);

    var todosDatabase = await openDatabase(
        path,
        version: DB_CURRENT_VERSION,
        onCreate: _createDb);
    return todosDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE ${Student.TABLE} ( '
        '${Student.COL_ID} INTEGER PRIMARY KEY AUTOINCREMENT, '
        '${Student.COL_NAME} TEXT, '
        '${Student.COL_BIRTHDAY} TEXT)'
    );
  }
}