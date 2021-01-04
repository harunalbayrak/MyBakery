import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/models/Market.dart';
import 'package:flutter_my_bakery/models/Payer.dart';
import 'package:flutter_my_bakery/widgets/NewMarket.dart';
import 'package:flutter_my_bakery/services/databaseService.dart';
import 'Payers.dart';

class Markets extends StatefulWidget {
  final List<Market> list;
  Markets({this.list});
  @override
  _MarketsState createState() => _MarketsState(marketList: list);
}

class _MarketsState extends State<Markets> {
  DatabaseService sv = DatabaseService();
  List<Market> marketList = [];
  void _addNewMarket(String prName, double prAmount) {
    final newMarket = Market(name: prName, debt: prAmount);
    setState(() {
      sv.addMarket(newMarket);
      marketList.add(newMarket);
    });
  }

  _MarketsState({this.marketList});

  void _startAddNewMarket(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewMarket(_addNewMarket),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void deleteMarket(String name) {
    setState(() {
      sv.deleteMarket(name);
      marketList.removeWhere((pr) => pr.name == name);
    });
  }

  final List<Payer> payerList = [];

  void nextPage(BuildContext cx) {
    Navigator.of(cx).push(
      MaterialPageRoute(
        builder: (_) {
          return Payers(list: payerList);
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
              onPressed: () => _startAddNewMarket(context))
        ],
        backgroundColor: Colors.blueGrey,
        title: Text("Marketler"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.80,
              child: ListView.builder(
                itemCount: marketList.length,
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
                              marketList[index].name,
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          Container(
                            child: Text(
                              marketList[index].debt.toStringAsFixed(2) + " ₺",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  deleteMarket(marketList[index].name))
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.done),
        onPressed: () => nextPage(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
