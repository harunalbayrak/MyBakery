import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_my_bakery/screens/service/service_models/market_model.dart';
import 'package:flutter_my_bakery/screens/service/widgets/market_info.dart';
import 'package:intl/intl.dart';

void main() => runApp(Marketler());

class Marketler extends StatefulWidget {
  @override
  _MarketlerState createState() => _MarketlerState();
}

class _MarketlerState extends State<Marketler> {
  List<Market> marketList = [];

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("dd.MM.yyyy");

    String currentTime = dateFormat.format(DateTime.now());

    DateTime minTime = DateTime(2018, 12, 5);

    DateTime maxTime = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text('Marketler'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            datePicker(context, currentTime, minTime, maxTime),
            MarketInfo(marketName: "BIM"),
            MarketInfo(marketName: "A101"),
            MarketInfo(marketName: "MIGROS"),
            MarketInfo(marketName: "AKMAR"),
            MarketInfo(marketName: "BIM"),
            MarketInfo(marketName: "A101"),
            MarketInfo(marketName: "MIGROS"),
            MarketInfo(marketName: "AKMAR"),
            MarketInfo(marketName: "BIM"),
            MarketInfo(marketName: "A101"),
            MarketInfo(marketName: "MIGROS"),
            MarketInfo(marketName: "AKMAR"),
            MarketInfo(marketName: "BIM"),
            MarketInfo(marketName: "A101"),
            MarketInfo(marketName: "MIGROS"),
            MarketInfo(marketName: "AKMAR"),
          ],
        ),
      ),
    );
  }

  Center datePicker(BuildContext context, String currentTime, DateTime minTime,
      DateTime maxTime) {
    return Center(
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
                  color: Colors.purple[10],
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: minTime,
                        maxTime: maxTime, onChanged: (date) {
                      print('change $date');
                    }, onConfirm: (date) {
                      print('confirm $date');
                    }, currentTime: DateTime.now(), locale: LocaleType.tr);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
