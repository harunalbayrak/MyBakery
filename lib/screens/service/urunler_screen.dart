import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/service/service_models/urun_model.dart';
import 'package:flutter_my_bakery/screens/service/widgets/urun_card.dart';
import 'package:flutter_my_bakery/shared/constants.dart';
import 'package:multi_select_item/multi_select_item.dart';

main(List<String> args) {
  runApp(UrunScreen());
}

class UrunScreen extends StatefulWidget {
  @override
  _UrunScreen createState() => _UrunScreen();
}

class _UrunScreen extends State<UrunScreen> {
  List<Urun> _urunList = [];

  List<Urun> get mainList => _urunList;

  MultiSelectController controller = new MultiSelectController();

  void add(String name, double price) {
    setState(() {
      mainList.add(Urun(name: name, price: price));
      controller.set(mainList.length);
    });
  }

  void delete() {
    var list = controller.selectedIndexes;
    list.sort((b, a) =>
        a.compareTo(b)); //reoder from biggest number, so it wont error
    list.forEach((element) {
      mainList.removeAt(element);
    });

    setState(() {
      controller.set(mainList.length);
    });
  }

  void selectAll() {
    setState(() {
      controller.toggleAll();
    });
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
        body: ListView.builder(
          itemCount: mainList.length,
          itemBuilder: (context, index) {
            return MultiSelectItem(
              isSelecting: controller.isSelecting,
              onSelected: () {
                setState(() {
                  controller.toggle(index);
                });
              },
              child: Container(
                child: UrunCard(
                  urunName: mainList[index].name,
                  price: mainList[index].price,
                  color: controller.isSelected(index)
                      ? Colors.grey[300]
                      : Colors.white,
                ),
              ),
            );
          },
        ),
        floatingActionButton: new FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => {_displayTextInputDialog(context)},
          tooltip: 'Increment',
          child: new Icon(Icons.add),
        ),
      ),
    );
  }
}
