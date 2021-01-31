import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_bakery/screens/service/market_detail_screen.dart';
import 'package:flutter_my_bakery/screens/service/service_models/market_model.dart';
import 'package:flutter_my_bakery/screens/service/service_models/service_model.dart';
import 'package:flutter_my_bakery/screens/service/widgets/market_info.dart';
import 'package:flutter_my_bakery/services/databaseService.dart';

class Marketler extends StatefulWidget {
  final ServiceModel service;
  Marketler(this.service);

  @override
  _MarketlerState createState() => _MarketlerState();
}

class _MarketlerState extends State<Marketler> {
  Query _ref;
  @override
  void initState() {
    super.initState();
    _ref = DatabaseService('bakery').marketsReference.orderByChild('name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marketler'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _ref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map market = snapshot.value;
            var newMarket = Market(market: market, service: widget.service);
            return InkWell(
                child: MarketInfo(market: newMarket),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) {
                      return MarketDetail(
                        market: newMarket,
                      );
                    }),
                  );
                });
          },
        ),
      ),
    );
  }
}
