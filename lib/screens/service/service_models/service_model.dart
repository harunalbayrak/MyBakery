import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_my_bakery/services/databaseService.dart';

import 'date_data.dart';

class ServiceModel {
  int bayat = 0;
  double debt = 0;
  int delivered = 0;
  double taken = 0;
  var dayReference;
  ServiceModel() {
    dayReference =
        DatabaseService('bakery').dailyDataReference.child(DateData.date);
  }
  void updateByKey(String key, String value) {
    switch (key) {
      case 'bayat':
        bayat = int.parse(value);
        break;
      case 'debt':
        debt = double.parse(value);
        break;
      case 'delivered':
        delivered = int.parse(value);
        break;
      case 'taken':
        taken = double.parse(value);
        break;
      default:
    }
  }

  Future<String> local() async {
    String d;

    DataSnapshot snapshot = await DatabaseService('bakery').bakeryRef.once();
    var day = snapshot.value['dailyData'][DateData.date];
    if (day != null) {
      bayat = day['bayat'] != null ? int.parse(day['bayat']) : 0;
      delivered = day['delivered'] != null ? int.parse(day['delivered']) : 0;
      taken =
          snapshot.value['taken'] != null ? double.parse(day['taken']) : 0.0;
    }
    if (snapshot.value != null) {
      debt = double.parse(snapshot.value['debt']);
      log(debt.toString());

      d = 'd';
    }

    return d;
  }

  addBayat(int amount) {
    bayat += amount;
    updateDb();
  }

  addDelived(int amount) {
    delivered += amount;
    updateDb();
  }

  addDebt(double amount) {
    debt += amount;
    updateDb();
  }

  addTaken(double amount) {
    taken += amount;
    updateDb();
  }

  Future<void> updateDb() async {
    final dayReference =
        DatabaseService('bakery').dailyDataReference.child(DateData.date);
    DatabaseService('bakery').bakeryRef.update({'debt': debt.toString()});
    dayReference.update({
      'delivered': delivered.toString(),
      'bayat': bayat.toString(),
      'taken': taken.toString()
    });
  }
}
