import 'package:flutter/material.dart';

class Urun {
  String name;
  double price;
  Urun({@required this.name, this.price = 0});

  updatePrice(double price) {
    this.price = price;
  }

  Urun.fromMap(Map<String, dynamic> map) {
    this.name = map['name'];
    this.price = map['price'];
  }
}
