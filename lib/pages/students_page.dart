import 'package:flutter/material.dart';
import 'package:sqlite_crud/models/student-model.dart';
import 'package:sqlite_crud/helpers/student_helper.dart';

import 'student_page.dart';

class StudentsPage extends StatefulWidget {
  StudentsPage({Key key}) : super(key: key);

  @override
  _StudentsPage createState() => new _StudentsPage();
}

class _StudentsPage extends State<StudentsPage> {
  StudentHelper _studentHelper = new StudentHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SQLite CRUD"),
      ),
      body: Container(
          child: Column(children: <Widget>[
            Expanded(
              child: FutureBuilder<List>(
                  future: _studentHelper.read(),
                  initialData: [],
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? _studentsListViewBuilder(context, snapshot)
                        : _waiting();
                  }),
            ),
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => new StudentPage()))
              .then((value) => {setState(() {})});
        },
        tooltip: 'Add student',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _studentsListViewBuilder(context, snapshot) {
    return new ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: snapshot.data.length,
      itemBuilder: (context, i) {
        return _studentTile(snapshot.data[i]);
      },
    );
  }

  Widget _studentTile(Student student) {
    return Dismissible(
      secondaryBackground: Container(
        child: Center(
          child: Text(
            'Delete',
            style: TextStyle(color: Colors.white),
          ),
        ),
        color: Colors.red,
      ),
      background: Container(),
      key: UniqueKey(),
      onDismissed: (DismissDirection direction) async {
        await _studentHelper.delete(student.id);

        setState(() {});
      },
      child: ListTile(
          title: Text(student.name),
          subtitle: Text('${student.birthday.toString()}'),
          trailing: Icon(Icons.chevron_right_outlined),
          onTap: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    new StudentPage(student: student)))
                .then((value) => {
              setState(() {}
              )});
            //  Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => new PlantDetailPage(plant: plant)));
          }),
    );
  }

  Widget _waiting() {
    return Center(
      child: Text("No data..."),
    );
  }
}
