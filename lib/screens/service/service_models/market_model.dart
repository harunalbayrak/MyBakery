import 'dart:developer';

import 'package:flutter_my_bakery/screens/service/service_models/date_data.dart';
import 'package:flutter_my_bakery/screens/service/service_models/service_model.dart';
import 'package:flutter_my_bakery/screens/service/service_models/urun_model.dart';
import 'package:flutter_my_bakery/services/databaseService.dart';

class Market {
  String name;
  List<Urun> urunler = [];
  double debt = 0;
  double taken = 0.0;
  int bayat = 0;
  int delivered = 0;
  double totalDebt = 0;
  int totalTaken = 0;
  ServiceModel service;

  var marketReference;
  Market({Map market, this.service}) {
    name = market["name"] != null ? market["name"] : "";
    debt = market["debt"] != null ? double.parse(market["debt"]) : 0;
    var day =
        market['dailyData'] != null ? market['dailyData'][DateData.date] : null;

    if (day != null) {
      taken = day["taken"] != null ? double.parse(day["taken"]) : 0;
      delivered = day["delivered"] != null ? int.parse(day["delivered"]) : 0;
      bayat = day["bayat"] != null ? int.parse(day["bayat"]) : 0;
    } else {
      taken = 0;
      delivered = 0;
      bayat = 0;
    }

    marketReference = DatabaseService('bakery').marketsReference.child(name);
  }

  void pay(double amount) {
    taken += amount;
    debt -= amount;
    service.addTaken(amount);
    service.addDebt(-amount);
    updateDb();
  }

  void addDebt(double amount) {
    debt += amount;
    service.addDebt(amount);
    updateDb();
  }

  void addBayat(int amount) {
    bayat += amount;
    service.addBayat(amount);
    updateDb();
  }

  void addEkmek(int amount) {
    log(amount.toString());
    delivered += amount;
    service.addDelived(amount);

    updateDb();
  }

  Future<void> updateDb() async {
    final dayReference =
        marketReference.child('dailyData').child(DateData.date);
    // final globalDayReference = DatabaseService.dailyDataReference.child(DateData.date);
    marketReference.update({'name': name, 'debt': debt.toString()});
    dayReference.update({
      'delivered': delivered.toString(),
      'bayat': bayat.toString(),
      'taken': taken.toString(),
    });
  }

  @override
  String toString() {
    // TODO: implement toString
    return name + ' ' + debt.toString();
  }
}
