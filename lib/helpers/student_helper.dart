import 'package:sqlite_crud/models/student-model.dart';
import 'database_helper.dart';

class StudentHelper {

  DatabaseHelper databaseHelper = new DatabaseHelper();

  Future<void> create(Student student) async {
    final db = await databaseHelper.database;
    await db.insert(
        Student.TABLE,
        student.toMap()
    );
  }

  Future<List<Student>> read() async {
    final db = await databaseHelper.database;
    var objects = await db.rawQuery('SELECT * FROM ${Student.TABLE} '
        'ORDER BY ${Student.COL_NAME} COLLATE NOCASE'
    );

    List<Student> students =
    objects.isNotEmpty
        ? objects.map((obj) => Student.fromMap(obj)).toList()
        : null;
    return students;
  }

  Future<void> update(Student student) async {
    final db = await databaseHelper.database;
    await db.update(
        Student.TABLE,
        student.toMap(),
        where: '${Student.COL_ID} = ?',
        whereArgs: [student.id]
    );
  }

  Future<void> delete(int id) async {
    var db = await databaseHelper.database;
    db.delete(
      Student.TABLE,
      where: "${Student.COL_ID} = ?",
      whereArgs: [id],
    );
  }

}