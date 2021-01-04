import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_my_bakery/screens/service/service_models/urun_model.dart';

class Market {
  String name;
  List<Urun> urunler = [];
  double borc = 0;
  double taken = 0.0;
  int bayat = 0;
  int delivered = 0;
  var _marketReference;
  Market(this.name, this.borc, this.urunler) {
    _marketReference = FirebaseDatabase.instance
        .reference()
        .child('bakery')
        .child('markets')
        .child(name);
  }

  void _addUrun(Urun urun) {
    if (urunler.contains(urun)) {
      urunler[urunler.indexOf(urun)].price = urun.price;
    } else {
      urunler.add(urun);
    }
  }

  Future<void> updateProduct(Urun urun) async {
    if (urun != null) {
      var urunlerReference = _marketReference.child('urunler');
      urunlerReference
          .child(urun.name)
          .set({'price': urun.price, 'name': urun.name});
      _addUrun(urun);
      DataSnapshot snapshot = await urunlerReference.once();
      List<dynamic> resultList = snapshot.value;
      for (var i = 0; i < resultList.length; i++) {
        Map<dynamic, dynamic> map = Map.from(resultList[i]);
        _addUrun(Urun.fromMap(map));
      }
    }

    Future<void> updateDb(String date) async {
      final dayReference = _marketReference.child('dailyData').child(date);
      _marketReference.set({'totalDebt': borc});
      dayReference.set({
        'name': name,
        'delivered': delivered,
        'bayat': bayat,
        'taken': taken,
      });
    }

    Future<void> updateLocal(String date) async {
      DataSnapshot snapshot = await _marketReference.once();
      snapshot.value == null
          ? borc = 0
          : borc = snapshot.value['totalDebt'].toDouble();

      final dayReference = _marketReference.child('dailyData').child(date);
      snapshot = await dayReference.once();

      if (snapshot.value == null) {
        delivered = 0;
        bayat = 0;
        taken = 0;
      } else {
        name = snapshot.value['name'];
        delivered = snapshot.value['delivered'];
        bayat = snapshot.value['bayat'];
        taken = snapshot.value['taken'].toDouble();
      }
    }
  }
}
