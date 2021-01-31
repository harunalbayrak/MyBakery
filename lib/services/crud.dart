import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateFormat formatter2 = DateFormat.Hms();
  var uuid = Uuid();
  final employeesReference =
      FirebaseDatabase.instance.reference().child("bakeries").child('bakery').child('employees');

  final dailyDataReference =
      FirebaseDatabase.instance.reference().child("bakeries").child('bakery').child('dailyData');
  final marketsReference =
      FirebaseDatabase.instance.reference().child("bakeries").child('bakery').child('markets');

  final veresiyelerDataReference = FirebaseDatabase.instance
      .reference()
      .child("bakeries")
      .child('bakery')
      .child('veresiyeler');

  void addEmployee(Map data) {
    var v1 = uuid.v1();
    employeesReference.child(v1).set(data);
  }

  void addEkmek(String uid, Map data) {
    print(data.toString());
    var day = formatter.format(DateTime.now());
    dailyDataReference.child(day).child("producedBreads").child(uid).set(data);
  }

  void addExpense(String uid, Map data) {
    var day = formatter.format(DateTime.now());
    dailyDataReference.child(day).child("expenses").child(uid).set(data);
  }

  void addNote(String uid, Map data) {
    // print("inside addNote");
    // print("data: " + data.toString());
    // print("uid: " + uid);
    var day = formatter.format(DateTime.now());
    dailyDataReference.child(day).child("notes").child(uid).set(data);
  }

  void addVeresiye(String title, Map data) {
    print("inside addVeresiye");
    print("data: " + data.toString());
    veresiyelerDataReference.child(title).set(data);
  }

  void addTx(Map data) {
    var day = formatter.format(DateTime.now());
    var time = formatter2.format(DateTime.now());
    print(time);
    dailyDataReference.child(day).child("tx").child(time).set(data);
  }

  void updateEmployee(String uid, Map data) {
    employeesReference.child(uid).update(data);
  }

  void updateExpense(String uid, Map data) {
    var day = formatter.format(DateTime.now());
    dailyDataReference.child(day).child("expenses").child(uid).update(data);
  }

  void updateNote(String uid, Map data) {
    print("inside update note: " + data.toString());
    var day = formatter.format(DateTime.now());
    dailyDataReference.child(day).child("notes").child(uid).update(data);
  }

  void updateVeresiye(String title, Map data) {
    veresiyelerDataReference.child(title).update(data);
  }

  void deleteEmployee(String uid) {
    employeesReference.child(uid).remove();
  }

  void deleteEkmek(String uid) {
    var day = formatter.format(DateTime.now());
    dailyDataReference.child(day).child("producedBreads").child(uid).remove();
  }

  void deleteExpense(String uid) {
    var day = formatter.format(DateTime.now());
    dailyDataReference.child(day).child("expenses").child(uid).remove();
  }

  void deleteNote(String uid) {
    var day = formatter.format(DateTime.now());
    dailyDataReference.child(day).child("notes").child(uid).remove();
  }

  void deleteVeresiye(String title) {
    veresiyelerDataReference.child(title).remove();
  }
}
