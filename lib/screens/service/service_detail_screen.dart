import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/service/service_models/date_data.dart';
import 'package:flutter_my_bakery/screens/service/service_models/market_model.dart';
import 'package:flutter_my_bakery/shared/constants.dart';

class ServiceDetails extends StatefulWidget {
  final int id;
  final Market market;
  ServiceDetails({Key key, this.id, this.market}) : super(key: key);

  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  Map products;
  Query _ref;
  var serviceRef;

  @override
  void initState() {
    super.initState();
    serviceRef = widget.market.marketReference
        .child('dailyData')
        .child(DateData.date)
        .child('service-' + widget.id.toString());
    _ref = serviceRef.orderByChild('name');

    loadData().whenComplete(() => {
          products.forEach((key, value) async {
            bool check =
                await rootFirebaseIsExists(serviceRef.child(value['name']));
            if (check) {
              serviceRef
                  .child(value['name'])
                  .update({'name': value['name'], 'price': value['price']});
            } else {
              serviceRef
                  .child(value['name'])
                  .update({'name': value['name'], 'price': value['price']});
            }
          })
        });
  }

  Future<bool> rootFirebaseIsExists(DatabaseReference databaseReference) async {
    DataSnapshot snapshot = await databaseReference.once();

    return snapshot != null;
  }

  Future<void> loadData() async {
    DataSnapshot snapshot =
        await widget.market.marketReference.child('products').once();

    products = snapshot.value;
  }

  void add(String name, int amount, double price) {
    setState(() {
      widget.market.addEkmek(amount);
      serviceRef.child(name).update({'amount': amount.toString()});
      widget.market.addDebt(amount * price);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: new Text(widget.id.toString()),
      ),
      body: FirebaseAnimatedList(
        query: _ref,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map product = snapshot.value;

          return Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(product['name']),
                  Text(
                    product['amount'] != null ? product['amount'] : '0',
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () =>
                          {_displayTextInputDialog(context, product)})
                ]),
          ));
        },
      ),
    );
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, Map product) async {
    TextEditingController _textFieldController = new TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24.0))),
            contentPadding: EdgeInsets.all(10),
            content: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(
                      hintText: "adet",
                    ),
                    controller: _textFieldController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: RaisedButton(
                  child: Text("ekle"),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      add(
                          product['name'],
                          int.parse(_textFieldController.text) +
                              (product['amount'] != null
                                  ? int.parse(product['amount'])
                                  : 0),
                          product['price'].toDouble());

                      _textFieldController.clear();
                      Navigator.pop(context); // Close the add todo screen
                    }
                  },
                ),
              ),
            ],
          );
        });
  }
}
