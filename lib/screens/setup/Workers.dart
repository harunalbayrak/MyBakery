import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/models/Market.dart';
import 'package:flutter_my_bakery/models/Worker.dart';
import 'package:flutter_my_bakery/screens/setup/Markets.dart';
import 'package:flutter_my_bakery/services/databaseService.dart';
import '../../widgets/NewWorker.dart';

class Workers extends StatefulWidget {
  final List<Worker> list;
  Workers({this.list});
  @override
  _WorkersState createState() => _WorkersState(workerList: list);
}

class _WorkersState extends State<Workers> {
  List<Worker> workerList = [];
  DatabaseService sv = DatabaseService();
  void _addNewWorker(String workerName, String workerMail, String gorevi) {
    int passwd = 0;
    for (var i = 0; i < 6; i++) {
      passwd = passwd + ((Random().nextInt(8) + 1) * pow(10, i));
    }

    final newWorker = Worker(
      name: workerName,
      mail: workerMail,
      job: gorevi,
      password: passwd.toString(),
    );
    setState(() {
      sv.addWorker(newWorker);
      workerList.add(newWorker);
    });
  }

  _WorkersState({this.workerList});

  void _startAddNewWorker(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewWorker(_addNewWorker),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void deleteWorker(String name) {
    setState(() {
      sv.deleteWorker(name);
      workerList.removeWhere((wr) => wr.name == name);
    });
  }

  final List<Market> marketList = [];

  void nextPage(BuildContext cx) {
    Navigator.of(cx).push(
      MaterialPageRoute(
        builder: (_) {
          return Markets(list: marketList);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () => _startAddNewWorker(context))
        ],
        title: Text("Çalışanlar"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.80,
              child: ListView.builder(
                itemCount: workerList.length,
                padding: EdgeInsets.only(top: 10),
                itemBuilder: (ctx, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      elevation: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 7),
                            child: Text(
                              workerList[index].name,
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          Container(
                            child: Text(
                              workerList[index].job,
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  deleteWorker(workerList[index].name))
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.done),
        onPressed: () => nextPage(context),
      ),
    );
  }
}
