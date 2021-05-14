class Student {

  static const String TABLE = 'Students';
  static const String COL_ID = 'Id';
  static const String COL_NAME = 'Name';
  static const String COL_BIRTHDAY = 'Birthday';

  // Structure
  int _id;
  String _name;
  DateTime _birthday;

  // Constructor
  Student(
    this._birthday,
    this._name,
  );

  // Getters
  int get id => _id;
  String get name => _name;
  DateTime get birthday => _birthday;

  // Setters
  set name(String name) => {this._name = name};
  set birthday(DateTime birthday) => {this._birthday = birthday};

  // Map
  Student.fromMap(dynamic obj) {
    this._id = obj[COL_ID];
    this._name = obj[COL_NAME];
    this._birthday = DateTime.parse(obj[COL_BIRTHDAY]);
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[COL_ID] = _id;
    map[COL_NAME] = _name;
    map[COL_BIRTHDAY] = _birthday.toIso8601String();
    return map;
  }
}