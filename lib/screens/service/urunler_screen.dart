import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/service/service_models/market_model.dart';
import 'package:flutter_my_bakery/screens/service/widgets/urun_card.dart';
import 'package:flutter_my_bakery/shared/constants.dart';
import 'package:multi_select_item/multi_select_item.dart';

main(List<String> args) {
  runApp(UrunScreen());
}

class UrunScreen extends StatefulWidget {
  final Market market;

  const UrunScreen({Key key, this.market}) : super(key: key);
  @override
  _UrunScreen createState() => _UrunScreen();
}

class _UrunScreen extends State<UrunScreen> {
  var productRef;
  Query _ref;
  List<String> _urunList = [];
  MultiSelectController controller = new MultiSelectController();
  @override
  void initState() {
    super.initState();
    productRef = widget.market.marketReference.child('products');
    _ref = productRef.orderByChild('name');

    log(productRef.toString());
  }

  void add(String name, double price) {
    productRef.child(name).set({'name': name, 'price': price});
  }

  void delete() {
    var list = controller.selectedIndexes;
    log('l: ' + controller.isSelecting.toString());
    log(_urunList.toString());
    list.sort((b, a) =>
        a.compareTo(b)); //reoder from biggest number, so it wont error
    list.forEach((index) {
      productRef.child(_urunList[index]).remove();
    });
    list.forEach((index) {
      _urunList.removeAt(index);
    });
  }

  void selectAll() {
    log(controller.listLength.toString());
    setState(() {
      controller.toggleAll();
    });
  }

  void select(index) {
    controller.toggle(index);
  }

  Future<void> _addProduct(BuildContext context) async {
    TextEditingController _textFieldController = new TextEditingController();
    TextEditingController _textFieldController2 = new TextEditingController();
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Card(
                      child: TextFormField(
                        decoration: textInputDecoration.copyWith(
                          hintText: "ürün adı",
                        ),
                        controller: _textFieldController,
                        keyboardType: TextInputType.name,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Card(
                      child: TextFormField(
                        decoration: textInputDecoration.copyWith(
                          hintText: "fiyat",
                        ),
                        controller: _textFieldController2,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: RaisedButton(
                  child: Text("Ekle"),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      add(_textFieldController.text,
                          double.parse(_textFieldController2.text));
                      _textFieldController.clear();
                      _textFieldController2.clear();

                      Navigator.pop(context); // Close the add todo screen
                    }
                  },
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _urunList = [];

    return WillPopScope(
      onWillPop: () async {
        //block app from quitting when selecting
        var before = !controller.isSelecting;
        setState(() {
          controller.deselectAll();
        });
        return before;
      },
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.blueGrey,
          title: new Text('Urunler'),
          centerTitle: true,
          actions: (controller.isSelecting)
              ? <Widget>[
                  IconButton(
                    icon: Icon(Icons.select_all),
                    onPressed: selectAll,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: delete,
                  )
                ]
              : <Widget>[],
        ),
        body: FirebaseAnimatedList(
          query: _ref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map product = snapshot.value;
            _urunList.add(product['name']);
            log(controller.listLength.toString());
            return MultiSelectItem(
              isSelecting: controller.isSelecting,
              onSelected: () {
                setState(() {
                  log('index: ' + index.toString());
                  select(index);
                  log(controller.isSelected(index).toString());
                });
              },
              child: Container(
                child: UrunCard(
                  name: product['name'],
                  price: product['price'].toDouble(),
                  color: controller.isSelected(index)
                      ? Colors.grey[300]
                      : Colors.white,
                  editFunction: editProduct,
                ),
              ),
            );
          },
        ),
        floatingActionButton: new FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => {_addProduct(context)},
          tooltip: 'Increment',
          child: new Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> editProduct(String name, double price) async {
    TextEditingController _textFieldController = new TextEditingController();
    TextEditingController _textFieldController2 = new TextEditingController();
    final _formKey = GlobalKey<FormState>();
    var oldName = name;
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Card(
                      child: TextFormField(
                        decoration: textInputDecoration.copyWith(
                          hintText: "ürün adı",
                        ),
                        controller: _textFieldController..text = name,
                        keyboardType: TextInputType.name,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Card(
                      child: TextFormField(
                        decoration: textInputDecoration.copyWith(
                          hintText: "fiyat",
                        ),
                        controller: _textFieldController2
                          ..text = price.toString(),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: RaisedButton(
                  child: Text("Değiştir"),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      productRef.child(oldName).remove();
                      productRef.child(_textFieldController.text).set({
                        'name': _textFieldController.text,
                        'price': double.parse(_textFieldController2.text)
                      });
                      _textFieldController.clear();
                      _textFieldController2.clear();
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
