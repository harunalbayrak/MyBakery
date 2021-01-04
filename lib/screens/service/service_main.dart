import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_my_bakery/screens/service/marketler_screen.dart';
import 'package:flutter_my_bakery/screens/service/service_models/service_model.dart';
import 'package:intl/intl.dart';

import 'info_card.dart';

class Service extends StatefulWidget {
  @override
  _ServiceState createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  ServiceModel _service = ServiceModel();

  DateFormat dateFormat = DateFormat("dd-MM-yyyy");

  DateTime currentDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime.now());

    if (pickedDate != null && pickedDate != currentDate) {
      currentDate = pickedDate;

      await _service.updateLocal(dateFormat.format(currentDate));
    }
  }

  @override
  initState() {
    _service.updateLocal(dateFormat.format(currentDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        currentDate.day.toString() +
                            '.' +
                            currentDate.month.toString() +
                            '.' +
                            currentDate.year.toString(),
                        style: TextStyle(
                            fontFamily: "Poppins", color: Colors.white),
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              height: MediaQuery.of(context).size.height / 6,
                              child: InfoCard(
                                label: "ÜRÜN",
                                info: _service.delivered.toString(),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              height: MediaQuery.of(context).size.height / 6,
                              child: InfoCard(
                                label: "ÖDEME",
                                info: _service.taken.toString(),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              height: MediaQuery.of(context).size.height / 6,
                              child: InfoCard(
                                label: "BAYAT",
                                info: _service.bayat.toString(),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              height: MediaQuery.of(context).size.height / 6,
                              child: InfoCard(
                                label: "BORÇ",
                                info: _service.borc.toString(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 20),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: RaisedButton(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  size: MediaQuery.of(context).size.height / 15,
                                )
                              ],
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) {
                                    return Marketler();
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 20,
                          width: MediaQuery.of(context).size.width / 20,
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
}
