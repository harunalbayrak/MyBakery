import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/service/service_models/urun_model.dart';
import 'package:flutter_my_bakery/shared/constants.dart';

class UrunCard extends StatefulWidget {
  final Color color;
  Urun urun;
  UrunCard({Key key, @required urunName, double price = 0, this.color}) {
    urun = Urun(name: urunName, price: price);
  }

  @override
  _UrunCardState createState() => _UrunCardState();
}

class _UrunCardState extends State<UrunCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      margin: EdgeInsets.all(8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Text(widget.urun.name)),
            Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Text(widget.urun.price.toString() + " TL")),
            Container(
              alignment: Alignment.centerRight,
              width: MediaQuery.of(context).size.width / 5,
              child: InkWell(
                child: Icon(Icons.edit),
                onTap: () => editPrice(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  editPrice(BuildContext context) {
    _displayTextInputDialog(context);
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
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
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Card(
                      child: TextFormField(
                        decoration: textInputDecoration.copyWith(
                          hintText: "ürün adı",
                        ),
                        controller: _textFieldController
                          ..text = widget.urun.name,
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
                          ..text = widget.urun.price.toString(),
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
                      setState(() {
                        widget.urun.name = _textFieldController.text;
                        widget.urun.price =
                            double.parse(_textFieldController2.text);
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
