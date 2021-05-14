import 'package:flutter/material.dart';
import 'package:sqlite_crud/models/student-model.dart';
import 'package:sqlite_crud/helpers/student_helper.dart';

class StudentPage extends StatefulWidget {
  final Student student;
  StudentPage({this.student});

  @override
  _StudentPageState createState() => new _StudentPageState(student);
}

class _StudentPageState extends State<StudentPage> {

  StudentHelper _studentHelper = new StudentHelper();
  Student _student;
  bool _isEditMode;
  TextEditingController nameController = TextEditingController();

  _StudentPageState(Student student) {
    if (student == null) {
      // CREATE Mode
      _isEditMode = false;
      _student = new Student(DateTime.now(), "");
    } else {
      // EDIT Mode
      _isEditMode = true;
      _student = student;
    }
  }

  Widget build(BuildContext context) {
    nameController.text = _student.name;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? "Update record ${_student.id}" : "Add Student"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _body(context)
      ),
    );
  }

  Widget _body(context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _name(context),
          _birthday(context),
          _commandsButtons(context)
        ]
    );
  }

  Widget _name(context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          TextField(
            controller: nameController,
            onChanged: (value) {
              _student.name = value;
            },
            decoration: InputDecoration(hintText: 'Student Name'),
          )
        ]
    );
  }

  Widget _birthday(context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
          children: [
            Expanded(
              child : Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                          color: Colors.green,
                          width: 1.0,
                        )
                    ),
                  ),
                  child: Text(
                    "${_student.birthday.year}-${_student.birthday.month}-${_student.birthday.day}",
                  )
              ),
            ),
            Container(width: 16.0),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Icon(Icons.calendar_today_outlined),
            ),
          ]
      ),
    );
  }

  Widget _commandsButtons(context) {
    return Padding(
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: Row(children: [
          _cancelButton(context),
          Container(width: 5.0,),
          _okButton(context)
        ]));
  }

  Widget _okButton(context) {
    return Expanded(
        child: ElevatedButton(
          onPressed: ()  async {
            if (_isEditMode) {
              _studentHelper.update(_student);
              Navigator.pop(context, true);
            } else {
              _studentHelper.create(_student);
              Navigator.pop(context, true);
            }
          },
          child: Text(_student.id == null ? 'Create' : 'Update'),
        ));
  }

  Widget _cancelButton(context) {
    return Expanded(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(primary: Colors.red),
          child: Text('Cancel'),
        ));
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _student.birthday, // Refer step 1
        firstDate: DateTime(1900),
        lastDate: DateTime(2025),
        initialDatePickerMode: DatePickerMode.year,
        helpText: "Birthday",
        confirmText: 'SELECT'
    );

    if (picked != null && picked != _student.birthday)
      setState(() {
        _student.birthday = picked;
      });
  }

}
