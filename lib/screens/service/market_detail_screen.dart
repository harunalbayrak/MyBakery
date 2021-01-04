import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_my_bakery/screens/service/info_card.dart';
import 'package:flutter_my_bakery/screens/service/widgets/service_card.dart';
import 'package:flutter_my_bakery/screens/service/urunler_screen.dart';
import 'package:flutter_my_bakery/shared/constants.dart';
import 'package:intl/intl.dart';

class MarketDetail extends StatefulWidget {
  final String marketName;

  MarketDetail({Key key, @required this.marketName}) : super(key: key);

  @override
  _MarketDetailState createState() => _MarketDetailState();
}

class _MarketDetailState extends State<MarketDetail> {
  double borc = 0;
  double odeme = 0;
  int bayat = 0;

  int ekmek = 0;
  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("dd.MM.yyyy");

    String currentTime = dateFormat.format(DateTime.now());

    DateTime minTime = DateTime(2018, 12, 5);

    DateTime maxTime = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.marketName),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(6),
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      child: Container(
                        child: RaisedButton(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                currentTime,
                                style: TextStyle(
                                    fontFamily: "Poppins", color: Colors.white),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          color: Colors.amber,
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: minTime,
                                maxTime: maxTime, onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                              print('confirm $date');
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.tr);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.height * .2,
                      child: InfoCard(
                        label: "ÖDENEN",
                        info: odeme.toString(),
                        fontSize: 24,
                        icon: Icon(Icons.attach_money),
                        onTap: () => newPage(context, "tutar"),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.height * .2,
                      child: InfoCard(
                        label: "EKMEK",
                        info: ekmek.toString(),
                        fontSize: 24,
                        icon: Icon(Icons.bakery_dining),
                        onTap: () => newPage(context, "ekmek"),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.height * .2,
                      child: InfoCard(
                        label: "BAYAT",
                        info: bayat.toString(),
                        fontSize: 24,
                        icon: Icon(Icons.assignment_return),
                        onTap: () => newPage(context, "bayat"),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.height * .2,
                      child: InfoCard(
                        label: "DİĞER",
                        fontSize: 24,
                        icon: Icon(Icons.inventory),
                        onTap: () => newPage(context, "urunler"),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Column(
              children: [
                ServiceCard(
                  index: 1,
                ),
                ServiceCard(
                  index: 2,
                ),
                ServiceCard(
                  index: 3,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void pay(double amount) {
    setState(() {
      borc -= amount;
      odeme += amount;
    });
  }

  void add_bayat(int amount) {
    setState(() {
      bayat += amount;
    });
  }

  void add_ekmek(int amount) {
    setState(() {
      ekmek += amount;
    });
  }

  Future<void> _displayTextInputDialog(BuildContext context, String op) async {
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
                      hintText: "miktar",
                    ),
                    controller: _textFieldController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: RaisedButton(
                  child: op == "ödeme" ? Text("Öde") : Text("ekle"),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      switch (op) {
                        case "ödeme":
                          pay(double.parse(_textFieldController.text));
                          break;
                        case "bayat":
                          add_bayat(int.parse(_textFieldController.text));
                          break;
                        case "ekmek":
                          add_ekmek(int.parse(_textFieldController.text));
                          break;
                        default:
                      }
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

  void newPage(BuildContext context, String page) {
    switch (page) {
      case "urunler":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UrunScreen()));
        break;
      case "tutar":
        _displayTextInputDialog(context, "ödeme");
        break;
      case "ekmek":
        _displayTextInputDialog(context, "ekmek");
        break;
      case "bayat":
        _displayTextInputDialog(context, "bayat");
        break;
      default:
    }
  }
}
