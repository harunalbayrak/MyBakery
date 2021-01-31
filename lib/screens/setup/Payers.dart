import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/home/bottom_bar_state.dart';
import '../../models/Payer.dart';
import '../../widgets/NewPayer.dart';
import 'package:flutter_my_bakery/services/databaseService.dart';

class Payers extends StatefulWidget {
  final List<Payer> list;
  final String bakeryName;
  Payers({this.list, this.bakeryName});
  @override
  _PayersState createState() => _PayersState(list, bakeryName);
}

class _PayersState extends State<Payers> {
  String bakeryName;
  DatabaseService sv;
  List<Payer> payerList = [];
  void _addNewPayer(String prName, double prAmount) {
    final newPayer = Payer(name: prName, debt: prAmount);
    setState(() {
      sv.addPayer(newPayer);
      payerList.add(newPayer);
    });
  }

  _PayersState(List<Payer> payers, String bakery) {
    payerList = payers;
    bakeryName = bakery;
    sv = DatabaseService(bakery);
  }

  void _startAddNewpayer(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewPayer(_addNewPayer),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void deletePayer(String name) {
    setState(() {
      sv.deletePayer(name);
      payerList.removeWhere((pr) => pr.name == name);
    });
  }

  void nextPage(BuildContext cx) {
    Navigator.of(cx).push(
      MaterialPageRoute(
        builder: (_) {
          return Scaffold();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () => _startAddNewpayer(context))
        ],
        backgroundColor: Colors.blueGrey,
        title: Text("Veresiyeler"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.80,
              child: ListView.builder(
                itemCount: payerList.length,
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
                              payerList[index].name,
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          Container(
                            child: Text(
                              payerList[index].debt.toStringAsFixed(2) + " ₺",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  deletePayer(payerList[index].name))
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
        // ignore: deprecated_member_use_from_same_package
        onPressed: () {
          sv.registerWorkers();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BottomBarState()),
          );
        },
      ),
    );
  }
}
