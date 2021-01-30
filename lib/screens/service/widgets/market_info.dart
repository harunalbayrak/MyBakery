import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/service/market_detail_screen.dart';
import 'package:flutter_my_bakery/screens/service/service_models/market_model.dart';

class MarketInfo extends StatefulWidget {
  final Market market;

  MarketInfo({Key key, this.market}) : super(key: key);

  @override
  _MarketInfoState createState() => _MarketInfoState();
}

class _MarketInfoState extends State<MarketInfo> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(6),
      elevation: 6,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Text(
              widget.market.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "BORÇ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    widget.market.debt.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "TOPLAM",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    widget.market.delivered.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
