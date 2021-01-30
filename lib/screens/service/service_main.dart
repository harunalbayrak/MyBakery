import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_my_bakery/screens/service/marketler_screen.dart';
import 'package:flutter_my_bakery/screens/service/service_models/date_data.dart';
import 'package:flutter_my_bakery/screens/service/service_models/service_model.dart';
import 'package:flutter_my_bakery/services/databaseService.dart';

import 'info_card.dart';

class Service extends StatefulWidget {
  @override
  _ServiceState createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  bool loading = false;

  ServiceModel _service = ServiceModel();

  StreamSubscription<Event> updates;
  StreamSubscription<Event> up2;

  var _dayRef;
  void _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateData.currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime.now());

    if (pickedDate != null && pickedDate != DateData.currentDate) {
      DateData.currentDate = pickedDate;
      _service = ServiceModel();
      _service.local();
    }
  }

  @override
  initState() {
    _dayRef = _service.dayReference.limitToLast(50);
    var _debtRef = DatabaseService('bakery').bakeryRef.child('child');
    log(DateData.date);
    updates = _dayRef.onChildChanged.listen((data) {
      if (data != null) {
        log(data.snapshot.key);
        _service.updateByKey(data.snapshot.key, data.snapshot.value);
      }
      setState(() {});
    });
    up2 = _debtRef.onChildChanged.listen((data) {
      if (data != null) {
        _service.updateByKey('debt', data.snapshot.value);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _service.local(), // async work
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else
              return Scaffold(
                backgroundColor: Colors.deepPurpleAccent[10],
                appBar: AppBar(
                  title: Text(
                    "Ana Menü",
                    style: TextStyle(fontFamily: "Poppins"),
                  ),
                  backgroundColor: Colors.blueGrey,
                  centerTitle: true,
                ),
                body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/background2.jpg"),
                        fit: BoxFit.cover),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          child: RaisedButton(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  DateData.currentDate.day.toString() +
                                      '.' +
                                      DateData.currentDate.month.toString() +
                                      '.' +
                                      DateData.currentDate.year.toString(),
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colors.white),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            color: Colors.indigo,
                            onPressed: () async {
                              await _selectDate(context);
                              setState(() {});
                            },
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              //ilk satır
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                20,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                6,
                                        child: InfoCard(
                                          label: "ÜRÜN",
                                          info: _service.delivered.toString(),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                20,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                6,
                                        child: InfoCard(
                                          label: "ÖDEME",
                                          info: _service.taken.toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                20,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                6,
                                        child: InfoCard(
                                          label: "BAYAT",
                                          info: _service.bayat.toString(),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                20,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                6,
                                        child: InfoCard(
                                          label: "BORÇ",
                                          info: _service.debt.toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              20),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: RaisedButton(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: EdgeInsets.all(30),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "MARKETLER",
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Icon(
                                            Icons.shopping_basket,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                15,
                                          )
                                        ],
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) {
                                              return Marketler(_service);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 20,
                                    width:
                                        MediaQuery.of(context).size.width / 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
        }
      },
    );
  }

  @override
  void dispose() {
    updates.cancel();
    up2.cancel();
    super.dispose();
  }
}
