import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

class ServiceModel {
  int bayat = 0;
  double borc = 0;
  int delivered = 0;
  double taken = 0;
  final _serviceReference = FirebaseDatabase.instance
      .reference()
      .child('bakery')
      .child('serviceData');

  Future<void> updateDb(String date) async {
    log('asd');
    final dayReference = _serviceReference.child('dailyData').child(date);
    _serviceReference.set({'totalDebt': borc});
    dayReference.set({'delivered': delivered, 'bayat': bayat, 'taken': taken});
  }

  Future<void> updateLocal(String date) async {
    DataSnapshot snapshot = await _serviceReference.once();
    snapshot.value == null
        ? borc = 0
        : borc = snapshot.value['totalDebt'].toDouble();

    final dayReference = _serviceReference.child('dailyData').child(date);
    snapshot = await dayReference.once();

    if (snapshot.value == null) {
      delivered = 0;
      bayat = 0;
      taken = 0;
    } else {
      delivered = snapshot.value['delivered'];
      bayat = snapshot.value['bayat'];
      taken = snapshot.value['taken'].toDouble();
    }
  }
}
