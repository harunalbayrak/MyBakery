import 'package:uuid/uuid.dart';

class NotesModel {
  String id = Uuid().v1();
  String title;
  String content;
  bool isImportant;
  DateTime date;

  NotesModel({this.id, this.title, this.content, this.isImportant, this.date});
  NotesModel.withID(
      this.title, this.content, this.isImportant, this.date, this.id);
  NotesModel.fromMap(Map<String, dynamic> map) {
    this.id = map['_id'];
    this.title = map['title'];
    this.content = map['content'];
    this.date = DateTime.parse(map['date']);
    this.isImportant = map['isImportant'] == 1 ? true : false;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': this.id,
      'title': this.title,
      'content': this.content,
      'isImportant': this.isImportant == true ? 1 : 0,
      'date': this.date.toIso8601String()
    };
  }
}

class ExpensesModel {
  String id = Uuid().v1();
  String title;
  String content;
  DateTime date;

  ExpensesModel({this.title, this.content, this.date});
  ExpensesModel.withID(this.title, this.content, this.date, this.id);

  ExpensesModel.fromMap(Map<String, dynamic> map) {
    this.id = map['_id'];
    this.title = map['title'];
    this.content = map['content'];
    this.date = DateTime.parse(map['date']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': this.id,
      'title': this.title,
      'content': this.content,
      'date': this.date.toIso8601String()
    };
  }
}

class EkmekModel {
  String id = Uuid().v1();
  String amount;
  String time;
  EkmekModel({this.amount, this.time});
  EkmekModel.withID(this.amount, this.time, this.id);

  EkmekModel.fromMap(Map<dynamic, dynamic> map) {
    this.id = map['_id'];
    this.amount = map['amount'];
    this.time = map['time'];
  }

  Map<String, String> toMap() {
    return <String, String>{
      '_id': this.id,
      'title': this.amount,
      'time': this.time,
    };
  }
}

class VeresiyeModel {
  // int id;
  String title;
  String content;
  DateTime date;

  VeresiyeModel({this.title, this.content, this.date});
  VeresiyeModel.withID(this.title, this.content, this.date);

  VeresiyeModel.fromMap(Map<String, dynamic> map) {
    // this.id = map['_id'];
    this.title = map['title'];
    this.content = map['content'];
    this.date = DateTime.parse(map['date']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': this.title,
      'content': this.content,
      'date': this.date.toIso8601String()
    };
  }
}
