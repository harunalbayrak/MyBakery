import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_my_bakery/shared/faderoute.dart';
import 'package:flutter_my_bakery/models/models.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/edit.dart';
import 'package:flutter_my_bakery/screens/tezgahtar/view.dart';
import 'package:flutter_my_bakery/shared/cards.dart';
import 'package:flutter_my_bakery/services/crud.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class Expense extends StatefulWidget {
  Expense({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ExpenseState createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  bool headerShouldHide = false;
  List<ExpensesModel> expensesList = [];
  TextEditingController searchController = TextEditingController();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  DatabaseService service = DatabaseService();

  @override
  void initState() {
    super.initState();
    setExpensesFromDB();
  }

  setExpensesFromDB() async {
    expensesList.clear();
    print("Entered setExpenses");
    // var fetchedExpenses = await NotesDatabaseService.db.getExpensesFromDB();
    // setState(() {
    //   expensesList = fetchedExpenses;
    // });
    service.dailyDataReference
        .child(formatter.format(DateTime.now()))
        .child("expenses")
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> map = snapshot.value;
      if (map != null) {
        map.forEach((key, values) {
          print(values);
          print("data: " +
              values["title"] +
              "--------------------------------------");
          setState(() {
            expensesList.add(ExpensesModel.withID(
                values["title"],
                values["content"],
                DateTime.parse(values["date"]),
                values["_id"]));
          });
        });
      } else {
        setState(() {
          expensesList.clear();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gider Gir",
          style: TextStyle(fontFamily: "Poppins"),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          gotoEditExpense();
        },
        label: Text('Gider Ekle'.toUpperCase()),
        icon: Icon(Icons.add),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Container(height: 32),
              ...buildExpenseComponentsList(),
            ],
          ),
          margin: EdgeInsets.only(top: 2),
          padding: EdgeInsets.only(left: 15, right: 15),
        ),
      ),
    );
  }

  List<Widget> buildExpenseComponentsList() {
    List<Widget> expenseComponentsList = [];
    expensesList.sort((a, b) {
      return b.date.compareTo(a.date);
    });
    expensesList.forEach((note) {
      expenseComponentsList.add(ExpenseCardComponent(
        expenseData: note,
        onTapAction: openExpenseToRead,
      ));
    });
    return expenseComponentsList;
  }

  void gotoEditExpense() {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                EditExpensePage(triggerRefetch: refetchExpensesFromDB)));
  }

  void refetchExpensesFromDB() async {
    await setExpensesFromDB();
    print("Refetched notes");
  }

  openExpenseToRead(ExpensesModel expenseData) async {
    setState(() {
      headerShouldHide = true;
    });
    await Future.delayed(Duration(milliseconds: 230), () {});
    Navigator.push(
        context,
        FadeRoute(
            page: ViewExpensePage(
                triggerRefetch: refetchExpensesFromDB,
                currentExpense: expenseData)));
    await Future.delayed(Duration(milliseconds: 300), () {});
    await setExpensesFromDB();
    setState(() {
      headerShouldHide = false;
    });
  }
}
