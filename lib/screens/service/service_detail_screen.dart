import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/service/service_models/urun_model.dart';
import 'package:flutter_my_bakery/shared/constants.dart';

class ServiceDetails extends StatefulWidget {
  final String servicename;
  ServiceDetails({Key key, this.servicename}) : super(key: key);

  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  List<Urun> urunList = [
    Urun(name: 'pogaca', price: 1),
    Urun(name: 'easaffaffjalafjkkjafaf', price: 1)
  ];
  Map<String, int> mainList = {};
  @override
  void initState() {
    super.initState();
    urunList.forEach((element) {
      mainList.putIfAbsent(element.name, () => 0);
    });
    mainList.forEach((key, value) {
      value = 0;
    });
  }

  void add(String name, int amount) {
    setState(() {
      mainList.update(name, (value) => value + amount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: new Text(widget.servicename),
      ),
      body: ListView.builder(
        itemCount: urunList.length,
        itemBuilder: (context, index) {
          return Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(urunList[index].name.length > 6
                      ? urunList[index].name.substring(0, 4) + '...'
                      : urunList[index].name),
                  Text(
                    mainList[urunList[index].name].toString(),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => {
                            _displayTextInputDialog(
                                context, urunList[index].name)
                          })
                ]),
          ));
        },
      ),
    );
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, String name) async {
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
                    log(_textFieldController.text);

                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      add(name, int.parse(_textFieldController.text));

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
