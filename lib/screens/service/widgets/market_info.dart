import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/service/market_detail_screen.dart';

class MarketInfo extends StatefulWidget {
  final String marketName;
  final int borc;
  final int toplam;

  MarketInfo(
      {Key key, @required this.marketName, this.borc = 0, this.toplam = 0})
      : super(key: key);

  @override
  _MarketInfoState createState() => _MarketInfoState();
}

class _MarketInfoState extends State<MarketInfo> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MarketDetail(
                marketName: widget.marketName,
              ),
            ));
      },
      child: Card(
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
                widget.marketName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "BORÇ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      widget.borc.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "TOPLAM",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      widget.toplam.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
